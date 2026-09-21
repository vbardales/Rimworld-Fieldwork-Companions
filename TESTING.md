# Testing

Three layers, from cheapest to dearest. Everything that can be proved out of game is proved out of
game; a Pickle run takes over the machine for tens of minutes and is kept for what only a running
game can show.

| Layer | Where | What it settles | Cost |
| --- | --- | --- | --- |
| Out-of-game harness | `_tools/Run-Functional-Tests.ps1` (25 checks) | The four patched vanilla methods still exist with the expected shape and nothing overrides them; the three non-public members the mod reads are covered by the access waiver; the chance arithmetic, clamps, defaults, reset and real Scribe round trip; the shortcut Def; every translation key in EN and FR; About metadata | seconds |
| Resource checks | `../scripts/Check-DefInjected.ps1` | The two DefInjected paths resolve | seconds |
| Pickle, in game | `Tests/Pickle/` (8 features) | The patches are installed and fire on the game's real runtime; the real settings dialog draws; the real settings file; the shortcut in the real main bar; the language the pass runs; a save that holds nothing of the mod | tens of minutes |
| Manual | `_tools/FUNCTIONAL-SCENARIOS.md` (scenarios 0-16) | Everything below the line in "What Pickle does not cover" | a play session |

## The passes

A run is `powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod FieldworkCompanions`
from the parent folder, and only through that script: it takes the machine lock, stages, runs under
Xvfb and gives the lock back. The Windows install is never launched.

Two passes are required, and the report must say which is which.

| # | Pass | Command | Mods loaded | What it proves |
| --- | --- | --- | --- | --- |
| 1 | Without optional mods, English | `... -Mod FieldworkCompanions` | Core, the DLC, Harmony, RimLogging, Pickle, the companion | The mod stands alone. The only pass whose captures are clean |
| 2 | Without optional mods, French | `... -Mod FieldworkCompanions -Language French` | Same set | Every text exists in French, and no control clips or reads as accented gibberish. The language is chosen at launch, never inside a scenario |

**Passes with optional mods: none.** The mod declares no optional mod. Its `loadAfter` names Harmony
and the Ludeon DLC, and the minimal staging already mounts all of those, so a pass "with the
optional mods" would be pass 1 under another name. There is therefore no combination of exclusive
optional mods to cover either.

**Passes for a declared incompatibility: none.** `About.xml` has no `incompatibleWith`, and neither
the README nor the description names an incompatible mod. If one is ever declared, it needs its own
pass (`wsl-deps.incompat-<mod>.map`) that asserts the documented symptom rather than expecting a red.

The reports are read in this order: `exitReason` first, then the number of scenarios played against
the number of features discovered, then the outcomes. A green run of a `@review` scenario says the
trip happened, not that the capture is right: those captures are opened and looked at, and the
result is recorded in `STATUS.md`.

`@wip` scenarios are skipped unless the launcher is given `-IncludeWip`. One is tagged so
(`02-settings-page.feature`, the reset confirmation): it clicks a button at the bottom of a scroll
view, which has never been tried. `@requires:Odyssey` scenarios are skipped on a game without it.

## Which scenario covers what

| Feature | Covers | `FUNCTIONAL-SCENARIOS.md` |
| --- | --- | --- |
| `01-loading` | Mod loaded after Harmony; no error at startup; the four hooks patched by this mod; documented defaults on a clean profile; the shortcut Def exists | 0 |
| `02-settings-page` | The real settings window at the top and at the bottom, captured (`@review`) | 15 |
| `03-settings-persistence` | The real file is written, read back through the game's own reader, and written when the window closes | 15 |
| `04-mainbuttons-shortcut` | Hidden on a clean configuration; drawn and live when revealed; opens this mod's dialog; shares values with Mod options | 16 |
| `05-language` | Every key exists in the language of the pass; the shortcut text is the one written for it; captures for a person to read | 15 |
| `06-assists` | Mining, harvesting and milking through the real vanilla methods, with and without a companion; obedience; the training requirement; the mark over the animal | 1, 4, 5, 9, 10 |
| `07-chance` | The chance in a live game, including the read of the internal training-step count | 10, 11 |
| `08-save-compatibility` | After an assist, the saved game holds nothing written by the mod | 13 |

## What Pickle does not cover

None of this is a defect of the suite; each is either out of Pickle's reach or would cost a run for
nothing.

- **Fishing.** It needs a water body with fish, which the shared test colony does not have. Its hook
  is checked out of game for existence and signature only. Manual scenario 8.
- **The walk.** The scenarios call the vanilla method each gesture ends with, not the job that leads
  to it: what only a live game adds is that the patch fires there, and the hours of swinging a
  pickaxe add nothing to that. Whether a real colonist, following a real order, ends up at that call
  is manual scenarios 4, 5 and 9.
- **Real randomness.** Every scenario runs at 100 % chance. Whether 15 % feels right is a play
  question, not a test.
- **Odyssey absent.** The minimal set mounts every DLC. A game without Odyssey, where `Dig` and
  `Forage` do not exist and the mod falls back on obedience, is manual.
- **RIMMSQOL.** Revealing the shortcut inside RIMMSQOL's own interface, and whether its choice
  survives a restart, is RIMMSQOL's behaviour and is manual. The suite moves the same
  `MainButtonDef.buttonVisible` field a customization mod moves and asks the game's own worker what
  it would draw.
- **A real restart.** The settings scenarios re-read the file in the same process.
- **Adding and removing the mod mid-game.** Pickle stages one mod set per run. The save scenario
  checks the consequence (nothing written) instead.
- **A window from another mod covering a click.** Only the reset-confirmation scenario clicks at all,
  and it is `@wip`.

## Status of these tests

Written 2026-09-21. Validated without running the game: the steps assembly builds against the
shipped DLL, and `Tests/Pickle/Check-Steps.ps1` compiles every step pattern with Pickle's own
engine and matches every step line of every feature against them. **No Pickle run has been played
yet**, so no scenario has passed, and the numbers in `06-assists.feature` are derived from the
vanilla 1.6 defs and have not been observed.
