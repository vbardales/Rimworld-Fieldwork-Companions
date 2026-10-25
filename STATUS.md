---
localization: complete
translation_en: complete
translation_fr: complete   # reviewed by Virginie 2026-10-02, see the French review line in "Translation audit"
mod:          Fieldwork Companions
packageId:    nelim.fieldworkcompanions
repo:         Rimworld-Fieldwork-Companions
remote:       https://github.com/vbardales/Rimworld-Fieldwork-Companions.git
local_path:   C:\Users\nelim\Documents\rimworld\FieldworkCompanions
visibility:   public
detached:     yes
workflow_stage: shootGallery[1.0.0]
settings_audit: passed
audit_revision: e39d9ab
licence:      original
license_spdx: MIT
licence_at:   Original implementation according to ATTRIBUTION.md; no third-party mod code or assets reused. Only the mechanic is inspired by Disney Dreamlight Valley. Root and distributed LICENSE grant MIT. Classification original describes provenance; MIT describes reuse permissions.
upstream_mod_remotes: N/A   # original mod (licence: original): no source mod ported, so no upstream repository to list. Distinct from `repo` (this mod's own repository) and `origin` (its git remote).
dependencies: declared
showcase:     complete
tested_on:    cd1afb7
code_review_sha: 980db5967464ec81059a1686db9fef81c26353da
echo_review_sha: 980db5967464ec81059a1686db9fef81c26353da
social_preview_sha256: 219233a643b3945e2aebabce4c4b4e89d31f24823fd5ce5010a2be469a44b249
workshop:      3806133311
maintainer:   Codex, current local repository task
updated:      2026-10-18
remaining:
  - defect: Ticket `20261016-224545-659-4675` done exit=0, capture refused 2026-10-17: yellow hard hat (tuque not applied), no hair visible, `+80` beside the rock, not over Rex, Rex side view. Evidence deleted 2026-10-19 (same scenario kept in `2026-10-17-gallery-20-retake`).
  - defect: Ticket `20261016-231343-764-47b8` (scenario 22, noon fishing) passed, exit=0 (`Tests/Pickle/Evidence/2026-10-17-gallery-22-fishing-1`); capture refused 2026-10-17: Nelim and Rex not face camera, `+1` beside Nelim not over Rex. Recompose before replay.
  - defect: Ticket `20261016-231344-857-a2c2` (scenario 23, evening) failed, exit=3, no report (evidence deleted 2026-10-19, nothing to read). Not replayed. Recomposed 2026-10-17 (`Rex faces South` added to `23-gallery-evening.feature`, uncommitted); replay awaits owner's go. Same exit=3 startup hang as `6f53`, `7f90`, `3485`: cause open (Audit owns the diagnosis).
  - defect: Ticket `20261017-142331-394-9334` (scenario 20, Show Hair Under Stuff, sha `95bf34c`) passed, exit=0 (`Tests/Pickle/Evidence/2026-10-17-gallery-20-retake`); capture refused 2026-10-17: the yellow dome is the tuque itself, dyed (230, 170, 40), read as a hard hat at this size (step `wears Apparel_Tuque` passes); no hair visible, Rex side or back facing left, `+80` above-left, not over Rex. Show Hair Under Stuff did not show hair on this capture.
  - validated: Tuque blue control read 2026-10-19: ticket `3485` itself failed exit=3 (no report, evidence deleted), but the scenario `a tuque dyed blue, close, to see its shape` passed inside the run of 2026-10-17 (evidence `Tests/Pickle/Evidence/2026-10-17-tuque-blue-green`, one JPEG). The capture shows a round blue dome on Nelim's head, no hair visible: the yellow "hard hat" of the gallery captures IS `Apparel_Tuque` dyed (230, 170, 40), its own shape, not a wrong item. Owner refused the `01-loading` test 2026-10-17 (not filed).
  - defect: Ticket `20261018-113212-944-6f53` (empty photo rice-paddy) failed, exit=3, no report (stall record: no growth for 5 min at 2026-10-18 19:01, Windows commit 42,4 of 44,2 GB, free RAM 0,6 GB, FireworkStand run in the same WSL; evidence deleted 2026-10-19). Probable cause: machine memory pressure with two games staged at once, not the map; unproven. Same exit=3 as `a2c2`, `3485`, `7f90`. Replay alone when memory is free.
  - validated: Ticket `20261018-113207-363-ba28` (empty photo fishing-zone) passed, exit=0, 1/1, staged the sanctuary map cleanly (evidence `Tests/Pickle/Evidence/2026-10-18-empty-fishing-zone`). Read 2026-10-18: at zoom 12 on (114, 68) the frame is about 80% deep water, a strip of bare soil on the right edge, green shore and reeds at left and top. Nelim cannot stand on water: the standing cells are only the right strip, exact coordinates not readable from the image (no grid). Scene 2 stays at 3 until NPT sends cells (`SANCTUAIRE-CASES.md`).
  - validated: Ticket `20261018-184320-262-db93` (replay of `7f90`, `25-hair-bare-control`, sha `9fd5784`) passed, exit=0, 1/1, evidence deleted 2026-10-20 (its purpose served by `14a2`). Capture opened 2026-10-19: Nelim bare-headed, front, hair up in a bun (not the long loose "Flowy" of the shotlist), face readable at this zoom. It proves hair renders without a hat, nothing about hair under the tuque. NPT finding 2026-10-19: Show Hair Under Stuff has `showUnderUpperHeadGear` and `showUnderFullHeadGear` false when no settings file exists, so the mod did nothing in every run so far; seed `Tests/Pickle/config/sanctuary/Mod_3255379190_ShowHairMod.xml` written 2026-10-19 (uncommitted at write time, not yet played). Every earlier "no hair under the tuque" reading (20, 21, the unusable control) was measured with the mod off.
  - validated (replayed green by `db93`, evidence of the failed run deleted): Ticket `20261018-111808-265-7f90` (control `25-hair-bare-control`, bare-headed) failed, exit=3, no report: launcher said "game wrote nothing for 5 min, killed" (startup hang). The stderr line "error: 3027639868 declares no packageId" in its log is NOT this run: 3027639868 is in FoodCourt's map only, FoodCourt tickets `7ac9` and `dd90` ended exit=3 just before and the stderr looks stale. This map stages cleanly in the running ticket `ba28` (17 Workshop folders, no 3027639868). Real cause: startup hang, same exit=3 as `a2c2`, undiagnosed. Falsifier: result of `ba28`. Hair verdict still open.
  - validated: Ticket `20261019-154223-679-14a2` (`21-hair-under-tuque`, map `wsl-deps.sanctuary.map` with the Show Hair seed, tree at `92718d1`) passed, exit=0, 1/1, evidence `Tests/Pickle/Evidence/hair-tuque-seed` (one JPEG). Capture opened 2026-10-20: hair visible under the tuque (brown hair framing the face, bun above the dome), so Show Hair Under Stuff works once its settings file is seeded; earlier "no hair" readings were the mod off. Frame is wide (Nelim small): gallery scene 1 needs a closer zoom. Open: the feature comment says Show Hair is "on by default", false without a settings file, to fix.
  - defect: Ticket `20261020-003921-376-1577` (`20-gallery-mark`, tree at `e7d5cfc`) failed, exit=1, 0/1 (read 2026-10-25, evidence deleted): `Undefined step: "{string} hairstyle is {string}"`, no scene played. `Check-Steps.ps1` 2026-10-25: 4 step lines match nothing: `"Nelim" hairstyle is "Flowy"` (20 and 23), `I let 10 ticks pass` (20), `the scene decor "Plant_Rice" stands 2 cells right of and 1 cell below "Nelim"` (23). Asked NPT for the steps; replay 20 once they exist. Then fix the feature 21 comment (Show Hair is off without a settings file).
  - unverified: Ticket `20261025-154810-853-eefb` (`20-gallery-mark`, shotlist v3, tree at `33dfca4`, map `wsl-deps.sanctuary.map`) queued, evidence `Tests/Pickle/Inbox/gallery-1-v3`. Capture to open: tuque and hair visible, Rex front, `+N` over Rex at zoom 8 (readable at 268 px?), Jade item and lit lamp in frame. Keep the tree on `33dfca4` (Mod, Source, Tests) until `RUN_DONE`.
  - validated: Shotlist v3 written 2026-10-25 (section "Shotlist v3", after the Opus director's pass): one outfit all day, hours 7, 12, 18, zoom 8, 5, 4, each scene 4.5. Features 20, 22, 23 rewritten to it (23 moved to `rice-paddy`); `Check-Steps.ps1` resolves every step. Nothing replayed yet: file 20 first (`advance the paused game` and `Jade` decor never played), then 22 and 23 one by one.
  - note: Ticket `d47d` (hair control) was cancelled, replaced by `7f90` then `db93`. Next ticket to file: `21-hair-under-tuque` (or the hair pair) with the settings seed, to read whether hair shows under the tuque once the mod is really on.
  - unverified: Gallery image 1 retake (20-gallery-mark, hour 8, tuque moutarde, Rex face caméra) not yet replayed with `ACertainSeriesCreaturesAndHairRenew` (Workshop 3806708754, added to `Tests/Pickle/wsl-deps.sanctuary.map` 2026-10-17, not checked in game). Run 22 (noon, `gallery-10`) and run 23 (evening, `gallery-11`) played green but captures refused: Nelim and Rex not face camera, `+N` not over the companion, no ripe rice visible (23). Recompose before replay.
  - note: Casque jaune dans la capture run 47a2: c'est la tuque (teinte `(230, 170, 40)`, forme ronde propre à `Apparel_Tuque`), pas un autre objet (voir le contrôle bleu du 2026-10-19). Candidate `1-candidate-companion-at-work.png` supprimée.
  - note: Hair control `2026-10-12-hair-sanctuary-noshowhair.map` capture (read 2026-10-17, evidence deleted 2026-10-19): figure too small at zoom 6, tuque (not a hard hat), no hair visible. Unusable, and measured with Show Hair Under Stuff off in any case (see `db93`). The `hair-sanctuary.map` pass is not read.
  - defect: Three runs relayed by TM as exit=0 (`5de1` gallery-sb-update, `27fa` gallery-morning, `aee4` hair-sanctuary.map) have no evidence folder on disk (checked by TM, depth 6). Treat as no proof; not counted in any pass. Re-run needed before any claim.
  - unverified: Subtitles in `PUBLICATION.md` (section Gallery subtitles, lines 2 and 3 reworded 2026-10-17) await owner review; scenario 22 still says "fishes at the lake" (shared step with 16-fishing), comment added in the feature.
  - validated: All four Pickle passes are green on revision `cd1afb7` (English, French, RIMMSQOL, without Odyssey), no `@wip` scenario remains, and every `@review` capture has been opened and looked at. See the 2026-09-29 section for the count per pass and the evidence folders.
  - validated: The cow scenario (14-what-it-does-not-help, "a cow that is its master's companion does not help milk itself") was red on three runs because milking throws the product away with a chance of 1 - AnimalGatherYield (seeded draw), a defect of the suite. Replayed green with the repeat-until-product step, again on `68a30c9`; evidence deleted 2026-10-19 (English run); French copy in Tests/Pickle/Evidence/2026-09-27-pass2-part3.
  - validated: The mining gallery capture (scenario 20) now shows the companion beside the colonist, the "+N" mark readable and no overlapping tooltip; cropped into Art/Gallery/1-candidate-companion-at-work.png and confirmed by the maintainer, along with the three settings captures (2-4). Evidence Tests/Pickle/Evidence/2026-09-28-pass3-chain-3 (the settings captures of pass2-part1/2 were dropped 2026-10-19: texts changed since).
  - validated: Scenario 13 of the functional list (mod added or removed in a game in progress) is played in both directions: `18-added-to-a-game-in-progress` (the shared fixture, written without the mod, loads with it, runs and saves again) and `19-save-for-removal` then `removal-check` (a game saved with the mod, holding nothing of it outside its mod list, loads, runs and saves again with the mod out of the mod list). Evidence Tests/Pickle/Evidence/2026-09-27-pass2-part3 (scenario 18, French run; English run deleted 2026-10-19) and 2026-09-25-retrait-3 (19 and removal-check).
  - validated: RIMMSQOL's own list offers the shortcut, reveals it, the bar draws it, it opens this mod's dialog and shares its values, hiding works, and the choice survives two restarts (09, 10, 11, 12, played as one launch each in a chain). Evidence Tests/Pickle/Evidence/2026-09-27-pass3-rimmsqol/seq1 and 2026-09-28-pass3-chain-3.
  - validated: Without Odyssey, `Dig` and `Forage` do not exist, the mod loads without error, and an obedient companion still helps at the base chance with the requirement ticked. The scenario that had no map to work on (the shared save needs Odyssey's Orbit layer) now starts a fresh colony instead of loading it. Evidence Tests/Pickle/Evidence/2026-09-28-pass4-newcolony.
  - note: Workshop item 3806133311 was published by the maintainer as 0.1.0 while the local metadata and draft notes use 1.0.0. The maintainer explicitly accepts that difference for this early publication; it is tracked for the next planned update, not treated as a current audit blocker.
  - unverified: Gallery image 1 (staged photograph, candidate retaken: `1-candidate-nelim-jade.png` (run 47a2) refused by Virginie 2026-10-11 and deleted; replay with the updated SanctuaryBacklot and Show Hair Under Stuff checked, ticket 2026-10-11). Subscribe to Workshop item 3806133311 and test the installed Workshop copy, including its visibility and the actual item page contents. This audit does not access Steam; `tested` does not require it, `prepublished`/publication do.
  - validated: PublishedFileId `3806133311` is committed and pushed on `main` (e2ec8fc, followed by release-preparation commits).
  - validated: French review by Virginie, 2026-10-02: 12 corrections requested (Intro, WorkHeader, FishingTip, GatheringTip, RequireSpecialtyTip, BondTip, ShareTip, Radius, RadiusTip, BondChance, then Intro and FishingTip again), all applied; she declared the French validated linguistically at revision `342f69d` on her own statement in chat. The wording after that is the corrections listed here only (commit following 51bc7e5). Reread against the 2026-09-30 French gender-agreement rule (TRANSLATIONS.md section 3). No owned text agrees with a pawn: all 33 Keyed entries are settings labels, tooltips, the reset confirmation and the numeric assist mote (`+{0}`); the one DefInjected pair is the hidden MainButtons shortcut's label/description. None names or describes a specific colonist or animal, so no `{PAWN_gender ? ...}` switch applies or is missing. `FRENCH_REVIEW.md` regenerated (`scripts/Make-FrenchReview.ps1` (shared, protocols repository), reads the shipped XML) on revision `7d441a6` (after the two English corrections of 6193bc0).
protocols_read_sha: 459f0376dce9e5bb718362cfcaccac1ed681e361
---
# Fieldwork Companions — status

Task owns, maintains this STATUS.md as work progresses. File stays at repository root, outside distributed Mod/ folder.

## Audit — 2026-10-11 (re-audit against the current AUDIT.md)

Audited on `e39d9ab` (working tree clean before edit). **`prepublished` (old vocabulary) becomes `shootGallery[1.0.0]`.**

**Why not further.** Old `prepublished` maps to `publish`, but cumulative criteria stop earlier:
- `playTests` (8): green passes on `cd1afb7` (EN, FR, RIMMSQOL, without Odyssey), no `@wip`, conditional scenarios played, `@review`
  captures opened, no manual test left: kept from 2026-09-29 sections (archived in `docs/runs/status-journal-to-2026-10-11.md`).
  **8.m was missing** (`code_review_sha`): done today. `git diff e2ec8fc..HEAD -- Source Mod` (0.1.0 to now): `Source/FieldworkCompanionsMod.cs`
  (`maxOneColumn`, comment only otherwise), one comment line in csproj, French and English settings texts (Virginie's
  2026-10-02 review, two English corrections), plain-text `About.xml`, `README.template.md`, `.steamignore`, ModIcon, Preview.
  No finding. `code_review_sha` = `e39d9abadc2103ea280b5a01310bb578047fe629`.
- `settings_audit`: `passed` (in-game checks played both languages: settings page top, bottom, reset confirmation in pass 1 and pass 2).
- `shootGallery` (9): not exited. Image 1 being retaken as staged photograph (`20-gallery-mark.feature`, run `47a2`): candidate
  `1-candidate-nelim-jade.png` (run 47a2) refused by Virginie 2026-10-11, deleted; scenario replayed with updated SanctuaryBacklot (new candidate judged by session first). Earlier
  `1-candidate-companion-at-work.png` stays until she answers, then one of two goes.

**Done in this audit.** Steam description lost its four em dashes (rule of 2026-10-10): `Mod/README.template.md`, then
`node .github/scripts/sync-about-description.mjs --write` (commit `e39d9ab`). `STATUS.md` folded: journal sections moved verbatim to
`docs/runs/status-journal-to-2026-10-11.md`. Front matter: `stage` removed, `workflow_stage` added, `protocols_read_sha` below.

**Not done, and for which state.**
- `mountPreview` (2026-10-12, done by this session): echo redrawn by hand from gallery (`Art/echo-source.png`: miner with pickaxe and dog, 260x260, commit `c8b040d`), `Art/Preview.config.json` points to it (`echo.file`, 260x260), Preview regenerated (`Mod/About/Preview.png` 896x504, 543 KB, opened at full size and at 268 px: echo is green line drawing in accent colour, right of summary (first render hid it: `"mode": "luminance"` in echo block masked black strokes away, removed 2026-10-12; echo block now panelWidth 27, panelTop 40)), `Art/Gallery/0-preview.png` is its byte copy, `echo_review_sha` and `social_preview_sha256` recorded, GitHub social preview uploaded and checked (`og:image` file has same sha256). `echo.png` and renamed copy `echo-original.png` removed (identical to committed one).
- `writeDocs`: description not yet `## Steam description` block in `PUBLICATION.md` (is `Mod/README.template.md`,
  accepted by `OPERATIONS.md` until migration); `publication_changelog_review_sha` (Virginie's reading); `## [1.0.0]` section
  of CHANGELOG dated 2026-09-29, `[Unreleased]` must come back until dry-run (12.e); owner marks review per `x.y` line.
- Regression after deploy (not before): English and French settings texts changed after `tested_on` (`cd1afb7`); Pickle replay of scenarios
  showing them runs after commit, in small tickets (AUDIT.md, "Une modification de texte après validation"). Retrait chain
  (scenarios 19 and `removal-check`) part of it.
- Still CI/CD session's: migration from semantic-release to `publish-tag.yml`.


**Replayed today against current protocols (AUDIT.md, section 16), on `e39d9ab`.**
- `declareDependencies`: `About.xml` read again: Harmony only hard dependency (id, Workshop url, download url), `loadAfter` Harmony, Core and five DLCs including Odyssey, `supportedVersions` 1.6, no `incompatibleWith`, no `LoadFolders.xml` (one version), no XML patch (only `MainButtonDef`); Odyssey's trainings resolved by name at runtime, degrade silently (pass 4 played it). Harmony used by four patches in `Source/`. Unchanged since 2026-10-02.
- `auditSettings`: MOD_SETTINGS.md read; see "Settings audit" below.
- `localize`: `scripts/Make-FrenchReview.ps1 -ModRoot` (shared script, replaces local `Generate-FrenchReview.ps1`, deleted on Audit session's ruling of 2026-10-11) regenerated `FRENCH_REVIEW.md` at `e39d9ab`: 35 rows, none flagged. French gender rule unchanged (no text agrees with a pawn).
- `writeTests`: `scripts/Run-Functional-Tests.ps1`: 25 tests, all passed (replayed). Shared `scripts/Check-Steps.ps1`: 20 features parse (62 scenario blocks), 75 patterns compile, none declared twice, 539 step lines each resolve to exactly one step (one dead pattern: `the camera looks at {string}`); Pickle assemblies taken from WSL install with `-PickleAssemblies`. Local `Tests/Pickle/Check-Steps.ps1` and `Minify-Evidence.ps1` deleted (shared copies, Audit ruling of 2026-10-11).
- Build: `dotnet build Source/FieldworkCompanions.csproj -c Release` 0 warnings, 0 errors. No longer reproducible byte for byte: see ".build" below.
- Mod root: only `.git`, `.gitattributes`, `.github`, `.gitignore` start with dot or underscore. `.build/` removed (see below); `_tools/` does not exist (moved to `scripts/` on 2026-10-05).

**`.build` (closing pass 3).** `Source/Directory.Build.props` and `Tests/Pickle/Source/Directory.Build.props` no longer redirect `obj`/`bin`: stay in `Source/obj`, `Source/bin` and `Tests/Pickle/Source/obj`, `bin` (gitignored, not `Mod/`); `scripts/Settings-Tests.ps1` scratch moved to `Source/obj/settings-tests`. **Cost:** compiled DLL embeds build path, so rebuild gives other bytes (`1E90ED968143…` against committed `99AEF88CEF37…`). Committed DLL restored, stays shipped one (sources unchanged since `cd1afb7`); next rebuild is `Mod/` commit, so reopens `code_review_sha`.

## Settings audit

Date 2026-10-11, revision `e39d9ab`. Inventory: 12 settings (4 work switches, training requirement, bond share, base chance, per-step chance, bond chance, radius, mark switch) plus reset; shortcut `FieldworkCompanions_Settings` MainButtonDef, hidden by default. Access: Mod options, then hidden shortcut for RIMMSQOL, same values. Applies immediately, global (not per save). Automated: `Run-Functional-Tests.ps1` 25/25 (defaults and reset, normalization, effect of every switch combination, Scribe persistence from EN and FR hosts, older and out-of-range files, shortcut hidden and revealable). In game (Pickle, revision `cd1afb7`): settings page top, bottom, reset in both languages (01-05), persistence (03), shortcut and RIMMSQOL (04, 09-12, passes 3 and 5); evidence `Tests/Pickle/Evidence/2026-09-27-pass2-part1` (mechanics only, settings-page captures dropped 2026-10-19), `-part2`, `2026-09-27-pass3-rimmsqol`, `2026-09-28-pass3-chain-3`. Result: `passed`. Full 2026-09-13 to 2026-09-23 detail in `docs/runs/status-journal-to-2026-10-11.md`.

## Translation audit — 2026-09-30

On peer session's notice: `TRANSLATIONS.md` gained French gender-agreement rule and systematic-French-review requirement (both 2026-09-30), `translation_fr` reset to `unchecked`. This audit redoes French pass on revision `7d441a6` (after two English corrections of 6193bc0); nothing in `Mod/` or
`Source/` changed, only check and record.

- **Where French lives:** `Mod/Languages/French/Keyed/FieldworkCompanions.xml` (33 entries:
  settings category title, 30 settings labels/tooltips/headers, reset confirmation, and
  numeric assist mote `+{0}`) and `Mod/Languages/French/DefInjected/MainButtonDef/FieldworkCompanions.xml`
  (2 entries: hidden MainButtons shortcut's label and description). No grammar resource files
  exist; mod issues no `GrammarRequest`.
- **Gender agreement:** read every French entry (see `FRENCH_REVIEW.md`) against three-segment
  switch rule. After Virginie's 2026-10-02 review (BondTip said "le colon", corrected, "maître" removed), none of 35 texts agrees with a pawn — they describe mechanic in
  abstract ("le compagnon", "l'animal", "un compagnon entièrement dressé et lié") not specific colonist or animal at runtime, and `Source/**/*.cs` passes no `Pawn` to any `.Translate()`
  call (`FieldworkCompanionsMod.cs`, `Runtime/Companions.cs`; grep confirms only numeric arguments:
  chance percentages, assist count, radius). No `{PAWN_gender ? ...}` switch used or
  missing.
- **`FRENCH_REVIEW.md`** generated at mod root by new `scripts/Make-FrenchReview.ps1` (shared, protocols repository)
  (reads shipped XML, one table per file, Original/English/French columns; Original repeats
  English since mod original, not ported). No row flagged `?`. Not committed to `Mod/`,
  so Steam never receives it.
- Not this session's to set: `translation_fr` stays `partial`, with `unverified: French review
  by Virginie` line in `remaining`. Only Virginie's own session marks it reviewed.


## What this mod taught the repository, and what outlives it

- **`GenerateAssemblyInfo=false` trap has taken second mod, will take more.**
  Krafs.Publicizer applies `IgnoresAccessChecksTo` through generated AssemblyInfo; switching
  property off embeds attribute's type, never applies it. Here two members milking patch reads,
  `ResourceDef` and `ResourceAmount`, are `protected abstract` in real
  Assembly-CSharp — checked against game's own file, not publicised reference — so
  desktop CLR would refuse that access. **Cost in game not established**: Architect Studio session found non-public call of its own, outside any try/catch, in assembly with no waiver, working in real game: RimWorld's Mono seems not to enforce check the way desktop CLR does, and every check we run happens under PowerShell, on desktop CLR. Treat as conformance fix, not repair of mod seen dead. Contented
  Livestock had it on fields, this one on properties: common factor is switched-off
  property, not kind of member, and **every mod that switches off `GenerateAssemblyInfo` and
  publicises deserves same check** — twelve of them, two now fixed. Fixed here in
  `Source/AccessChecks.cs`.

- **Searching built assembly's bytes for `IgnoresAccessChecksTo` returns false positive.**
  Type name is in file whether or not attribute applied — that is shape of trap. Check that counts is one line of reflection on built assembly:
  `[Reflection.Assembly]::ReflectionOnlyLoadFrom(<dll>).GetCustomAttributesData()`, attribute either in that list or not. No need to launch game, or even resolve
  assembly's dependencies.
## Shotlist v3 (2026-10-25, write-shotlist, shootGallery; supersedes the v1 and v2 tables of 2026-10-18)

Story (k): one day for Nelim (only colonist, protagonist) and her husky Rex, from the river to the rice on the east side of the Sanctuary; the day's extras pile up, one more each time. Hours 7, 12, 18 set per scenario (`I set the hour to N`), weather Clear. Same teal shirt `(30, 140, 150)` and ochre trousers `(150, 100, 50)` all day (continuity, d), long loose hair "Flowy" (Core catalogue; visible under the tuque thanks to Show Hair Under Stuff, in the DepMap); the mustard tuque `(230, 170, 40)` is worn at dawn only, for the stone dust: she is bare-headed by noon (the plan says so). Series: opening WIDE (1), MEDIUM (2), closing TIGHT (3); the front view of the animal is image 1 only (Rex looks back toward the path), then profile (2: watching the water, 3: watching the next plant). Light by the hour: low at 7, flat at 12, warm and low at 18.

| # | a. Place, hour, time | b. Decor | c. Living | d. Nelim | e. Instant | f. Composition | g. Says | j. Mod, at 268 px | Est. | Risk and plan |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 dawn (20) | `bare-clearing` (195, 152), 7, Clear, the job runs about 40 s at ultrafast | lit `TorchLamp`, one `Jade` item (the haul so far), `MineableJade` rock, existing flower column | Rex, FRONT (South: looks back along the path), flowers | tuque (230, 170, 40), teal shirt, ochre pants, Flowy under the tuque; brows squared, mouth neutral (effort, justified) | pickaxe just down, rock at 20 %, `+N` just risen over Rex | zoom 8 wide, Nelim left third, Rex right-front, lamp lower left, jade right, low light, presentation mode | "a little more jade than it should" | `+N` over Rex at zoom 8: unproven at 268 px (fall back to zoom 6) | 3.5 | `I advance the paused game by exactly 10 ticks` compiled by NPT, not played; decor `Jade` item through the shared decor step, not tried; Show Hair seed needed (config/sanctuary) |
| 2 noon (22) | `right-bank` (144, 131), 12, Clear, fishing job to the first catch | `FishRack`, `FishGear` (zal.fishprops, in the map), one `Jade` item beside the gear, fish stocked in the river | Rex at her feet facing West (profile, watches the water), red-leaved trees, river | bare-headed (tuque off: the plan), teal shirt, ochre pants, Flowy in the light, `MouthSmile` + `LidCheerful` | a fish has just been landed, `+N` rises over Rex | zoom 5 medium, Nelim left third, water on the left, rack and gear lower right | "one fish more than she caught" | `+N` over Rex at zoom 5, proven readable on the earlier captures | 3.5 | cell (144, 131) estimated from the empty photo (water edge), not seen in a run; fish stocking step `the water beside Nelim holds fish` played in 16-fishing only |
| 3 evening (23) | `rice-paddy` (230, 122), cells (227, 121), 18, Clear, harvest to the first plant | lit `TorchLamp` (field lamp), second ripe `Plant_Rice`, bamboo edge | Rex facing East (profile, toward the second plant), rice | bare-headed, teal shirt, ochre pants, Flowy loose, her own relaxed face | sickle mid-cut on a ripe plant, `+N` rises, next plant waits | zoom 4 tight, Nelim right of centre, Rex left, bamboo behind, last light | "one grain more than expected" | `+N` over Rex at zoom 4, large | 3.5 | cells read from the empty photo, never seen in a run; exit=3 history on this scenario (memory pressure, not the map): replay alone; `Plant_Rice` decor step singular cell fixed 2026-10-25 |

Criteria not rated per scene: k (series), met: story written here and in each feature header, opening (1) and closing (3), wide, medium and tight, one animal front view (1). No interface window in the story; the settings captures 2 to 4 stay as menus, no subtitle. Subtitles: lines in `PUBLICATION.md` after acceptance and reindex.

Director's pass (Opus sub-agent, one call): kept the hours 7 and 18 (torch at 8 read staged), Jade item instead of two stone chunks (a jade vein drops jade), the zoom spread 8, 5, 4, Rex front view in one scene only, the fish landed as the one instant of scene 2, Nelim right of centre in scene 3. Dropped: the tuque on the fish rack and a raw-fish stack in scene 3 (no step puts apparel on a rack or a fish stack on a cell; asked to NPT only if the owner wants them).

Score (rate-gallery 2026-10-25, corrects the 4.5 first written): every scene 3.5, series k ok. 1: a weather not scripted, b three props on bare earth, j mark at zoom 8. 2: a weather, e Rex not held at her feet during the job, j "readable" claim has no evidence. 3: a weather, b bare soil after the clear, e "mid-cut" and "+N rises" contradict (the mark rises when the harvest ends). To reach 4: add `I set the weather to "Clear"` to 20, 22, 23; fix the instant of 23; hold Rex beside her in 22; enrich the decor of 1 and 3. Ticket eefb (20) was filed before this fix; the tree stays frozen until its RUN_DONE.

### Shotlist v3.1 (2026-10-25, after rate-gallery; supersedes the Est. column above; apply to the features after the RUN_DONE of eefb, the tree stays frozen until then)

Changes against v3, all scenes: `I set the weather to "Clear"` added after `I set the hour to N` (a). Scene 1: decor enriched with a `Stool` (where she rests) and a fully grown `Plant_Daylily`; check written: downscale the capture to 268 px and read the `+N`, else zoom 6. Scene 2: Rex held at her feet during the fishing job by a new own step `"Rex" is kept beside "Nelim" at (143, 131)` (sets `keptBeside`, which `MarkOverWithin` already applies every frames); the claim "readable on earlier captures" is dropped (evidence deleted): the 268 px check is done on the new capture. Scene 3: instant rewritten, no sickle and no "mid-cut": the harvest has just ended, Nelim straightens up, the plant is gone, the `+N` rises over Rex who looks East toward the second ripe plant (the next cut); the paddy sprouts are kept (clear only the 3 x 3 under Nelim and the second plant), so the soil is lived-in.

| # | a | b | c | d | e (instant, how) | f | g | j | Est. |
|---|---|---|---|---|---|---|---|---|---|
| 1 dawn (20) | `bare-clearing`, 7, Clear (step), job ~40 s | lit `TorchLamp`, `Stool`, `Plant_Daylily`, `Jade` item, jade rock | Rex front, daylily, flower column | tuque (230, 170, 40), teal, ochre, Flowy; neutral mouth (effort) | pickaxe just down, rock 20 %, `+N` just risen; job mine, pause on the mark frame | zoom 8 wide, Nelim left third, Rex right-front | "a little more jade than it should" | `+N` at zoom 8 doubtful: 268 px check, else zoom 6 | 4.5 |
| 2 noon (22) | `right-bank` (144, 131), 12, Clear (step) | `FishRack`, `FishGear`, `Jade` item, stocked river | Rex profile West at her feet (kept beside), trees, river | bare-headed, teal, ochre, Flowy, `MouthSmile` + `LidCheerful` | fish just landed, `+N` rises; fishing job, pause on the mark frame | zoom 5 medium, Nelim left third, water left | "one fish more than she caught" | `+N` at zoom 5, 268 px check on the new capture | 5 |
| 3 evening (23) | `rice-paddy` (227, 121), 18, Clear (step) | lit `TorchLamp`, second ripe `Plant_Rice`, kept sprouts, bamboo edge | Rex profile East, rice, bamboo | bare-headed, teal, ochre, Flowy, own relaxed face | harvest just ended, Nelim straightens, `+N` rises, next plant waits; harvest job, pause on the mark frame | zoom 4 tight, Nelim right of centre, Rex left | "one grain more than expected" | `+N` at zoom 4, large | 5 |

k (series): ok, unchanged. Steps: 1 new own step (scene 2, `kept beside`), `Jade`/`Stool`/`Plant_Daylily` decor through the shared decor step (never tried: not counted). Unverified: cells of 2 and 3 (empty photos only), fishing job on a river, `Rex faces East/West`.


Verdicts after the runs: none yet. Previous captures (v2): refused 2026-10-17 (tuque read as hard hat, no hair, Rex sideways, `+80` above-left; scene 2 back or profile, `+1` not over Rex).

## State 2026-10-25

- Scenes: 20 (dawn, 4.5), 22 (noon, 4.5), 23 (evening, 4.5) per shotlist v3; none replayed since the rewrite. Ticket 1577 (20) failed on undefined steps, read 2026-10-25, evidence deleted; the steps now resolve.
- Open: file ticket for 20 alone; NPT confirmed the hairstyle step (prefix fixed) and the paused-advance step (compiled 8318f39, not played). Cells of 22 and 23 unseen (empty photos only). exit=3 cause open with Audit.
- Evidence: Inbox empty, Parked absent (2026-10-25). Protocols read 459f037 (2026-10-25).
