using System.Collections.Generic;
using HarmonyLib;
using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// Fishing, added by Odyssey. <c>GetCatchesFor</c> is the cleanest of the four hooks: it
    /// receives the fisher and returns the list of catches, so the bonus joins that list without
    /// dropping anything on the ground - the JobDriver sees to that afterwards.
    ///
    /// <c>animalFishing</c> rules out the case of an animal doing the fishing: a companion does
    /// not assist another animal.
    /// </summary>
    [HarmonyPatch(typeof(FishingUtility), nameof(FishingUtility.GetCatchesFor))]
    internal static class Patch_FishingUtility_GetCatchesFor
    {
        private static void Postfix(List<Thing> __result, Pawn pawn, bool animalFishing)
        {
            if (animalFishing) return;
            if (__result == null || __result.Count == 0) return;

            Pawn helper = Companions.TryAssist(pawn, AssistKind.Fishing);
            if (helper == null) return;

            // One more catch, picked at random among those just landed. A fish is already the
            // unit: no share to work out here.
            Thing model = __result.RandomElement();
            if (model?.def == null) return;

            Thing extra = ThingMaker.MakeThing(model.def, model.Stuff);
            extra.stackCount = 1;
            __result.Add(extra);

            Companions.NoteAssist(helper, 1);
        }
    }
}
