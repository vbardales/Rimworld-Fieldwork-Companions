# Publication

What the Workshop page needs and the rest of the repository does not hold. It serves twice: for the
first upload, and for whoever takes the mod over.

**Status: partial, 2026-09-22.** Workshop item `3806133311` was created as the maintainer's early
0.1.0 publication, and its `PublishedFileId.txt` is committed and pushed. No Git tag or GitHub
Release exists. The screenshots still need a completed Pickle run and human review; the Workshop
item itself has not been subscribed to and validated through its installed copy.

## Screenshots, in this order

**Not settled.** No Workshop screenshot has been produced or looked at, so no order can be justified
yet. Steam shows the first one large under the Preview, so it must be the most demonstrative, not
the prettiest. Candidates, in the order I would try them once they exist:

| Order | What it should show | Why there |
|---|---|---|
| 1 | The `+N` mark floating over the companion just after the work turned up extra (scenario `06-assists`, the `@review` capture) | It is the only image that shows the mod *doing* something, and the mark lives about two seconds |
| 2 | The whole settings page on a clean configuration | It shows how much is adjustable |
| 3 | The settings page in French | Only if it adds something the English one does not |

**Blocker for image 2:** in the first WSL run (2026-09-21, English) the settings-page captures were
cut off after "Chance to bond per assist" and showed neither the "Show a mark" checkbox nor the
reset button, and no scrollbar. Whether the page cannot scroll or the capture step did nothing is
not established (see STATUS.md). An image of a page whose last controls cannot be reached must not
go on the Workshop page. Do not use a capture from a run that ended without a report.

Every image must be opened and looked at before it is listed here: a green capture scenario proves
the journey ran, not that the image shows anything.

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

Checked against the sources and the installed game on 2026-09-21, not against the intention: the
mod reads three members of the game that are not public (`ResourceDef`, `ResourceAmount`,
`Pawn_TrainingTracker.GetSteps`) under an access waiver in `Source/AccessChecks.cs`. What that costs
on RimWorld's Mono is not established; the milking and chance scenarios of the Pickle suite are
where it would show, and none has been played to the end.

## Mature content checkboxes

**None of them.** The mod adds no content: no def, no texture beyond its icon and its preview, no
character, no scene. The two images it ships were opened: the preview is a miner with a pickaxe and a
dog in a cave, and the icon is a winking cartoon mascot in a hat with binoculars. The Workshop
screenshots are not produced yet; each one must be opened before this answer is final.

## Messages for the mods this one draws from

Steam comments take BBCode, and a bare Workshop URL becomes a widget, hence the link alone on the
last line. Under 1000 characters each.

**Post them once the item is public.** A link to a private item opens for nobody and the widget does
not render. Replace `ITEM_ID` with the item's id.

The mechanic comes from Disney Dreamlight Valley, which is a game and not a Workshop mod, so it gets
no message. The only mod this one depends on is Harmony.

### Harmony, https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077

```
Hello Andreas! I just released Fieldwork Companions, a small mod where an animal that follows its master at work can turn up a little extra: ore, crops, a fish, some milk. It is four Harmony patches and nothing else, and it would not exist without Harmony.

Two of them have to remember something before the vanilla method runs, because the rock's position and yield are gone once it is destroyed. Passing that through __state made it a few lines instead of a tangle, and PatchAll did the rest.

Thank you for the library, and for keeping it working through every RimWorld update.

https://steamcommunity.com/sharedfiles/filedetails/?id=ITEM_ID
```

## What the upload cannot take back

- The description is sent only when the item is created. Afterwards it is a manual edit on the Steam
  page. Read it one last time before clicking. It ends, in this order, with `IF I GO QUIET`,
  `AI-GENERATED`, `THANKS`, the line pointing to ATTRIBUTION.md and the licence, and the source link.
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
