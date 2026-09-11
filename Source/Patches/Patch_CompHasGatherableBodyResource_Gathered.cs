using HarmonyLib;
using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// Milking and shearing. <c>Gathered</c> receives the pawn seeing to it and spawns the
    /// resource; the bonus is dropped beside it.
    ///
    /// The animal being milked is excluded from the companion search: it is busy being the
    /// resource, and it does not help itself.
    /// </summary>
    [HarmonyPatch(typeof(CompHasGatherableBodyResource), "Gathered")]
    internal static class Patch_CompHasGatherableBodyResource_Gathered
    {
        private static void Postfix(CompHasGatherableBodyResource __instance, Pawn doer)
        {
            Thing source = __instance?.parent;
            if (source == null || !source.Spawned) return;

            ThingDef resource = __instance.ResourceDef;
            if (resource == null || __instance.ResourceAmount <= 0) return;

            Pawn helper = Companions.TryAssist(doer, AssistKind.Gathering, source);
            if (helper == null) return;

            int count = Companions.BonusCount(__instance.ResourceAmount);
            Companions.PlaceBonus(resource, count, source.Position, source.Map);
            Companions.NoteAssist(helper, count);
        }
    }
}
