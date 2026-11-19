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
workflow_stage: settings[1.0.0]
settings_audit: partial   # markScale audited 2026-11-19 (code and automated tests); in-game check owed at playTests, then passed
audit_revision: e39d9ab
licence:      original
license_spdx: MIT
licence_at:   Original implementation according to ATTRIBUTION.md; no third-party mod code or assets reused. Only the mechanic is inspired by Disney Dreamlight Valley. Root and distributed LICENSE grant MIT. Classification original describes provenance; MIT describes reuse permissions.
upstream_mod_remotes: N/A   # original mod (licence: original): no source mod ported, so no upstream repository to list. Distinct from `repo` (this mod's own repository) and `origin` (its git remote).
dependencies: declared
workshop_required_items: n/a, not released yet   # Harmony is the only hard dependency (steamWorkshopUrl 2009463077); item 3806133311 is a 0.1.0 prepublication, 1.0.0 not released (owner rule 2026-11-10); set by hand on the Steam page at the end of writeReleaseDocs or at publish
showcase:     complete
tested_on:    cd1afb7
code_review_sha: 980db5967464ec81059a1686db9fef81c26353da
echo_review_sha: 980db5967464ec81059a1686db9fef81c26353da
social_preview_sha256: 219233a643b3945e2aebabce4c4b4e89d31f24823fd5ce5010a2be469a44b249
workshop:      3806133311
maintainer:   Codex, current local repository task
updated:      2026-11-19
remaining:
  - unverified: markScale in game (settings audit 2026-11-19, automated tests green): slider drawn, greyed out while the mark is off, and dragged, mark drawn larger and centred at 1.25 to 4, value kept over a restart, label and tooltip not clipped in English and French; played at `playTests` with the settings-page captures (02, 05) and the gallery scenes 20, 22, 23 that set the scale to 4.
  - unverified: texts `MarkScale` and `MarkScaleTip` (EN and FR; tip extended 2026-11-19) and the regenerated `TRANSLATION_REVIEW.md` await the ChatGPT review and Virginie's reading (6.f, 6.g at `localize`).
  - unverified: further down (not replayed, stage-defining once reached): 8.m `code_review_sha` 980db596 and 8.l `tested_on` cd1afb7 stale against the v6b code (review of `code_review_sha..HEAD`, small Pickle tickets for the mark size setting); 6.f `TRANSLATION_REVIEW.md` stale (regenerate with `Make-TranslationReview.ps1`, new MoteDef and strings); 12.c `social_preview_sha256` stale (Preview.png regenerated 2026-11-08).
  - unverified: Ticket `fb21` (`gallery-1-v5`, scene 1 v5) passed, exit=0, 1/1 (run relayed 2026-11-15, evidence `Tests/Pickle/Inbox/gallery-1-v5`, read 2026-11-15). Capture: Nelim (bun, no tuque) side view facing right, the white and grey wolf front facing beside her, `+80` above both (a little left of the wolf), zoom 4, Jade item, torch, flowers column, campfire, berries and stone chunks in frame; no rock being mined visible. score-gallery 2026-11-15: image 2.5, adequacy 2.5, understanding 3, decoration 3.5 = REDO (capture deleted). 268 px thumb: pair readable, `+80` a speck (j weak). No mining gesture (Nelim stands, no rock adjacent), pair at centre not left third, right half of frame bare ground, smile not readable (side view). Next: recompose scene 1 (v6: closer zoom, Nelim at the rock, mark larger or lower, decor on the right), Check-ShotlistVsScenario, refile. No owner review before the whole gallery (GALLERY.md, one review at the end).
  - defect: replay-audit 2026-10-30, mod root against the closed list (`STYLE_RIMWORLD.md`, root folders of a mod): git tracks `docs/` (lowercase, the list says `Docs/`), `package.json` and `package-lock.json` (not on the list; used by `.github/scripts/sync-about-description.mjs`). Not renamed or removed here (CI): Audit to decide with Virginie. Not stage-defining before `mountPreview` (10.e).
  - note: kept gallery evidence (all pre-v6 captures, prune with Prune-Evidence once the gallery is done): `Tests/Pickle/Evidence/2026-10-17-gallery-20-retake`, `2026-10-17-gallery-22-fishing-1`, `2026-10-17-tuque-blue-green`, `2026-10-18-empty-fishing-zone` (sanctuary map stages cleanly), `hair-tuque-seed`. What they taught: the yellow dome of the old captures is `Apparel_Tuque` dyed (dropped from v4); Show Hair Under Stuff shows hair under the tuque only once its settings file is seeded (`Tests/Pickle/config/sanctuary/Mod_3255379190_ShowHairMod.xml`); the `+N` mote sits over the animal, not the colonist.
  - unverified: Subtitles in `PUBLICATION.md` (section Gallery subtitles, lines 2 and 3 reworded 2026-10-17) await owner review; scenario 22 still says "fishes at the lake" (shared step with 16-fishing), comment added in the feature.
  - validated: All four Pickle passes are green on revision `cd1afb7` (English, French, RIMMSQOL, without Odyssey), no `@wip` scenario remains, and every `@review` capture has been opened and looked at. See the 2026-09-29 section for the count per pass and the evidence folders.
  - validated: Scenario 13 of the functional list (mod added or removed in a game in progress) is played in both directions: `18-added-to-a-game-in-progress` (the shared fixture, written without the mod, loads with it, runs and saves again) and `19-save-for-removal` then `removal-check` (a game saved with the mod, holding nothing of it outside its mod list, loads, runs and saves again with the mod out of the mod list). Evidence Tests/Pickle/Evidence/2026-09-27-pass2-part3 (scenario 18, French run; English run deleted 2026-10-19) and 2026-09-25-retrait-3 (19 and removal-check).
  - validated: RIMMSQOL's own list offers the shortcut, reveals it, the bar draws it, it opens this mod's dialog and shares its values, hiding works, and the choice survives two restarts (09, 10, 11, 12, played as one launch each in a chain). Evidence Tests/Pickle/Evidence/2026-09-27-pass3-rimmsqol/seq1 and 2026-09-28-pass3-chain-3.
  - validated: Without Odyssey, `Dig` and `Forage` do not exist, the mod loads without error, and an obedient companion still helps at the base chance with the requirement ticked. The scenario that had no map to work on (the shared save needs Odyssey's Orbit layer) now starts a fresh colony instead of loading it. Evidence Tests/Pickle/Evidence/2026-09-28-pass4-newcolony.
  - note: Workshop item 3806133311 was published by the maintainer as 0.1.0 while the local metadata and draft notes use 1.0.0. The maintainer explicitly accepts that difference for this early publication; it is tracked for the next planned update, not treated as a current audit blocker.
  - validated: PublishedFileId `3806133311` is committed and pushed on `main` (e2ec8fc, followed by release-preparation commits).
  - validated: French review by Virginie, 2026-10-02: 12 corrections requested (Intro, WorkHeader, FishingTip, GatheringTip, RequireSpecialtyTip, BondTip, ShareTip, Radius, RadiusTip, BondChance, then Intro and FishingTip again), all applied; she declared the French validated linguistically at revision `342f69d` on her own statement in chat. The wording after that is the corrections listed here only (commit following 51bc7e5). Reread against the 2026-09-30 French gender-agreement rule (TRANSLATIONS.md section 3). No owned text agrees with a pawn: all 33 Keyed entries are settings labels, tooltips, the reset confirmation and the numeric assist mote (`+{0}`); the one DefInjected pair is the hidden MainButtons shortcut's label/description. None names or describes a specific colonist or animal, so no `{PAWN_gender ? ...}` switch applies or is missing. `FRENCH_REVIEW.md` regenerated (`scripts/Make-FrenchReview.ps1` (shared, protocols repository), reads the shipped XML) on revision `7d441a6` (after the two English corrections of 6193bc0).
protocols_read_sha: 3cf9191dbe17df42a65d1d2cf21fb9cf53b70ccb
---
# Fieldwork Companions — status

Task owns, maintains this STATUS.md as work progresses. File stays at repository root, outside distributed Mod/ folder.

## Settings audit

Date 2026-11-19, code revision `d48ced9` (HEAD `bfc154a`). Redo of 5.a to 5.g after the 13th setting `markScale` (the 2026-10-11 audit on `e39d9ab` covered 12). **Inventory (13):** 4 work switches (mining, harvest, fishing, gathering), training requirement, bond share, base chance, per-step chance, bond chance, radius, mark switch `showMote`, mark size `markScale` (slider 1 to 4 in steps of 0.25, default 1 = the game's own text size, owner validation 2026-11-15), plus reset; shortcut `FieldworkCompanions_Settings` MainButtonDef, hidden by default (`Check-SettingsContract` PASS 2026-11-19). **Usage review of `markScale`:** concrete use (a readable mark on small images, gallery criterion j); label "Size of the mark: x{0}" with the live value, tooltip says what 1 means; default 1 changes nothing for existing players; applies to each new mark at once (the scale is read when the mark is thrown, marks already on screen keep theirs); global, not per save; no data added to the save. Reset restores 1. Layout: last slider before the reset button inside the existing scroll view. **Finding (low), fixed 2026-11-19:** the slider stayed active when the mark switch `showMote` was off and the tooltip was silent. It is now greyed out (`GUI.enabled = settings.showMote`) and the tooltip ends with "Greyed out while the mark above is off." (EN) and "GrisÃ© tant que la marque ci-dessus est dÃ©sactivÃ©e." (FR); DLL rebuilt, both strings to review with the other new texts. **Automated (2026-11-19):** the former functional harness (`scripts/Run-Functional-Tests.ps1`, `Settings-Tests.ps1`, deleted in `8692433`) is replaced by `Tests/Rule-OwnValues.ps1` (12 rules, run by the generated `Tests/Test-Mod.ps1`: 6 of 6 passed, row in `scripts/LOCAL_SCRIPTS.md`). It holds: 13 defaults and Reset (field count pinned at 13); bounds of every numeric setting incl. `markScale` 1 to 4 (-99, 99, NaN, both infinities, idempotent); chance, radius boundary at every radius, 16 work-switch combinations, bonus share; real Scribe round trip from EN and FR hosts of all 13 values; older file without the key gives 1, out-of-range file bounded on load; IL links from each setting to its consumer (`AssistMark.Throw` reads `markScale`, `DrawGUIOverlay` gated on `scale`, `NoteAssist` throws the mark); the mote def and the hidden shortcut def; EN and FR Keyed parity; About identity; the four hooks through `Check-HarmonyContract` (hooks, grant, injected parameters). Mutation proof: a changed bound in `Source` and a missing French key are both reported. The compile probe of the non-public members (ResourceDef, ResourceAmount, GetSteps) is in it since Audit fixed the shared probe (1c2b755). Not in game: slider drawn, greyed out with the mark off, and dragged, mark really drawn larger and centred, persistence over a restart, label clipping in EN and FR (played at `playTests` by Pickle, with the settings-page captures). `settings_audit` stays `partial`. Earlier audit (2026-10-11, 12 settings, passes 1 to 5 of 2026-09) is kept below as history: Run-Functional-Tests 25/25, Pickle evidence `Tests/Pickle/Evidence/2026-09-27-pass2-part1`, `-part2`, `2026-09-27-pass3-rimmsqol`, `2026-09-28-pass3-chain-3`.

History. Date 2026-10-11, revision `e39d9ab`. Inventory: 12 settings (4 work switches, training requirement, bond share, base chance, per-step chance, bond chance, radius, mark switch) plus reset; shortcut `FieldworkCompanions_Settings` MainButtonDef, hidden by default. Access: Mod options, then hidden shortcut for RIMMSQOL, same values. Applies immediately, global (not per save). Automated: `Run-Functional-Tests.ps1` 25/25 (defaults and reset, normalization, effect of every switch combination, Scribe persistence from EN and FR hosts, older and out-of-range files, shortcut hidden and revealable). In game (Pickle, revision `cd1afb7`): settings page top, bottom, reset in both languages (01-05), persistence (03), shortcut and RIMMSQOL (04, 09-12, passes 3 and 5); evidence `Tests/Pickle/Evidence/2026-09-27-pass2-part1` (mechanics only, settings-page captures dropped 2026-10-19), `-part2`, `2026-09-27-pass3-rimmsqol`, `2026-09-28-pass3-chain-3`. Result: `passed`. Full 2026-09-13 to 2026-09-23 detail in `docs/runs/status-journal-to-2026-10-11.md`.

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


## Shotlist v4 (2026-11-08, write-shotlist after the refusal of capture c78e; supersedes v3 and v3.1, folded here)

Story (k): one day for Nelim (only colonist, protagonist) and the husky Yuki (NSB animal, Soren's bond; here she follows Nelim through the mod's own step), east side of the Sanctuary, from the jade vein to the rice. Each image leaves one more pile on the ground: Jade, then fish, then RawRice, so the dog's extra adds up in the picture. Hours 7, 12, 18, weather `Clear` by step. Looks (no validation needed, sheet of Nelim): high ponytail `Roo_HD_Hair_Highpony` all day, brows and eyes as the sheet, teal shirt (30, 140, 150), ochre trousers (150, 100, 50) all day, no headgear (the tuque of v3 is dropped: it read as a hard hat and hid the hair). Mouth override allowed by `GALLERY.md` (2026-10-25): neutral in 1 (effort, written), `MouthSmile` in 2 and 3. Yuki: fuchsia `Apparel_leatherdogcollar` (daily outfit, validated 2026-11-06), seen from the front in 1 only (South), West in 2, East in 3. "Chronic conditions cured" stays a run-only condition so she is not slowed (asthma, back): to confirm with Virginie with the Rex question. Chosen over Rex: Yuki, the NSB husky (no validation required).


| # | a Frame | b Decor | c Living | d Pawns | e Instant, how | f Composition | g Says | j Mod at 268 px |
|---|---|---|---|---|---|---|---|---|
| 1 dawn (20) | `bare-clearing` (195, 152), 7, Clear step, ~40 s of job at ultrafast | lit `TorchLamp`, lit `Campfire` with a `Stool`, `Plant_TallGrass` and `Plant_Berry` groups, `ChunkGranite` rubble, second intact `MineableJade`, fresh Jade stack south of Yuki | Yuki FRONT (South, looks at the Jade), grass | Nelim ponytail, teal, ochre, neutral mouth (effort, written) | one jade block just broke, `+N` just risen over Yuki, Nelim pickaxe lowered turning to the second rock; mine job, pause on the tick the mote spawns | zoom 5, Nelim left third, Yuki right of centre in front, fire lower left | "a little more jade than the pick earned" | `+N` over Yuki at zoom 5, 268 px check on the capture |
| 2 noon (22) | `right-bank` (144, 132, NSB cell), 12, Clear step, fishing to the first catch | `FishRack`, `FishGear`, lit `Campfire`, `Stool`, Jade stack from the dawn, `Plant_TallGrass` groups; the fish is whatever the fishing job drops (not a staged item, no defName to fix); NPT decor of the bank to recheck | Yuki at her feet, West (kept beside), water | Nelim ponytail, teal, ochre, `MouthSmile` | fish just landed, `+N` over Yuki, Nelim turns to her; fishing job, pause on the mark frame | zoom 4 tight, Nelim left third, water left, fire lower right | "one fish more than she caught" | `+N` at zoom 4, large |
| 3 evening (23) | `rice-paddy` (230, 122), 18, Clear step, harvest to the first plant | lit `TorchLamp`, second ripe `Plant_Rice`, kept sprouts, bamboo edge of the map, `Stool` with the day's Jade, `RawRice` stack (the fish has no defName to stage: dropped from the Stool) | Yuki East (heads to the next plant), rice | Nelim ponytail, teal, ochre, `MouthSmile` (relaxed) | second plant just cut, `RawRice` on the ground, `+N` over Yuki, Nelim steps to the next ripe plant; harvest job, pause on the mark frame | zoom 5, Nelim right of centre, Yuki left, bamboo behind, last light | "one grain more than expected" | `+N` at zoom 5 |




## NSB (sync-nsb-npt 2026-11-09; replaces any earlier section)

Changed in NSB since 2026-11-08 (read in the git log, diffs of `SANCTUAIRE-LIEUX.md` and `VALIDE.md` only): redecoration finished, every place validated (`right-bank` 2026-11-09 on photo z3, `left-bank`, `workshops`, `barn` on 2026-11-09, `gravel-yard` 2026-11-08); decor save `Nelims-tribe-decor-mods-z3.rws` copied to `Mod/Pickle/Fixtures`, no scenario repointed yet (`Nelims-tribe` stays the old undecorated Sanctuary, which our scenes decorate by step). Not adopted: z3 would give `right-bank` its NSB decor for scene 2; to decide at the 22 recompose. NPT since 2026-11-08: hold-in-hand steps, `the camera orthographic size is held at {float}` (could fix the zoom of a frame), light steps; none replaces a step used by 20, 22, 23.

Places, Tribe and Steps read: 2026-11-19 (NSB commits 2026-11-15 to 2026-11-18 touch only VALIDE.md, IORI-PROFIL.md, NEUTRES-TETE.md, TESTING.md, VTW-BODYTYPES.md and a new plan `RECONSTRUCTION-SAUVEGARDE.md` (rebuild of the Sanctuary save as `Nelims-tribe-v2`, nothing built, current fixture unchanged); no place, Nelim sheet, Yuki or animal entry moved; NPT steps 2026-11-15 to 2026-11-18: `face-parts.md` only, no step used by 20, 22, 23 changed). Rules said back: everything in NSB free, outside NSB needs validation, colonist properties need validation, outfits free, every included animal shown (the mod adds none). Older read logs deleted (git keeps them).

First sync of this mod (no earlier section). Rules said back (owner, 2026-11-05 and 2026-11-07): everything in NSB is free; a colonist or domestic animal outside NSB needs the owner's express validation (exception: an animal the mod adds or its items address); a colonist's properties change only with her express validation; every outfit is free; every animal the mod includes is in the gallery.

Found: scenarios 20, 22, 23 use two things outside NSB or off the roster, no quoted validation exists for either. Nothing is played with them until she answers. Default if she says nothing: Yuki (NSB husky, Soren's) and Nelim as her sheet.

| Place | Shots | Changes made for the gallery | Last read |
|---|---|---|---|
| `bare-clearing` (195, 152), free zone | 1 (20) | decor posed then removed (TorchLamp, Stool, Plant_Daylily, Jade item, jade rock); floor bared by NSB step | 2026-11-08 |
| `right-bank` (NSB cell now (144, 132), our shotlist says (144, 131)), refused by owner 2026-11-08 as too empty, NPT decorating it | 2 (22) | FishRack, FishGear, Jade item; place may change under us: recheck after NPT decor, update cell | 2026-11-08 |
| `rice-paddy` (230, 122), validated 2026-11-07, rice to replant | 3 (23) | second ripe `Plant_Rice`, TorchLamp; sprouts kept | 2026-11-08 |

| Colonist | Shots | Outfit per shot | Last read | Exceptions |
|---|---|---|---|---|
| Nelim | 1, 2, 3 | teal shirt, ochre trousers all day (continuity, free outfit), mustard tuque in 1 only (stone dust) | 2026-11-08 | PENDING, properties changed by the scenarios: hairstyle "Flowy" (sheet: `Roo_HD_Hair_Highpony`, `Roo_Royal_LongHD` under headgear), brows `BrowSquare` (sheet `BrowNormal`), mouth `MouthNormal` in 1 and `MouthSmile` in 2 (sheet `MouthLipsSmirk`), cured of chronic conditions (sheet: asthma, bad back). No quoted validation. Without it: sheet looks, tuque with `Roo_Royal_LongHD`, bare-headed with `Roo_HD_Hair_Highpony`; the mouth reasons in the shotlist (effort, smile) are dropped. |

| Animal | Shots | Outfit | Last read | Exceptions |
|---|---|---|---|---|
| Rex (husky) | 1, 2, 3 | none | not in NSB | outside NSB, PENDING: not a mod animal (the mod adds none), no item addresses it. Alternative: Yuki (NSB husky, Soren's bond, daily outfit leather collar fuchsia `#D1008F`, validated 2026-11-06). |
| Yuki (husky) | none yet | alternative, as above | `VALIDE.md` row 2026-11-08 | none |

| Animal the mod includes | Shots | |
|---|---|---|
| none: the mod adds no animal (`Mod/Defs` holds only `MainButtonDef`); any animal is the companion of the mechanic | n/a | no row MISSING |

## Ecosystem (PiI, refreshed 2026-11-19, `docs/inventory/ecosystem-steam/FieldworkCompanions.md`, protocols commit d312513; first study 2026-11-14)

- Duplicates and replacements: none (36 Workshop searches, 8 new on 2026-11-19): no mod gives a companion animal a share of mined, harvested, fished, milked or sheared yield.
- Look-alikes (animals working alone, no bonus to the master): Animals at Work Herding and Plowing (3766198296, 3766198499, 1.6 1.7), Animals Forage Continued (3667046888, 1.2 to 1.7), Hunt for Me (1593245720); Follow Target (3555423377) only escorts. Linked rows of the report (8, no parent): also Animals Can Forage (3347265326, 1.5), Allies are Helpful (3534920369), More Like a Pet (3621380595).
- Patches and retextures: none. Translations of an original: n/a (original mod). Links: none to add.
- Odyssey Dig and Forage are vanilla content; no mod touches their yield.
- Verdict: niche free. Pickle checks owed at the next full pass: our share against the vanilla forage or dig output of a trained animal that also follows; Animals at Work animals that leave the master.

## Shotlist v5 (2026-11-14, write-shotlist after the refusal of capture e95c; changes v4 in zoom and composition only, story, places, hours, outfits, Yuki and decor kinds unchanged)

Cause of the refusal (read 2026-11-14): the mark spawns at the animal and rises about 2 cells before the picture freezes (the step already freezes on the first frame the mark exists); Yuki stood beside Nelim with a green rock and piles between her and the mark, frame wide and empty. Director's pass (Opus, one call). **Kept:** camera centred on the pair, column above Yuki clear of rocks and piles, decor dense within 5 cells, no bare patch, series variety medium / wide / tight (rhythm close, open, closest), same outfit and collar in all three. **Not kept:** exact cells and facing of Nelim and a raised pickaxe (the mining job walks her, she is not placeable at the freeze), Nelim holding the fish (no step, unverified), fish on the Stool (the fish has no defName to stage), zoom 3 for scene 1 and zoom 2 for scene 3 (zoom 2 never tried, 268 px check unknown).

| # | Zoom | Frame | Change vs v4 |
|---|---|---|---|
| 1 dawn (20) | 4 (was 5), medium opening | camera 1 cell right of Nelim (was 3), pair in the left third | second `MineableJade` 4 cells left (was 3); added `ChunkGranite` 2 right 1 below and 6 right 1 below (5 left 2 above was on an occupied cell outside the cleared area, ticket 5169), `Plant_Berry` 1 left 4 below (3 left 3 below was the Campfire cell, ticket 99d9), `Plant_TallGrass` 1 right 3 below; nothing in the cells above Yuki |
| 2 noon (22) | 5 (was 4), wide | unchanged | water as the wide background |
| 3 evening (23) | 3 (was 5), tight | unchanged | closest shot, `+N` read at 268 px to check on the capture |

Old capture of scene 1 deleted (`Tests/Pickle/Evidence/gallery-1-v4`, not tracked). Features 20, 22, 23 edited. Unverified: zoom 3 of scene 3 frames Nelim, Yuki and the rice; where Yuki stands at the freeze (beside Nelim, west cell by `SceneBeside`, within 2 cells by `KeepBeside`).

Plan score v5 (score-gallery 2026-11-14, no capture yet: rating the plan; read: this section, features 20, 22, 23 headers and steps, GALLERY.md criteria, `GalleryMiningSteps.cs` mark and placement steps): scene 1 = 5, scene 2 = 5, scene 3 = 5; k ok (one day, one pile per image, medium 4 / wide 5 / close 3, opening and closing, rhythm close-open-closest). Mean 5. Not verified: zoom 3 frames Nelim, Yuki and the rice (scene 3); where Yuki stands at the freeze (west cell, within 2 cells); the 268 px read of `+N` at zoom 4 and 3 (check on the captures); defNames `Plant_TallGrass`, `Plant_Berry`, `ChunkGranite`, `RawRice` (vanilla, not checked in game files). Verdicts after the runs: none yet.

- Ticket `20261115-111402-903-fb21` (scene 1 v5, `20-gallery-mark`, tree `0ffe3b4`, evidence `Tests/Pickle/Inbox/gallery-1-v5`) queued 2026-11-15. Earlier reds: `5169` (ChunkGranite on an occupied cell outside the cleared area), `99d9` (Plant_Berry on the Campfire cell), both fixed. Keep Mod, Source, Tests on `0ffe3b4` until `RUN_DONE`. On green: open the capture (Yuki beside Nelim, `+N` over her with a clear column, 268 px check), score-gallery, then file 22 and 23 one by one.

## Shotlist v6, scene 1 only (2026-11-15, rewrite-shotlist after the REDO of capture fb21, score 2.5; scenes 2 and 3 unchanged from v5)

Director's pass (Opus, one call). **Kept:** zoom 3, decor filling the right half, column above Yuki free, Yuki front view with the fuchsia collar. **Changed:** hour 6 (was 7: warm low light reads as dawn against noon and evening), Nelim 2 cells left of the camera (was 1), Campfire 6 right 3 below and Stool 7 right 4 below (moved from the left), second `MineableJade` 3 left 1 above (was 4 left 1 above). **Not kept:** interface scale 250 percent (buys about 1 px, breaks UI layout: stays 200). **Not done yet, needs a new step:** freeze later (let the job reach rock 2 with progress above 0 so mining and the mark share one frame), select Nelim before the pause (inspect pane "Mining jade" proves the action). **Ceiling:** the `+N` mote is fixed in screen pixels (GameFont.Small via `MoteMaker.ThrowText`), about 3 px at 268 px wide at any zoom or scale: criterion j rests on the pair and the Jade pile. Real fix is in the mod (larger mark), an owner decision.

Plan score v6 (score-gallery 2026-11-15, rating the plan): scene 1 = 4.5 (j weak, malus assumed, mark size cannot be written away), scenes 2 and 3 = 5 as v5 (their j is also the small `+N`, same limit); k ok. `Check-ShotlistVsScenario.ps1` passes. No ticket filed: waits for the owner's decision on the mark.

**v6b (2026-11-15, same day).** Owner validation quoted (chat, 2026-11-15): "oui, ajoute le réglage de taille de la marque". Mod change: new setting `markScale` (slider 1 to 4, default 1 = unchanged for players; `Source/FieldworkCompanionsSettings.cs`, `FieldworkCompanionsMod.cs`), new mote class `AssistMark` (`Source/Runtime/AssistMark.cs`, scales the game's text mote around its screen point) and def `FieldworkCompanions_AssistMark` (`Mod/Defs/MoteDefs`), EN and FR strings, own step `draws the mark at {float} times its size`. Scenes 20, 22, 23 draw the mark at 4 times its size and set Nelim's hairstyle to the sheet's `Roo_HD_Hair_Highpony` (the v5 capture showed a bun, forbidden by `NELIM-PROFIL.md`). Build 0 errors; `Check-Steps` and `Check-ShotlistVsScenario` pass. Plan score v6b: scene 1 = 5 (j ok on paper: mark about 11 px at 268 px, to check on the capture), 2 and 3 = 5. Unverified: the scaled text renders and stays centred in game (never run), the settings page row. Still PENDING owner: mouth override (`MouthNormal` in 1, `MouthSmile` in 2 and 3, sheet says `MouthLipsSmirk`) and the cure of Nelim's chronic conditions: without an answer the sheet applies, but the scenarios still carry both overrides (to remove or validate before the ticket counts).
