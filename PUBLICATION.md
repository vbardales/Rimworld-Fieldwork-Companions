# Publication

What the Workshop page needs and the rest of the repository does not hold. It serves twice: for the
first upload, and for whoever takes the mod over.

**Status: `prepublished`, audited 2026-10-02 (reached 2026-09-29).** Workshop item `3806133311` was created as the maintainer's early
0.1.0 publication, and its `PublishedFileId.txt` is committed and pushed. No Git tag or GitHub
Release exists yet — for a CI publish they are created after a successful upload, not before. The
gallery below is settled and every image has been opened, looked at and confirmed by the maintainer.
The Workshop item itself has not been subscribed to and validated through its installed copy; that
belongs to `prepublished -> published`, not to this file.

## Screenshots, in this order

**Settled, 2026-09-29.** Steam shows the first one large under the Preview, so it carries the same
picture as the header image rather than something a viewer has not seen yet — Workshop convention,
and it means the mark-and-companion scene (the mod actually *doing* something) still lands as the
second thing seen, right where a browsing eye goes next.

| File | What it shows | Why there |
|---|---|---|
| `Art/Gallery/0-preview.png` | The same image as `Mod/About/Preview.png`: the miner, the dog and the pickaxe scene, with the ModIcon cut out and composited in a bottom corner, tilted, running past the frame | Matches the page's own Preview thumbnail; the icon corner is the mod's own mark of identity, so the first screenshot doubles as a signature, not a surprise |
| `Art/Gallery/1-companion-at-work.png` | A real mining job: the colonist working the rock, the dog right beside them, a readable `+N` mark over the dog, ore chunks on the ground | The only image that shows the mod *doing* something |
| `Art/Gallery/2-settings-page-top.png` | The top of the settings page (English): the intro text, the four work toggles, the training requirement | Shows how much is adjustable |
| `Art/Gallery/3-settings-page-bottom.png` | The bottom of the settings page: the chance and yield sliders, the scroll bar visible | Proves the scroll fix (STATUS.md, 2026-09-22) reaches every control |
| `Art/Gallery/4-reset-confirmation.png` | The reset confirmation dialog over the settings page | The one destructive control on the page; worth showing it asks first |

Produced by `20-gallery-mark.feature` (0-1) and `02-settings-page.feature`/`04-mainbuttons-shortcut.feature`
(2-4), all `@review`, on revision `cd1afb7`; evidence in `Tests/Pickle/Evidence/2026-09-27-pass2-part1`,
`-part2` and `2026-09-28-pass3-chain-3`. Every image was opened and looked at before being listed here: a
green capture scenario proves the journey ran, not that the image shows anything.

## Dependencies and DLCs

**No DLC is required.** `supportedVersions` declares 1.6 only, and there is no `LoadFolders.xml` and
no `IfModActive` branch.

| Declared | packageId | Actually required |
|---|---|---|
| Harmony | `brrainz.harmony` | Yes: four `[HarmonyPatch]` classes, applied with `PatchAll()` |
| Odyssey | `Ludeon.RimWorld.Odyssey` | **No**, and deliberately only in `loadAfter`. The `Forage` and `Dig` trainings and the fishing gesture exist only with it; the mod looks the trainings up by name and silently (`GetNamedSilentFail`), and without them falls back on obedience alone |
| Royalty, Ideology, Biotech, Anomaly | `Ludeon.RimWorld.*` | No. `loadAfter` only, so the load order is stable when they are present |

No `incompatibleWith` is declared and none is known. The one integration named in the tests is
RIMMSQOL, for the hidden MainButtons shortcut: it is not read by the code and is not declared.

Checked against the sources on 2026-09-29 (still 1.6 only, no `LoadFolders.xml`, no `IfModActive`
branch), and against the installed game on 2026-09-21, not against the intention: the
mod reads three members of the game that are not public (`ResourceDef`, `ResourceAmount`,
`Pawn_TrainingTracker.GetSteps`) under an access waiver in `Source/AccessChecks.cs`. What that costs
on RimWorld's Mono is not established; the milking and chance scenarios of the Pickle suite are
where it would show, and none has been played to the end.

## Mature content checkboxes

**None of them.** The mod adds no content: no def, no texture beyond its icon and its preview, no
character, no scene. Every image it ships or lists in the gallery above was opened: the preview and
the mark-and-companion screenshot are a miner with a pickaxe and a dog in a cave, the icon (also cut
into the preview's corner) is a winking cartoon mascot in a hat with binoculars, and the three
settings captures are the mod's own options dialog.

## Messages for the mods this one draws from

Steam comments take BBCode, and a bare Workshop URL becomes a widget, hence the link alone on the
last line. Under 1000 characters each.

**Post them once the item is public and its installed copy has been checked.** A link to a private
item opens for nobody and the widget does not render.

The mechanic comes from Disney Dreamlight Valley, which is a game and not a Workshop mod, so it gets
no message. The only mod this one depends on is Harmony.

### Harmony (2009463077): nothing to post

`WORKSHOP_COMMENTS.md` is the register, keyed by the recipient's Workshop id, and it holds one main comment per
recipient page for the whole collection. Harmony's is already `posted` (2026-09-22, covering Architect Studio, Skill
Icons, Work Studio, PickleTools and Bill Autopilot), so this mod is added to its `Covers` column and **no second
comment is sent**. The draft that stood here was removed on 2026-09-25 for that reason. The one line of `Covers`
to add is `Fieldwork Companions`; the register is edited by the session that owns it or with the owner's word.

