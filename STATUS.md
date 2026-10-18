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
social_preview_sha256: 53a6764353fb962b3b9b8f9eba8d6dada654e38c1752edc736ee765402c9ccde
workshop:      3806133311
maintainer:   Codex, current local repository task
updated:      2026-10-11
remaining:
  - defect: Ticket `20261016-224545-659-4675` done exit=0, capture refused 2026-10-17: yellow hard hat (tuque not applied), no hair visible, `+80` beside the rock, not over Rex, Rex side view. Evidence `Tests/Pickle/Evidence/2026-10-17-gallery-20-hair`.
  - defect: Ticket `20261016-231343-764-47b8` (scenario 22, noon fishing) passed, exit=0 (`Tests/Pickle/Evidence/2026-10-17-gallery-22-fishing-1`); capture refused 2026-10-17: Nelim and Rex not face camera, `+1` beside Nelim not over Rex. Recompose before replay.
  - defect: Ticket `20261016-231344-857-a2c2` (scenario 23, evening) failed, exit=3, no report (`Tests/Pickle/Evidence/2026-10-17-gallery-23-evening`). Not replayed. Recomposed 2026-10-17 (`Rex faces South` added to `23-gallery-evening.feature`, uncommitted); replay awaits owner's go.
  - defect: Ticket `20261017-142331-394-9334` (scenario 20, Show Hair Under Stuff, sha `95bf34c`) passed, exit=0 (`Tests/Pickle/Evidence/2026-10-17-gallery-20-retake`); capture refused 2026-10-17: the yellow dome is the tuque itself, dyed (230, 170, 40), read as a hard hat at this size (step `wears Apparel_Tuque` passes); no hair visible, Rex side or back facing left, `+80` above-left, not over Rex. Show Hair Under Stuff did not show hair on this capture.
  - defect: Ticket `20261016-232655-331-3485` (tuque blue control) failed, exit=3, no report (`Tests/Pickle/Evidence/2026-10-17-tuque-blue`). Decides nothing yet; cause same exit code as `a2c2`, not diagnosed. Owner refused the `01-loading` test 2026-10-17 (not filed); exit=3 cause stays open.
  - unverified: Ticket `20261018-000031-499-d47d` (control `25-hair-bare-control.feature`, Nelim bare-headed, Show Hair Under Stuff in `wsl-deps.sanctuary.map`, sha `51511ec`) queued; evidence `Tests/Pickle/Evidence/2026-10-18-hair-bare-control`. Hair here and not under the tuque (21/20) = the tuque hides it; no hair here = the mod or the hairstyle. Capture to open before any verdict.
  - unverified (superseded by the line above): Ticket `20261016-232655-331-3485` queued: control `24-tuque-colour-check.feature` (tuque dyed blue `(30, 80, 220)`), evidence `Tests/Pickle/Evidence/2026-10-17-tuque-blue`. Decides whether the yellow dome in gallery captures is the tuque's own shape (`Apparel_Tuque`, texture not readable from disk). Not verdict until the capture is opened.
  - (old line, superseded) Ticket `20261016-224545-659-4675` queued (scenario `20-gallery-mark`, map `wsl-deps.sanctuary.map` with hair mod, sha `fb72482`, evidence `Tests/Pickle/Evidence/2026-10-17-gallery-20-hair`). Waits for `RUN_DONE`; capture to open and judge before any verdict. Scenarios 22 and 23 to recompose before any new ticket.
  - unverified: Gallery image 1 retake (20-gallery-mark, hour 8, tuque moutarde, Rex face caméra) not yet replayed with `ACertainSeriesCreaturesAndHairRenew` (Workshop 3806708754, added to `Tests/Pickle/wsl-deps.sanctuary.map` 2026-10-17, not checked in game). Run 22 (noon, `gallery-10`) and run 23 (evening, `gallery-11`) played green but captures refused: Nelim and Rex not face camera, `+N` not over the companion, no ripe rice visible (23). Recompose before replay.
  - defect: Casque jaune au lieu de `Apparel_Tuque` dans la capture run 47a2 / candidate `1-candidate-companion-at-work.png`; cause non trouvée. Tuque demandée par le step, pas appliquée.
  - defect: Hair control `2026-10-12-hair-sanctuary-noshowhair.map` capture (read 2026-10-17): figure too small at zoom 6, yellow hard hat (not tuque), no hair visible. Control unusable: replay the hair pair with a closer frame and the tuque applied. The `hair-sanctuary.map` pass is not read.
  - defect: Three runs relayed by TM as exit=0 (`5de1` gallery-sb-update, `27fa` gallery-morning, `aee4` hair-sanctuary.map) have no evidence folder on disk (checked by TM, depth 6). Treat as no proof; not counted in any pass. Re-run needed before any claim.
  - unverified: Subtitles in `PUBLICATION.md` (section Gallery subtitles, lines 2 and 3 reworded 2026-10-17) await owner review; scenario 22 still says "fishes at the lake" (shared step with 16-fishing), comment added in the feature.
  - validated: All four Pickle passes are green on revision `cd1afb7` (English, French, RIMMSQOL, without Odyssey), no `@wip` scenario remains, and every `@review` capture has been opened and looked at. See the 2026-09-29 section for the count per pass and the evidence folders.
  - validated: The cow scenario (14-what-it-does-not-help, "a cow that is its master's companion does not help milk itself") was red on three runs because milking throws the product away with a chance of 1 - AnimalGatherYield (seeded draw), a defect of the suite. Replayed green with the repeat-until-product step, again on `68a30c9`; evidence Tests/Pickle/Evidence/2026-09-27-pass1-part3.
  - validated: The mining gallery capture (scenario 20) now shows the companion beside the colonist, the "+N" mark readable and no overlapping tooltip; cropped into Art/Gallery/1-candidate-companion-at-work.png and confirmed by the maintainer, along with the three settings captures (2-4). Evidence Tests/Pickle/Evidence/2026-09-28-pass3-chain-3 and 2026-09-27-pass2-part1/2.
  - validated: Scenario 13 of the functional list (mod added or removed in a game in progress) is played in both directions: `18-added-to-a-game-in-progress` (the shared fixture, written without the mod, loads with it, runs and saves again) and `19-save-for-removal` then `removal-check` (a game saved with the mod, holding nothing of it outside its mod list, loads, runs and saves again with the mod out of the mod list). Evidence Tests/Pickle/Evidence/2026-09-27-pass1-part3 (scenario 18) and 2026-09-25-retrait-3 (19 and removal-check).
  - validated: RIMMSQOL's own list offers the shortcut, reveals it, the bar draws it, it opens this mod's dialog and shares its values, hiding works, and the choice survives two restarts (09, 10, 11, 12, played as one launch each in a chain). Evidence Tests/Pickle/Evidence/2026-09-27-pass3-rimmsqol/seq1 and 2026-09-28-pass3-chain-3.
  - validated: Without Odyssey, `Dig` and `Forage` do not exist, the mod loads without error, and an obedient companion still helps at the base chance with the requirement ticked. The scenario that had no map to work on (the shared save needs Odyssey's Orbit layer) now starts a fresh colony instead of loading it. Evidence Tests/Pickle/Evidence/2026-09-28-pass4-newcolony.
  - note: Workshop item 3806133311 was published by the maintainer as 0.1.0 while the local metadata and draft notes use 1.0.0. The maintainer explicitly accepts that difference for this early publication; it is tracked for the next planned update, not treated as a current audit blocker.
  - unverified: Gallery image 1 (staged photograph, candidate retaken: `1-candidate-nelim-jade.png` (run 47a2) refused by Virginie 2026-10-11 and deleted; replay with the updated SanctuaryBacklot and Show Hair Under Stuff checked, ticket 2026-10-11). Subscribe to Workshop item 3806133311 and test the installed Workshop copy, including its visibility and the actual item page contents. This audit does not access Steam; `tested` does not require it, `prepublished`/publication do.
  - validated: PublishedFileId `3806133311` is committed and pushed on `main` (e2ec8fc, followed by release-preparation commits).
  - validated: French review by Virginie, 2026-10-02: 12 corrections requested (Intro, WorkHeader, FishingTip, GatheringTip, RequireSpecialtyTip, BondTip, ShareTip, Radius, RadiusTip, BondChance, then Intro and FishingTip again), all applied; she declared the French validated linguistically at revision `342f69d` on her own statement in chat. The wording after that is the corrections listed here only (commit following 51bc7e5). Reread against the 2026-09-30 French gender-agreement rule (TRANSLATIONS.md section 3). No owned text agrees with a pawn: all 33 Keyed entries are settings labels, tooltips, the reset confirmation and the numeric assist mote (`+{0}`); the one DefInjected pair is the hidden MainButtons shortcut's label/description. None names or describes a specific colonist or animal, so no `{PAWN_gender ? ...}` switch applies or is missing. `FRENCH_REVIEW.md` regenerated (`scripts/Make-FrenchReview.ps1` (shared, protocols repository), reads the shipped XML) on revision `7d441a6` (after the two English corrections of 6193bc0).
protocols_read_sha: 7693bc9c57044ef5e155ba5216069f8320290a55
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

Date 2026-10-11, revision `e39d9ab`. Inventory: 12 settings (4 work switches, training requirement, bond share, base chance, per-step chance, bond chance, radius, mark switch) plus reset; shortcut `FieldworkCompanions_Settings` MainButtonDef, hidden by default. Access: Mod options, then hidden shortcut for RIMMSQOL, same values. Applies immediately, global (not per save). Automated: `Run-Functional-Tests.ps1` 25/25 (defaults and reset, normalization, effect of every switch combination, Scribe persistence from EN and FR hosts, older and out-of-range files, shortcut hidden and revealable). In game (Pickle, revision `cd1afb7`): settings page top, bottom, reset in both languages (01-05), persistence (03), shortcut and RIMMSQOL (04, 09-12, passes 3 and 5); evidence `Tests/Pickle/Evidence/2026-09-27-pass2-part1`, `-part2`, `2026-09-27-pass3-rimmsqol`, `2026-09-28-pass3-chain-3`. Result: `passed`. Full 2026-09-13 to 2026-09-23 detail in `docs/runs/status-journal-to-2026-10-11.md`.

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
## Shotlist — 2026-10-18 (write-shotlist, shootGallery)

Story: one day on the east bank of the river, Nelim (only colonist) and her husky Rex, same shirt and trousers, light changes. Start hour 8 for image 1, then 12, then 17 (set per scenario, `I set the hour to N`). Scenes below 4 are not played.

| # | Scene (scenario) | Place | Hour | Subject, what it says | Composition | Living / props / mods | Score (estimate) | Main risk | Verdict after run |
|---|---|---|---|---|---|---|---|---|---|
| 1 | morning jade (20) | `right-bank` (not in SANCTUAIRE-LIEUX named table: confirm on empty photo) | 8 | Nelim at the jade vein, mustard tuque, Rex beside her; the mark is the extra | Zoom 5, Nelim facing South (front), Rex facing South, mark over Rex, presentation mode | Nelim (teal shirt, ochre pants, mustard `Apparel_Tuque` (UpperHead, vanilla), Show Hair Under Stuff in DepMap), Rex, MineableJade, ChunkSlate, ChunkLimestone | 3 now, target 4 | Hair under the tuque not proven (`d47d` control pending); Rex facing not controllable beyond the step; mark placed near the rock, not Rex | Refused (ticket 9334 read 2026-10-17): tuque read as hard hat at this size, no hair, Rex sideways, `+80` above-left |
| 2 | noon fishing (22) | `fishing-zone` `(114, 68)` zoom 12 (named, pond) | 12 | Nelim fishing, bare-headed, smile; one fish more than she caught | Zoom 5, Nelim and Rex facing camera (South), fish rack and gear as decor | Nelim bare-headed, Rex, fish stocked in water (step), FishRack, FishGear (Odyssey, zal.fishprops) | 3 now, target 4 | Fishing needs Odyssey in the DepMap; Rex and Nelim facing; mark over Rex | Refused: Nelim and Rex back or profile, `+1` not over Rex (ticket 47b8) |
| 3 | evening harvest (23) | `rice-paddy` `(230, 122)` zoom 8 (named) | 17 | Nelim harvests rice in the last light, relaxed, own face; one grain more than expected | Zoom 5, Nelim facing South, Rex facing South, ripe rice beside her | Nelim, Rex, ripe `Plant_Rice` x2 (one stays after harvest) | 3 now, target 4 | Harvest ran into exit=3 (`a2c2`), cause not found; right-bank replaced by rice-paddy: check it is empty and sunny | Not played (exit=3, recomposed 2026-10-17) |

To retire (score below 4, not yet removed): `1-candidate-companion-at-work.png` (scene 1, refused at ticket 9334 read), and the scene-2 capture of 47b8 (never in Art/Gallery).

Control (not a gallery shot): `25-hair-bare-control.feature` (ticket `d47d`) decides whether Show Hair Under Stuff shows hair at all.

## Shotlist v2 — 2026-10-18 (against GALLERY.md a to k; supersedes the table above)

Story (k): one day on the Sanctuary's east side, Nelim (only colonist, protagonist) and her husky Rex. Three episodes that move forward: dawn at a jade vein, noon at the pond, evening at the rice. Hours 8, 12, 17 set per scenario (`I set the hour to N`). Weather clear.

| # | Scene (scenario) | a. Place, hour (b) decor | d. Nelim: outfit / hair / expression | c. Living | e. Action | f. Composition | g. Subject and what it says | h. Risk and plan | i/j. Mod shown | Score | Blocking criteria |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | dawn jade (20) | `bare-clearing` (named, bare earth, 18 x 10), hour 8; ChunkSlate, ChunkLimestone, TorchLamp: removed after the shot | teal shirt `(30, 140, 150)`, ochre pants `(150, 100, 50)`, mustard tuque `(230, 170, 40)`; hair visible (Show Hair Under Stuff in DepMap); brows squared, mouth neutral | Rex (husky), faces South | Nelim mines a MineableJade rock; the mark rises | zoom 5, Nelim centre-left, Rex front right, mark over Rex, presentation mode, interface 200% | "a little more jade than it should": the mark, the companion | Risk: hair under tuque unproven (`d47d` queued, one scenario); Rex facing (step staged, NPT asked); mark placed by the game, not controlled. Plan: cut the tuque if hair stays hidden, swap to a bare-headed dawn; ask NPT for a mark anchored on the animal | Show Hair Under Stuff; Rex as companion; mark | 3 | (c) and (d) need the hair proof; (f) coordinates on `bare-clearing` unverified (feature still says right-bank, to change) |
| 2 | noon pond (22) | `fishing-zone` `(114, 68)` zoom 12 (named pond), hour 12; FishRack, FishGear (Odyssey, zal.fishprops): removed after the shot | blue shirt `(40, 90, 160)`, cream trousers, bare-headed, long hair in the light; plain smile | Rex (husky) at her feet, faces South; fish stocked in the pond | Nelim fishes; one fish landed | zoom 5, Nelim left third, pond right, Rex front; daylight | "one fish more than she caught": the fish, the companion | Risk: DepMap needs Odyssey and zal.fishprops; coordinates on `fishing-zone` unverified; Rex front unproven. Plan: confirm coordinates on the empty photo, then ticket | Odyssey fishing gesture; zal.fishprops; companion | 3 | (f) coordinates; (c) front view unproven |
| 3 | evening rice (23) | `rice-paddy` `(230, 122)` zoom 8 (named), hour 17; two ripe Plant_Rice, one harvested and removed: the other stays | rust jacket `(160, 70, 40)`, grey trousers, hair up under a bandana, relaxed face | Rex (husky), faces South; ripe rice | Nelim harvests rice; the mark rises | zoom 5, Nelim centre, rice behind, Rex front left, last sun | "one grain more than expected": the harvest, the companion | Risk: scene 3 exit=3 at startup (`a2c2`: game silent 5 min before any step); fix or re-run first. Plan: replay alone after a startup check; if it hangs again, ask NPT | Plant harvest assist; companion | 3 | (h) exit=3 unresolved, nothing replayed |

Criteria left open for all three, for the record: (a) time passing between shots not yet written; (i) not a catalogue (met: one subject each); (k) story written here, not yet in each feature header.

Result: no scene at 4 on the evidence; the table writes a–k, but four items depend on runs not yet done (hair `d47d`, Rex facing, the three coordinates, the exit=3 startup).
