# Testing

Three layers, cheapest to dearest. Everything provable out of game proved out of
game; Pickle run takes over machine tens of minutes, kept for what only running
game can show.

| Layer | Where | What it settles | Cost |
| --- | --- | --- | --- |
| Out-of-game harness | `scripts/Run-Functional-Tests.ps1` (25 checks) | Four patched vanilla methods still exist with expected shape, nothing overrides them; three non-public members mod reads covered by access waiver; chance arithmetic, clamps, defaults, reset, real Scribe round trip; shortcut Def; every translation key in EN and FR; About metadata | seconds |
| Resource checks | `../scripts/Check-DefInjected.ps1` | Two DefInjected paths resolve | seconds |
| Pickle, in game | `Tests/Pickle/` (20 features) | Patches installed and fire on game's real runtime; real settings dialog draws; real settings file; shortcut in real main bar; language pass runs; save holds nothing of mod | tens of minutes |
| Evidence review | Pickle screenshots and films | Human reviews rendered result; no manual gameplay procedure is release gate | minutes |

## The passes

Run = `powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod FieldworkCompanions`
from parent folder, only through that script: takes machine lock, stages, runs under
Xvfb, gives lock back. Windows install never launched.

Validation pass (first or last) plays every scenario, but as several small tickets not one big one, so
other mods not wait behind hour of lock. Pass 1 plays about 60 scenarios, many films
and captures 30 to 110 s each, does not fit Pickle default deadline 45 minutes (third attempt,
2026-09-24, ended by it after 43 scenarios, `exitReason: watchdog-timeout`). So every feature carries
`@part1`, `@part2` or `@part3` tag (01-05; 06-08 and 20; 09-19), pass played as three tickets, each excluding other
two with filter syntax launcher already knows:

```
-Filter "Fieldwork Companions - Pickle tests,!@part2,!@part3"    # part 1
-Filter "Fieldwork Companions - Pickle tests,!@part1,!@part3"    # part 2
-Filter "Fieldwork Companions - Pickle tests,!@part1,!@part2"    # part 3
```

Pass complete when three reports each end `exitReason: passed` and scenarios add up to
whole suite. Targeted fix or exploration is opposite: one ticket, one scenario, `-Filter '::<name>'`.

Submit each ticket with `Rimworld-Ticket-Dispatcher/scripts/Submit-PickleRun.ps1` (`-Owner` is session id, not process kept in session), always with `-EvidenceDir FieldworkCompanions/Tests/Pickle/Evidence/<date>-<pass>` (relative to rimworld root, where launcher lives): before giving lock back, launcher copies
this launch's report there, and, when game wrote none (crash at startup, stall, machine sleeping),
its `Player.log` and `no-report.txt`. Without it, log of dead run left in shared `pickle-reports/`
and overwritten by next ticket; launcher's own `pickle-reports-archive/<stamp>-nosummary` copy pruned
after five archives. Run with no report = no verdict, but its log tells game crash from suite defect,
so kept and named in `docs/runs/history.md`.

Six passes required, report must say which is which.

