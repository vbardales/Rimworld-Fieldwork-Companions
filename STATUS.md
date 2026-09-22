---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Fieldwork Companions
packageId:    nelim.fieldworkcompanions
repo:         Rimworld-Fieldwork-Companions
remote:       https://github.com/vbardales/Rimworld-Fieldwork-Companions.git
local_path:   C:\Users\nelim\Documents\rimworld\FieldworkCompanions
visibility:   public
detached:     yes
stage:        done   # workflow state names are used literally, no codes; see the 2026-09-21 sections
settings_audit: complete
audit_revision: e2ec8fc5086e24f7b324516e3f81828cd4b3cd35
licence:      original
license_spdx: MIT
licence_at:   Original implementation according to ATTRIBUTION.md; no third-party mod code or assets reused. Only the mechanic is inspired by Disney Dreamlight Valley. Root and distributed LICENSE grant MIT. Classification original describes provenance; MIT describes reuse permissions.
dependencies: declared
showcase:     complete
tested_on:
workshop:      3806133311
maintainer:   Codex, current local repository task
updated:      2026-09-22
remaining:
  - unverified: Run the Pickle suite (Tests/Pickle, 8 features, written 2026-09-21, never played): pass 1 English and pass 2 French as declared in TESTING.md; check exitReason first, then scenarios played against features discovered, then open and look at every @review capture. The thresholds in 06-assists.feature come from the vanilla defs and have not been observed.
  - unverified: Pass 3 "avec-rimmsqol" (Tests/Pickle features 09-12, written 2026-09-21 with the shared steps of PickleTools/RimmsqolSteps, never played): RIMMSQOL lists, reveals, hides and forgets the shortcut, the bar draws it, it opens this mod's dialog, and the choice survives a restart. Only RIMMSQOL is covered; its checkbox is driven through the calls it makes, not clicked; no other customization mod is tested.
  - unverified: The @wip reset-confirmation scenario (02-settings-page.feature) has never been tried; run it with -IncludeWip.
  - unverified: Fishing has no Pickle scenario (the test colony has no water); it stays manual scenario 8.
  - unverified: Execute scenarios 0-16 in game, including both settings access routes, persistence/reset, FR/EN, new-game and existing-save coverage.
  - unverified: RIMMSQOL reveal/open/edit/hide and visibility persistence; no customization integration has been tested interactively.
  - unverified: In-game English/French settings, tooltips, reset dialog and assist mote; check raw keys, fallback, formatting and clipping in both languages.
  - Manual scenarios 0-16 have not been played; actual RimWorld/Mono behavior remains unverified.
  - note: Workshop item 3806133311 was published by the maintainer as 0.1.0 while the local metadata and draft notes use 1.0.0. The maintainer explicitly accepts that difference for this early publication; it is tracked for the next planned update, not treated as a current audit blocker.
  - unverified: Subscribe to Workshop item 3806133311 and test the installed Workshop copy, including its visibility and the actual item page contents. The maintainer reported publication, but this audit did not access Steam.
  - unverified: Commit e2ec8fc records PublishedFileId.txt but is one commit ahead of origin/main. Push it before the next upload so the Workshop identifier is safely retained remotely.
---

# Fieldwork Companions — status

This task owns and maintains this STATUS.md as work progresses. The file stays at the
repository root, outside the distributed Mod/ folder.

## Post-tested gates reviewed without claiming `tested` — 2026-09-22

`tested` is deliberately set aside: no completed Pickle/media review or own-subscription Workshop
test exists. The later gates were audited independently at `fb83402` against `origin/main`.

- **Repository:** public `main`, with the published-file-id commits pushed. No matching Git tag and
  no GitHub Release were returned by the live GitHub query.
- **Publication record:** `PUBLICATION.md` now records Workshop item `3806133311` and the early
  0.1.0 publication instead of its obsolete “none yet” state. It retains the still-unfulfilled
  screenshot, installation-test, tag/release and message work.
- **Prepublished remains not established:** the local tree contains the uncommitted scroll fix and
  its rebuilt assemblies, so it is not clean; screenshots are not yet produced/reviewed; and the
  tag/release are absent. These are prerequisites, not evidence that the published item is invalid.

## Publication identifier and ordered audit — 2026-09-22

Previous stage: `done`. Retained stage: **`done`**. The Workshop item is real only to the
extent directly evidenced here: the maintainer reports publishing **0.1.0**, and RimWorld wrote
`Mod/About/PublishedFileId.txt` with `3806133311`. That file was committed alone as
`e2ec8fc` (`Record Workshop published file ID for 0.1.0`); it has not yet been pushed.

This is not, by itself, evidence for `prepublished` or `published`: the later gates must not be
backfilled from the act of uploading. The current distributed `About.xml` declares `modVersion`
**1.0.0**, while the stated Workshop release is 0.1.0. The maintainer explicitly accepts that
difference for this early publication; it is an informational note for the next update, not a
defect or a criterion blocking this audit.

### Scope and local state

