using System;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Text.RegularExpressions;
using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// What the settings scenarios need that Pickle's generic vocabulary does not cover: opening the
    /// real Dialog_ModSettings the primary Options entry itself opens, setting and reading the
    /// mod's fields, and looking at the file the game writes.
    ///
    /// The clamps, the defaults, the reset and the Scribe round trip are already proved out of game
    /// by _tools/Run-Functional-Tests.ps1; nothing here repeats them. What only a running game can
    /// say is that the real dialog draws, that the real file is written where the game writes it,
    /// and that the game reads it back.
    /// </summary>
    [PickleSteps]
    public class SettingsSteps
    {
        private static FieldInfo SettingsField(PickleContext ctx, string name)
        {
            var f = typeof(FieldworkCompanionsSettings).GetField(name, BindingFlags.Public | BindingFlags.Instance);
            ctx.Require(f != null, $"FieldworkCompanionsSettings has no public field '{name}'");
            return f;
        }

        /// <summary>
        /// Waits for its own frames rather than leaving that to the scenario. Dialog_ModSettings
        /// force-pauses the game, so a tick wait in the scenario can never be satisfied. Frames
        /// still pass while the game is paused.
        /// </summary>
        [When("I open the Fieldwork Companions settings dialog")]
        public async System.Threading.Tasks.Task OpenDialog(PickleContext ctx)
        {
            Find.WindowStack.Add(new Dialog_ModSettings(Driver.Mod(ctx)));
            await ctx.WaitFrames(3);
        }

        [When("Fieldwork Companions scrolls its settings window to the bottom")]
        public async System.Threading.Tasks.Task ScrollToBottom(PickleContext ctx)
        {
            SetScroll(ctx, 100000f);
            await ctx.WaitFrames(3);
        }

        [When("Fieldwork Companions scrolls its settings window back to the top")]
        public async System.Threading.Tasks.Task ScrollToTop(PickleContext ctx)
        {
            SetScroll(ctx, 0f);
            await ctx.WaitFrames(3);
        }

        /// <summary>
        /// Added after the first WSL run, whose "top" and "bottom" captures were identical: neither
        /// showed the last two controls (the mark checkbox and the reset button) and neither showed
        /// a scrollbar. That is either a scroll step that did nothing or a page that cannot scroll,
        /// and a capture cannot tell the two apart. The scroll position is written back by the
        /// game's own scroll view, clamped to what the content allows, so a value above zero after
        /// asking for the bottom proves the page really scrolls; the message carries both numbers.
        /// </summary>
        [Then("the Fieldwork Companions settings page has scrolled down")]
        public void AssertScrolled(PickleContext ctx)
        {
            var mod = Driver.Mod(ctx);
            var y = ((Vector2)Driver.Field(ctx, typeof(FieldworkCompanionsMod), "scrollPosition", Driver.InstanceAny).GetValue(mod)).y;
            var h = (float)Driver.Field(ctx, typeof(FieldworkCompanionsMod), "viewHeight", Driver.InstanceAny).GetValue(mod);
            ctx.Assert(y > 0f,
                $"asked to scroll to the bottom, the page is still at scrollPosition.y {y} with viewHeight {h}: "
                + "either the page does not scroll, so the controls below the fold (the mark checkbox and "
                + "the reset button) cannot be reached, or the step did not take effect");
        }

        private static void SetScroll(PickleContext ctx, float y)
        {
            var f = Driver.Field(ctx, typeof(FieldworkCompanionsMod), "scrollPosition", Driver.InstanceAny);
            f.SetValue(Driver.Mod(ctx), new Vector2(0f, y));
        }

        [Given("Fieldwork Companions settings are at their documented defaults")]
        public void ResetToDefaults(PickleContext ctx) => Driver.Settings(ctx).Reset();

        /// <summary>
        /// The preset every gameplay scenario starts from. At the default 15 % the scenarios would be
        /// reading a coin; at 100 % they read the mod. The share is the largest the slider allows so
        /// that the bonus (twice the nominal yield) is always bigger than anything the base
        /// gesture can produce, which is what lets a scenario tell an assisted yield from a plain
        /// one by size alone.
        /// </summary>
        [Given("Fieldwork Companions always helps, at the largest share")]
        public void AlwaysHelps(PickleContext ctx)
        {
            var s = Driver.Settings(ctx);
            s.Reset();
            s.baseChance = 1f;
            s.bonusShare = 2f;
            s.requireSpecialty = false;
            s.bondChance = 0f;
        }

        [Given("Fieldwork Companions requires the matching training")]
        public void RequireTraining(PickleContext ctx) => Driver.Settings(ctx).requireSpecialty = true;

        [When("Fieldwork Companions setting {string} is set to {string}")]
        public void SetSetting(PickleContext ctx, string field, string value)
        {
            var f = SettingsField(ctx, field);
            f.SetValue(Driver.Settings(ctx), Convert.ChangeType(value, f.FieldType, CultureInfo.InvariantCulture));
        }

        [Then("Fieldwork Companions setting {string} reads {string}")]
        public void AssertSetting(PickleContext ctx, string field, string expected)
        {
            var f = SettingsField(ctx, field);
            var actual = Convert.ToString(f.GetValue(Driver.Settings(ctx)), CultureInfo.InvariantCulture);
            ctx.Assert(actual == expected, $"FieldworkCompanionsSettings.{field} reads '{actual}', expected '{expected}'");
        }

        // Settings are global, not per save, so the round trip that matters is object -> file ->
        // object. A real restart is the one thing this cannot stand in for, and TESTING.md says so.
        [When("Fieldwork Companions settings are written to disk")]
        public void WriteSettings(PickleContext ctx)
        {
            // A report keeps no stack, so carry the whole exception into the failure message.
            try { Driver.Mod(ctx).WriteSettings(); }
            catch (Exception ex) { ctx.Assert(false, "WriteSettings threw " + ex); }

            var path = Driver.SettingsFilePath(ctx);
            ctx.Require(File.Exists(path), $"WriteSettings left no file at {path}");
        }

        [Then("the Fieldwork Companions settings file records {string} as {string}")]
        public void AssertOnDisk(PickleContext ctx, string field, string expected)
        {
            var xml = File.ReadAllText(Driver.SettingsFilePath(ctx));
            var match = Regex.Match(xml, $"<{field}>([^<]*)</{field}>");
            ctx.Assert(match.Success, $"the settings file has no <{field}> element. It holds:\n{xml}");

            // A float is written with the digits that round-trip it, so 0.4f lands in the file as
            // 0.400000006 (the first WSL run read exactly that). Numbers are compared as numbers.
            var actual = match.Groups[1].Value;
            double a, e;
            if (double.TryParse(actual, NumberStyles.Float, CultureInfo.InvariantCulture, out a)
                && double.TryParse(expected, NumberStyles.Float, CultureInfo.InvariantCulture, out e))
            {
                ctx.Assert(Math.Abs(a - e) < 1e-5, $"the settings file records <{field}> as {actual}, expected {expected}");
            }
            else
            {
                ctx.Assert(actual == expected, $"the settings file records <{field}> as {actual}, expected {expected}");
            }
        }

        /// <summary>
        /// Reads the file back through the game's own reader into a NEW object, and leaves the live
        /// settings alone. Swapping the live object would risk the static property and the Mod base
        /// class disagreeing about which one is current; comparing a fresh one avoids the question.
        /// </summary>
        [Then("Fieldwork Companions reading its settings file back gives {string} as {string}")]
        public void AssertReadBack(PickleContext ctx, string field, string expected)
        {
            var mod = Driver.Mod(ctx);
            var fresh = LoadedModManager.ReadModSettings<FieldworkCompanionsSettings>(
                mod.Content.FolderName, mod.GetType().Name);
            ctx.Require(fresh != null, "ReadModSettings returned nothing");

            var actual = Convert.ToString(SettingsField(ctx, field).GetValue(fresh), CultureInfo.InvariantCulture);
            ctx.Assert(actual == expected,
                $"read back from disk, {field} is '{actual}', expected '{expected}'");
        }

        [Then("Fieldwork Companions sees a settings dialog open for itself")]
        public void AssertDialogOpen(PickleContext ctx) => ShortcutSteps.AssertDialogFor(ctx);
    }
}
