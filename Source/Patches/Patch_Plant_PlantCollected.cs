using HarmonyLib;
using RimWorld;
using UnityEngine;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// Harvesting, cultivated and wild alike - in Dreamlight Valley these are two distinct roles,
    /// gardening and foraging; RimWorld makes one gesture of them, so one patch.
    ///
    /// <c>PlantCollected</c> is called by <c>JobDriver_PlantWork</c> just after the harvest has
    /// been dropped on the ground, and it receives the pawn. The decisive filter is the current
    /// job: <c>PlantDestructionMode</c> does not tell a harvest from a cut (its four values are
    /// Smash, Flame, Chop, Cut), whereas the job def does.
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
            // The def's nominal yield, rounded without a roll. Neither YieldNow(), which rolls and
            // would then be consumed a second time, nor GenMath.RoundRandom: this prefix runs on
            // every harvest of the game, companion at hand or not, and it must draw nothing from
            // the game's random generator.
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
