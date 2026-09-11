# Attribution

No third-party code is reused in this mod: everything here is written from scratch.

The mechanic comes from **Disney Dreamlight Valley** (Gameloft), where taking a villager along
whose assigned role matches your activity gives a chance of extra resources — a base rate, plus a
step per friendship level. Only that mechanic was borrowed, from published descriptions of how the
game behaves. **No asset, texture, name, character or line of that game is used here, and none
could be**: it is licensed Disney material.

The transposition is entirely RimWorld's own vocabulary. The friendship level is replaced by the
training steps the game already tracks (`Forage` and `Dig`, added by Odyssey, three steps each) and
by the `Bond` relation. The trigger is the vanilla master-and-follow toggle
(`Pawn_PlayerSettings.master` plus `followFieldwork`), which the base game exposes and then leaves
without any effect.

The mod depends on Harmony (brrainz.harmony, MIT) and RimWorld 1.6. Odyssey is optional.

**Licence:** MIT (`LICENSE`).
