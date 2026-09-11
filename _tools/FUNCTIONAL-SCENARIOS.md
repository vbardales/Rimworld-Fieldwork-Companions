# Functional scenarios, to be played in game

The mod hangs four Harmony patches on four vanilla methods and rolls a die inside each. Nothing
about that can be answered by reading the code: it takes a map, an animal with a master, and a
colonist actually swinging a pickaxe. These are the scenarios that answer it, written so each one
has a single thing to watch and a single way of being wrong.

The mod has never been run in a game. Until scenario 0 passes, nothing below is worth playing.

## Setup for everything here

Development mode on. A small colony with a mountain to dig, a growing zone of rice, a river or a
coast if Odyssey is installed, one cow, one sheep, and two huskies — one trained, one not.

**Set the base chance to 100% in the mod options before starting, and the share to 100%.** Every
scenario below except 10 and 11 is about *whether* the bonus happens, not how often. At the
default 15% you would be reading a coin, not a mod. Put both back when you are done: the defaults
are 15% and 25%, and scenario 10 needs them back.

Leave the mark over the animal switched on. It is the only visible sign that a given piece of work
was assisted, and most scenarios are read from it.

**The bonus is not the colonist's yield.** Mining reads `mineableYield` off the rock def and
harvesting reads `harvestYield` off the plant def — the nominal figures, before the pawn's mining
or plant-yield stat, before quality, before anything. A tester who expects the bonus to scale with
a skilled miner will call that a bug. It is not: the stats are capped in vanilla, 1.25 for mining
and 1.5 for harvesting, and a multiplicative bonus would have been swallowed by the cap. The mod
adds an object instead.

---

## 0. It loads, and the patches take

**Do.** Start the game with the mod active. Load any save. Mine one block of ore by hand.

**Expect.** No red text at startup, and none at that first swing.

**Watch for in `Player.log`.** Four lines in particular, each meaning a different failure:

- `HarmonyException` or `Could not find method` at startup — one of the four targets has been
  renamed by a game update. `FishingUtility.GetCatchesFor` is the likeliest, being the youngest.
- `MissingMethodException` naming `ResourceDef` or `ResourceAmount` — the publiciser did not run
  on this build. Those two members are `protected abstract` and the milking patch needs them
  public; the `Publicize` item in the csproj is what makes that so.
- `NullReferenceException` inside `Patch_Plant_PlantCollected` — a modded plant with no
  `harvestedThingDef`. The prefix guards it, so a line here means the guard was lost.
- Anything naming `TrainableDef` at load — `Forage` and `Dig` are resolved by name and silently,
  so a missing Odyssey must produce no line at all. A line here is a regression.

**If it fails here, stop.** Everything below assumes the patches are live.

---

## 1. Obedience is the floor

**Do.** Give the untrained husky a master and tick "follow master while doing field work". Send
that master to mine, with the husky beside them. Mine ten blocks.

**Expect.** Nothing. No extra ore, no mark, ten times over.

**Then.** Train the husky to obedience and mine again.

**Expect.** Extra ore on every block, and the mark over the husky.

**Why it matters.** This is not a rule the mod invented. Vanilla already refuses to let an animal
respect a master without obedience (`Pawn_PlayerSettings.RespectsMaster`), and the follow branch of
the animal think tree is gated the same way. If the untrained husky helps, the obedience check in
`Companions.Qualifies` is not running.

## 2. It must be *this* colonist's animal, and the box must be ticked

**Do.** With the trained husky mastered to colonist A and following, send **colonist B** to mine
with the husky standing right there. Mine five blocks.

**Expect.** Nothing at all.

**Then.** Send colonist A. Extra ore, every block.

**Then.** Untick "follow master while doing field work" on the husky, leaving the master set, and
send colonist A again.

**Expect.** Nothing.

**Why it matters.** The whole mod hangs on that one checkbox. It is the thing the base game
exposes and then never lets bear on the work, and it is the only thing that separates a companion
from an animal that happens to be nearby.

## 3. The radius

**Do.** Colonist A mining, husky following, at the default radius of 8. Draft the husky's master
elsewhere — or simply mine a cell far from where the husky settles — so the two are clearly more
than eight cells apart. Mine five blocks.

**Expect.** Nothing while it is far, extra ore once it has caught up.

**Then.** Set the radius to 30 in the options and repeat at the same distance.

**Expect.** The bonus comes back without the husky moving.

**Why it matters.** Distance is measured from the **worker**, not from the rock. An animal standing
next to the ore but far from the miner does not count, which is the right reading of "at hand".

---

## 4. Mining, and where the ore lands

**Do.** Mine a vein of any ore with the trained obedient husky at hand.

**Expect.** The extra chunks appear **at the mined cell**, not under the animal, and the mark
appears over the animal. The amount is the rock's nominal yield times the share, rounded, never
less than one.

**Then.** Set the share to 5% and mine a steel vein.

**Expect.** Still one chunk, never zero. `BonusCount` floors at one: a companion that succeeds
always turns up something.

## 5. Harvesting is not cutting

**Do.** Harvest a ripe rice zone with the husky at hand.

