using System.Collections.Generic;
using RimWorld;
using UnityEngine;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>Les quatre gestes de recolte auxquels un compagnon peut preter main-forte.</summary>
    public enum AssistKind
    {
        Mining,
        Harvest,
        Fishing,
        Gathering
    }

    /// <summary>
    /// Le coeur du mod. RimWorld sait deja qu'un animal a un maitre et qu'il le suit au travail
    /// (<c>Pawn_PlayerSettings.master</c> + <c>followFieldwork</c>, la case « Follow master while
    /// doing field work » de l'onglet Animaux) : il ne se passe simplement rien quand il le fait.
    /// Cette classe repond a une seule question — « un compagnon qualifie accompagne-t-il ce
    /// colon, et rend-il quelque chose cette fois-ci ? » — et les quatre patchs s'en servent.
    /// </summary>
    public static class Companions
    {
        private static bool trainablesResolved;
        private static TrainableDef forage;
        private static TrainableDef dig;

        /// <summary>
        /// Les deux dressages sont ceux d'Odyssey. Sans le DLC ils n'existent pas, et le mod se
        /// rabat alors sur la seule obeissance : d'ou la resolution silencieuse plutot qu'un
        /// <c>TrainableDefOf</c>, qui hurlerait au chargement.
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

        /// <summary>Le dressage qui correspond au geste, ou null quand le jeu n'en a pas.</summary>
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
        /// Le compagnon present, ou null. Volontairement strict : seul un colon humanoide est
        /// aide. Sans ce garde, un megaparesseux dresse au creusement passerait lui-meme pour un
        /// mineur — <c>Mineable.DestroyMined</c> ne fait pas la difference depuis Odyssey.
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

                // Ce test d'abord : c'est une comparaison de reference, et il elimine la quasi
                // totalite du troupeau avant tout calcul de distance.
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
        /// L'obeissance est le plancher, et ce n'est pas une regle du mod : le vanilla refuse deja
        /// d'obeir a un maitre sans elle (<c>Pawn_PlayerSettings.RespectsMaster</c>). La specialite
        /// s'y ajoute quand le geste en a une et que l'option l'exige.
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
        /// La chance qu'il rende quelque chose. Transposition du calcul de Dreamlight Valley — une
        /// base, plus un palier par niveau — sauf que le niveau d'amitie y est remplace par ce que
        /// RimWorld sait deja mesurer : les paliers de dressage, et le lien.
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
        /// Le tirage. Renvoie l'animal quand il a reussi, null sinon, et noue le lien au passage.
        /// Le mote est laisse aux appelants : eux seuls savent combien la prime rapporte.
        /// </summary>
        public static Pawn TryAssist(Pawn worker, AssistKind kind, Thing exclude = null)
        {
            Pawn animal = HelperFor(worker, kind, exclude);
            if (animal == null) return null;

            if (!Rand.Chance(ChanceFor(worker, animal, kind))) return null;

            // Chez Dreamlight Valley, travailler ensemble fait monter l'amitie ; ici ca pousse vers
            // le lien, avec l'API que le vanilla emploie deja pour l'apprivoisement et le dressage.
            var settings = FieldworkCompanionsMod.Settings;
            if (settings.bondChance > 0f && !IsBonded(worker, animal))
            {
                RelationsUtility.TryDevelopBondRelation(worker, animal, settings.bondChance);
            }

            return animal;
        }

        /// <summary>Le « +3 » qui flotte au-dessus de l'animal, pour voir qui a trouve quoi.</summary>
        public static void NoteAssist(Pawn animal, int count)
        {
            if (!FieldworkCompanionsMod.Settings.showMote) return;
            if (animal == null || !animal.Spawned || animal.Map == null) return;

            MoteMaker.ThrowText(animal.DrawPos, animal.Map,
                "FieldworkCompanions.Mote.Assist".Translate(count), 2.5f);
        }

        /// <summary>
        /// La prime, exprimee en part de ce que le geste rend nominalement, et jamais nulle : un
        /// compagnon qui reussit rapporte toujours au moins une unite.
        /// </summary>
        public static int BonusCount(int nominalYield)
        {
            float share = FieldworkCompanionsMod.Settings.bonusShare;
            return Mathf.Max(1, Mathf.RoundToInt(nominalYield * share));
        }

        /// <summary>Pose la prime au sol, a cote de qui l'a trouvee.</summary>
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