| # | Pass | Command | Mods loaded | What it proves |
| --- | --- | --- | --- | --- |
| 1 | Without optional mods, English | `... -Mod FieldworkCompanions -DepMap wsl-deps.runtime-evidence.map` | Core, DLC, Harmony, RimLogging, Pickle, companion and evidence-only PickleTools | Mod stands alone, produces reviewable evidence. |
| 2 | Without optional mods, French | `... -Mod FieldworkCompanions -DepMap wsl-deps.runtime-evidence.map -Language French` | Same set | Every text exists in French; review media for layout and literals. |
| 3 | With RIMMSQOL | `... -Mod FieldworkCompanions -DepMap wsl-deps.avec-rimmsqol.map -Filter '09-rimmsqol-shortcut.feature'`, then the restart chain `-Filter '10-rimmsqol-restart-reveal.feature' -Then '11-rimmsqol-restart-hide.feature','12-rimmsqol-restart-forget.feature'` | Same set plus RIMMSQOL (Workshop 1084452457) and `PickleTools/RimmsqolSteps` | RIMMSQOL's own list offers shortcut, can reveal it, bar draws it, opens this mod's own dialog, shares its values, hiding works, choice survives restart |
| 4 | Without Odyssey | `... -Mod FieldworkCompanions -DepMap wsl-deps.sans-odyssey.map -Filter '17-without-odyssey.feature'` | Same set minus Odyssey DLC, plus `PickleTools/ExpansionSteps` | `Dig` and `Forage` do not exist, nothing logged, obedient animal still helps with requirement ticked: mod falls back on obedience alone |
| 5 | Retrait: game saved with mod, loaded without it | `... -Mod FieldworkCompanions -DepMap wsl-deps.retrait.map -Filter '19-save-for-removal.feature' -Then 'removal-check' -ThenWithout nelim.fieldworkcompanions,nelim.fieldworkcompanions.pickletests` | Same set, plus companion `Tests/Pickle/Removal`, not depending on mod; second launch runs with mod and test companion taken out of mod list | Save made after assist holds nothing of mod outside its mod list, loads, runs 250 ticks, saves again without mod, no error (FUNCTIONAL-SCENARIOS.md scenario 13, second half). First half, game saved without mod loaded with it, is `18-added-to-a-game-in-progress`, played every pass. |
| 6 | Gallery photograph, in Sanctuary | `... -Mod FieldworkCompanions -DepMap wsl-deps.sanctuary.map -Filter '::a real mining job'` | Backlot's minimum mod list (Female Body/Apparel Variants, WDI, AB's Visible Pants, facial animation) plus ColonistRace, InterfaceScale, ScreenshotMode; fixture `Nelims-tribe` comes from SanctuaryBacklot repository | `20-gallery-mark` only (`@requires:ab.vplrf` keeps it out of other passes). Produces image 1 of gallery; capture opened and looked at, green run not a validation |

**Passes with optional mods: only RIMMSQOL, and it is integration, not optional mod.** Mod
declares no optional mod of its own. Its `loadAfter` names Harmony and Ludeon DLC, minimal
staging already mounts all those, so "with optional mods" pass would be pass 1 under another
name. RIMMSQOL not something code reads: it is customization tool MOD_SETTINGS.md asks to
have tested and named, so lives in pass map (`Tests/Pickle/wsl-deps.avec-rimmsqol.map`) and no
`About.xml`. Only customization mod claimed tested. No combination of exclusive
optional mods to cover.

Pass 3 uses shared steps of `PickleTools/RimmsqolSteps`, which reveals and hides button through
RIMMSQOL's own settings instance, not by clicking its checkbox. Its features carry
`@requires:MalteSchulze.RIMMSqol` and `@requires:nelim.pickletools.rimmsqol`, which makes passes 1 and 2
skip them: Pickle skips only on `@requires:<packageId>`, `@rimmsqol` tag alone skips nothing (without
`@requires` tags shared run of 2026-09-22 played them without RIMMSQOL and they failed). New RIMMSQOL feature
needs same two tags.

**Passes for declared incompatibility: none.** `About.xml` has no `incompatibleWith`, and neither
README nor description names incompatible mod. If one ever declared, needs own
pass (`wsl-deps.incompat-<mod>.map`) asserting documented symptom, not expecting red.

Reports read in this order: `exitReason` first, then scenarios played against
features discovered, then outcomes. Green run of `@review` scenario says trip
happened, not capture right: those captures opened and looked at, result
recorded in `STATUS.md`.

`@requires:<packageId>` scenarios skip when selected pass does not stage that dependency. Required
scenario that skips is not pass. `@requires:Odyssey` scenarios skip without Odyssey.

## Evidence to keep

