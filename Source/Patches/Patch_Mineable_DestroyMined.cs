using HarmonyLib;
using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// Le minage. <c>DestroyMined</c> est le point d'entree unique de « un pion vient d'abattre ce
    /// bloc » : il fait sortir le minerai puis detruit le bloc. On patche celui-la et pas les deux
    /// surcharges de <c>TrySpawnYield</c>, qui se relaient et feraient tirer deux fois.
    ///
    /// La position, la carte et la def sont relevees en prefixe : apres l'appel, le bloc est
    /// detruit et <c>Position</c> ne vaut plus rien.
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
