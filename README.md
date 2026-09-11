# Fieldwork Companions

An animal that follows its master at work finally earns its keep. RimWorld 1.6.

## The idea

RimWorld already lets you give an animal a master and tick **“follow master while doing field
work”** — `Pawn_PlayerSettings.master` plus `followFieldwork`, in the Animals tab. The animal
then walks along while your colonist mines, harvests, forages or fishes.

The toggle works — it feeds `ThinkNode_ConditionalShouldFollowMaster`, whose branch holds
`JobGiver_AIFollowMaster`, `JobGiver_WanderNearMaster` and `JobGiver_AIDefendMaster`. The animal
follows, wanders nearby, and defends.

What it never does is bear on **the work**. The animal keeps a miner company for hours and the ore
never knows. This mod hangs something on that: when the companion is at hand, the work turns up a
little more than it should.

## What the mod does

Four gestures, each switchable on its own:

| Work | Hook | Bonus |
| --- | --- | --- |
| Mining, by hand | `Mineable.DestroyMined` | a share of `mineableYield` |
| Harvesting and foraging | `Plant.PlantCollected` | a share of `harvestYield` |
| Fishing | `FishingUtility.GetCatchesFor` | exactly one more fish |
| Milking and shearing | `CompHasGatherableBodyResource.Gathered` | a share of `ResourceAmount` |

A mark appears over the animal that found the extra.

### The chance

| Criterion | Default |
| --- | --- |
| Obedient companion present | 15 % |
| Per step of the matching training | +10 % |
| Bonded to that colonist | +15 % |

`Forage` and `Dig` — the two trainings Odyssey added — have three steps each, so a fully trained,
bonded companion helps **60 %** of the time and turns up **a quarter** of the usual yield when it
does. Every number is a slider.

### The rules that keep it honest

- **Obedience is the floor**, and that is not a rule of this mod: without it, the game itself has
  the animal ignore its master (`Pawn_PlayerSettings.RespectsMaster`).
- **The training has to match the work.** Mining asks for `Dig`, harvesting for `Forage`. Fishing,
  milking and shearing have no training of their own, so obedience is enough there. One option
  drops the requirement everywhere.
- **Only a colonist is helped.** Since Odyssey an animal can mine on its own, and
  `Mineable.DestroyMined` does not tell the two apart — without the humanlike check, a
  `Dig`-trained megasloth would qualify as its own miner.
- **Deep drills are untouched**: nobody stands next to them.
- **Cutting a plant down is not harvesting**, and the job def is what says so —
  `PlantDestructionMode` cannot, since its four values are Smash, Flame, Chop and Cut.
- **An animal fishing on its own is never assisted**, and the animal being milked never counts as
  its own helper.

## Requirements

Harmony. Odyssey is optional: without it the `Forage` and `Dig` trainings do not exist, they are
resolved silently by name, and the mod falls back to obedience alone.

## Save compatibility

Nothing is written to the save. The mod can be added to or removed from a game in progress.

## Where it comes from

The mechanic is Disney Dreamlight Valley's: take a villager along whose role matches what you are
doing, and the gathering has a chance of yielding extra — a base rate plus a step per friendship
level. Only the mechanic was borrowed. The transposition replaces the friendship level with what
RimWorld already measures: training steps, and the bond.

## Licence

MIT (`LICENSE`). See `ATTRIBUTION.md`.
