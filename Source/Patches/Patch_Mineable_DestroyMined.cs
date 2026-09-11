using HarmonyLib;
using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// Mining. <c>DestroyMined</c> is the single entry point of "a pawn has just brought this block
    /// down": it spawns the ore, then destroys the block. That one is patched and not the two
    /// overloads of <c>TrySpawnYield</c>, which relay each other and would fire twice.
    ///
    /// Position, map and def are read in the prefix: after the call the block is destroyed and
    /// <c>Position</c> is worth nothing.
    /// </summary>
    [HarmonyPatch(typeof(Mineable), nameof(Mineable.DestroyMined))]
    internal static class Patch_Mineable_DestroyMined
    {
        internal struct State
        {
            public ThingDef yield;
            public int amount;
            public IntVec3 cell;
            public Map map;
        }

        private static void Prefix(Mineable __instance, Pawn pawn, out State __state)
        {
            __state = default;

            if (pawn == null || !__instance.Spawned) return;

            BuildingProperties building = __instance.def?.building;
            if (building?.mineableThing == null || building.mineableYield <= 0) return;

            __state.yield = building.mineableThing;
            __state.amount = building.mineableYield;
            __state.cell = __instance.Position;
            __state.map = __instance.Map;
        }

        private static void Postfix(Pawn pawn, State __state)
        {
            if (__state.yield == null || __state.map == null) return;

            Pawn helper = Companions.TryAssist(pawn, AssistKind.Mining);
            if (helper == null) return;

            int count = Companions.BonusCount(__state.amount);
            Companions.PlaceBonus(__state.yield, count, __state.cell, __state.map);
            Companions.NoteAssist(helper, count);
        }
    }
}
