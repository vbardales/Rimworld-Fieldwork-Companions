using HarmonyLib;
using RimWorld;
using UnityEngine;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// La récolte, cultivée comme sauvage — chez Dreamlight Valley ce sont deux rôles distincts,
    /// jardinage et cueillette ; RimWorld n'en fait qu'un geste, donc un seul patch.
    ///
    /// <c>PlantCollected</c> est appelé par <c>JobDriver_PlantWork</c> juste après que la récolte
    /// a été posée au sol, et il reçoit le pion. Le filtre décisif est le job en cours :
    /// <c>PlantDestructionMode</c> ne distingue pas une récolte d'une coupe (ses quatre valeurs
    /// sont Smash, Flame, Chop, Cut), alors que la def du job, elle, le dit.
    /// </summary>
    [HarmonyPatch(typeof(Plant), nameof(Plant.PlantCollected))]
    internal static class Patch_Plant_PlantCollected
    {
        internal struct State
        {
            public ThingDef yield;
            public int amount;
            public IntVec3 cell;
            public Map map;
        }

        private static void Prefix(Plant __instance, Pawn by, out State __state)
        {
            __state = default;

            if (by == null || !__instance.Spawned) return;
            if (!IsHarvestJob(by)) return;

            PlantProperties plant = __instance.def?.plant;
            if (plant?.harvestedThingDef == null || plant.harvestYield <= 0f) return;

            __state.yield = plant.harvestedThingDef;
            // Le rendement nominal de la def, arrondi sans tirage. Ni YieldNow(), qui tire au sort
            // et serait consommé une seconde fois, ni GenMath.RoundRandom : ce préfixe tourne à
            // chaque récolte de la partie, y compris quand aucun compagnon n'accompagne, et il ne
            // doit rien prélever sur le générateur aléatoire du jeu.
            __state.amount = Mathf.RoundToInt(plant.harvestYield);
            __state.cell = __instance.Position;
            __state.map = __instance.Map;
        }

        private static void Postfix(Pawn by, State __state)
        {
            if (__state.yield == null || __state.map == null) return;

            Pawn helper = Companions.TryAssist(by, AssistKind.Harvest);
            if (helper == null) return;

            int count = Companions.BonusCount(__state.amount);
            Companions.PlaceBonus(__state.yield, count, __state.cell, __state.map);
            Companions.NoteAssist(helper, count);
        }

        private static bool IsHarvestJob(Pawn pawn)
        {
            JobDef job = pawn.CurJob?.def;
            return job == JobDefOf.Harvest || job == JobDefOf.HarvestDesignated;
        }
    }
}
