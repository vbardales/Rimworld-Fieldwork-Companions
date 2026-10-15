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
protocols_read_sha: 23f263539905e7d5a57ecaf3f85c29c92dc4b10d
---

# Fieldwork Companions — status

This task owns and maintains this STATUS.md as work progresses. The file stays at the
repository root, outside the distributed Mod/ folder.

## Audit — 2026-10-11 (re-audit against the current AUDIT.md)

Audited on `e39d9ab` (working tree clean before this edit). **`prepublished` (old vocabulary) becomes `shootGallery[1.0.0]`.**

**Why not further.** The old `prepublished` maps to `publish`, but the cumulative criteria stop earlier:
- `playTests` (8): green passes on `cd1afb7` (EN, FR, RIMMSQOL, without Odyssey), no `@wip`, conditional scenarios played, `@review`
  captures opened, no manual test left: kept from the 2026-09-29 sections (archived in `docs/runs/status-journal-to-2026-10-11.md`).
  **8.m was missing** (`code_review_sha`): done today. `git diff e2ec8fc..HEAD -- Source Mod` (0.1.0 to now): `Source/FieldworkCompanionsMod.cs`
  (`maxOneColumn`, comment only otherwise), one comment line in the csproj, the French and English settings texts (Virginie's
  2026-10-02 review and two English corrections), the plain-text `About.xml`, `README.template.md`, `.steamignore`, ModIcon and Preview.
  No finding. `code_review_sha` = `e39d9abadc2103ea280b5a01310bb578047fe629`.
- `settings_audit`: `passed` (in-game checks played in both languages: settings page top, bottom and reset confirmation in pass 1 and pass 2).
- `shootGallery` (9): not exited. Image 1 is being retaken as a staged photograph (`20-gallery-mark.feature`, run `47a2`): the
  candidate `1-candidate-nelim-jade.png` (run 47a2) was refused by Virginie on 2026-10-11 and deleted; the scenario is replayed with the updated SanctuaryBacklot (new candidate to be judged by the session first). The earlier
  `1-candidate-companion-at-work.png` stays until she answers, then one of the two goes.

**Done in this audit.** The Steam description lost its four em dashes (rule of 2026-10-10): `Mod/README.template.md`, then
`node .github/scripts/sync-about-description.mjs --write` (commit `e39d9ab`). `STATUS.md` folded: the journal sections moved verbatim to
`docs/runs/status-journal-to-2026-10-11.md`. Front matter: `stage` removed, `workflow_stage` added, `protocols_read_sha` below.

