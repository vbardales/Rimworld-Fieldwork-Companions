using System.Collections.Generic;
using RimWorld;
using UnityEngine;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>The four gathering gestures a companion can lend a hand with.</summary>
    public enum AssistKind
    {
        Mining,
        Harvest,
        Fishing,
        Gathering
    }

    /// <summary>
    /// The heart of the mod. RimWorld already knows that an animal has a master and follows it to
    /// work (<c>Pawn_PlayerSettings.master</c> + <c>followFieldwork</c>, the "Follow master while
    /// doing field work" checkbox of the Animals tab). The animal follows, wanders nearby and
    /// defends; what it never does is bear on the work itself. This class answers the one question
    /// that gap leaves open - "is a qualified companion at hand, and does it turn up anything this
    /// time?" - and the four patches lean on it.
    /// </summary>
    public static class Companions
    {
        private static bool trainablesResolved;
        private static TrainableDef forage;
        private static TrainableDef dig;

        /// <summary>
        /// Both trainings come from Odyssey. Without the DLC they do not exist, and the mod falls
        /// back on obedience alone: hence the silent lookup rather than a <c>TrainableDefOf</c>,
        /// which would scream at load time.
        /// </summary>
        private static void ResolveTrainables()
        {
            if (trainablesResolved) return;
            trainablesResolved = true;
            forage = DefDatabase<TrainableDef>.GetNamedSilentFail("Forage");
            dig = DefDatabase<TrainableDef>.GetNamedSilentFail("Dig");
        }

        public static TrainableDef ForageDef
        {
            get { ResolveTrainables(); return forage; }
        }

        public static TrainableDef DigDef
        {
            get { ResolveTrainables(); return dig; }
        }

        /// <summary>The training that matches the gesture, or null when the game has none.</summary>
        public static TrainableDef SpecialtyFor(AssistKind kind)
        {
            switch (kind)
            {
                case AssistKind.Mining: return DigDef;
                case AssistKind.Harvest: return ForageDef;
                default: return null;
            }
        }

        private static bool KindEnabled(AssistKind kind)
        {
            var s = FieldworkCompanionsMod.Settings;
            switch (kind)
            {
                case AssistKind.Mining: return s.assistMining;
                case AssistKind.Harvest: return s.assistHarvest;
                case AssistKind.Fishing: return s.assistFishing;
                case AssistKind.Gathering: return s.assistGathering;
                default: return false;
            }
        }

        /// <summary>
        /// The companion at hand, or null. Deliberately strict: only a humanlike colonist is
        /// helped. Without that guard a megasloth trained to dig would pass for a miner itself -
        /// <c>Mineable.DestroyMined</c> has not told the difference since Odyssey.
        /// </summary>
        public static Pawn HelperFor(Pawn worker, AssistKind kind, Thing exclude = null)
        {
            if (!KindEnabled(kind)) return null;
            if (worker == null || !worker.Spawned || worker.Dead) return null;
            if (worker.Map == null) return null;
            if (!worker.RaceProps.Humanlike) return null;
            if (worker.Faction != Faction.OfPlayer) return null;

            var settings = FieldworkCompanionsMod.Settings;
            TrainableDef specialty = SpecialtyFor(kind);
            float radiusSquared = settings.radius * settings.radius;
            IntVec3 workerCell = worker.Position;

            List<Pawn> animals = worker.Map.mapPawns.SpawnedColonyAnimals;
            for (int i = 0; i < animals.Count; i++)
            {
                Pawn animal = animals[i];

                // This test first: it is a reference comparison, and it rules out nearly the whole
                // herd before any distance is computed.
                if (animal.playerSettings == null || animal.playerSettings.Master != worker) continue;
                if (!animal.playerSettings.followFieldwork) continue;
                if (animal == exclude) continue;
                if (animal.Dead || animal.Downed || animal.InMentalState) continue;
                if (animal.Position.DistanceToSquared(workerCell) > radiusSquared) continue;
                if (!Qualifies(animal, specialty)) continue;

                return animal;
            }

            return null;
        }

        /// <summary>
        /// Obedience is the floor, and that is not a rule of this mod: vanilla already refuses to
        /// obey a master without it (<c>Pawn_PlayerSettings.RespectsMaster</c>). The specialty adds
        /// to it when the gesture has one and the option asks for it.
        /// </summary>
        private static bool Qualifies(Pawn animal, TrainableDef specialty)
        {
            if (animal.training == null) return false;
            if (!animal.training.HasLearned(TrainableDefOf.Obedience)) return false;

            if (specialty == null) return true;
            if (!FieldworkCompanionsMod.Settings.requireSpecialty) return true;

            return animal.training.HasLearned(specialty);
        }

        /// <summary>
        /// The chance it turns up something. The Dreamlight Valley formula transposed - a base,
        /// plus one step per level - except that the friendship level gives way to what RimWorld
        /// already knows how to measure: the training steps, and the bond.
        /// </summary>
        public static float ChanceFor(Pawn worker, Pawn animal, AssistKind kind)
        {
            var settings = FieldworkCompanionsMod.Settings;
            float chance = settings.baseChance;

            TrainableDef specialty = SpecialtyFor(kind);
            if (specialty != null && animal.training != null)
            {
                chance += settings.perStepBonus * animal.training.GetSteps(specialty);
            }

            if (IsBonded(worker, animal))
            {
                chance += settings.bondBonus;
            }

            return Mathf.Clamp01(chance);
        }

        public static bool IsBonded(Pawn worker, Pawn animal)
        {
            return animal.relations != null
                && animal.relations.DirectRelationExists(PawnRelationDefOf.Bond, worker);
        }

        /// <summary>
        /// The roll. Returns the animal when it succeeded, null otherwise, and ties the bond on
        /// the way. The mote is left to the callers: they alone know how much the bonus came to.
        /// </summary>
        public static Pawn TryAssist(Pawn worker, AssistKind kind, Thing exclude = null)
        {
            Pawn animal = HelperFor(worker, kind, exclude);
            if (animal == null) return null;

            if (!Rand.Chance(ChanceFor(worker, animal, kind))) return null;

            // In Dreamlight Valley working together raises friendship; here it pushes towards the
            // bond, through the API vanilla already uses for taming and for training.
            var settings = FieldworkCompanionsMod.Settings;
            if (settings.bondChance > 0f && !IsBonded(worker, animal))
            {
                RelationsUtility.TryDevelopBondRelation(worker, animal, settings.bondChance);
            }

            return animal;
        }

        /// <summary>The "+3" floating over the animal, so you see who found what.</summary>
        public static void NoteAssist(Pawn animal, int count)
        {
            if (!FieldworkCompanionsMod.Settings.showMote) return;
            if (animal == null || !animal.Spawned || animal.Map == null) return;

            MoteMaker.ThrowText(animal.DrawPos, animal.Map,
                "FieldworkCompanions.Mote.Assist".Translate(count), 2.5f);
        }

        /// <summary>
        /// The bonus, expressed as a share of what the gesture nominally yields, and never nil: a
        /// companion that succeeds always turns up at least one unit.
        /// </summary>
        public static int BonusCount(int nominalYield)
        {
            float share = FieldworkCompanionsMod.Settings.bonusShare;
            return Mathf.Max(1, Mathf.RoundToInt(nominalYield * share));
        }

        /// <summary>Drops the bonus on the ground, next to whoever found it.</summary>
        public static void PlaceBonus(ThingDef def, int count, IntVec3 cell, Map map)
        {
            if (def == null || count <= 0 || map == null || !cell.IsValid) return;

            while (count > 0)
            {
                int stack = Mathf.Min(count, def.stackLimit);
                Thing thing = ThingMaker.MakeThing(def);
                thing.stackCount = stack;
                GenPlace.TryPlaceThing(thing, cell, map, ThingPlaceMode.Near);
                count -= stack;
            }
        }
    }
}