**Expect.** Extra rice at each plant's cell, mark over the husky.

**Then.** Order the same colonist to **cut** plants — the Cut Plants order, or harvesting a tree
for wood — with the husky still there.

**Expect.** Nothing. No extra wood, no mark.

**Why it matters.** `PlantDestructionMode` does not tell a harvest from a cut: its four values are
Smash, Flame, Chop and Cut, and a harvest comes through as Cut like any other. The mod reads the
current job instead, `Harvest` or `HarvestDesignated`. If cutting a tree produces extra wood, that
job check is gone.

## 6. Deep drilling gives nothing

**Do.** Run a deep drill with the husky sitting beside the colonist operating it.

**Expect.** No bonus, ever, however long it runs.

**Why it matters.** The drill does not go through `Mineable.DestroyMined` — it spawns its yield
itself. This is a documented limit, not an oversight, and it is in the mod description: nobody
stands next to a drill in the sense the mod means.

## 7. An animal cannot be its own miner

**Requires Odyssey.** Train an animal to `Dig` and let it mine on its own, with another obedient
companion of the same master anywhere on the map.

**Expect.** No bonus from anything the animal digs, and no mark.

**Why it matters.** Since Odyssey a trained animal mines by itself, and `Mineable.DestroyMined`
receives it in the same parameter as a colonist. Without the humanlike guard in `HelperFor`, a
digging megasloth would qualify as the worker and a second animal would "assist" it. The guard is
one line and this scenario is the only thing that watches it.

## 8. Fishing

**Requires Odyssey.** Send a colonist to fish with the husky at hand.

**Expect.** One extra fish in the catch — exactly one, whatever the size of the haul, and of a
species drawn from what was actually caught. The mark reads 1.

**Then.** Let an **animal** fish on its own, with a companion nearby.

**Expect.** Nothing.

**Why it matters.** A fish is already the unit, so there is no share to compute here; and
`animalFishing` is the parameter that keeps a companion from assisting another animal.

## 9. Milking and shearing

**Do.** Milk the cow with the husky at hand. Then shear the sheep.

**Expect.** Extra milk beside the cow, extra wool beside the sheep, mark over the husky both
times.

**Then — the one that matters.** Give the **cow** a master, obedience and the follow box, and milk
the cow with no other animal anywhere near.

**Expect.** Nothing. The cow does not help milk itself.

**Why it matters.** The animal being gathered from is passed as `exclude` to the companion search.
It is the only one of the four gestures where the subject of the work is itself a candidate
companion, and the exclusion is what stops a herd from paying itself.

---

## 10. Training raises the chance, and the switch that ignores it

**Put the base chance back to 15% and the share back to 25% for this one.**

**Do.** Read the mod options page: the ceiling line under the three sliders should say 60% with
the defaults. Then mine thirty blocks with an obedient husky that has no `Dig` training, and thirty
more with one fully trained to `Dig`.

**Expect.** Roughly one block in six assisted in the first run, and far more in the second.
Thirty swings is a small sample; the point is that the second run is visibly better, not that it
hits a figure.

**Then.** Turn off "require the matching training" and mine with an obedient, untrained animal.

**Expect.** It assists now, at the base chance, with no step bonus.

**Without Odyssey** neither `Dig` nor `Forage` exists, so there is nothing to require: every
obedient animal helps at the base chance, and this scenario collapses into the base rate. That is
the intended degradation, not a failure.

## 11. The bond

**Do.** Read the tip on a bonded pair: the chance should be 15 points higher than the same animal
unbonded.

**Then.** Leave an unbonded obedient companion working alongside its master for a long while — the
bond chance is 0.5% per successful assist by default, so this is a hundreds-of-assists affair. Raise
it to 5% in the options to see it happen within a session.

**Expect.** The bond forms, announced by the game's own message, exactly as taming or training
would announce it.

**Why it matters.** The mod does not write its own relation: it calls
`RelationsUtility.TryDevelopBondRelation`, the same entry point vanilla uses. If the bond ever
appears without that message, something else is creating it.

## 12. The four switches

**Do.** Turn off mining alone. Mine, harvest, fish and milk.

**Expect.** Bonus on the last three, nothing on the first. Repeat for each switch.

---

## 13. It can be added and removed mid-game

**Do.** Save a colony with the mod active and companions at work. Remove the mod. Load the save.

**Expect.** The save loads with no missing-def warning and no red text. Nothing of this mod is
written to a save: `ExposeData` covers the settings file only, and the mod adds no def, no comp,
no hediff and no thing.

**Then.** Add it back and load again. The companions work at once, with no reload dance.

## 14. Nothing happens when nothing should

**Do.** Play an hour of ordinary colony life with the mod active and **no** animal mastered at all.

**Expect.** No mark anywhere, no stray items, and no measurable change to anything.

**Why it matters.** The plant prefix runs on every harvest of the game whether a companion is
present or not. It was written to draw nothing from the random generator for that reason — no
`YieldNow()`, no `GenMath.RoundRandom`. If a colony with no companions plays differently with the
mod than without it, that discipline has been broken somewhere, and the symptom will be a seed
that no longer reproduces.
