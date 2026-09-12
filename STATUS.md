---
mod:        Fieldwork Companions
packageId:  nelim.fieldworkcompanions
repo:       Rimworld-Fieldwork-Companions
visibility: public
detached:   yes
stage:      done
licence:    original
licence_at: an original creation, MIT with no reservation. Nothing is reused from another mod - no code, no def, no texture, no sound - and the LICENSE is a bare MIT with no scope section, so the showcase images fall under it too. The mechanic comes from Disney Dreamlight Valley, credited in ATTRIBUTION.md and reused from none of its lines: no asset, no name, no character, and none could be.
showcase:   complete
tested_on:
workshop:
remaining:
  - unverified: never seen running, and nothing here cuts that unknown down, this mod having no
    out-of-game suite at all. The fifteen scenarios of `_tools/FUNCTIONAL-SCENARIOS.md` are
    unplayed, starting with the zeroth: until it passes, the other fourteen prove nothing.
  - feature: no out-of-game test suite, though all four hooks are public methods of
    Assembly-CSharp and the fault found on 2026-09-12 was exactly the kind such a suite catches.
    It took a note left by Contented Livestock to think of looking; a suite here would have said
    it on its own.
session:    local_0080fea9-b65b-4cd4-9e3e-06491ff4de8c
updated:    2026-09-12, the mod's own session
---

# Fieldwork Companions — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The fields above were read off the disk on 2026-09-12, then taken over by the session that holds
this mod. The three the sweep could not fill:

- **`stage`** — `done`, prefilled and confirmed. The mod is complete, detached, its showcase is
  made and its scenarios are written. What is missing is a run in a game, which `tested_on` and
  `remaining` both say, and which is not a build stage.
- **`tested_on`** — empty. Never launched, per the standing rule: the session prepares, she plays.
- **`remaining`** — two lines, both true on 2026-09-12.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` nothing reused.

## What this mod taught the repository, and what outlives it

- **The `GenerateAssemblyInfo=false` trap has taken a second mod, and it will take more.**
  Krafs.Publicizer applies `IgnoresAccessChecksTo` through the generated AssemblyInfo; switching
  that property off embeds the attribute's type and never applies it. Here the two members the
  milking patch reads, `ResourceDef` and `ResourceAmount`, are `protected abstract` in the real
  Assembly-CSharp — checked against the game's own file, not against the publicised reference — so
  milking and shearing threw `MethodAccessException` on the first pail, behind a startup that said
  nothing. Contented Livestock had it on fields, this one on properties: the common factor is not
  the kind of member, it is the switched-off property. **Every mod in the repository that switches
  off `GenerateAssemblyInfo` and publicises deserves the same check.** Fixed in
  `Source/AccessChecks.cs`.

- **Searching the built assembly's bytes for `IgnoresAccessChecksTo` returns a false positive.**
  The type name is in the file whether or not the attribute was applied — that is the shape of the
  trap. The check that counts is one line of reflection on the built assembly:
  `[Reflection.Assembly]::ReflectionOnlyLoadFrom(<dll>).GetCustomAttributesData()`, and the
  attribute is either in that list or it is not. No need to launch the game, or even to resolve
  the assembly's dependencies.
