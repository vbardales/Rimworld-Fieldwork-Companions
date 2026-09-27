# In-game scenarios, run by Pickle

The features in `Mod/Pickle/Features/`, written in Gherkin and played inside a running RimWorld by
[Pickle](https://github.com/RimWorks/Rimworld-Pickle) (`rimworks.pickle`, Workshop 3791648678).
`../../TESTING.md` says which passes to run and what each proves; this file is the practical side.

`Mod/` is a companion mod, **Fieldwork Companions - Pickle tests**, never published. It holds the
features and the steps assembly, so nothing test-related ships in the Workshop folder.

## Run

A session does not launch the game: it **deposits a request** with the TicketDispatcher, whose worker plays it through
`scripts/Run-PickleWsl.ps1` (machine lock, staging, Xvfb) and wakes the session by message. One request per pass, a
fix or an exploration plays the fewest scenarios (`-Filter '::<scenario>'`), an initial or final pass plays all of them,
in three small tickets selected by the `@part1`, `@part2` and `@part3` tags of the features (01-05, 06-08, 09-17).
The Windows install is never launched by a session. From `rimworld/`:

```powershell
$id = 'local_<the session id, from get_session "self">'
$set = 'Fieldwork Companions - Pickle tests'
powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher/scripts/Submit-PickleRun.ps1 -Mod FieldworkCompanions -Owner $id `
  -Filter "$set,!@part2,!@part3" -DepMap wsl-deps.runtime-evidence.map -Label "<SHA> pass 1 English, part 1 of 3" `
  -EvidenceDir FieldworkCompanions/Tests/Pickle/Evidence/<date>-pass1-part1
# French: add -Language French. RIMMSQOL: -DepMap wsl-deps.avec-rimmsqol.map -Filter '09-rimmsqol-shortcut.feature'
# Without Odyssey: -DepMap wsl-deps.sans-odyssey.map -Filter '17-without-odyssey.feature'
powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher/scripts/Submit-PickleRun.ps1 -List
```

The request carries no SHA and the mod is staged when its ticket is played, sometimes hours later: keep the tree on the
revision under test until the `RUN_DONE` message, and write the SHA in `-Label`. No `Monitor`, heartbeat or cron for the
queue. To look without launching: `powershell.exe -ExecutionPolicy Bypass -File scripts/Pickle-Status.ps1`.

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

Every review capture loads PickleTools' `nelim-zen-meadow-studio` fixture and frames its `zen`
preset first. Functional scenarios which need the standard fixture remain separate; the studio is
the reproducible setting for the reviewer-facing evidence.

| Capture | The question |
| --- | --- |
| `settings page, top / bottom, as this pass runs it` | Any control running past the window edge, any clipped label or tooltip anchor? |
| `settings page opened by the MainButtons shortcut` | Is it the same window Mod options opens? |
| `language, settings page top / bottom` (French pass) | Any accented gibberish (a key missing from French) or clean English among French text (a literal that never went through Translate)? |
| `the mark over the companion` and `companion-bonus-mark` film | Is the +N over the dog, readable, and not hidden behind the colonist? |
| `settings-page-scroll` film | Does the page visibly move from its top to its bottom, ending with the reset control in view? |
| `reset confirmation` | Is the confirmation understandable and attached to the reset action? |

A capture taken without developer mode proves nothing about missing keys; every Pickle run is in
developer mode.

## Files

- `Source/` steps: `Driver` (lookups that name their own misses), `SettingsSandbox` (snapshot and
  restore of the live settings and of the settings file around every scenario), `SettingsSteps`,
  `ShortcutSteps`, `LanguageSteps`, `HookSteps`, `FieldworkSteps` (companions, rocks, plants, cows,
  yields, marks). Screenshot mode, diagnostic keyed clicks and tick-based films come from PickleTools.
- `wsl-deps.runtime-evidence.map`: ScreenshotMode, ClickDiagnostics, FilmTicks and ScreenshotStudio
  for the English/French evidence passes.
- `wsl-deps.avec-rimmsqol.map`: the RIMMSQOL pass map. The mod has no optional mod to stage (Harmony,
  RimLogging and Pickle are known to the launcher), but RIMMSQOL is the customization integration
  MOD_SETTINGS.md asks to have tested. The map stages it with the shared steps of
  `PickleTools/RimmsqolSteps` (a folder of the PickleTools repository, cloned at the root of the
  collection); features 09 to 12 are tagged `@rimmsqol` and play only in that pass. Guide to the
  launcher, the queue and the passes: `PickleTools/Headless/README.md`.
