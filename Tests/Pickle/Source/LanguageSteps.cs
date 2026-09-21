using System.Linq;
using RimWorks.Pickle;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// The half of the translation check that only a running game can settle: what the loaded
    /// language database really holds, and what a MainButtonDef ends up reading after DefInjected.
    ///
    /// The language is never changed here. SelectLanguage clears and reloads every def and pulls the
    /// game out from under the runner, so it is chosen at launch by
    /// <c>Run-PickleWsl.ps1 -Language French</c> and these steps assert against whichever language
    /// the pass runs. Both languages are covered by two passes, not by a switch inside a scenario.
    ///
    /// In developer mode, which every Pickle run is, a key missing from the active language does not
    /// fall back to plain English: RimWorld prints the English text accented letter by letter. So
    /// accented gibberish in a capture means a missing key, and clean English inside a French
    /// interface means a literal that never went through Translate.
    /// </summary>
    [PickleSteps]
    public class LanguageSteps
    {
        private const string Prefix = "FieldworkCompanions.";

        // Kept in step with Mod/Languages/English/Keyed/FieldworkCompanions.xml. A count below this
        // means the filter found fewer keys than the mod owns, which would make the check vacuous.
        private const int OwnedKeys = 33;

        [Then("Fieldwork Companions key {string} does not read as a raw key")]
        public void AssertTranslated(PickleContext ctx, string key)
        {
            var text = key.Translate().ToString();
            ctx.Assert(!string.IsNullOrWhiteSpace(text) && text != key,
                $"'{key}' resolved to '{text}': the key itself is what a player would see");
        }

        /// <summary>
        /// Every Keyed key the English resources declare must have text in the ACTIVE language's own
        /// resources. Comparing against the English list rather than a hand-kept list means a key
        /// added to the mod without a French entry fails here even if this suite never heard of it.
        /// </summary>
        [Then("every Fieldwork Companions text exists in the language this pass runs")]
        public void AssertEveryKeyExists(PickleContext ctx)
        {
            var active = LanguageDatabase.activeLanguage;
            ctx.Require(active != null, "no active language: the game has not finished loading one");
            var english = LanguageDatabase.defaultLanguage;

            var keys = english.keyedReplacements.Keys.Where(k => k.StartsWith(Prefix)).ToList();
            ctx.Assert(keys.Count >= OwnedKeys,
                $"only {keys.Count} English keys start with '{Prefix}', the mod owns {OwnedKeys}: "
                + "the English resources did not load, or a key was removed without updating this suite");

            var missing = keys.Where(k => !active.HaveTextForKey(k)).ToList();
            ctx.Assert(missing.Count == 0,
                $"{active.folderName} has no text for {missing.Count} key(s): " + string.Join(", ", missing.ToArray()));
        }

        /// <summary>
        /// The shortcut's description is DefInjected in French and a native Def value in English.
        /// A language the mod does not translate is not asserted: the step names it and passes,
        /// rather than pretending to have checked something.
        /// </summary>
        [Then("the Fieldwork Companions shortcut reads as written for the language this pass runs")]
        public void AssertShortcutText(PickleContext ctx)
        {
            var def = DefDatabase<RimWorld.MainButtonDef>.GetNamedSilentFail("FieldworkCompanions_Settings");
            ctx.Require(def != null, "no MainButtonDef named 'FieldworkCompanions_Settings'");

            var folder = LanguageDatabase.activeLanguage?.folderName ?? "";
            string expected;
            if (folder.StartsWith("English")) expected = "Open Fieldwork Companions settings.";
            else if (folder.StartsWith("French")) expected = "Ouvrir les réglages de Fieldwork Companions.";
            else
            {
                Log.Message($"[Fieldwork Companions tests] the shortcut text is not asserted for '{folder}': the mod ships English and French only");
                return;
            }

            ctx.Assert(def.description == expected,
                $"the shortcut description reads '{def.description}' in {folder}, expected '{expected}'");
        }
    }
}
