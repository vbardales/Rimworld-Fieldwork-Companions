# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it in game.

## [Unreleased]

### Fixed

- The settings page could not scroll: past a certain height, `Listing_Standard` silently opened a second column outside the visible area, so the "show a mark" checkbox and the reset button were drawn off-screen and unreachable. Confirmed in the real game before the fix; a later Pickle run drew the scroll bar with both controls reachable. The fix was committed after the 0.1.0 upload.
- The ModIcon now shows the whole artwork instead of a crop.

## [0.1.0] — 2026-09-22

Creation of the Workshop item: `About/PublishedFileId.txt`, item `3806133311`. First public build, RimWorld 1.6. The local `About.xml` still declares `modVersion` 1.0.0; the difference is accepted for this early publication and is left for the next update.

### Added

- An animal whose master is a colonist, set to follow that master while doing field work, now gives a chance of extra yield when it is at hand. The vanilla toggle already made the animal follow, wander nearby and defend; what it never did was bear on the work.
- Four kinds of work, each switchable on its own: mining by hand, harvesting and foraging, fishing, milking and shearing.
- The chance rises with the matching training — `Dig` for mining, `Forage` for harvesting, three steps each — and again when the animal is bonded to that colonist.
- Working side by side has a small chance of forming the bond, through the same call the game uses for taming and training.
- A mark over the companion that found the extra.
- A settings page in Mod options, in English and French, with a reset. Changes apply at once to every save; stored values outside the sliders' ranges, and non-finite ones, are corrected when loaded and before saving.
- An optional MainButtons shortcut to the same page, hidden by default, with French localization, for RIMMSQOL and its kind to reveal.
- The settings category title is localizable; deep-drill exclusion and the French harvesting, training and radius wording are clarified.
- The source-code link is formatted for the Workshop description; the repository carries text and binary attributes.
