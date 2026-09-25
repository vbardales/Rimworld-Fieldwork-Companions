using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;
using Verse.AI;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// The rules of the mod that a scenario has to be able to break one at a time: whose animal helps,
    /// how far it may stand, what it does not help with (a deep drill, a cow milking itself, an animal
    /// mining on its own, an animal fishing), the fishing gesture itself, and the promise that a
    /// colony with no companion plays exactly as it would without the mod.
    ///
    /// These are the manual scenarios 2, 3, 5, 6, 7, 8, 9, 11, 12 and 14 of _tools/FUNCTIONAL-SCENARIOS.md
    /// written for a running game. They share the private helpers of <see cref="FieldworkSteps"/>, which
    /// is why this is the other half of one class.
    /// </summary>
    public partial class FieldworkSteps
    {
        /// <summary>
        /// Changes made to the game's shared definitions (a race's trainability, a biome's fish types) for one
        /// scenario. Definitions outlive the scenario in the same process, so each change registers its own undo and
        /// [AfterScenario] runs them, pass or fail.
        /// </summary>
        private static readonly List<Action> UndoAfterScenario = new List<Action>();

        [AfterScenario]
        public void UndoSharedDefinitionChanges(PickleContext ctx)
        {
            foreach (var undo in UndoAfterScenario) undo();
            UndoAfterScenario.Clear();
        }

        /// <summary>The cell a scenario fishes at, in the lake it built.</summary>
        private class FishingSpot { public IntVec3 Cell; }

        /// <summary>Why a bond did not form, kept for the assertion that reports it.</summary>
        private class BondTrace { public string Text; }
        /// <summary>What one call of the vanilla catch method handed back, copied at once.</summary>
        private class Catch { public List<Thing> Things = new List<Thing>(); }

        // ------------------------------------------------------------ whose animal, and how far

        [Given("Fieldwork Companions: {string} stops following at work")]
        public void StopsFollowing(PickleContext ctx, string animalName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            ctx.Require(animal.playerSettings != null, $"{animalName} has no player settings");
            animal.playerSettings.followFieldwork = false;
        }

        [Given("Fieldwork Companions: {string} stands {int} cells from {string}")]
        public void StandsCellsFrom(PickleContext ctx, string animalName, int distance, string colonistName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var worker = Driver.PawnNamed(ctx, colonistName);
            var map = worker.Map;
            var origin = worker.Position;

            var candidates = GenRadial.RadialCellsAround(origin, distance + 2f, false)
                .Where(c => c.InBounds(map) && c.Standable(map) && c.GetEdifice(map) == null
                            && c.DistanceToSquared(origin) >= distance * distance
                            && c.DistanceToSquared(origin) <= (distance + 1) * (distance + 1))
                .ToList();
            ctx.Require(candidates.Count > 0,
                $"no free cell {distance} cells from {colonistName} at {origin}: the map around it is full");

            if (animal.Spawned) animal.DeSpawn();
            GenSpawn.Spawn(animal, candidates[0], map);
            ctx.Assert(animal.Position.DistanceToSquared(origin) >= distance * distance,
                $"{animalName} stands at {animal.Position}, closer than {distance} cells to {colonistName} at {origin}");
        }

        // ------------------------------------------------------------ what it does not help with

        /// <summary>
        /// A deep drill spawns its yield itself and never goes through <c>Mineable.DestroyMined</c>. The portion is
        /// produced by the drill's own private method, the one a working drill calls when its progress is full.
        /// </summary>
        [Given("Fieldwork Companions: a deep drill over a steel deposit stands next to {string}")]
        public void DeepDrillNextTo(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var map = pawn.Map;
            var cell = CellNear(ctx, pawn, 6);

            var drill = (ThingWithComps)GenSpawn.Spawn(ThingMaker.MakeThing(Def(ctx, "DeepDrill")), cell, map, Rot4.North, WipeMode.Vanish);
            map.deepResourceGrid.SetAt(cell, Def(ctx, "Steel"), 500);
            ctx.Require(drill.GetComp<CompDeepDrill>() != null, "the deep drill carries no CompDeepDrill");
            ctx.Set(new Target { Thing = drill, Cell = cell });
        }

        [When("Fieldwork Companions: the deep drill next to {string} produces a portion")]
        public void DrillProduces(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var drill = ctx.Get<Target>().Thing as ThingWithComps;
            ctx.Require(drill != null && drill.Spawned, "no deep drill is standing: use 'a deep drill ... stands next to' first");
            drill.GetComp<CompDeepDrill>().TryProducePortion(1f, pawn);
        }

        /// <summary>
        /// Since Odyssey an animal trained to dig mines on its own, and <c>Mineable.DestroyMined</c> gets it in
        /// the same parameter as a colonist. The animal is passed as the worker here.
        /// </summary>
        [When("Fieldwork Companions: the animal {string} brings down the rock next to them")]
        public void AnimalBringsDownRock(PickleContext ctx, string animalName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var rock = ctx.Get<Target>().Thing as Mineable;
            ctx.Require(rock != null && rock.Spawned, "no rock is standing: use 'a rock stands next to' first");
            rock.DestroyMined(animal);
        }

        /// <summary>
        /// <c>PlantDestructionMode</c> cannot tell a harvest from a cut: its four values are Smash, Flame, Chop and Cut,
        /// and a harvest comes through as Cut like any other. The mod reads the current job instead, so the cut is
        /// really ordered (the <c>CutPlant</c> job) before the plant is collected with the same mode a harvest uses.
        /// </summary>
        [When("Fieldwork Companions: {string} cuts the plant next to them")]
        public void CutPlant(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var plant = ctx.Get<Target>().Thing as Plant;
            ctx.Require(plant != null && plant.Spawned, "no plant is standing: use 'a ripe ... stands next to' first");

            pawn.jobs.StartJob(JobMaker.MakeJob(JobDefOf.CutPlant, plant), JobCondition.InterruptForced);
            ctx.Require(pawn.CurJob?.def == JobDefOf.CutPlant, $"{colonistName} did not take the cut job: it is doing {pawn.CurJob?.def?.defName ?? "nothing"}");
            plant.PlantCollected(pawn, PlantDestructionMode.Cut);
        }
        // ------------------------------------------------------------ shearing, and a cow that milks itself

        [Given("Fieldwork Companions: a sheep {string}, full of wool, stands next to {string}")]
        public void SheepNextTo(PickleContext ctx, string sheepName, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var sheep = SpawnPlayerAnimal(ctx, "Sheep", sheepName, pawn, 3, biologicalAge: 3f);

            var wool = sheep.TryGetComp<CompShearable>();
            ctx.Require(wool != null, "the sheep has no CompShearable");
            ctx.Require(wool.Active, $"the sheep is not shearable yet: age {sheep.ageTracker.AgeBiologicalYears}");
            wool.fullness = 1f;
            ctx.Set(new Target { Thing = sheep, Cell = sheep.Position });
        }

        [When("Fieldwork Companions: {string} shears the sheep next to them")]
        public void Shear(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var sheep = ctx.Get<Target>().Thing as Pawn;
            ctx.Require(sheep != null && sheep.Spawned, "no sheep is standing: use 'a sheep, full of wool, stands next to' first");
            var wool = sheep.TryGetComp<CompShearable>();
            GatherUntilYielded(ctx, pawn, wool, wool.Props.woolDef);
        }

        /// <summary>
        /// No vanilla animal that gives milk or wool can learn obedience: <c>HasLearned</c> answers false when the
        /// race's trainability is below the training's required one, and cows are <c>None</c> (the first run of this
        /// suite, 2026-09-23, tried to grant the state by hand and it did not read). The exclusion of the animal being
        /// milked is still one line of the mod, and a modded animal that is both trainable and milkable is exactly what
        /// it guards against, so the cow's race is made trainable for this scenario only, and the animal goes through
        /// the real path: obedience learned, master, follow box. What it proves is that the animal being milked is
        /// never its own helper, the one gesture where the subject of the work is itself a candidate.
        /// </summary>
        [Given("Fieldwork Companions: {string} is a milk cow of {string}, its race made trainable for this scenario, following at work")]
        public void CowThatCountsAsCompanion(PickleContext ctx, string cowName, string masterName)
        {
            var master = Driver.PawnNamed(ctx, masterName);
            var cow = SpawnPlayerAnimal(ctx, "Cow", cowName, master, 3, Gender.Female, 3f);

            ctx.Require(cow.playerSettings != null && cow.training != null, $"{cowName} was not generated as a player's animal");

            var race = cow.RaceProps;
            var vanillaTrainability = race.trainability;
            race.trainability = TrainabilityDefOf.Advanced;
            UndoAfterScenario.Add(() => race.trainability = vanillaTrainability);

            cow.training.Train(TrainableDefOf.Obedience, master, complete: true);
            cow.playerSettings.Master = master;
            cow.playerSettings.followFieldwork = true;
            ctx.Require(cow.training.HasLearned(TrainableDefOf.Obedience), $"{cowName} does not read as obedient although its race was made trainable");
            ctx.Require(cow.playerSettings.Master == master, $"{cowName} did not take {masterName} as its master");

            var milk = cow.TryGetComp<CompMilkable>();
            ctx.Require(milk != null && milk.Active, "the cow is not milkable");
            milk.fullness = 1f;
            ctx.Set(new Target { Thing = cow, Cell = cow.Position });
        }

        // ------------------------------------------------------------ the bond

        /// <summary>
        /// The mod ties no relation of its own: each successful assist calls the game's
        /// <c>RelationsUtility.TryDevelopBondRelation</c> with the configured chance. At the largest chance
        /// (5 per cent) a few hundred assists are enough on average; the loop stops at the first bond.
        /// </summary>
        [When("Fieldwork Companions: {string} mines beside {string} until they bond, at most {int} times")]
        public void MinesUntilBond(PickleContext ctx, string colonistName, string animalName, int maxTimes)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var animal = Driver.PawnNamed(ctx, animalName);
            ctx.Require(!Companions.IsBonded(worker, animal), $"{animalName} is already bonded to {colonistName}");

            var tries = 0;
            var rolled = 0;
            while (tries < maxTimes && !Companions.IsBonded(worker, animal))
            {
                tries++;
                if (Companions.TryAssist(worker, AssistKind.Mining) != null) rolled++;
            }

            // The first run of this suite (2026-09-23) saw no bond in 3000 tries. A bond that never forms has two
            // possible causes, and the trace tells them apart: the mod never reached the game's call (rolled is
            // far below tries), or the game's own call refused every time (its preconditions are listed).
            if (!Companions.IsBonded(worker, animal))
            {
                var willing = new HistoryEvent(HistoryEventDefOf.Bonded,
                    worker.Named(HistoryEventArgsNames.Doer), animal.Named(HistoryEventArgsNames.Victim)).DoerWillingToDo();
                ctx.Set(new BondTrace
                {
                    Text = $"{rolled} of {tries} calls found a helper and reached the game's bond call at a chance of "
                           + $"{FieldworkCompanionsMod.Settings.bondChance}; the game's own preconditions: animal {animal.IsAnimal}, "
                           + $"trainability {TrainableUtility.GetTrainability(animal)?.defName ?? "none"}, "
                           + $"colonist psychopath {worker.story.traits.HasTrait(TraitDefOf.Psychopath)}, "
                           + $"bond factor {worker.GetStatValue(StatDefOf.BondAnimalChanceFactor)}, "
                           + $"animal bonded elsewhere {animal.relations.GetFirstDirectRelationPawn(PawnRelationDefOf.Bond, x => x.Spawned) != null}, "
                           + $"colonist willing to bond {willing}"
                });
            }
        }

        /// <summary>
        /// The game's bond call refuses when the colonist's ideology is unwilling to bond (a precept of the shared
        /// test colony, seen on 2026-09-23: 3000 calls reached vanilla, 3000 refusals). Ideologies are the
        /// world's, so the colonist is given the first one that accepts this bond. Without Ideology nothing
        /// forbids it and nothing is changed.
        /// </summary>
        [Given("Fieldwork Companions: {string} may bond with {string}")]
        public void MayBondWith(PickleContext ctx, string colonistName, string animalName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var animal = Driver.PawnNamed(ctx, animalName);
            if (worker.Ideo == null) return;

            Func<bool> willing = () => new HistoryEvent(HistoryEventDefOf.Bonded,
                worker.Named(HistoryEventArgsNames.Doer), animal.Named(HistoryEventArgsNames.Victim)).DoerWillingToDo();
            if (!willing())
            {
                foreach (var ideo in Find.IdeoManager.IdeosListForReading)
                {
                    worker.ideo.SetIdeo(ideo);
                    if (willing()) break;
                }
            }
            ctx.Require(willing(), $"no ideology of this world lets {colonistName} bond with {animalName}");
        }

        [Then("Fieldwork Companions: {string} and {string} are bonded")]
        public void AreBonded(PickleContext ctx, string colonistName, string animalName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var animal = Driver.PawnNamed(ctx, animalName);
            BondTrace trace = null;
            try { trace = ctx.Get<BondTrace>(); } catch { }
            ctx.Assert(Companions.IsBonded(worker, animal),
                $"{animalName} is not bonded to {colonistName}: the bond never formed through the assists"
                + (trace != null ? ". " + trace.Text : ""));
        }

        [Then("Fieldwork Companions: {string} and {string} are not bonded")]
        public void AreNotBonded(PickleContext ctx, string colonistName, string animalName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var animal = Driver.PawnNamed(ctx, animalName);
            ctx.Assert(!Companions.IsBonded(worker, animal), $"{animalName} is bonded to {colonistName}, which nothing should have caused");
        }

        // ------------------------------------------------------------ fishing

        /// <summary>
        /// The shared test colony has no water body with fish, so the scenario makes one: a lake of 21 by 21 deep
        /// water cells, well above the 200 cells at which a water body always holds common fish. The map is a
        /// disposable fixture, and whatever stood on those cells is removed first.
        /// </summary>
        [Given("Fieldwork Companions: a lake lies near {string}")]
        public void LakeNear(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var map = pawn.Map;
            ctx.Require(ModsConfig.OdysseyActive, "fishing needs Odyssey: tag the scenario @requires:Odyssey");

            var center = new IntVec3(
                Mathf.Clamp(pawn.Position.x + 20, 12, map.Size.x - 13), 0,
                Mathf.Clamp(pawn.Position.z, 12, map.Size.z - 13));
            var rect = CellRect.CenteredOn(center, 10);
            ctx.Require(rect.InBounds(map), $"a lake around {center} does not fit in the map");

            foreach (var cell in rect)
            {
                foreach (var thing in cell.GetThingList(map).ToList())
                {
                    if (!(thing is Pawn)) thing.Destroy();
                }
                map.terrainGrid.SetTerrain(cell, TerrainDefOf.WaterDeep);
            }

            WaterBody body;
            if (!map.waterBodyTracker.TryGetWaterBodyAt(center, out body))
            {
                map.waterBodyTracker.ConstructBodies();
                map.waterBodyTracker.TryGetWaterBodyAt(center, out body);
            }
            ctx.Require(body != null, $"no water body exists at {center} after the terrain was set to deep water");

            // The shared test colony's biome has no freshwater fish to distribute (the first run, 2026-09-23: a lake of
            // 441 cells, "common fish 0, has fish False"). The fish types of another biome are borrowed for this
            // scenario, and the lake draws its fish again. A biome without any fish types would also make
            // GetCatchesFor dereference a null, which is why the borrowed list is put on the biome, not on the lake.
            // Whether a lake has fish at all is drawn once, by the size of the water body (SetFishTypes), so a first
            // draw that lands on "none" is not a biome without fish: the 2026-09-24 run read "common fish 0" on a
            // desert lake that had types to give. The draw is repeated, and the types of another biome are borrowed
            // only if the biome truly has none.
            for (var draw = 0; draw < 100 && !body.HasFish; draw++) body.SetFishTypes();
            if (!body.HasFish)
            {
                var biome = map.Biome;
                var donor = DefDatabase<BiomeDef>.AllDefsListForReading
                    .FirstOrDefault(b => b.fishTypes != null && !b.fishTypes.freshwater_Common.NullOrEmpty());
                ctx.Require(donor != null, "no biome of the game has freshwater fish to borrow");
                var ownFishTypes = biome.fishTypes;
                biome.fishTypes = donor.fishTypes;
                UndoAfterScenario.Add(() => biome.fishTypes = ownFishTypes);
                for (var draw = 0; draw < 100 && !body.HasFish; draw++) body.SetFishTypes();
            }
            ctx.Require(map.waterBodyTracker.AnyFishPopulationAt(center),
                $"the lake holds no fish: {DescribeLake(body, map, center)}");
            ctx.Set(new FishingSpot { Cell = center });
        }

        private static string DescribeLake(WaterBody body, Map map, IntVec3 cell) =>
            $"biome {map.Biome.defName} (fish types {(map.Biome.fishTypes == null ? "none" : "set")}), type {body.waterBodyType}, {body.Size} cells, population {map.waterBodyTracker.FishPopulationAt(cell)}, "
            + $"common fish {body.CommonFish.Count()}, has fish {body.HasFish}";

        [When("Fieldwork Companions: {string} fishes at the lake")]
        public void Fishes(PickleContext ctx, string colonistName) => FishOnce(ctx, Driver.PawnNamed(ctx, colonistName), false);

        [When("Fieldwork Companions: the animal {string} fishes at the lake")]
        public void AnimalFishes(PickleContext ctx, string animalName) => FishOnce(ctx, Driver.PawnNamed(ctx, animalName), true);

        /// <summary>
        /// Calls the vanilla method the mod's postfix hangs on, on a cell of the lake. A rare catch replaces the
        /// whole list, so it is drawn again: the assertions below are about an ordinary catch. The list the game
        /// hands back is a static one, cleared by the next call, hence the copy.
        /// </summary>
        private static void FishOnce(PickleContext ctx, Pawn pawn, bool animalFishing)
        {
            var spot = ctx.Get<FishingSpot>().Cell;
            for (var attempt = 0; attempt < 20; attempt++)
            {
                bool rare;
                var result = FishingUtility.GetCatchesFor(pawn, spot, animalFishing, out rare);
                if (result != null && result.Count > 0 && !rare)
                {
                    ctx.Set(new Catch { Things = new List<Thing>(result) });
                    return;
                }
            }
            ctx.Assert(false, $"twenty casts by {pawn.LabelShort} at {spot} landed no ordinary catch: "
                              + DescribeLake(Driver.Map(ctx).waterBodyTracker.WaterBodyAt(spot), Driver.Map(ctx), spot));
        }

        [Then("Fieldwork Companions: the catch holds one extra fish, a single unit of a kind that was landed")]
        public void CatchHasOneExtra(PickleContext ctx)
        {
            var things = ctx.Get<Catch>().Things;
            ctx.Assert(things.Count == 2,
                $"the catch holds {things.Count} entries ({Describe(things)}), expected the landed one plus exactly one extra");
            ctx.Assert(things[1].stackCount == 1, $"the extra fish is a stack of {things[1].stackCount}, expected a single unit");
            ctx.Assert(things[1].def == things[0].def,
                $"the extra fish is a {things[1].def.defName}, but the catch was a {things[0].def.defName}");
        }

        [Then("Fieldwork Companions: the catch holds nothing beyond what was landed")]
        public void CatchHasNoExtra(PickleContext ctx)
        {
            var things = ctx.Get<Catch>().Things;
            ctx.Assert(things.Count == 1, $"the catch holds {things.Count} entries ({Describe(things)}), expected only what was landed");
        }

        private static string Describe(List<Thing> things) =>
            string.Join(", ", things.Select(t => $"{t.stackCount} {t.def.defName}").ToArray());

        // ------------------------------------------------------------ nothing at all when nothing should

        [Then("Fieldwork Companions: no bonus mark floats anywhere")]
        public void NoMarkAnywhere(PickleContext ctx)
        {
            var marks = Driver.Map(ctx).dynamicDrawManager.DrawThings.OfType<MoteText>()
                .Where(m => m.text != null && m.text.StartsWith("+")).ToList();
            ctx.Assert(marks.Count == 0, $"{marks.Count} '+N' mark(s) float on the map ({string.Join(", ", marks.Select(m => m.text).ToArray())}) although no companion was at hand");
        }

        /// <summary>
        /// The plant patch runs on every harvest of the game, companion or not. It was written to draw nothing from
        /// the game's random generator for that reason: a colony with no companion must not play differently with the
        /// mod than without it. The generator is read three times from a fixed seed, then again after the patch's
        /// own prefix and postfix have run on a real harvest, and the two runs must agree.
        /// </summary>
        [Then("Fieldwork Companions: the plant patch draws nothing from the random generator for {string} when no companion is at hand")]
        public void PlantPatchDrawsNothing(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var plant = ctx.Get<Target>().Thing as Plant;
            ctx.Require(plant != null && plant.Spawned, "no plant is standing: use 'a ripe ... stands next to' first");

            pawn.jobs.StartJob(JobMaker.MakeJob(JobDefOf.Harvest, plant), JobCondition.InterruptForced);
            ctx.Require(pawn.CurJob?.def == JobDefOf.Harvest, $"{colonistName} did not take the harvest job");

            var patch = typeof(Companions).Assembly.GetType("FieldworkCompanions.Patch_Plant_PlantCollected", true);
            var prefix = Driver.Method(ctx, patch, "Prefix", Driver.StaticAny);
            var postfix = Driver.Method(ctx, patch, "Postfix", Driver.StaticAny);

            const int seed = 20260923;
            Rand.PushState(seed);
            var expected = new[] { Rand.Value, Rand.Value, Rand.Value };
            Rand.PopState();

            Rand.PushState(seed);
            var args = new object[] { plant, pawn, null };
            prefix.Invoke(null, args);
            postfix.Invoke(null, new[] { pawn, args[2] });
            var actual = new[] { Rand.Value, Rand.Value, Rand.Value };
            Rand.PopState();

            ctx.Assert(expected.SequenceEqual(actual),
                $"the patch disturbed the random generator: from seed {seed} it gives {string.Join(", ", expected.Select(v => v.ToString("R")).ToArray())} "
                + $"untouched but {string.Join(", ", actual.Select(v => v.ToString("R")).ToArray())} after the prefix and postfix");
        }

        // ------------------------------------------------------------ where the extra landed

        [Then("Fieldwork Companions: the map gained at least {int} of the noted resource within {int} cells of the target")]
        public void GainedNearTarget(PickleContext ctx, int amount, int radius)
        {
            var b = ctx.Get<Baseline>();
            var target = ctx.Get<Target>();
            var gained = CountNear(Driver.Map(ctx), b.Def, target.Cell, radius) - b.NearCount;
            ctx.Assert(gained >= amount,
                $"within {radius} cells of {target.Cell} the map gained {gained} {b.Def.defName}, expected at least {amount}: "
                + "the extra did not land at the worked cell");
        }
    }
}
