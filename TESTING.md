# Testing

Three layers, from cheapest to dearest. Everything that can be proved out of game is proved out of
game; a Pickle run takes over the machine for tens of minutes and is kept for what only a running
game can show.

| Layer | Where | What it settles | Cost |
| --- | --- | --- | --- |
| Out-of-game harness | `_tools/Run-Functional-Tests.ps1` (25 checks) | The four patched vanilla methods still exist with the expected shape and nothing overrides them; the three non-public members the mod reads are covered by the access waiver; the chance arithmetic, clamps, defaults, reset and real Scribe round trip; the shortcut Def; every translation key in EN and FR; About metadata | seconds |
| Resource checks | `../scripts/Check-DefInjected.ps1` | The two DefInjected paths resolve | seconds |
| Pickle, in game | `Tests/Pickle/` (17 features) | The patches are installed and fire on the game's real runtime; the real settings dialog draws; the real settings file; the shortcut in the real main bar; the language the pass runs; a save that holds nothing of the mod | tens of minutes |
| Evidence review | Pickle screenshots and films | A human reviews the rendered result; no manual gameplay procedure is a release gate | minutes |

## The passes

A run is `powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod FieldworkCompanions`
from the parent folder, and only through that script: it takes the machine lock, stages, runs under
Xvfb and gives the lock back. The Windows install is never launched.

A validation pass (first or last) plays every scenario, but as several small tickets rather than one big one, so
that other mods are not made to wait behind an hour of lock. Pass 1 plays about 60 scenarios, many of them films
and captures at 30 to 110 s each, and does not fit in Pickle's default deadline of 45 minutes (the third attempt,
2026-09-24, was ended by it after 43 scenarios, `exitReason: watchdog-timeout`). Every feature therefore carries a
`@part1`, `@part2` or `@part3` tag (01-05, 06-08, 09-17), and a pass is played as three tickets, each excluding the
other two with the filter syntax the launcher already knows:

```
-Filter "Fieldwork Companions - Pickle tests,!@part2,!@part3"    # part 1
-Filter "Fieldwork Companions - Pickle tests,!@part1,!@part3"    # part 2
-Filter "Fieldwork Companions - Pickle tests,!@part1,!@part2"    # part 3
```

The pass counts as complete when the three reports each end with `exitReason: passed` and their scenarios add up to
the whole suite. A targeted fix or an exploration is the opposite case: one ticket, one scenario, `-Filter '::<name>'`.

Submit each ticket with `Rimworld-Ticket-Dispatcher/scripts/Submit-PickleRun.ps1` (`-Owner` is the session id, not a process kept in the session), always with `-EvidenceDir FieldworkCompanions/Tests/Pickle/Evidence/<date>-<pass>` (relative to the rimworld root, where the launcher lives): before giving the lock back, the launcher then copies
this launch's report there, and, when the game wrote none (a crash at startup, a stall, the machine going to sleep),
its `Player.log` and a `no-report.txt`. Without it the log of a run that died is left in the shared `pickle-reports/`
and is overwritten by the next ticket; the launcher's own `pickle-reports-archive/<stamp>-nosummary` copy is pruned
after five archives. A run with no report is no verdict, but its log is what tells a game crash from a suite defect,
so it is kept and named in `docs/runs/history.md`.

Four passes are required, and the report must say which is which.

| # | Pass | Command | Mods loaded | What it proves |
| --- | --- | --- | --- | --- |
| 1 | Without optional mods, English | `... -Mod FieldworkCompanions -DepMap wsl-deps.runtime-evidence.map` | Core, DLC, Harmony, RimLogging, Pickle, companion and evidence-only PickleTools | The mod stands alone and produces reviewable evidence. |
| 2 | Without optional mods, French | `... -Mod FieldworkCompanions -DepMap wsl-deps.runtime-evidence.map -Language French` | Same set | Every text exists in French; review media for layout and literals. |
| 3 | With RIMMSQOL | `... -Mod FieldworkCompanions -DepMap wsl-deps.avec-rimmsqol.map -Filter '09-rimmsqol-shortcut.feature'`, then the restart chain `-Filter '10-rimmsqol-restart-reveal.feature' -Then '11-rimmsqol-restart-hide.feature','12-rimmsqol-restart-forget.feature'` | The same set plus RIMMSQOL (Workshop 1084452457) and `PickleTools/RimmsqolSteps` | RIMMSQOL's own list offers the shortcut, can reveal it, the bar draws it, it opens this mod's own dialog and shares its values, hiding works, and the choice survives a restart |
| 4 | Without Odyssey | `... -Mod FieldworkCompanions -DepMap wsl-deps.sans-odyssey.map -Filter '17-without-odyssey.feature'` | The same set minus the Odyssey DLC, plus `PickleTools/ExpansionSteps` | `Dig` and `Forage` do not exist, nothing is logged, and an obedient animal still helps with the requirement ticked: the mod falls back on obedience alone |