- Audited standalone repository `C:\Users\nelim\Documents\rimworld\FieldworkCompanions`,
  distributed folder `Mod/`, at committed revision
  `e2ec8fc5086e24f7b324516e3f81828cd4b3cd35`, plus pre-existing uncommitted changes in
  `CHANGELOG.md`, `Mod/About/About.xml`, `Mod/Assemblies/FieldworkCompanions.dll`, `STATUS.md`,
  `Source/FieldworkCompanionsMod.cs`, and
  `Tests/Pickle/Mod/Pickle/Assemblies/FieldworkCompanions.PickleSteps.dll`, and untracked
  `PUBLICATION.md`. These changes were preserved; this audit did not create or fix product code.
- No RimWorld instance was launched and no Pickle run was started.
- The published DLL currently hashes to
  `99AEF88CEF37FAC137A6B7A7F7413DB9D08F74B5761DE544C10C9B7F2D9E772E` after the existing local
  scroll-page fix. The release build matched the distributed DLL.

### Controls run now

- `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo`: passed,
  0 warnings, 0 errors.
- `_tools/Run-Functional-Tests.ps1`: **25/25 passed**. It checked the shipped assembly, 33/33
  English/French keyed resources, XML/resources, 12 settings defaults and reset, normalization,
  settings effect and persistence, plus the hidden native MainButtons shortcut contract.
- `Tests/Pickle/Check-Steps.ps1`: passed; **43** declared patterns compiled with no duplicates,
  covering **258** feature step lines. This validates the suite definition only, not a game run.
- Root and distributed `LICENSE` files are byte-identical, as are the two `ATTRIBUTION.md` files.

### Transition results

| Transition | Result | Current evidence / limit |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Validated | Independent repository, coherent identity and English documentation; prior remote verification retained. |
| horsMonoRepo -> ModIcon | Validated | Current release build passed and supplied DLL is current. |
| ModIcon -> Preview | Validated | Prior direct image inspection remains independent of this change. |
| Preview -> preOptions | Validated | English description and final GitHub source link remain present. |
| preOptions -> options | Validated statically | Source, definitions and 25/25 checks cover the useful settings and hidden shortcut. The uncommitted scroll fix still needs an in-game regression pass. |
| options -> l10n | Validated statically | 33 English and French keyed entries, matching resources and passing checks. |
| l10n -> preTest | Validated | Harmony is declared and actually used; optional Odyssey handling remains documented. |
| preTest -> done | Validated | Written functional scenarios, green automated/XML checks and written Pickle suites with a justified runtime scope. |
| done -> tested | Not established | No complete in-game/Pickle pass with reviewed captures; current scroll fix is not yet observed in game. |
| tested -> prepublished | Not established | Dirty tree, no pushed 0.1.0 tag/release, no reviewed screenshots and incomplete runtime validation. The accepted early-release version difference is not counted as a blocker. |
| prepublished -> published | Not established | PublishedFileId is now committed, but not pushed; the actual Workshop page, own-subscription test, visibility and thank-you messages were not verified by this audit. |

## Settings page: the scroll question resolved, a real defect found and fixed — 2026-09-22

