using HarmonyLib;
using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// La traite et la tonte. <c>Gathered</c> recoit le pion qui s'en occupe et fait sortir la
    /// ressource ; la prime se pose a cote.
    ///
    /// L'animal qu'on est en train de traire est exclu de la recherche de compagnon : il est
    /// occupe a etre la ressource, il ne s'aide pas lui-meme.
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
