# In-game scenarios, run by Pickle

The features in `Mod/Pickle/Features/`, written in Gherkin and played inside a running RimWorld by
[Pickle](https://github.com/RimWorks/Rimworld-Pickle) (`rimworks.pickle`, Workshop 3791648678).
`../../TESTING.md` says which passes to run and what each proves; this file is the practical side.

`Mod/` is a companion mod, **Fieldwork Companions - Pickle tests**, never published. It holds the
features and the steps assembly, so nothing test-related ships in the Workshop folder.

## Run

From the parent folder, only through the launcher, which takes the machine lock, stages, plays under
Xvfb and gives the lock back. The Windows install is never launched by a session.

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod FieldworkCompanions
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod FieldworkCompanions -Language French
```

Before any launch, check both sides (`Get-Process RimWorldWin64` and
`wsl.exe -- bash -lc "pgrep -fa RimWorldLinux"`), and if something runs, read whose it is before
touching it: `scripts/Pickle-Status.ps1` says.

## Build the steps

```powershell
dotnet build Tests/Pickle/Source/FieldworkCompanions.PickleSteps.csproj -c Release
```

The output goes to `Mod/Pickle/Assemblies/` and is committed, because the staging copies
`Tests/Pickle/Mod` verbatim. It binds to `Mod/Assemblies/FieldworkCompanions.dll`: build the mod
first if it is stale. Feature files need no build.

## Check before spending a run

```powershell
powershell.exe -ExecutionPolicy Bypass -File Tests/Pickle/Check-Steps.ps1
```

Two seconds, no game. It compiles every step pattern with Pickle's own engine and matches every step
line of every feature against them. An invalid pattern makes Pickle refuse to build its whole step
table, so a run plays zero scenarios and reports `infrastructure-error`; a duplicate pattern fails
healthy scenarios as `Ambiguous step`. Both are cheaper to find here.

## Look at the captures

Scenarios tagged `@review` assert nothing about their pictures. After a run, open
`PickleReports/screenshots/` and answer one question per image:

| Capture | The question |
| --- | --- |
| `settings page, top / bottom, as this pass runs it` | Any control running past the window edge, any clipped label or tooltip anchor? |
| `settings page opened by the MainButtons shortcut` | Is it the same window Mod options opens? |
| `language, settings page top / bottom` (French pass) | Any accented gibberish (a key missing from French) or clean English among French text (a literal that never went through Translate)? |
| `the mark over the companion` | Is the +N over the dog, readable, and not hidden behind the colonist? |

A capture taken without developer mode proves nothing about missing keys; every Pickle run is in
developer mode.

## Files

- `Source/` steps: `Driver` (lookups that name their own misses), `SettingsSandbox` (snapshot and
  restore of the live settings and of the settings file around every scenario), `SettingsSteps`,
  `ShortcutSteps`, `LanguageSteps`, `HookSteps`, `FieldworkSteps` (companions, rocks, plants, cows,
  yields, marks), `ScreenshotSteps`.
- `wsl-deps.avec-rimmsqol.map`: the only pass map. The mod has no optional mod to stage (Harmony,
  RimLogging and Pickle are known to the launcher), but RIMMSQOL is the customization integration
  MOD_SETTINGS.md asks to have tested. The map stages it with the shared steps of
  `PickleTools/RimmsqolSteps` (a folder of the PickleTools repository, cloned at the root of the
  collection); features 09 to 12 are tagged `@wip @rimmsqol` and play only in that pass. Guide to the
  launcher, the queue and the passes: `PickleTools/Headless/README.md`.
