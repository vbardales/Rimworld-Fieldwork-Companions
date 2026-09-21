using System;
using System.Collections.Generic;
using System.Linq;
using RimWorks.Pickle;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// Hides everything around the window being photographed, so a capture does not carry the tab
    /// bar, the colonist bar, alerts, dev tools or Pickle's own runner panel. RimWorld's own
    /// screenshot mode draws only the windows whose <c>Window.drawInScreenshotMode</c> is true, so
    /// the step raises that flag on the windows currently open, skipping any that belongs to Pickle.
    ///
    /// Restoring matters more than it looks: a scenario that dies between hiding and restoring
    /// leaves the game with no interface at all, and every scenario after it photographs a blank
    /// screen. Hence an explicit step and an [AfterScenario] that runs even when the scenario throws.
    /// </summary>
    [PickleSteps]
    public class ScreenshotSteps
    {
        private static readonly Dictionary<Window, bool> Previous = new Dictionary<Window, bool>();
        private static bool hiding;

        private static bool BelongsToPickle(Window w) =>
            w.GetType().Assembly.GetName().Name.StartsWith("RimWorks.Pickle", StringComparison.OrdinalIgnoreCase);

        [When("Fieldwork Companions hides the interface around the windows on screen")]
        public void Hide(PickleContext ctx)
        {
            var root = Find.UIRoot;
            ctx.Require(root?.screenshotMode != null, "no UIRoot.screenshotMode to drive");

            Previous.Clear();
            var kept = 0;
            foreach (var w in Find.WindowStack.Windows.ToList())
            {
                Previous[w] = w.drawInScreenshotMode;
                var keep = !BelongsToPickle(w);
                w.drawInScreenshotMode = keep;
                if (keep) kept++;
            }
            ctx.Require(kept > 0,
                "every open window belongs to Pickle, so the capture would be empty: open the window "
                + "to photograph before hiding the interface");

            root.screenshotMode.Active = true;
            hiding = true;
        }

        [When("Fieldwork Companions brings the interface back")]
        public void Restore(PickleContext ctx) => RestoreNow();

        [AfterScenario]
        public void RestoreAfterScenario(PickleContext ctx) => RestoreNow();

        /// <summary>Safe to call when nothing was hidden, which is the normal case.</summary>
        private static void RestoreNow()
        {
            if (!hiding) return;
            hiding = false;

            var root = Find.UIRoot;
            if (root?.screenshotMode != null) root.screenshotMode.Active = false;

            foreach (var pair in Previous)
            {
                if (pair.Key != null) pair.Key.drawInScreenshotMode = pair.Value;
            }
            Previous.Clear();
        }
    }
}