## What the upload cannot take back

- The description is sent only when the item is created. Afterwards it is a manual edit on the Steam
  page. Read it one last time before clicking. It ends, in this order, with `If I go quiet`,
  `AI-generated`, `Thanks`, the line pointing to ATTRIBUTION.md and the licence, and the source link
  — the exact plain text of `Mod/About/About.xml`'s `<description>`, generated from
  `Mod/README.template.md` (`aboutFromDescription`, checked by every dry-run).
- `About/PublishedFileId.txt` is written into the mod folder by the upload. Commit it at once: lost,
  the next upload creates a second item.
- Steam creates every item private and RimWorld never calls `SteamUGC.SetItemVisibility`. Going
  public is a manual step, after subscribing to the item and testing it for real.
- The version tag and the GitHub release must be created before the next update: an item newer than
  its repository can no longer be reproduced. The early 0.1.0 publication predates both, so do not
  represent it as a release candidate until a tag, release and matching notes exist.

## Steam change notes

Written at upload time, in the Change Notes tab, and easy to forget because nothing asks for them
until the form is already open. Unlike the description, these go out again on every update and can be
corrected freely. BBCode works.

### 1.0.0

```
[h3]1.0.0 — first release[/h3]

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

## Gallery staging plan (rule of 2026-10-02, not yet played)

Only `Art/Gallery/1-companion-at-work.png` is a staged photograph. `0-` is the Preview and `2-` to `4-` are menus
and windows: screenshots of what they are, not staged.

**Story of the series (one image).** Early morning at the foot of a ridge. Mara, a miner, has her husky Rex with her:
Rex has followed her up the slope every day since she took him in. Today the vein pays a little more than it should,
and the first thing the camera catches is Rex, tail up, over the fresh chunks.

**The shot.**
- Subject: Mara, an adult woman of a body type chosen by the owner (`body type is` step; never a random silhouette),
  dark copper hair so that she stands out against the grey rock and the husky's pale coat, a teal work shirt and
  ochre trousers (teal against the rock's brown, and the husky is neutral), no tattoo (nothing to say), named
  "Mara", not "Miner".
- Companion: Rex, the husky, at her side, so that the `+N` mark reads above him.
- Decor, placed then removed with StageDecor: a lantern on a post beside the vein, two or three plants at the foot of the
  rock, a stack of steel ore. Nothing else in the frame: no filth, no other pawn, no tooltip.
- Camera: centered on Mara and Rex, as close as the game allows, so the three of them fill the frame.
- Sequence: place the decor, photograph, remove the decor.

**Steps missing**, asked of the Pickle Tools session through the Ticket Manager on 2026-10-02: a colonist wears a
chosen garment (then the existing dye step colours it), and a camera centered on a named pawn at a given zoom.
`20-gallery-mark.feature` keeps the plain version until they exist; the staged version replaces it and the
capture is retaken and opened before `Art/Gallery/1-companion-at-work.png` changes.

**Choices made 2026-10-02 (owner: "pick the cute, fun, fan ones").** Mara is a round, cosy `Fat` miner with
`Pigtails` in copper (rgb 190, 90, 40), a mustard `Apparel_Tuque` (230, 170, 40) over a teal `Apparel_BasicShirt`
(30, 140, 150) and `Apparel_Pants`, as a girl who took her dog to work. Rex is the husky. Decor: a lit `TorchLamp`
beside the vein, `Plant_Daylily` and `Plant_Dandelion` at the foot of the rock. Steps (delivered by the Pickle
Tools session, written and compiled but not yet played): `wears`, `dyed rgb`, `the camera is centered on`; companions
`nelim.pickletools.colonistrace`, `nelim.pickletools.camerazoom`, `nelim.pickletools.stagedecor`. The decor cells
depend on where the scenario puts the rock and the animal, so a first scouting run reads them, then the decor is fixed
and replayed.

**Rewritten 2026-10-05 after the Pickle Tools gallery rules** (`PickleTools/docs/GALERIE.md`, not yet committed there).
The scouting run of 2026-10-03 (`20261003-000034-402-a407`) left no report and is dropped. The scene moves to the
fixture `Nelims-tribe` (Sanctuary, 250x250, not installed yet: nothing is submitted until Pickle Tools says "fixture
ready"): load it with `the save "Nelims-tribe" is loaded`, frame with `I am at the sanctuary "<place>"` after looking
at every place (`docs/SANCTUAIRE-LIEUX.md`), light a dark place with `TorchLamp` and `... is lit`, never remove a roof.
The only colonist of the fixture is Nelim: Mara is dropped and the dressing steps (`wears`, `dyed rgb`, new
`gender is`) apply to Nelim, or to a colonist the fixture allows. The pass map is modelled on
`wsl-deps.sanctuary.map` plus `nelim.pickletools.colonistrace`.