Disk shared and full, so report kept only while it still proves something (root `AGENTS.md`, "Test
evidence"). **Proof belongs to revision**: every summary in `docs/runs/` names commit and SHA-256 of
`Mod/Assemblies/FieldworkCompanions.dll` and of steps assembly it ran against; report of another build
proves nothing about current one. Per pass, keep latest report for revision now in repository,
minified with shared `scripts/Minify-Evidence.ps1` (protocols repository), under `Tests/Pickle/Evidence/<date>-<pass>/` (on disk, ignored
by git), and one text line in `docs/runs/history.md`. What report must contain:

| Proof | Where it is | Why it cannot be dropped |
| --- | --- | --- |
| `exitReason`, scenarios played against features discovered, outcome per scenario | `junit.xml`, `summary.md` | First thing read; report without them not verdict |
| Numbers gameplay scenarios asserted against (gains of 80, 12, 16, 90 and plain values) | failure or attachment text in `junit.xml`; copied into run summary | Thresholds come from vanilla defs, never observed: first completed run only place they are read |
| No `MethodAccessException` naming `ResourceDef`, `ResourceAmount` or `GetSteps`, no `Attempted to set master` | `Player.log` | Only evidence of what access waiver costs on RimWorld's Mono; nobody has produced that log yet |
| Settings page, top and bottom, English (pass 1) and French (pass 2) | `02-settings-page`, `05-language` captures, opened and looked at | Scroll bar and two last controls (mark checkbox and reset button) are regression check of `maxOneColumn` fix; French capture is where missing key shows as accented text |
| Mark over companion | `06-assists` film and capture | One picture showing mod doing something; also Workshop candidate |
| RIMMSQOL's list and edit pages, shortcut opened through bar | pass 3 captures | Only sight of shortcut in another mod's interface |
| Conditional scenario **ran** (not skipped) in pass meeting its condition | `junit.xml` (`skipped` count per feature) | `@requires:Odyssey`, `@requires:<tool>` and pass 4 are part of `tested` gate; skip is not pass |

Not kept: `report.html` and `messages.ndjson` (derived from `junit.xml`), captures nobody opened, reports of
superseded builds, settings file and save scenarios read back (asserted in run, not
archived). Capture needing pixel measurement keeps original; others JPEG. Run ended
without report gets line in `history.md`, no folder.

Run summary says which of these it holds, which captures opened and what they showed, and, when
proof missing, that it is missing.
## Which scenario covers what

| Feature | Covers | `FUNCTIONAL-SCENARIOS.md` |
| --- | --- | --- |
| `01-loading` | Mod loaded after Harmony; no error at startup; four hooks patched by this mod; documented defaults on clean profile; shortcut Def exists | 0 |
| `02-settings-page` | Real settings window top and bottom, captured (`@review`) | 15 |
| `03-settings-persistence` | Real file written, read back through game's own reader, written when window closes | 15 |
| `04-mainbuttons-shortcut` | Hidden on clean configuration; drawn and live when revealed; opens this mod's dialog; shares values with Mod options | 16 |
| `09` to `12` (pass 3) | RIMMSQOL lists, reveals, hides, forgets shortcut; bar draws it; opens this mod's dialog and shares values; choice survives two restarts | 16 |
| `05-language` | Every key exists in pass language; shortcut text is the one written for it; captures for person to read | 15 |
| `06-assists` | Mining, harvesting, milking through real vanilla methods, with and without companion; obedience; training requirement; mark over animal | 1, 4, 5, 9, 10 |
| `07-chance` | Chance in live game, including read of internal training-step count | 10, 11 |
| `08-save-compatibility` | After assist, saved game holds nothing written by mod | 13 |
| `13-companion-rules` | Another colonist's animal never helps; follow box; radius (15 cells away, then widened to 30); extra lands at worked cell; tiny share still gives one; bond forms through game's own call, not at zero | 2, 3, 4, 11 |
| `14-what-it-does-not-help` | Deep drill; cutting plant down; animal mining on its own (Odyssey); cow that is its own master's companion; colony with no companion gives only plain yields, marks nothing, leaves random generator alone | 5, 6, 7, 9, 14 |
| `15-switches-and-shearing` | Each work switch silences own gesture and none other; shearing, with companion and too far | 9, 12 |
| `16-fishing` | Lake built; exactly one extra fish of landed kind; fishing switch; animal fishing on its own (Odyssey) | 8 |
| `17-without-odyssey` (pass 4) | Pass leaves only Odyssey out; mod falls back on obedience alone | 10, 16 |
| `18-added-to-a-game-in-progress` | Shared fixture written without this mod; loads with mod, runs, saves again | 13 |
| `19-save-for-removal` (pass 5) | Game saved with mod holds nothing of it outside mod list, handed to companion that launch without mod loads | 13 |
| `20-gallery-mark` | For person: real mining job, animal beside colonist, mark over animal, taken at right instant (Workshop page picture) | 1 |

## What is not a gate

**No manual scenario remains as gate: each written as Pickle feature, none of features 13 to 17 played
yet.** Every scenario of `scripts/FUNCTIONAL-SCENARIOS.md` has Pickle feature (see table above and
mapping at top of that file). Coverage by design, not result: scenario counts once its pass has
completed (`exitReason: passed`, scenarios played equal features discovered) and its `@review` captures
opened. Below are limits of automated route, each recorded so nobody reads green run as more
than it says; none asks for hand-played validation.

- **The walk.** Scenarios call vanilla method each gesture ends with (`Mineable.DestroyMined`,
  `Plant.PlantCollected`, `CompHasGatherableBodyResource.Gathered`, `FishingUtility.GetCatchesFor`), not
  job leading to it. Live game only adds that patch fires there, proved by
  `01-loading` (patches installed by this mod) and every scenario showing bonus. Whether
  colonist, following real order, ends at that call is game's own job driver, which mod does not touch.
- **Real randomness.** Every gameplay scenario runs at 100 % chance. Chance arithmetic proved out of game
  and read in live game by `07-chance`. Whether 15 % feels right is play question, not test.
- **What RIMMSQOL's checkbox does.** Pass 3 drives RIMMSQOL through calls its Visible checkbox makes, not
  through click: that checkbox wired to those calls read from its source, not shown. No other
  customization mod tested.
- **Real restart of this mod's own settings.** Settings scenarios re-read file in same process.
  RIMMSQOL's visibility choice does survive restart in pass 3, three-launch chain, but that is RIMMSQOL's file.
- **Fishing lake made, not found.** Shared test colony has no water body with fish, so
  `16-fishing` builds one. Catch method is vanilla, fish is game's own; lake is not.
- **Window from another mod covering click.** Only scenario that clicks at all, reset button, goes
  through `PickleTools/ClickDiagnostics` and would name covering window and its assembly.
## Status of these tests

Written 2026-09-21; passes played on revision `cd1afb7` (2026-09-27/28), audited 2026-10-02. State against
gate `done -> tested` as audit now states it:

- **No `@wip` scenario** under `Tests/Pickle/Mod/Pickle/Features` (grep, 2026-10-02).
- **Every conditional scenario has run, in pass meeting its condition**: `@requires:Odyssey` in passes 1 and 2
  (0 skipped in parts 1-2); RIMMSQOL (09-12) in pass 3; `17-without-odyssey` in pass 4; `19-save-for-removal` and
  `removal-check` in pass 5. 11 skips of parts 3 of passes 1 and 2 are exactly those, by design, not
  counted as passed.
- **No manual test left to validate**: see "What is not a gate". `@review` captures opened and looked at
  (`STATUS.md`, 2026-09-29).

Evidence folders on disk (`Tests/Pickle/Evidence/`, ignored by git, about 5.5 MB), and what each is only proof of.
New report of same scenario on revision now in repository replaces line, folder goes once
nothing else in it is latest:

| Folder | Scenarios it proves | Note |
| --- | --- | --- |
| `2026-09-27-pass1-part1` / `-part2` / `-part3` | Pass 1 (English), parts 1-3 | `-part3` holds `16-fishing` from before fix; `2026-09-28-fix-fishing-en` replaces that scenario only |
| `2026-09-27-pass2-part1` / `-part2` / `-part3` | Pass 2 (French), parts 1-3 | `-part3` holds the one red (`16-fishing`); `2026-09-28-fix-fishing-fr` replaces it, other 20 scenarios have no other report |
| `2026-09-28-fix-fishing-en` / `-fr` | `16-fishing`, fixed | Latest for that scenario |
| `2026-09-27-pass3-rimmsqol/seq1` | `09-rimmsqol-shortcut` | |
| `2026-09-28-pass3-chain-3/seq1-3` | `10`, `11`, `12` (restart chain) | |
| `2026-09-28-pass4-newcolony` | `17-without-odyssey` | Version of scenario starting fresh colony |
| `2026-09-25-retrait-3/seq1-2` | `19-save-for-removal`, `removal-check` | Played from working tree before feature committed; replayed by final non-regression pass, then this folder goes |

No evidence, film, capture or `.dds` tracked in git; `.gitignore` carries `Tests/Pickle/Evidence/`, `Evidence/` and
`*.dds`.