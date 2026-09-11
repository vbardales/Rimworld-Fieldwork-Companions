using System.Collections.Generic;
using HarmonyLib;
using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// La peche, ajoutee par Odyssey. <c>GetCatchesFor</c> est le meilleur crochet des quatre :
    /// il recoit le pecheur et rend la liste des prises, donc la prime s'ajoute a la liste sans
    /// rien poser au sol soi-meme — c'est le JobDriver qui s'en charge ensuite.
    ///
    /// <c>animalFishing</c> ecarte le cas ou c'est un animal qui peche : un compagnon n'assiste
    /// pas un autre animal.
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

            // Une prise de plus, prise au hasard parmi celles qui viennent d'etre sorties. Un
            // poisson est deja l'unite : pas de part a calculer ici.
            Thing model = __result.RandomElement();
            if (model?.def == null) return;

            Thing extra = ThingMaker.MakeThing(model.def, model.Stuff);
            extra.stackCount = 1;
            __result.Add(extra);

            Companions.NoteAssist(helper, 1);
        }
    }
}
