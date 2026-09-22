# Testing

Three layers, from cheapest to dearest. Everything that can be proved out of game is proved out of
game; a Pickle run takes over the machine for tens of minutes and is kept for what only a running
game can show.

| Layer | Where | What it settles | Cost |
| --- | --- | --- | --- |
| Out-of-game harness | `_tools/Run-Functional-Tests.ps1` (25 checks) | The four patched vanilla methods still exist with the expected shape and nothing overrides them; the three non-public members the mod reads are covered by the access waiver; the chance arithmetic, clamps, defaults, reset and real Scribe round trip; the shortcut Def; every translation key in EN and FR; About metadata | seconds |
| Resource checks | `../scripts/Check-DefInjected.ps1` | The two DefInjected paths resolve | seconds |
| Pickle, in game | `Tests/Pickle/` (12 features) | The patches are installed and fire on the game's real runtime; the real settings dialog draws; the real settings file; the shortcut in the real main bar; the language the pass runs; a save that holds nothing of the mod | tens of minutes |
| Evidence review | Pickle screenshots and films | A human reviews the rendered result; no manual gameplay procedure is a release gate | minutes |

## The passes

A run is `powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod FieldworkCompanions`
from the parent folder, and only through that script: it takes the machine lock, stages, runs under
Xvfb and gives the lock back. The Windows install is never launched.

Three passes are required, and the report must say which is which.

| # | Pass | Command | Mods loaded | What it proves |
| --- | --- | --- | --- | --- |
| 1 | Without optional mods, English | `... -Mod FieldworkCompanions -DepMap wsl-deps.runtime-evidence.map` | Core, DLC, Harmony, RimLogging, Pickle, companion and evidence-only PickleTools | The mod stands alone and produces reviewable evidence. |
| 2 | Without optional mods, French | `... -Mod FieldworkCompanions -DepMap wsl-deps.runtime-evidence.map -Language French` | Same set | Every text exists in French; review media for layout and literals. |
| 3 | With RIMMSQOL | `... -Mod FieldworkCompanions -DepMap wsl-deps.avec-rimmsqol.map -IncludeWip -Filter '09-rimmsqol-shortcut.feature'`, then the restart chain `-Filter '10-rimmsqol-restart-reveal.feature' -Then '11-rimmsqol-restart-hide.feature','12-rimmsqol-restart-forget.feature'` | The same set plus RIMMSQOL (Workshop 1084452457) and `PickleTools/RimmsqolSteps` | RIMMSQOL's own list offers the shortcut, can reveal it, the bar draws it, it opens this mod's own dialog and shares its values, hiding works, and the choice survives a restart |

**Passes with optional mods: only RIMMSQOL, and it is an integration, not an optional mod.** The mod
declares no optional mod of its own. Its `loadAfter` names Harmony and the Ludeon DLC, and the minimal
staging already mounts all of those, so a pass "with the optional mods" would be pass 1 under another
name. RIMMSQOL is not something the code reads: it is the customization tool MOD_SETTINGS.md asks to
have tested and named, so it lives in a pass map (`Tests/Pickle/wsl-deps.avec-rimmsqol.map`) and in no
`About.xml`. It is the only customization mod claimed as tested. There is no combination of exclusive
optional mods to cover.

Pass 3 uses the shared steps of `PickleTools/RimmsqolSteps`, which reveals and hides the button through
RIMMSQOL's own settings instance rather than by clicking its checkbox. Its features are tagged
`@rimmsqol`; passes 1 and 2 do not stage their required integration.

**Passes for a declared incompatibility: none.** `About.xml` has no `incompatibleWith`, and neither
the README nor the description names an incompatible mod. If one is ever declared, it needs its own
pass (`wsl-deps.incompat-<mod>.map`) that asserts the documented symptom rather than expecting a red.

The reports are read in this order: `exitReason` first, then the number of scenarios played against
the number of features discovered, then the outcomes. A green run of a `@review` scenario says the
trip happened, not that the capture is right: those captures are opened and looked at, and the
result is recorded in `STATUS.md`.

`@requires:<packageId>` scenarios skip when the selected pass does not stage that dependency. A
required scenario that skips is not a pass. `@requires:Odyssey` scenarios skip without Odyssey.

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
- **What RIMMSQOL's checkbox does.** Pass 3 drives RIMMSQOL through the calls its Visible checkbox
  makes, not through a click on it: that the checkbox is wired to those calls is read from its
  source, not shown. No other customization mod is tested.
- **A real restart of this mod's own settings.** The settings scenarios re-read the file in the same
  process. (RIMMSQOL's visibility choice does survive a restart in pass 3, which is a three-launch
  chain, but that is RIMMSQOL's file, not this mod's.)
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
