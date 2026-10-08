# Publication

What the Workshop page needs and the rest of the repository does not hold. It serves twice: for the
first upload, and for whoever takes the mod over.

**Status: `prepublished` (reached 2026-09-29, audited 2026-10-02).** Workshop item `3806133311` was created as the
maintainer's early 0.1.0 publication, and its `PublishedFileId.txt` is committed and pushed. No Git tag or GitHub
Release exists yet: for a CI publish they are created after a successful upload. The gallery is settled: image 1 was retaken on 2026-10-07. The Workshop item itself has not been subscribed to and
validated through its installed copy; that belongs to `prepublished -> published`, not to this file.

**Publication mode: CI** (public mod). Dry-run of the exact commit, `publish` with the full 40-character SHA,
`steam-production` approved by the owner alone, tag and release created by the CI after the upload
(`Rimworld-Release-Admin/docs/OPERATIONS.md`). This mod is still on the semantic-release path in "documented mode"
(`release.yml`), which `docs/MIGRATION-TO-MANUAL.md` of the release repository plans to retire; the migration belongs to
the CI/CD session, not to this file.

**Description source.** Not yet the single-source standard of `PUBLISHING.md` (a ```` ```markdown ```` block under
`## Steam description` of this file). It is `Mod/README.template.md`, converted to BBCode for Steam and to the plain text
of `Mod/About/About.xml`'s `<description>` (`aboutFromDescription`, checked by every dry-run), which `OPERATIONS.md`
accepts for this mod until its migration. The description ends, in this order, with `If I go quiet`, `AI-generated`,
`Thanks`, the line pointing to ATTRIBUTION.md and the licence, and the source link.

## Gallery

The folder `Art/Gallery/` holds only the images to upload, numbered on one digit in the order of the page, and nothing else.
Every image weighs under 2 MB and the folder under 8 MB (about 1.9 MB). Steam shows the first one large under the
Preview, so `0-` is the byte-for-byte copy of `Mod/About/Preview.png` (written by `scripts/Render-Preview.cjs`, not by a
scenario; copy it again whenever the Preview is regenerated).

| File | What it shows | Why there |
|---|---|---|
| `Art/Gallery/0-preview.png` | The Preview: the miner, the dog and the pickaxe scene, with the ModIcon cut out and composited in the bottom-left corner, tilted | Matches the page's own header image; the icon corner is the mod's mark |
| `Art/Gallery/1-candidate-companion-at-work.png` | The staged photograph (see below): Nelim at the rock, Rex beside her, the `+80` mark, ore chunks, two stone chunks as decor, on a vein of jade | The only image that shows the mod *doing* something |
| `Art/Gallery/2-settings-page-top.png` | The top of the settings page (English): the intro, the four work toggles, the training requirement | Shows how much is adjustable (a menu: a screenshot, not staged) |
| `Art/Gallery/3-settings-page-bottom.png` | The bottom of the settings page: the sliders, the scroll bar | Proves the scroll fix reaches every control |
| `Art/Gallery/4-reset-confirmation.png` | The reset confirmation dialog over the settings page | The one destructive control; it asks first |

Images 2 to 4 were produced by `02-settings-page.feature` and `04-mainbuttons-shortcut.feature` (`@review`, revision
`cd1afb7`; evidence `Tests/Pickle/Evidence/2026-09-27-pass2-part1`, `-part2`, `2026-09-28-pass3-chain-3`) and confirmed
by the maintainer on 2026-09-29. A green capture scenario proves the journey ran, not that the image shows anything: every
image is opened and looked at before it is listed here.

**Image 1, the staged photograph** (`20-gallery-mark.feature`, rules of 2026-10-02 to 2026-10-06 in `PUBLISHING.md`: a set-up
photograph, one story, chosen subject, read before accepted, anomalies reported to Pickle Tools).
- **Story.** Mara, a round and cosy miner, took her husky Rex to work; the vein pays a little more than it should, and the
  camera catches Rex under the `+N`.
- **Cast, chosen not random.** Mara: female, `Fat` body, copper `Pigtails` (rgb 190, 90, 40), mustard `Apparel_Tuque`
  (230, 170, 40) over a teal `Apparel_BasicShirt` (30, 140, 150) and ochre `Apparel_Pants` (150, 100, 50). Rex: the husky.
  Two stone chunks (`ChunkGranite`, `ChunkLimestone`, instead of the flowers of the first tries) at the foot of the rock, placed relative to Mara and cleared afterwards.
- **Place.** The Sanctuary of Nelim, fixture `Nelims-tribe` (SanctuaryBacklot repository, `docs/GALERIE.md`; steps `Nelim's Sanctuary:` are the Backlot's, `Nelim's Pickle Tools:` PickleTools'), place `gravel-yard`, emptied of its
  furniture and of every animal before Rex arrives; no bamboo is cleared and no roof removed. Nelim is Virginie and is left
  alone: Mara is a guest colonist the scenario adds. Pass map: `Tests/Pickle/wsl-deps.sanctuary.map` (since 2026-10-08, the Backlot's minimum list plus three PickleTools; the run of 2026-10-07 used the old map and the old steps).
- **Frame.** `studio presentation mode` (no HUD), `I frame the animal "Rex" at zoom 5`, the game paused as soon as the mark
  floats and a few real seconds allowed to settle before the capture.
- **Tries (2026-10-06/07), nine runs.** Emerald-clearing (viridian carpet, HUD, horses); gravel-yard emptied; zoom 5; a blue patch
  and a stray animal (frame moved 10 cells east; `all animals are removed` before Rex); the `+N` hidden by Pickle Tools'
  presentation mode (fixed by them in `ea4f221` and `d962e54`) and then invisible because `Mote_Text` ages in real seconds
  (the step now sets `overrideTimeBeforeStartFadeout = 120`); too small to read (interface scale 200 percent). Accepted
  from run `11d1` (`Tests/Pickle/Evidence/2026-10-07-gallery-scout9`, revision `20aa7b5`): the file is that capture
  cropped to 1440x810 around the subjects and reduced to a 256-colour palette (1.0 MB). Opened and looked at: no HUD, no stray
  animal, `+80` readable, Rex facing the camera; the pale halo over the tuque is mining dust. The mark floats beside the
  rock, where it was made, not directly over Rex, who stepped after it.

## Dependencies and DLCs

**No DLC is required.** `supportedVersions` declares 1.6 only, and there is no `LoadFolders.xml` and
no `IfModActive` branch.

| Declared | packageId | Actually required |
|---|---|---|
| Harmony | `brrainz.harmony` | Yes: four `[HarmonyPatch]` classes, applied with `PatchAll()` |
| Odyssey | `Ludeon.RimWorld.Odyssey` | **No**, and deliberately only in `loadAfter`. The `Forage` and `Dig` trainings and the fishing gesture exist only with it; the mod looks the trainings up by name and silently (`GetNamedSilentFail`), and without them falls back on obedience alone |
| Royalty, Ideology, Biotech, Anomaly | `Ludeon.RimWorld.*` | No. `loadAfter` only, so the load order is stable when they are present |

No `incompatibleWith` is declared and none is known. The one integration named in the tests is RIMMSQOL, for the hidden
MainButtons shortcut: it is not read by the code and is not declared.

Checked against the sources on 2026-09-29 (still 1.6 only, no `LoadFolders.xml`, no `IfModActive` branch). The mod reads three
members of the game that are not public (`ResourceDef`, `ResourceAmount`, `Pawn_TrainingTracker.GetSteps`) under an access
waiver in `Source/AccessChecks.cs`; the milking and chance scenarios of the Pickle suite played green with it on 2026-09-27.

## Mature content checkboxes

**None of them.** The mod adds no content: no def, no texture beyond its icon and its preview, no character, no scene. Every
image it ships or lists in the gallery was opened: the preview and the mark-and-companion photograph show a miner and a dog,
the icon (also cut into the preview's corner) is a winking cartoon mascot in a hat with binoculars, and three captures are
the mod's own options dialog.

## Messages for the mods this one draws from

Steam comments take BBCode, and the link to the mod goes behind `[url=…]name[/url]`, never a bare URL. Under 1000
characters each; the voice and cadence are in `WORKSHOP_COMMENTS.md`, "Writing a comment". **Post them once the item is
public and its installed copy has been checked.**

Cross-check of `THANKS` against the comments (`PUBLISHING.md`):

| Thanked | Public page? | Comment |
|---|---|---|
| Andreas Pardeike, Harmony (2009463077) | Yes | **Nothing to post.** The register `WORKSHOP_COMMENTS.md` holds one main comment per recipient page; Harmony's is `posted` (2026-09-22) and its `Covers` column already names Fieldwork Companions |
| Disney Dreamlight Valley (the mechanic) | A game, not a Workshop item | `not_applicable`: nothing to comment on |
| Claude Code (Anthropic) | An external tool, no Workshop page | `not_applicable`: nothing to comment on |

## What the upload cannot take back

- Description. The in-game button sends it only when the item is created; later it changes by hand on the Steam page or by
  the CI (`update_description` of the workflow, in the dry-run and in the `publish`). Read it one last time first.
- `About/PublishedFileId.txt` is written into the mod folder by the upload. It is committed and pushed here; lost, the next
  upload creates a second item.
- Steam creates every item private and RimWorld never calls `SteamUGC.SetItemVisibility`. Going public is a manual step, after
  subscribing to the item and testing it for real.
- Tag and release. For a CI publish they follow a successful upload (the workflow creates `v<version>` on the exact SHA and the
  release with the `## [<version>]` section of `CHANGELOG.md`); nothing is tagged by hand. The early 0.1.0 publication predates
  both, so do not present it as a release candidate.
- The gallery never goes by the CI: it is uploaded by hand on the Steam page, in the order above.

## Steam change notes

Written at upload time, in the Change Notes tab, and easy to forget because nothing asks for them until the form is already
open. Unlike the description, these go out again on every update and can be corrected freely. BBCode works. **The first line
carries the version alone** (`[h3]1.0.0[/h3]`), or the page does not show which version the note is about.

### 1.0.0

```
[h3]1.0.0[/h3]

An animal that follows its master at work now earns its keep.

[b]Added[/b]
[list]
[*]An animal whose master is a colonist, set to follow that master while doing field work, gives a chance of extra yield when it is at hand. The vanilla toggle already made it follow; it never bore on the work.
[*]Mining, harvesting and foraging, fishing, milking and shearing, each switchable on its own.
[*]The chance rises with the matching training (Dig for mining, Forage for harvesting, three steps each, added by Odyssey) and again when the animal is bonded to that colonist. Working together can tie the bond.
[*]A mark over the animal that found the extra.
[*]A settings page in Mod options, with a reset. Changes apply at once to every save. Stored values outside the sliders' ranges are corrected when loaded.
[*]A hidden MainButtons shortcut to the same page, invisible on a clean install, for RIMMSQOL and its kind to reveal.
[*]English and French.
[/list]

Nothing is added to the save: the mod can be added to or removed from a game in progress.
```