The open question of 2026-09-21 ("Not yet established whether the page cannot scroll or the step
did not take effect") is closed: **confirmed directly in the real Windows game, by the user, that
the settings page does not scroll.** This was a defect of the mod, not of the suite or the capture
step.

- **Root cause, found by decompiling the installed `Assembly-CSharp.dll`** (`ilspycmd`, run with
  `DOTNET_ROLL_FORWARD=LatestMajor` against the .NET 8 runtimes present here) rather than guessed:
  `Verse.Listing.NewColumnIfNeeded` opens a second column once `curY` passes the height `Begin()`
  was given, unless `maxOneColumn` is set. On the first frame `viewHeight` is 0, so that height is
  only `inRect.height` (`Dialog_ModSettings.InitialSize` is a fixed 900x700, decompiled too, minus
  its 40px title and its close-button row). The page's own content passes that height right before
  the "show a mark" checkbox, so both it and "Reset to defaults" were pushed into a phantom column
  drawn outside the clipped, visible area: invisible and unreachable, not merely scrolled past. Worse,
  `Listing.CurHeight` after that only reflects the short second column, so `viewHeight` never grew
  and the scrollbar this mod's own `Widgets.BeginScrollView` call depends on never had a reason to
  appear. The bug reproduced identically every frame.
- **Fix**: `Source/FieldworkCompanionsMod.cs`, one field on the `Listing_Standard` used by
  `DoSettingsWindowContents`: `maxOneColumn = true`. Commented with the mechanism above.
- **Rebuilt**: `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo`,
  0 warnings, 0 errors. The delivered DLL hash **changes** with this fix:
  `99AEF88CEF37FAC137A6B7A7F7413DB9D08F74B5761DE544C10C9B7F2D9E772E`
  (was `EF4432026EAAD0038C08F75B20AC931F131B27CF850826960D76B5AF1D2F08BC`, referenced as unchanged in
  the section below, which that reference no longer describes).
- `_tools/Run-Functional-Tests.ps1`: 25 tests, all passed, against the rebuilt DLL. These checks
  exercise the settings logic, not the drawn page, so they could not have caught this; they confirm
  no regression.
- The Pickle steps assembly was rebuilt against the fixed DLL and `Tests/Pickle/Check-Steps.ps1`
  still passes (43 patterns). `CHANGELOG.md` records the fix under `[Unreleased]`.
- **Not yet done**: no in-game run has confirmed the fix. The scroll assertion added to
  `02-settings-page.feature` on 2026-09-21 (`the Fieldwork Companions settings page has scrolled
  down`) is what will confirm it once a Pickle pass reaches that scenario, and it should now pass
  where it previously would have failed silently-as-cut-off. Not claiming it passed: it has not run.

## Towards tested and prepublished — 2026-09-21

Stage stays **done**. `done -> tested` needs scenarios played in game and the Pickle suites played to
the end with their `@review` captures opened; the only run so far ended without a report, so nothing
can be claimed. `tested -> prepublished` cannot be reached before it. What was prepared meanwhile,
without publishing anything:

- **About.xml description**: added the line pointing to ATTRIBUTION.md and the licence that the workflow
  places between THANKS and the source link (it was missing). Order now: body, `IF I GO QUIET`,
  `AI-GENERATED`, `THANKS`, attribution and licence line, `[url=...]Source code on GitHub[/url]`.
  `Run-Functional-Tests.ps1` re-run after the change: 25 tests, all passed. This changes the delivered
  `About.xml`; the DLL is untouched.
- **`PUBLICATION.md`** (draft, root of the repository): dependencies and DLCs checked against the sources
  (Harmony required; Odyssey `loadAfter` only, deliberately; no DLC required), the mature-content answer
  (none, with the two shipped images opened), a personalised thank-you message to Harmony at 644
  characters, what the upload cannot take back, and Steam change notes for 1.0.0.
- **Not ready, and why:** the Workshop screenshots and their order (none produced; the settings page
  was cut off in every capture so far by the scroll defect fixed 2026-09-22, see below — a fresh
  capture is needed before any image is chosen); the item URL for the messages;
  `CHANGELOG.md` still has an `[Unreleased]` block above a `1.0.0` that was never released; no
  version tag and no GitHub release; the second and third Pickle passes; the manual scenarios.

## Pickle suites written — 2026-09-21 (after the audit below)

Stage **preTest -> done**. The one blocker of the audit below is lifted: the Pickle (Gherkin)
tests now exist and their scope is justified. `done` still means ready for the final in-game
validation, not `tested`: nothing here has been played.

- Added `Tests/Pickle/`: a companion mod `Fieldwork Companions - Pickle tests` (About.xml, 8
  features), a steps assembly built against the shipped DLL, `Check-Steps.ps1`, and a README.
  Added `TESTING.md` at the root: the layers, the two required passes (English and French, without
  optional mods), why there is no pass with optional mods and none for an incompatibility (the mod
  declares neither), which scenario covers what, and what Pickle does not cover and why.
- Scope kept to what only a running game shows: the four patches installed on the game's real
  runtime; the mod's reads of three non-public game members inside the actual runtime, through
  milking and the per-step chance; the real settings dialog, captured (`@review`); the real settings
  file written, read back and written on close; the shortcut in the game's own main bar and its
  identity with Mod options; every key in the language of the pass; a save that holds nothing of the
  mod. What the harness already proves (arithmetic, clamps, reset, Scribe round trip) is not
  repeated.
- Validated without a game: `dotnet build Tests/Pickle/Source/FieldworkCompanions.PickleSteps.csproj -c Release`
  succeeded with 0 warnings and 0 errors; `Tests/Pickle/Check-Steps.ps1` exit 0 — 42 step patterns
  compile with Pickle's own engine, none declared twice, none unused, and all 179 step lines of
  the features match either one of them or a step of Pickle's own vocabulary already used by other
  suites. `Mod/` and `Source/` were not touched; the shipped DLL hash is unchanged
  (`EF4432026EAAD0038C08F75B20AC931F131B27CF850826960D76B5AF1D2F08BC`).
- **First WSL run, pass 1 (English), 2026-09-21 17:44 local, through `Run-PickleWsl.ps1`.** It did
  NOT complete: 19 of 32 scenarios were played (13 passed, 5 failed, 1 skipped), then the game ended
  while loading the 20th and wrote no final report (`exitReason: in-progress`, exit 1). The cause of
  the early end is not established. These numbers are not a verdict. What did pass: the mod loaded
  after Harmony with no startup error, the four hooks patched by this mod, the clean-profile
  defaults, the hidden shortcut (hidden, drawn once revealed, opens this mod's own dialog), every
  key present in English, the shortcut text, and the settings-page captures. The gameplay scenarios
  were not reached.
- The 5 failures were defects of the suite, not of the mod, and are fixed in the next commit (not
  replayed): floats are written to the settings file with round-trip digits (`0.400000006`), and
  the game refuses `Master` for a pawn that has not learned obedience.
- **Open, possibly a defect of the mod:** the "top" and "bottom" captures of the settings page are
  identical, show no scrollbar, and do not show the mark checkbox or the reset button. The suite now
  asserts the scroll position after scrolling to the bottom and reports it with `viewHeight`. Not yet
  established whether the page cannot scroll or the step did not take effect.
- The report of this run was in `pickle-reports-archive/0921-1748`, an archive that is rotated.
- Passes 1 and 2 remain to be played to completion, and the `@review` captures to be looked at.

## Ordered workflow audit — 2026-09-21

Previous stage: `done`. Retained stage at the time of this audit: **`preTest`** (superseded by the
section above). Applies `rimworld/AUDIT.md` as revised
on 2026-09-21. The `stage` field uses the workflow's own state names, so no code table is needed.

The step-down is not a regression of the mod: nothing validated on 2026-09-13 has changed.
AUDIT.md now requires, for `preTest -> done`, that Pickle (Gherkin) tests be **written** with
their scope justified (their execution belongs to `done -> tested`). This repository has
neither Pickle tests nor a recorded reason why none applies, so `done` is not established.
The 2026-09-13 sections below are kept as history and were correct under the criteria of that day.

### Scope and revision

- Standalone repository `C:\Users\nelim\Documents\rimworld\FieldworkCompanions`; distributed
  folder `Mod/`. Audited HEAD `0432fea8858be140396f832975e6dba0cd00a47b`
  (`git ls-remote origin HEAD` returns the same SHA). Working tree clean before this edit.
  Since the previous `audit_revision` (928584d) three commits landed: the hidden settings
  shortcut and its tests, and the licence holder name. Only STATUS.md was edited by this audit.
- No RimWorld was launched (`Get-Process RimWorldWin64`: nothing running; no WSL run attempted,
  no lock taken, none needed). All results below are out-of-game.

### Transition results

| Transition | Result | Direct evidence |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Validated | Own `.git`; origin `vbardales/Rimworld-Fieldwork-Companions`; `gh repo view` reports PUBLIC, default branch `main`, HEAD pushed. STATUS present. Licence `original` + MIT, justified in `licence_at`; root and `Mod/` LICENSE and ATTRIBUTION are byte-identical. packageId `nelim.fieldworkcompanions`, repo, folder and title coherent. README, ATTRIBUTION, LICENSE, CHANGELOG in English. |
| horsMonoRepo -> ModIcon | Validated | Release build to a separate output (`.build/audit-20260921/`): 0 warnings, 0 errors, DLL SHA-256 `EF4432026EAAD0038C08F75B20AC931F131B27CF850826960D76B5AF1D2F08BC`, identical to the shipped DLL. `ModIcon.png` 128x128, 29,749 bytes, opened and looked at. |
| ModIcon -> Preview | Validated | `Preview.png` 896x504 PNG, 635,659 bytes (< 1 MB), opened and looked at: overhead oblique view, tiled floor, miner, dog, jade pile, lamp; no camera defect seen. |
| Preview -> preOptions | Validated | Accent (yellow-green rule and badge) clearly separate from the ochre secondary and the brown ground. English description; title has no prefix, suffix or linking word to style. Description ends with `[url=https://github.com/vbardales/Rimworld-Fieldwork-Companions]Source code on GitHub[/url]`, matching origin and `<url>`. |
| preOptions -> options | Validated | Source and Defs: 12 useful settings via Mod options, hidden `MainButtonDef` (`buttonVisible=false`) opening the same `Dialog_ModSettings`, no second store. 10 settings tests green (defaults/reset, limits and non-finite values, effect on chance/radius/dispatcher/yield, real Scribe round-trip, older files, shortcut contract). In-game and RIMMSQOL checks belong to `done -> tested`. |
| options -> l10n | Validated | 33 Keyed keys resolved in EN and FR, none missing, none duplicated; placeholders and line breaks match; all UI text goes through `.Translate()` (no literal UI string in `Source/`). Shortcut: English in the Def, French in DefInjected. `Check-DefInjected.ps1`: 2 keys, 0 errors. |
| l10n -> preTest | Validated | Harmony is the only mandatory dependency, actually patched against, declared in `modDependencies` with `loadAfter`. Odyssey trainings are resolved silently by name, so it stays optional. `supportedVersions` 1.6; no LoadFolders and no conditional patch to reconcile. |
| preTest -> done | **Not established** | Written and green: 15 functional scenarios (0-16), 25/25 automated checks, XML/resource checks. **Missing: Pickle tests, and any justification for having none.** See remaining. |
| done -> tested | Not started | Scenarios 0-16 never played in game; no Pickle run. Not a defect. |

### Commands and observed results

- `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo -p:OutputPath=../.build/audit-20260921/`: exit 0, 0 warnings, 0 errors, hash equal to the shipped DLL.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`: exit 0, **25 tests, all passed**, against the delivered DLL and the installed game's assemblies and data. These are out-of-game compatibility, settings-logic and resource checks.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod <repository>/Mod`: 2 keys checked, 0 errors, 11,587 Defs indexed.
- Live `gh repo view` and `git ls-remote origin HEAD`: PUBLIC, HEAD on origin.
- Direct inspection of `Preview.png` and `ModIcon.png`; System.Drawing size check.

### Remaining for `preTest -> done`

- Write the Pickle (Gherkin) suites for what only a running game can show, and justify that scope; or record explicitly why none applies. Do not duplicate what the 25 unit checks already prove. Execution is not required here.

### Later transitions, not yet started (not blockers now)

- `tested`: play scenarios 0-16, run Pickle in both language passes and the passes declared in a `TESTING.md` (none exists yet), open the `@review` captures, check logs, RIMMSQOL reveal/open/hide.
- `prepublished`: no `PUBLICATION.md`, no version tag or GitHub release, no Steam release notes, no thank-you messages, no Workshop screenshots; CHANGELOG still has an `[Unreleased]` block on top of 1.0.0 dated 2026-09-07.
- `published`: no `About/PublishedFileId.txt`; `workshop:` is empty.

### Optional recommendations

- `../PROMPT_FIELDWORKCOMPANIONS.md` still sits in the parent folder although the images exist; PUBLISHING.md says to delete such a note. It is outside this repository and was left alone.

## Audit fixes and revalidation — 2026-09-13

User follow-up authorized fixes. This section supersedes the earlier audit's unresolved
findings below; the original audit and historical results remain intact.
Stage **preOptions -> done**. `done` means ready for final functional validation in game,
not `tested`. The supplied workflow explicitly places interactive checks at `done -> tested`.

- Based on commit `928584df23c38bd76901bb9064c2587ff6f91a60` plus the local changes
  recorded in `_tools/results/2026-09-13-settings-manifest.json`. No commit or publication.
- Added `Source/MainButtonWorker_Settings.cs` and a MainButtonDef with
  `buttonVisible=false`, `validWithoutMap=true`, and no separate tab window. The worker
  inherits native visibility, so compatible tools can reveal/hide the same definition.
  Activate opens `Dialog_ModSettings(FieldworkCompanionsMod.Instance)`, exactly the native
  primary settings UI. The game dialog calls WriteSettings when closing; no second settings
  store or mandatory customization dependency was introduced.
- All 12 existing settings retained. Stored numeric values now normalize on LoadingVars
  and before saving: finite values clamp to slider ranges; NaN/infinity restore defaults.
  Chance and radius predicates were extracted into production settings methods, preserving
  the existing formula and inclusive radius while making boundary behavior executable in tests.
  The actual dispatcher and BonusCount are tested against the delivered DLL as well.
- EN/FR introductory text now explains immediate global scope and saving on close.
  Shortcut label/description use native English Def values and two French DefInjected entries.
  All 33 Keyed entries remain covered; no redundant English injection file was added.
- Fixed the final Workshop source-code link and added .gitattributes for text/PNG/DLL.
  README, changelog and scenarios 15-16 document the configuration routes and final manual
  checks. The parent's old prompt file was left outside this mod's changes; it is not a gate.

### Validation of the delivered changes

- `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo`:
  passed, zero warnings/errors, updated the distributed DLL. SHA-256:
  `EF4432026EAAD0038C08F75B20AC931F131B27CF850826960D76B5AF1D2F08BC`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  **25/25 passed**, exit 0. Output: `_tools/results/2026-09-13-settings-tests.txt`.
  Ten new checks cover all defaults/reset, numeric limits/nonfinite values, probability
  effects/caps/restoration, every allowed radius, all 16 work-switch combinations, real
  BonusCount changes, real scalar Scribe round-trips, missing/older fields, normalization
  on load, native shortcut Def/worker/dialog contracts and translation coverage.
  The existing 15 compatibility/API/XML tests also pass against the changed DLL.
- The first run had 24/25 passes: its test forced fr-FR numeric culture without game
  initialization, causing Scribe to write comma decimals and read them incorrectly.
  Inspection of the installed Verse.Root confirmed its call to CultureInfoUtility.EnsureEnglish.
  The test now invokes that actual initializer after selecting each EN/FR host culture;
  both round-trips pass. This corrected the harness, not a diagnosed in-game defect.
  Initial failure preserved in `_tools/results/2026-09-13-settings-tests-initial.txt`.
- Scribe uses real game saver/loader and the actual ExposeData method, with isolated files
  under .build/settings-tests. Scalar loading stops after LoadingVars; Unity's profiler and
  final scene-loading lifecycle are not executed. Real user settings are untouched.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1
  -TransMod <repository>/Mod`: **2 keys checked, 0 errors**, 11,587 indexed Defs;
  output `_tools/results/2026-09-13-definjected.txt`. XML/resource checks cover the two new
  XML files in addition to About and both Keyed resources. A final About XML comment-only
  change was parsed again; it does not invalidate functional results.
- Native API/visibility/persistence linkage uses the installed RimWorld 1.6.4871 rev590
  assembly. The shortcut Def and worker are instantiated; compiled native dialog calls
  and inherited visibility are checked. This is not a RIMMSQOL interaction test.
- Specialty gating, bond creation and mote delivery retain their production consumers;
  compiled field/call linkage is checked. Full animal eligibility, random bond outcomes,
  map placement, UI rendering and new-game/save lifecycle remain manual scenarios.

Settings and translation gates now pass at the technical/source level specified by the
user. Harmony remains the sole mandatory mod; Odyssey remains optional. Images, naming,
licence and remote validation were unaffected and are retained. Functional scenarios 0-16
are written with preconditions/actions/expectations; automated and XML tests are green.
The sole next workflow transition is `done -> tested`: run those scenarios, inspect logs,
verify FR/EN UI, persistence and optional shortcut interaction, and rerun affected regression
checks after any resulting fix. No game or customization mod was launched in this task.

## Ordered workflow audit — 2026-09-13 (historical, before fixes)

This audit supersedes historical stage conclusions below while preserving their results.
The user's supplied workflow takes precedence over the four parent protocols, all read:
PUBLISHING.md, STYLE_RIMWORLD.md, MOD_SETTINGS.md and TRANSLATIONS.md.
In particular, interactive game tests belong to `done -> tested`, not the options gate.
`preOptions` is the literal workflow state after Preview styling and before the settings
gate; it is not an alias for `preTest`. Previous stage: `done`; retained stage: `preOptions`.

### Scope and revision

- Autonomous repository: `C:\Users\nelim\Documents\rimworld\FieldworkCompanions`;
  distributed content: its `Mod/` subdirectory (eight files). Source, Art and tests are
  outside that directory. Git top-level, git-dir and common-dir confirm independence;
  no superproject is reported. The parent's remote is irrelevant.
- At entry, HEAD was `50b9a35c77e40b16231d9d3bb315e51691ca4e71`, with local changes in
  CHANGELOG.md, STATUS.md, Source/FieldworkCompanionsMod.cs, the shipped DLL and both
  Keyed files. During the audit HEAD advanced externally to
  `928584df23c38bd76901bb9064c2587ff6f91a60`, committing those six files. The working
  tree was clean before this report edit; the reviewed localized category and resource
  contents are included in that revision. This audit made no commit or publication.
- Checked the delivered working files, not only committed source. The audit only edits
  STATUS.md; a separate build output is under ignored `.build/audit-20260913/`.
  No delivered code, DLL, image or historical report was replaced.

### Transition results

| Transition | Result | Direct evidence / limit |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Validated | Independent Git repository; configured GitHub origin; live `gh repo view` reports PUBLIC and `git ls-remote origin HEAD` returned pushed commit 50b9a35. English README, attribution, MIT licence and changelog exist. Root/distributed licence and attribution pairs have identical SHA-256 hashes. Original provenance is documented, with no third-party implementation/assets identified in the inventory. Title, packageId, repository and directory are coherent without literal identity. |
| horsMonoRepo -> ModIcon generated | Validated | Existing gameplay implementation and four patches present; separate Release build succeeds and matches shipped DLL exactly. PNG icon directly inspected: 128 x 128, 29,749 bytes. The later settings-contract defect is assessed at its explicit workflow gate. |
| ModIcon generated -> Preview generated | Validated | Distributed PNG directly opened: 896 x 504, 635,659 bytes, below 1 MB. High overhead view, tiled ground, miner/companion/resource subject, no concrete camera defect found. No historical generation record is required. |
| Preview generated -> preOptions | Validated | English title/summary and About description. Full-size Preview and existing 268px thumbnail inspected; readable title/version, no clipping or overlap. Jade-green accent separates from warm ochre secondary/ground. Secondary is intentionally unused because the original public title has no prefix, suffix, status tag or linking word requiring special styling. Palette and composition remain in Art/. |
| preOptions -> options | Defect + unverified | Useful primary settings UI exists, but no MainButtonDef, MainTabWindow or equivalent runtime registration exists anywhere in Source/ or Mod/. The required discoverable hidden shortcut is absent. Existing tests do not exercise settings behavior or serialization; see settings audit below. |
| options -> l10n | Independent resource validation retained | All 33 owned keys have nonempty EN/FR resources; source helper arguments and mote traced, placeholders reviewed and checked. No owned DefInjected targets, grammar, XML patches or LoadFolders. This does not bypass the blocked options gate. |
| l10n -> preTest | Independent dependency validation retained | Harmony is actually used and declared with loadAfter; RimWorld 1.6 declared. Odyssey trainables use silent optional lookup; fishing target exists in the installed base assembly. Other DLC loadAfter entries do not make those DLC mandatory. No bundled dependency DLLs or conditional XML/LoadFolders to reconcile. DLC present/absent gameplay remains unverified. |
| preTest -> done | Partially established independently | Existing automated suite and shipped XML checks pass on delivered DLL; 15 gameplay scenarios have setup/actions/expectations. Settings-specific automated coverage and written scenarios for both routes, persistence/reset, FR/EN and new-game validation remain incomplete. No artificial tests added during this audit. |
| done -> tested | Unverified | No game launched and no scenarios executed by this audit. No verified FR/EN UI, Player.log, persistence, shortcut integration, new-game or existing-save results. This is not an observed runtime defect. |

### Settings audit

- Useful settings: four work switches, specialty requirement, base chance, per-training-step
  and bonded bonuses, resource share, radius, bond-creation chance and assist mote (12 values).
  They control real branches/calculations in Companions and the four patches. Primary access
  uses Verse.Mod.SettingsCategory/DoSettingsWindowContents and GetSettings; no customization
  dependency is required. Runtime consumers read the shared settings on each assist.
- Static review: all work switches, specialty and mote default true; chances default to
  15%, 10% per step, 15% bonded, 0.5% bond creation; share 25%, radius 8. Reset and Scribe
  fallback defaults match initializers. UI sliders bound base/bond bonus to 0-100%, step
  bonus to 0-50%, share to 5-200%, radius to 2-30 and bond creation to 0-5%.
  ChanceFor clamps the total to 0-100%; fishing intentionally ignores share and adds one fish.
  Controls use sliders/checkboxes, so invalid free-text entry is not applicable.
- Scope is global ModSettings, not per-save data. Immediate application and persistence are
  supported by source structure, but actual behavior, reset and save/load have not been
  established by executable settings tests. ExposeData has no post-load bounds normalization;
  malformed/older stored numeric values are an unverified robustness case, not an observed crash.
- Defect: shortcut is absent, not merely hidden. A future fix must expose a discoverable
  default-hidden MainButton that opens the same primary configuration and shares persistence.
  No RIMMSQOL or other customization integration was tested. Game data/API inspected:
  RimWorld `1.6.4871 rev590`; no claim of Mono execution.
- Next transition requires the shortcut implementation and applicable automated technical
  settings checks with observed passing results. Rebuild and recheck affected resources/XML
  after that change. Interactive route and integration tests remain for `tested` per the prompt.

### Commands and observed results

- `gh repo view vbardales/Rimworld-Fieldwork-Companions --json nameWithOwner,visibility,url`
  and `git ls-remote origin HEAD`: passed with read-only elevated access after the sandbox
  denied CLI configuration/network access. This initial access limitation was resolved.
- `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo
  -p:OutputPath=../.build/audit-20260913/`: exit 0, zero warnings/errors.
  Rebuilt and delivered DLL SHA-256 both
  `79E47BB45C3C5A65CB13BAF84BAD52507BFFE181AF90A3967B83838C1643E120`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  exit 0, **15/15 passed**, against the delivered DLL and installed game assemblies/data.
  Includes the real compile probe for three non-public members, access grants, four Harmony
  targets, subclass/API checks, vanilla trainables/yield caps, 33/33/33 keys, all three shipped
  XML files, duplicate/empty entries and About identity/dependency metadata. These are
  compatibility/resource checks, not execution of the settings UI or gameplay.
- Additional PowerShell XML comparison of parameters, escaped line breaks and markup:
  zero EN/FR mismatches; sample String.Format succeeds for each parameterized entry.
  Reviewed English/French meaning, labels, tooltips and dynamically supplied PercentRow keys.
  Numeric mote and proper mod name being identical in both languages is intentional.
- Direct image inspection and System.Drawing metadata check completed. Existing Art QA
  measurements are preserved; browser font/contrast measurements were not rerun or claimed
  as new results. No direct visual concern remains requiring a new image.

### Separate publishing follow-ups (not blockers of the next settings transition)

- About.xml currently places a bare source URL in the middle of the description. This is a
  confirmed deviation from PUBLISHING.md's final `[url=...]Source code on GitHub[/url]`
  convention, to address before publication; the English-description workflow criterion passes.
- The standalone repository has no .gitattributes, and the parent still contains
  PROMPT_FIELDWORKCOMPANIONS.md. Repository hygiene follow-ups do not invalidate directly
  verified images or require restoring a monorepo remote. No parent file was removed.
- Steam publication is outside this audit and is not required to reach `tested`.

## Translation audit — 2026-09-13

- Applied ../PUBLISHING.md and ../TRANSLATIONS.md to Source/**/*.cs and all of Mod/.
  No LoadFolders, version folders, owned Defs, XML patches or grammar resources exist.
- Inventory: 33 owned Keyed entries: settings category title, 31 settings labels,
  tooltips and confirmation texts, and the numeric assist mote. Traced PercentRow's
  label/tooltip arguments and numeric formatting, the reset confirmation, and all four
  patches through NoteAssist. No other owned player-facing text was found.
- Fixed the hardcoded settings category with FieldworkCompanions.Settings.Title.
  Both languages retain Fieldwork Companions as a proper name, now localizable.
  The identical +{0} mote is intentionally numeric in both languages.
- Reviewed all English and French entries against the UI and mechanics. Clarified the
  deep-drill exclusion in both languages, corrected French harvesting text to mean
  no bonus, and made the French radius inclusive as implemented. French training
  descriptions use descriptive wording rather than claiming exact vanilla UI labels.
- No dependency translation keys are explicitly reused. Standard confirmation buttons
  and bond notifications are generated by vanilla APIs. Serialization keys, Harmony
  targets, defNames, numeric format patterns and About metadata are not owned UI text.
  DefInjected validation is not applicable because no owned Def fields are shipped.
- Resource checks: 33 source keys, 33 English and 33 French entries; no missing,
  duplicate or empty keys; all shipped XML parses. PowerShell XML/regex comparison
  confirmed matching placeholders, escaped line breaks and markup for every entry;
  String.Format with a sample numeric argument succeeded for both languages.
- Build: dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo;
  succeeded with zero warnings/errors and refreshed Mod/Assemblies/FieldworkCompanions.dll.
  Initial sandbox SDK access failure was resolved by rerunning with approved access.
- Functional validation: powershell -NoProfile -ExecutionPolicy Bypass -File
  _tools/Run-Functional-Tests.ps1 passed 15/15 against the rebuilt DLL and installed game.
- These complete fields certify the source/resource gate only. In-game English/French
  verification remains unverified in remaining; the historical stage is preserved.

## Identity and publication audit — 2026-09-13

- Independent local Git repository: top-level is the local_path above, git-dir and
  common-dir are both .git, and no superproject is reported. This is not the monorepo.
- GitHub visibility verified live with gh repo view: PUBLIC.
- Title: Fieldwork Companions. No continuation/revival suffix is needed: this is an
  original mod, not a takeover or update of another author's mod.
- GitHub URL is present both in About.xml's url field and, after this audit, in its
  visible description under SOURCE CODE.
- Mod provenance category: original. Explicit distribution licence: MIT, identical in
  LICENSE and Mod/LICENSE. ATTRIBUTION.md documents the inspiration and lack of reused
  third-party code/assets. This is neither forbidden nor silent; open would describe
  explicit permission for a reused source, whereas original identifies this mod's origin.
- Harmony is declared; Odyssey is optional and resolved defensively at runtime.

## Verification — 2026-09-13

- Build: dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo
  succeeded, zero warnings and zero errors.
- Automated: powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
  succeeded: 15/15 tests against the installed game's assemblies and data.
- Coverage: access grants and required non-public members, four Harmony targets and
  signatures, subclass overrides, master/follow API, bond API, trainable defs, yield caps,
  32 English/French translation keys, all shipped XML parsing, duplicate/empty translation
  keys, About identity, supported version, Harmony dependency and visible GitHub link.
- No Defs or XML patches are shipped. Relevant mod XML consists of About.xml and the two
  language files, all checked; relevant vanilla training/stat XML is also inspected.
- The compile probe now reports infrastructure failures explicitly instead of claiming
  that private API members are no longer needed when the SDK is inaccessible.
- Manual: 15 scenarios (0-14) exist in _tools/FUNCTIONAL-SCENARIOS.md. Corrected setup
  to disable the specialty requirement outside its dedicated scenario, and corrected
  scenario 10: missing required Dig training means zero assists, not a 15% chance.
- Limits: no game launched, no manual scenario marked passed. These automated checks
  cover compatibility and metadata, not end-to-end gameplay or Mono behavior. Historical
  mutation checks concern the original suite; no new mutation campaign was performed.

## What this mod taught the repository, and what outlives it

- **The `GenerateAssemblyInfo=false` trap has taken a second mod, and it will take more.**
  Krafs.Publicizer applies `IgnoresAccessChecksTo` through the generated AssemblyInfo; switching
  that property off embeds the attribute's type and never applies it. Here the two members the
  milking patch reads, `ResourceDef` and `ResourceAmount`, are `protected abstract` in the real
  Assembly-CSharp — checked against the game's own file, not against the publicised reference — so
  the desktop CLR would refuse that access. **What it costs in the game is not established**: the
  Architect Studio session found a non-public call of its own, outside any try/catch, in an
  assembly with no waiver, working in a real game: RimWorld's Mono does not seem to enforce the
  check the way the desktop CLR does, and every check we run happens under PowerShell, on the
  desktop CLR. Treat it as a conformance fix, not as the repair of a mod seen dead. Contented
  Livestock had it on fields, this one on properties: the common factor is the switched-off
  property, not the kind of member, and **every mod that switches off `GenerateAssemblyInfo` and
  publicises deserves the same check** — twelve of them, of which two are now fixed. Fixed here in
  `Source/AccessChecks.cs`.

- **Searching the built assembly's bytes for `IgnoresAccessChecksTo` returns a false positive.**
  The type name is in the file whether or not the attribute was applied — that is the shape of the
  trap. The check that counts is one line of reflection on the built assembly:
  `[Reflection.Assembly]::ReflectionOnlyLoadFrom(<dll>).GetCustomAttributesData()`, and the
  attribute is either in that list or it is not. No need to launch the game, or even to resolve
  the assembly's dependencies.

## Preview overlay — 2026-09-13

- Recomposition follows ../STYLE_RIMWORLD.md and the supplied overlay specification.
  Existing title and summary are preserved exactly. No status tag or reduced title
  word applies to this original public mod. Badge 1.6 is read from the highest stable
  supportedVersions entry in Mod/About/About.xml at render time.
- Illustration retained, not replaced: Art/Preview.png is an unmodified copy of
  Art/Preview-source.png; that full-resolution original remains available. The centered
  cover crop preserves the miner, dog, jade pile and lamp. No text was added to either source.
- Final distributed image: Mod/About/Preview.png (896 x 504; 635,659 bytes, below 900 kB).
- Composition and parameters: Art/preview.html; sole palette reference:
  Art/preview-palette.json; reproducible renderer: Art/render-preview.cjs.
  _tools/preview.html redirects to the maintained composition instead of retaining an
  independent old palette. Serve the repository root over HTTP to preview the HTML.
- Palette rationale: the veil takes the dark stone/earth surface near the upper-left
  text area. Secondary ink is a lightened ochre from the dominant warm earth and lamp-lit
  floor family, not an average of the pixels. The accent draws on the green jade pile,
  a meaningful resource beside the companion, strengthened in saturation and lightness.
  Its yellow-green hue separates it from the ochre secondary and warm brown ground.
  Secondary ink is retained in the palette but unused here because no tag or suffix applies.
- Actual fonts verified through Chrome CSS.getPlatformFontsForNode after document.fonts.ready:
  Segoe UI Semibold for the title, Segoe UI for the summary, Segoe UI Bold for the version.
  No fallback font. Text block starts at (50,54); title 46px/600, summary 21px/400;
  standard dark radial veil and text shadow, standard rule and 80px corner badge.
- Contrast measured across every pixel of each text bounding rectangle on a second render
  with text hidden, not merely against the nominal veil colour: title minimum 8.58:1,
  summary 4.86:1; badge digits on opaque accent 11.33:1. All exceed 4.5:1.
  Tag contrast is not applicable because there is no tag.
- Evidence: Art/preview-qa.json (fonts, bounds, contrasts, version and size),
  Art/preview-background.png (actual text-free composited background), Art/preview-268.png.
  Visually checked final 896 x 504 image and 268px thumbnail: title and version identifiable,
  no clipping or overlap, rule visible; subject remains clear. Summary is designed for the
  full image, as the guide specifies. Nothing published.
