# 2026-09-22, English, shared run (partial for this mod)

**Pass:** without optional mods, English, with the evidence-only PickleTools staged (Click diagnostics, Film ticks,
Screenshot mode, Screenshot Studio). **RIMMSQOL was not staged.** Report preserved before unlock at
2026-09-23T00:04:31 (from `evidence-complete.txt`).

**This was not a run of this mod alone.** The report was the machine's shared report folder: dozens of other suites
(Bill Autopilot, Ancient Chinese Beast, Flavor Text Extended, Drum Bath Hygiene, ...) were in it, about 1.2 GB. Only
two testsuites of the report concern Fieldwork Companions, and the copy kept in the repository under
`Tests/Pickle/Evidence/` was deleted at the maintainer's request on 2026-09-23. **What follows is what was read from
`junit.xml` before that deletion**; the report itself is no longer on disk, and no `exitReason` was read from it.
It is therefore not a completed pass of this mod: 13 of its 17 features (as they are now) never appear in it.

## Results for this mod

| Feature (testsuite name) | Outcome | Notes |
| --- | --- | --- |
| `01-loading` ("Fieldwork Companions loads, and its four hooks are live") | **5 of 5 passed**, 3.4 s | The mod loaded after Harmony, no error logged, the four vanilla methods patched by this mod, documented defaults on a clean profile, the shortcut Def declared |
| `02-settings-page` ("the settings page, as a player sees it") | **3 of 3 passed**, 101 s, no failure | Includes the scenario that asserts the page has scrolled down after scrolling to the bottom, with a film of one picture and the "top" and "bottom" screenshots |
| `09-rimmsqol-shortcut` | **4 of 4 failed** | `mod 'MalteSchulze.RIMMSqol' should be loaded`: the pass did not stage RIMMSQOL. **An environment defect, not the mod's**: the features are now tagged `@requires:MalteSchulze.RIMMSqol` so that a pass without it skips them |
| `10`, `11`, `12` (restart chain) | **1 of 1 failed each** | `Undefined step: RIMMSQOL is ready to be driven`: the shared steps of `PickleTools/RimmsqolSteps` were not staged either. Same cause and same fix |

## Captures

The "bottom" capture of the settings page was opened. It shows a scroll bar on the right of the window, the "Show a
mark over the companion" checkbox and the "Reset to defaults" button, both reachable. That is the regression check of
the `maxOneColumn` fix of 2026-09-22 (see `STATUS.md` and `CHANGELOG.md`): before it, neither control was drawn and
no scroll bar existed. No other capture of this run was opened.

## Evidence

Deleted from disk on 2026-09-23. Future evidence goes to `Tests/Pickle/Evidence/<date>-<pass>/`, on disk and ignored
by git, with a summary like this one in `docs/runs/`.
