using System.Collections.Generic;
using System.IO;
using System.Reflection;
using RimWorks.Pickle;
using UnityEngine;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// Every settings-changing step in this suite mutates the live FieldworkCompanionsSettings, the
    /// same object the settings window and the four Harmony patches both read. Left alone that
    /// would leak into the next scenario, and into the configuration file the moment anything
    /// writes it (Dialog_ModSettings does when it closes).
    ///
    /// So each scenario starts from a snapshot of the public fields and puts them back, and the
    /// settings file is backed up and restored beside them. A backup left over by a run that never
    /// finished is restored first: it is the file the run started from.
    ///
    /// The object itself is never replaced, only its fields written back. That is deliberate: the
    /// mod reads it through a static property and the Mod base class holds a second reference, and
    /// a sandbox that swapped one and not the other is exactly the bug SkillIcons' suite lost a
    /// run to. Writing fields cannot make them disagree.
    /// </summary>
    [PickleSteps]
    public class SettingsSandbox
    {
        private static Dictionary<string, object> snapshot;

        private static FieldInfo[] Fields =>
            typeof(FieldworkCompanionsSettings).GetFields(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);

        private static string BackupPath(string path) => path + ".pickle-backup";

        // The mod may legitimately be absent: Pickle also plays its own sample features in the same
        // process, and a hook that throws here would fail every one of them.
        private static bool ModLoaded => LoadedModManager.GetMod<FieldworkCompanionsMod>() != null
                                          && FieldworkCompanionsMod.Settings != null;

        [BeforeScenario]
        public void IsolateSettings(PickleContext ctx)
        {
            if (!ModLoaded) return;

            var path = Driver.SettingsFilePath(ctx);
            if (File.Exists(BackupPath(path)))
            {
                File.Copy(BackupPath(path), path, overwrite: true);
                File.Delete(BackupPath(path));
            }
            if (File.Exists(path)) File.Copy(path, BackupPath(path), overwrite: true);

            snapshot = new Dictionary<string, object>();
            foreach (var f in Fields) snapshot[f.Name] = f.GetValue(FieldworkCompanionsMod.Settings);
        }

        [AfterScenario]
        public void RestoreSettings(PickleContext ctx)
        {
            if (!ModLoaded) return;

            if (snapshot != null)
            {
                foreach (var f in Fields) f.SetValue(FieldworkCompanionsMod.Settings, snapshot[f.Name]);
                snapshot = null;
            }

            // The settings window keeps its scroll position on the Mod object, which outlives the
            // window: a scenario that scrolled to the bottom would hand the next one a window
            // already scrolled.
            var scroll = typeof(FieldworkCompanionsMod).GetField("scrollPosition", Driver.InstanceAny);
            scroll?.SetValue(Driver.Mod(ctx), Vector2.zero);

            var path = Driver.SettingsFilePath(ctx);
            if (File.Exists(BackupPath(path)))
            {
                File.Copy(BackupPath(path), path, overwrite: true);
                File.Delete(BackupPath(path));
            }
            else if (File.Exists(path))
            {
                // There was no file before this scenario, so any file now is the scenario's own.
                File.Delete(path);
            }
        }
    }
}