**Not done, and for which state.**
- `mountPreview` (2026-10-12, done by this session): the echo was redrawn by hand from the gallery (`Art/echo-source.png`: the miner with her pickaxe and the dog, 260x260, commit `c8b040d`), `Art/Preview.config.json` points to it (`echo.file`, 260x260), Preview regenerated (`Mod/About/Preview.png` 896x504, 543 KB, opened at full size and at 268 px: the echo is a green line drawing in the accent colour, right of the summary (the first render hid it: `"mode": "luminance"` in the echo block masked the black strokes away, removed 2026-10-12; echo block now panelWidth 27, panelTop 40)), `Art/Gallery/0-preview.png` is its byte copy, `echo_review_sha` and `social_preview_sha256` recorded, GitHub social preview uploaded and checked (`og:image` file has the same sha256). `echo.png` and its renamed copy `echo-original.png` removed (identical to the committed one).
- `writeDocs`: the description is not yet a `## Steam description` block in `PUBLICATION.md` (it is `Mod/README.template.md`,
  accepted by `OPERATIONS.md` until the migration); `publication_changelog_review_sha` (Virginie's reading); the `## [1.0.0]` section
  of the CHANGELOG is dated 2026-09-29, `[Unreleased]` must come back until the dry-run (12.e); the owner marks the review per `x.y` line.
- Regression after deploy (not before): the English and French settings texts changed after `tested_on` (`cd1afb7`); the Pickle replay of the scenarios
  that show them runs after the commit, in small tickets (AUDIT.md, "Une modification de texte après validation"). The retrait chain
  (scenarios 19 and `removal-check`) is part of it.
- Still the CI/CD session's: migration from semantic-release to `publish-tag.yml`.


**Replayed today against the current protocols (AUDIT.md, section 16), on `e39d9ab`.**
- `declareDependencies`: `About.xml` read again: Harmony the only hard dependency (id, Workshop url, download url), `loadAfter` Harmony, Core and the five DLCs including Odyssey, `supportedVersions` 1.6, no `incompatibleWith`, no `LoadFolders.xml` (one version), no XML patch (only a `MainButtonDef`); Odyssey's trainings are resolved by name at runtime and degrade silently (pass 4 played it). Harmony is used by four patches in `Source/`. Unchanged since 2026-10-02.
- `auditSettings`: MOD_SETTINGS.md read; see "Settings audit" below.
- `localize`: `scripts/Make-FrenchReview.ps1 -ModRoot` (the shared script, replaces the local `Generate-FrenchReview.ps1`, deleted on the Audit session's ruling of 2026-10-11) regenerated `FRENCH_REVIEW.md` at `e39d9ab`: 35 rows, none flagged. French gender rule unchanged (no text agrees with a pawn).
- `writeTests`: `scripts/Run-Functional-Tests.ps1`: 25 tests, all passed (replayed). Shared `scripts/Check-Steps.ps1`: 20 features parse (62 scenario blocks), 75 patterns compile, none declared twice, 539 step lines each resolve to exactly one step (one dead pattern: `the camera looks at {string}`); Pickle assemblies taken from the WSL install with `-PickleAssemblies`. The local `Tests/Pickle/Check-Steps.ps1` and `Minify-Evidence.ps1` are deleted (shared copies, Audit ruling of 2026-10-11).
- Build: `dotnet build Source/FieldworkCompanions.csproj -c Release` 0 warnings, 0 errors. Not reproducible byte for byte any more: see ".build" below.
- Mod root: only `.git`, `.gitattributes`, `.github`, `.gitignore` start with a dot or underscore. `.build/` was removed (see below); `_tools/` does not exist (moved to `scripts/` on 2026-10-05).

**`.build` (closing pass 3).** `Source/Directory.Build.props` and `Tests/Pickle/Source/Directory.Build.props` no longer redirect `obj`/`bin`: they stay in `Source/obj`, `Source/bin` and `Tests/Pickle/Source/obj`, `bin` (gitignored, not `Mod/`); `scripts/Settings-Tests.ps1` scratch moved to `Source/obj/settings-tests`. **Cost:** the compiled DLL embeds its build path, so a rebuild gives other bytes (`1E90ED968143…` against the committed `99AEF88CEF37…`). The committed DLL was restored and stays the shipped one (sources unchanged since `cd1afb7`); the next rebuild is a `Mod/` commit and so reopens `code_review_sha`.

## Settings audit

Date 2026-10-11, revision `e39d9ab`. Inventory: 12 settings (4 work switches, training requirement, bond share, base chance, per-step chance, bond chance, radius, a mark switch) plus a reset; shortcut `FieldworkCompanions_Settings` MainButtonDef, hidden by default. Access: Mod options, then the hidden shortcut for RIMMSQOL, same values. Applies immediately, global (not per save). Automated: `Run-Functional-Tests.ps1` 25/25 (defaults and reset, normalization, effect of every switch combination, Scribe persistence from EN and FR hosts, older and out-of-range files, shortcut hidden and revealable). In game (Pickle, revision `cd1afb7`): settings page top, bottom and reset in both languages (01-05), persistence (03), shortcut and RIMMSQOL (04, 09-12, passes 3 and 5); evidence `Tests/Pickle/Evidence/2026-09-27-pass2-part1`, `-part2`, `2026-09-27-pass3-rimmsqol`, `2026-09-28-pass3-chain-3`. Result: `passed`. The full 2026-09-13 to 2026-09-23 detail is in `docs/runs/status-journal-to-2026-10-11.md`.

## Translation audit — 2026-09-30

On the peer session's notice: `TRANSLATIONS.md` gained a French gender-agreement rule and a
systematic-French-review requirement (both 2026-09-30), and `translation_fr` was reset to
`unchecked`. This audit redoes the French pass on revision `7d441a6` (after the two English corrections of 6193bc0); nothing in `Mod/` or
`Source/` changed, only the check and its record.

- **Where the French lives:** `Mod/Languages/French/Keyed/FieldworkCompanions.xml` (33 entries:
  the settings category title, 30 settings labels/tooltips/headers, the reset confirmation, and
  the numeric assist mote `+{0}`) and `Mod/Languages/French/DefInjected/MainButtonDef/FieldworkCompanions.xml`
  (2 entries: the hidden MainButtons shortcut's label and description). No grammar resource files
  exist; the mod issues no `GrammarRequest`.
- **Gender agreement:** read every French entry (see `FRENCH_REVIEW.md`) against the three-segment
  switch rule. After Virginie’s 2026-10-02 review (BondTip said "le colon" and was corrected, "maître" removed), none of the 35 texts agrees with a pawn — they describe the mechanic in the
  abstract ("le compagnon", "l'animal", "un compagnon entièrement dressé et lié") rather than a
  specific colonist or animal at runtime, and `Source/**/*.cs` passes no `Pawn` to any `.Translate()`
  call (`FieldworkCompanionsMod.cs`, `Runtime/Companions.cs`; grep confirms only numeric arguments:
  chance percentages, the assist count, the radius). No `{PAWN_gender ? ...}` switch is used or
  missing.
- **`FRENCH_REVIEW.md`** generated at the mod root by the new `scripts/Make-FrenchReview.ps1` (shared, protocols repository)
  (reads the shipped XML, one table per file, Original/English/French columns; Original repeats
  English since the mod is original, not ported). No row is flagged `?`. Not committed to `Mod/`,
  so Steam never receives it.
- Not this session's to set: `translation_fr` stays `partial`, with an `unverified: French review
  by Virginie` line in `remaining`. Only Virginie's own session marks it reviewed.


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