**Passes with optional mods: only RIMMSQOL, and it is an integration, not an optional mod.** The mod
declares no optional mod of its own. Its `loadAfter` names Harmony and the Ludeon DLC, and the minimal
staging already mounts all of those, so a pass "with the optional mods" would be pass 1 under another
name. RIMMSQOL is not something the code reads: it is the customization tool MOD_SETTINGS.md asks to
have tested and named, so it lives in a pass map (`Tests/Pickle/wsl-deps.avec-rimmsqol.map`) and in no
`About.xml`. It is the only customization mod claimed as tested. There is no combination of exclusive
optional mods to cover.

Pass 3 uses the shared steps of `PickleTools/RimmsqolSteps`, which reveals and hides the button through
RIMMSQOL's own settings instance rather than by clicking its checkbox. Its features carry
`@requires:MalteSchulze.RIMMSqol` and `@requires:nelim.pickletools.rimmsqol`, which is what makes passes 1 and 2
skip them: Pickle skips only on `@requires:<packageId>`, and the `@rimmsqol` tag alone skips nothing (without the
`@requires` tags the shared run of 2026-09-22 played them without RIMMSQOL and they failed). A new RIMMSQOL feature
needs the same two tags.

**Passes for a declared incompatibility: none.** `About.xml` has no `incompatibleWith`, and neither
the README nor the description names an incompatible mod. If one is ever declared, it needs its own
pass (`wsl-deps.incompat-<mod>.map`) that asserts the documented symptom rather than expecting a red.

The reports are read in this order: `exitReason` first, then the number of scenarios played against
the number of features discovered, then the outcomes. A green run of a `@review` scenario says the
trip happened, not that the capture is right: those captures are opened and looked at, and the
result is recorded in `STATUS.md`.

`@requires:<packageId>` scenarios skip when the selected pass does not stage that dependency. A
required scenario that skips is not a pass. `@requires:Odyssey` scenarios skip without Odyssey.

## Evidence to keep

