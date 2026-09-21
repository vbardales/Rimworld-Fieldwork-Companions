using System.Linq;
using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// The optional MainButtons shortcut, and the contract MOD_SETTINGS.md puts on it: available for
    /// RIMMSQOL and the other customization tools to reveal, hidden by default, neither visible nor
    /// greyed, and opening the same settings as Mod options.
    ///
    /// What RIMMSQOL does when a player reveals the button is move <c>MainButtonDef.buttonVisible</c>.
    /// What this mod owes is the other side of that contract, so these steps move that same field
    /// and then ask RimWorld's own worker what the bar would do. Nothing here installs or drives
    /// RIMMSQOL: whether ITS interface can reveal the button, and whether ITS choice survives a
    /// restart, stays manual.
    /// </summary>
    [PickleSteps]
    public class ShortcutSteps
    {
        private const string DefName = "FieldworkCompanions_Settings";

        [Then("the Fieldwork Companions shortcut is hidden on a clean configuration")]
        public void AssertHiddenByDefault(PickleContext ctx)
        {
            var def = Shortcut(ctx);
            ctx.Assert(!def.buttonVisible,
                "FieldworkCompanions_Settings ships with buttonVisible true: it would stand in "
                + "everyone's main bar without anyone asking for it");
            AssertNotDrawn(ctx);
        }

        [When("Fieldwork Companions reveals its shortcut, as a customization mod would")]
        public void Reveal(PickleContext ctx) => Shortcut(ctx).buttonVisible = true;

        [When("Fieldwork Companions hides its shortcut again")]
        public void Hide(PickleContext ctx) => Shortcut(ctx).buttonVisible = false;

        /// <summary>
        /// Both halves are asserted. <c>Worker.Visible</c> decides whether the bar draws the def at
        /// all and <c>Worker.Disabled</c> whether it draws it greyed; MOD_SETTINGS.md forbids a
        /// greyed shortcut as firmly as a visible one, and a def can be drawn and still be dead.
        /// </summary>
        [Then("the Fieldwork Companions shortcut is drawn in the bar")]
        public void AssertDrawn(PickleContext ctx)
        {
            var def = Shortcut(ctx);
            ctx.Assert(def.Worker.Visible,
                "the shortcut has been revealed and its worker still reports Visible false, so a "
                + "customization mod cannot actually put it in the bar");
            ctx.Assert(!def.Worker.Disabled, "the shortcut is drawn but greyed out, which MOD_SETTINGS.md forbids");
        }

        [Then("the Fieldwork Companions shortcut is not drawn in the bar")]
        public void AssertNotDrawn(PickleContext ctx)
        {
            var def = Shortcut(ctx);
            ctx.Assert(!def.Worker.Visible,
                $"the shortcut reports Visible true with buttonVisible {def.buttonVisible}: it shows "
                + "without anything having revealed it");
        }

        /// <summary>Activating the worker is what a revealed button ends up calling.</summary>
        [When("Fieldwork Companions activates its shortcut")]
        public void Activate(PickleContext ctx) => Shortcut(ctx).Worker.Activate();

        /// <summary>
        /// The claim is not "a settings window opened" but "the SAME settings opened": a dialog
        /// belonging to another mod would look identical in a screenshot, so the window is asked
        /// which mod it was built for.
        /// </summary>
        internal static void AssertDialogFor(PickleContext ctx)
        {
            var stack = Find.WindowStack;
            ctx.Require(stack != null, "there is no window stack: no game and no main menu is running");

            var dialogs = stack.Windows.OfType<Dialog_ModSettings>().ToList();
            ctx.Assert(dialogs.Count > 0, "no Dialog_ModSettings is open");

            var mine = Driver.Mod(ctx);
            ctx.Assert(dialogs.Any(d => ModOf(ctx, d) == mine),
                "a settings dialog is open, but not this mod's: it was built for "
                + string.Join(", ", dialogs.Select(d => ModOf(ctx, d)?.Content?.Name ?? "an unknown mod").ToArray())
                + ". The shortcut and Mod options must lead to the same place");
        }

        private static MainButtonDef Shortcut(PickleContext ctx)
        {
            var def = DefDatabase<MainButtonDef>.GetNamedSilentFail(DefName);
            ctx.Require(def != null,
                $"no MainButtonDef named '{DefName}': the shortcut RIMMSQOL is meant to be able to reveal is not shipped");
            return def;
        }

        /// <summary>
        /// Dialog_ModSettings keeps the mod it was built for in a private field whose name has moved
        /// between game versions: the first Mod-typed field is taken, and a miss lists what exists.
        /// </summary>
        private static Mod ModOf(PickleContext ctx, Dialog_ModSettings dialog)
        {
            var type = typeof(Dialog_ModSettings);
            var field = type.GetFields(Driver.InstanceAny).FirstOrDefault(f => typeof(Mod).IsAssignableFrom(f.FieldType));
            ctx.Require(field != null,
                "Dialog_ModSettings holds no Mod field in this version; it has: "
                + string.Join(", ", type.GetFields(Driver.InstanceAny).Select(f => f.Name).ToArray()));
            return field.GetValue(dialog) as Mod;
        }
    }
}
