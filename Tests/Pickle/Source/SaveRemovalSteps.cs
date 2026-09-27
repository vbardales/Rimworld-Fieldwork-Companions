using System;
using System.IO;
using System.Linq;
using System.Xml;
using RimWorks.Pickle;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// The mod can be added to a game in progress and taken out of it, since it writes nothing to the save. Two halves.
    /// Added: every scenario loads the shared fixture, written before this mod existed, and
    /// <see cref="GameWasSavedWithoutThisMod"/> names that fact. Removed: one launch saves a game with the mod, hands it
    /// to a companion that does not depend on the mod, and the next launch (the mod taken out of the list by the
    /// launcher's -ThenWithout) loads it. Same design as Housebroken's TF-18.
    /// </summary>
    [PickleSteps]
    public class SaveRemovalSteps
    {
        private const string PackageId = "nelim.fieldworkcompanions";

        [Then("Fieldwork Companions: the loaded game was saved without this mod")]
        public void GameWasSavedWithoutThisMod(PickleContext ctx)
        {
            var ids = ScribeMetaHeaderUtility.loadedModIdsList;
            ctx.Require(ids != null, "the game was not loaded from a save, so the mod list it was written with is unknown");
            ctx.Assert(!ids.Any(id => string.Equals(id, PackageId, StringComparison.OrdinalIgnoreCase)),
                "the loaded game was written with this mod; its mod list is: " + string.Join(", ", ids));
        }

        [When("Fieldwork Companions saves the game as {string}")]
        public void Save(PickleContext ctx, string file)
        {
            GameDataSaveLoader.SaveGame(file);
            ctx.Require(File.Exists(GenFilePaths.FilePathForSavedGame(file)), "no save file was written for " + file);
        }

        /// <summary>
        /// The header lists every active mod, so it is set aside; anything else that names the mod, as an element, an
        /// attribute or a class, would be data of the mod in the save.
        /// </summary>
        [Then("Fieldwork Companions save {string} holds no data of this mod outside its mod list")]
        public void NoData(PickleContext ctx, string file)
        {
            var doc = new XmlDocument();
            doc.Load(GenFilePaths.FilePathForSavedGame(file));
            var meta = doc.DocumentElement.SelectSingleNode("meta");
            ctx.Require(meta != null, "the save has no meta header, so the mod list cannot be set aside");
            doc.DocumentElement.RemoveChild(meta);
            var text = doc.OuterXml;
            // Not "Fieldwork" alone: the game's own player settings hold a field called followFieldwork, and the first
            // run of this step (2026-09-25) named it as data of the mod. What would betray the mod is its own name, as
            // a namespace or type ("FieldworkCompanions"), as its package id, or spelled as the mod list spells it.
            var at = new[] { "FieldworkCompanions", "nelim.fieldworkcompanions", "Fieldwork Companions" }
                .Select(n => text.IndexOf(n, StringComparison.OrdinalIgnoreCase)).Where(i => i >= 0).DefaultIfEmpty(-1).Min();
            var from = Math.Max(0, at - 60);
            ctx.Assert(at < 0, "the save holds data of this mod outside its header, near: "
                + (at < 0 ? "" : text.Substring(from, Math.Min(160, text.Length - from))));
        }

        /// <summary>Pickle finds a saved game as a fixture: a .rws in the Pickle/Fixtures folder of an active mod.</summary>
        [When("Fieldwork Companions hands the saved game {string} to the mod {string}")]
        public void Hand(PickleContext ctx, string file, string packageId)
        {
            var target = LoadedModManager.RunningModsListForReading.FirstOrDefault(m =>
                m.PackageIdPlayerFacing.ToLowerInvariant() == packageId.ToLowerInvariant());
            ctx.Require(target != null, "no active mod has the packageId " + packageId);
            var folder = Path.Combine(target.RootDir, "Pickle", "Fixtures");
            Directory.CreateDirectory(folder);
            var destination = Path.Combine(folder, file + ".rws");
            File.Copy(GenFilePaths.FilePathForSavedGame(file), destination, true);
            ctx.Require(File.Exists(destination), "the saved game was not copied to " + destination);
        }
    }
}