The disk is shared and full, so a report is kept only while it still proves something (root `AGENTS.md`, "Test
evidence"). **A proof belongs to a revision**: every summary in `docs/runs/` names the commit and the SHA-256 of
`Mod/Assemblies/FieldworkCompanions.dll` and of the steps assembly it ran against, and a report of another build
proves nothing about the current one. Per pass, keep the latest report for the revision now in the repository,
minified with `Tests/Pickle/Minify-Evidence.ps1`, under `Tests/Pickle/Evidence/<date>-<pass>/` (on disk, ignored
by git), and one text line in `docs/runs/history.md`. What that report has to contain:

| Proof | Where it is | Why it cannot be dropped |
| --- | --- | --- |
| `exitReason`, scenarios played against features discovered, outcome per scenario | `junit.xml`, `summary.md` | The first thing read; a report without them is not a verdict |
| The numbers the gameplay scenarios asserted against (the gains of 80, 12, 16, 90 and their plain values) | failure or attachment text in `junit.xml`; copied into the run summary | The thresholds come from vanilla defs and have never been observed: the first completed run is the only place they are read |
| No `MethodAccessException` naming `ResourceDef`, `ResourceAmount` or `GetSteps`, and no `Attempted to set master` | `Player.log` | This is the only evidence of what the access waiver costs on RimWorld's Mono; nobody has produced that log yet |
| The settings page, top and bottom, in English (pass 1) and French (pass 2) | `02-settings-page`, `05-language` captures, opened and looked at | The scroll bar and the two last controls (the mark checkbox and the reset button) are the regression check of the `maxOneColumn` fix; the French capture is where a missing key shows as accented text |
| The mark over the companion | `06-assists` film and capture | The one picture that shows the mod doing something; also the candidate for the Workshop |
| RIMMSQOL's list and edit pages, the shortcut opened through the bar | pass 3 captures | The only sight of the shortcut in another mod's interface |
| That a conditional scenario **ran** (not skipped) in a pass that met its condition | `junit.xml` (`skipped` count per feature) | `@requires:Odyssey`, `@requires:<tool>` and pass 4 are part of the `tested` gate; a skip is not a pass |

Not kept: `report.html` and `messages.ndjson` (derived from `junit.xml`), captures nobody opened, reports of
superseded builds, and the settings file and the save the scenarios read back (they are asserted in the run, not
archived). A capture that has to be measured to the pixel keeps its original; the others are JPEG. A run that ended
without a report gets a line in `history.md` and no folder.

The summary of a run says which of these it holds, which captures were opened and what they showed, and, when a
proof is missing, that it is missing.
## Which scenario covers what

| Feature | Covers | `FUNCTIONAL-SCENARIOS.md` |
| --- | --- | --- |
| `01-loading` | Mod loaded after Harmony; no error at startup; the four hooks patched by this mod; documented defaults on a clean profile; the shortcut Def exists | 0 |
| `02-settings-page` | The real settings window at the top and at the bottom, captured (`@review`) | 15 |
| `03-settings-persistence` | The real file is written, read back through the game's own reader, and written when the window closes | 15 |
| `04-mainbuttons-shortcut` | Hidden on a clean configuration; drawn and live when revealed; opens this mod's dialog; shares values with Mod options | 16 |
| `09` to `12` (pass 3) | RIMMSQOL lists, reveals, hides and forgets the shortcut; the bar draws it; it opens this mod's dialog and shares values; the choice survives two restarts | 16 |
| `05-language` | Every key exists in the language of the pass; the shortcut text is the one written for it; captures for a person to read | 15 |
| `06-assists` | Mining, harvesting and milking through the real vanilla methods, with and without a companion; obedience; the training requirement; the mark over the animal | 1, 4, 5, 9, 10 |
| `07-chance` | The chance in a live game, including the read of the internal training-step count | 10, 11 |
| `08-save-compatibility` | After an assist, the saved game holds nothing written by the mod | 13 |
| `13-companion-rules` | Another colonist's animal never helps; the follow box; the radius (15 cells away, then widened to 30); the extra lands at the worked cell; a tiny share still gives one; the bond forms through the game's own call, and does not at zero | 2, 3, 4, 11 |
| `14-what-it-does-not-help` | A deep drill; cutting a plant down; an animal mining on its own (Odyssey); a cow that is its own master's companion; a colony with no companion gives only plain yields, marks nothing and leaves the random generator alone | 5, 6, 7, 9, 14 |
| `15-switches-and-shearing` | Each work switch silences its own gesture and none other; shearing, with a companion and too far | 9, 12 |
| `16-fishing` | A lake is built; exactly one extra fish of a landed kind; the fishing switch; an animal fishing on its own (Odyssey) | 8 |
| `17-without-odyssey` (pass 4) | The pass leaves only Odyssey out; the mod falls back on obedience alone | 10, 16 |

## What is not a gate

**No manual scenario remains as a gate: each is written as a Pickle feature, and none of features 13 to 17 has been
played yet.** Every scenario of `_tools/FUNCTIONAL-SCENARIOS.md` has a Pickle feature (see the table above and the
mapping at the top of that file). That is coverage by design, not a result: a scenario counts once its pass has
completed (`exitReason: passed`, scenarios played equal to features discovered) and its `@review` captures have
been opened. What follows are limits of the automated route, each recorded so that nobody reads a green run as more
than it says; none asks for a hand-played validation.

- **The walk.** The scenarios call the vanilla method each gesture ends with (`Mineable.DestroyMined`,
  `Plant.PlantCollected`, `CompHasGatherableBodyResource.Gathered`, `FishingUtility.GetCatchesFor`), not the
  job that leads to it. What only a live game adds is that the patch fires there, and that is proved by
  `01-loading` (the patches are installed by this mod) and by every scenario that shows a bonus. Whether a
  colonist, following a real order, ends up at that call is the game's own job driver, which the mod does not touch.
- **Real randomness.** Every gameplay scenario runs at 100 % chance. The chance arithmetic is proved out of game
  and read in a live game by `07-chance`. Whether 15 % feels right is a play question, not a test.
- **What RIMMSQOL's checkbox does.** Pass 3 drives RIMMSQOL through the calls its Visible checkbox makes, not
  through a click on it: that the checkbox is wired to those calls is read from its source, not shown. No other
  customization mod is tested.
- **A real restart of this mod's own settings.** The settings scenarios re-read the file in the same process.
  RIMMSQOL's visibility choice does survive a restart in pass 3, a three-launch chain, but that is RIMMSQOL's file.
- **Adding and removing the mod mid-game (scenario 13).** Pickle stages one mod set per run, so a save made with the
  mod cannot be loaded without it. The claim is that nothing of the mod is written to a save, and
  `08-save-compatibility` checks exactly that on a real save written after an assist: a save holding none of the
  mod's types loads without it, since RimWorld only complains about what a save refers to.
- **The fishing lake is made, not found.** The shared test colony has no water body with fish, so
  `16-fishing` builds one. The catch method is the vanilla one and the fish is the game's own; the lake is not.
- **A window from another mod covering a click.** The only scenario that clicks at all, the reset button, goes
  through `PickleTools/ClickDiagnostics` and would name the covering window and its assembly.
## Status of these tests

Written 2026-09-21. Validated without running the game: the steps assembly builds against the
shipped DLL, and `Tests/Pickle/Check-Steps.ps1` compiles every step pattern with Pickle's own
engine and matches every step line of every feature against them. An initial English run ended
without a completed report. **No completed Fieldwork Companions pass has been reviewed**, so
the numbers in `06-assists.feature` remain derived from the vanilla 1.6 defs rather than observed.
