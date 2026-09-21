using System.Linq;
using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;
using Verse.AI;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// The gameplay half: a colonist, an animal that follows it at work, and the real vanilla method
    /// each of the mod's patches hangs on, called inside a running game.
    ///
    /// Why the vanilla methods are called directly rather than through a job: what only a live game
    /// can show is that the patch fires there, on the runtime the game really uses, and that the
    /// mod's reads of three non-public members of the game succeed in that runtime. The walk to the
    /// rock and the hours of swinging a pickaxe add nothing to that and a great deal of waiting.
    /// The gesture is therefore triggered at the exact call the job driver ends with
    /// (<c>Mineable.DestroyMined</c>, <c>Plant.PlantCollected</c>, <c>CompHasGatherableBodyResource.Gathered</c>).
    ///
    /// Fishing is left out on purpose: it needs a water body with fish in the fixture, which the
    /// shared test colony does not have. TESTING.md says so.
    /// </summary>
    [PickleSteps]
    public class FieldworkSteps
    {
        /// <summary>The thing a scenario is about to work on.</summary>
        private class Target { public Thing Thing; }

        /// <summary>What the map held of a resource before the gesture.</summary>
        private class Baseline { public ThingDef Def; public int Count; }

        private static int CountOf(Map map, ThingDef def) =>
            map.listerThings.ThingsOfDef(def).Sum(t => t.stackCount);

        private static ThingDef Def(PickleContext ctx, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");
            return def;
        }

        /// <summary>A free, standable cell a few steps from the pawn.</summary>
        private static IntVec3 CellNear(PickleContext ctx, Pawn pawn, int radius)
        {
            var map = pawn.Map;
            IntVec3 cell;
            bool found = CellFinder.TryFindRandomCellNear(pawn.Position, map, radius,
                c => c != pawn.Position && c.Standable(map) && c.GetEdifice(map) == null
                     && c.GetFirstItem(map) == null && c.GetPlant(map) == null,
                out cell);
            ctx.Require(found, $"no free cell within {radius} of {pawn.LabelShort} at {pawn.Position}");
            return cell;
        }

        // ------------------------------------------------------------ companions

        [Given("Fieldwork Companions: {string} is an obedient {string} that follows {string} at work")]
        public void ObedientCompanion(PickleContext ctx, string name, string kind, string master) =>
            MakeCompanion(ctx, name, kind, master, obedient: true);

        [Given("Fieldwork Companions: {string} is a {string} that follows {string} at work but has not learned obedience")]
        public void DisobedientCompanion(PickleContext ctx, string name, string kind, string master) =>
            MakeCompanion(ctx, name, kind, master, obedient: false);

        private static void MakeCompanion(PickleContext ctx, string name, string kind, string masterName, bool obedient)
        {
            var master = Driver.PawnNamed(ctx, masterName);
            var kindDef = DefDatabase<PawnKindDef>.GetNamedSilentFail(kind);
            ctx.Require(kindDef != null, $"no PawnKindDef named '{kind}'");

            var animal = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                kindDef, Faction.OfPlayer, forceGenerateNewPawn: true));
            animal.Name = new NameSingle(name);
            GenSpawn.Spawn(animal, CellNear(ctx, master, 3), master.Map);

            ctx.Require(animal.playerSettings != null && animal.training != null,
                $"{name} has no player settings or training tracker: it was not generated as a player's animal");

            // Both fields the vanilla "follow master while doing field work" checkbox sets.
            animal.playerSettings.Master = master;
            animal.playerSettings.followFieldwork = true;

            if (obedient) animal.training.Train(TrainableDefOf.Obedience, master, complete: true);

            ctx.Require(animal.training.HasLearned(TrainableDefOf.Obedience) == obedient,
                $"{name} {(obedient ? "did not learn" : "already knows")} obedience");
            ctx.Require(animal.playerSettings.Master == master, $"{name} did not take {masterName} as its master");
        }

        [Given("Fieldwork Companions: {string} has learned the {string} training")]
        public void LearnedTraining(PickleContext ctx, string name, string trainable)
        {
            var animal = Driver.PawnNamed(ctx, name);
            var def = DefDatabase<TrainableDef>.GetNamedSilentFail(trainable);
            ctx.Require(def != null, $"no TrainableDef named '{trainable}': it comes from Odyssey, tag the scenario @requires:Odyssey");
            animal.training.Train(def, animal.playerSettings.Master, complete: true);
            ctx.Require(animal.training.HasLearned(def), $"{name} did not learn {trainable}");
        }

        [Given("Fieldwork Companions: {string} is bonded to {string}")]
        public void Bonded(PickleContext ctx, string animalName, string colonistName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var colonist = Driver.PawnNamed(ctx, colonistName);
            colonist.relations.AddDirectRelation(PawnRelationDefOf.Bond, animal);
            ctx.Require(Companions.IsBonded(colonist, animal), $"{animalName} is not bonded to {colonistName} after adding the relation");
        }

        // ------------------------------------------------------------ what the mod computes, in the live game

        /// <summary>
        /// Reaches the chance through the mod's own public calculation. It reads the per-step part
        /// through a game member that is internal in the real Assembly-CSharp, so an answer here
        /// means that read works in this runtime.
        /// </summary>
        [Then("Fieldwork Companions: the chance of {string} helping {string} with {word} is {int} percent")]
        public void AssertChance(PickleContext ctx, string animalName, string colonistName, string kind, int percent)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var colonist = Driver.PawnNamed(ctx, colonistName);
            AssistKind assist;
            ctx.Require(System.Enum.TryParse(kind, out assist), $"'{kind}' is not Mining, Harvest, Fishing or Gathering");

            var chance = Companions.ChanceFor(colonist, animal, assist);
            ctx.Assert(Mathf.RoundToInt(chance * 100f) == percent,
                $"the chance of {animalName} helping {colonistName} with {kind} is {Mathf.RoundToInt(chance * 100f)} percent, expected {percent}");
        }

        // ------------------------------------------------------------ the work

        [Given("Fieldwork Companions: a {string} rock stands next to {string}")]
        public void RockNextTo(PickleContext ctx, string rockDefName, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var def = Def(ctx, rockDefName);
            ctx.Require(def.building?.mineableThing != null, $"'{rockDefName}' is not a mineable rock");

            var rock = GenSpawn.Spawn(ThingMaker.MakeThing(def), CellNear(ctx, pawn, 4), pawn.Map);
            ctx.Set(new Target { Thing = rock });
        }

        [Given("Fieldwork Companions: a ripe {string} stands next to {string}")]
        public void RipePlantNextTo(PickleContext ctx, string plantDefName, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var def = Def(ctx, plantDefName);
            ctx.Require(def.plant?.harvestedThingDef != null, $"'{plantDefName}' is not a harvestable plant");

            var plant = (Plant)ThingMaker.MakeThing(def);
            plant.Growth = 1f;
            GenSpawn.Spawn(plant, CellNear(ctx, pawn, 4), pawn.Map);
            ctx.Set(new Target { Thing = plant });
        }

        [Given("Fieldwork Companions: a cow {string}, full of milk, stands next to {string}")]
        public void MilkCowNextTo(PickleContext ctx, string cowName, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail("Cow");
            ctx.Require(kind != null, "no PawnKindDef named 'Cow'");

            var cow = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                kind, Faction.OfPlayer, forceGenerateNewPawn: true, fixedGender: Gender.Female, fixedBiologicalAge: 3f));
            cow.Name = new NameSingle(cowName);
            GenSpawn.Spawn(cow, CellNear(ctx, pawn, 3), pawn.Map);

            var milk = cow.TryGetComp<CompMilkable>();
            ctx.Require(milk != null, "the cow has no CompMilkable");
            ctx.Require(milk.Active, $"the cow is not milkable yet: gender {cow.gender}, age {cow.ageTracker.AgeBiologicalYears}");
            milk.fullness = 1f;
            ctx.Set(new Target { Thing = cow });
        }

        /// <summary>For the capture: the mark lives about two seconds, so the camera is put where the
        /// companion is before the gesture, not after.</summary>
        [When("Fieldwork Companions: the camera looks at {string}")]
        public void LookAt(PickleContext ctx, string name)
        {
            Find.CameraDriver.JumpToCurrentMapLoc(Driver.PawnNamed(ctx, name).Position);
        }

        [When("Fieldwork Companions notes what the map holds of {string}")]
        public void NoteBaseline(PickleContext ctx, string defName)
        {
            var def = Def(ctx, defName);
            ctx.Set(new Baseline { Def = def, Count = CountOf(Driver.Map(ctx), def) });
        }

        [When("Fieldwork Companions: {string} brings down the rock next to them")]
        public void BringDownRock(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var rock = ctx.Get<Target>().Thing as Mineable;
            ctx.Require(rock != null && rock.Spawned, "no rock is standing: use 'a rock stands next to' first");
            rock.DestroyMined(pawn);
        }

        /// <summary>
        /// The harvest patch reads the pawn's current job, because only the job def tells a harvest
        /// from a cut, so the job is really started; the vanilla driver's own last call is then made
        /// by hand. The base yield is dropped by the driver, not by <c>PlantCollected</c>, so only
        /// the companion's bonus appears on the map.
        /// </summary>
        [When("Fieldwork Companions: {string} harvests the plant next to them")]
        public void HarvestPlant(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var plant = ctx.Get<Target>().Thing as Plant;
            ctx.Require(plant != null && plant.Spawned, "no plant is standing: use 'a ripe plant stands next to' first");

            pawn.jobs.StartJob(JobMaker.MakeJob(JobDefOf.Harvest, plant), JobCondition.InterruptForced);
            ctx.Require(pawn.CurJob?.def == JobDefOf.Harvest, $"{colonistName} did not take the harvest job: it is doing {pawn.CurJob?.def?.defName ?? "nothing"}");
            plant.PlantCollected(pawn, PlantDestructionMode.Cut);
        }

        [When("Fieldwork Companions: {string} milks the cow next to them")]
        public void MilkCow(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            var cow = ctx.Get<Target>().Thing as Pawn;
            ctx.Require(cow != null && cow.Spawned, "no cow is standing: use 'a cow, full of milk, stands next to' first");
            cow.TryGetComp<CompMilkable>().Gathered(pawn);
        }

        // ------------------------------------------------------------ what came of it

        /// <summary>
        /// The size of the yield is the evidence. At the largest share the bonus is twice the nominal
        /// yield, which is more than the plain gesture can produce, so a threshold between the two
        /// says whether the companion helped. The scenarios name the numbers from the vanilla defs.
        /// </summary>
        [Then("Fieldwork Companions: the map gained at least {int} of the noted resource")]
        public void GainedAtLeast(PickleContext ctx, int amount)
        {
            var b = ctx.Get<Baseline>();
            var gained = CountOf(Driver.Map(ctx), b.Def) - b.Count;
            ctx.Assert(gained >= amount,
                $"the map gained {gained} {b.Def.defName}, expected at least {amount}: the companion did not help");
        }

        [Then("Fieldwork Companions: the map gained less than {int} of the noted resource")]
        public void GainedLessThan(PickleContext ctx, int amount)
        {
            var b = ctx.Get<Baseline>();
            var gained = CountOf(Driver.Map(ctx), b.Def) - b.Count;
            ctx.Assert(gained < amount,
                $"the map gained {gained} {b.Def.defName}, expected less than {amount}: something helped that should not have");
        }

        /// <summary>
        /// The "+N" mark over the animal that found the extra. Motes are drawn objects, not listed
        /// things, so they are read from the map's draw manager.
        /// </summary>
        [Then("Fieldwork Companions: a bonus mark floats over {string}")]
        public void MarkOver(PickleContext ctx, string animalName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var marks = Driver.Map(ctx).dynamicDrawManager.DrawThings.OfType<MoteText>()
                .Where(m => m.text != null && m.text.StartsWith("+")
                            && (m.exactPosition - animal.DrawPos).MagnitudeHorizontalSquared() < 4f)
                .ToList();
            ctx.Assert(marks.Count > 0, $"no '+N' mark is floating within two cells of {animalName}");
        }

        /// <summary>
        /// README promises that nothing is written to the save, so that the mod can be added to or
        /// removed from a game in progress. The header of a save lists the mod's name, with a space;
        /// what would betray saved data is one of the mod's own type names, spelled without one.
        /// </summary>
        [Then("the saved game {string} holds nothing written by Fieldwork Companions")]
        public void SaveHoldsNothing(PickleContext ctx, string saveName)
        {
            var path = GenFilePaths.FilePathForSavedGame(saveName);
            ctx.Require(System.IO.File.Exists(path), $"no saved game at {path}: save it first with 'I save and reload as'");
            var text = System.IO.File.ReadAllText(path);
            ctx.Assert(!text.Contains("FieldworkCompanions"),
                "the save contains 'FieldworkCompanions': the mod wrote something into it, which would make it "
                + "impossible to remove from a game in progress");
        }

        [Then("Fieldwork Companions: no bonus mark floats over {string}")]
        public void NoMarkOver(PickleContext ctx, string animalName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var marks = Driver.Map(ctx).dynamicDrawManager.DrawThings.OfType<MoteText>()
                .Where(m => m.text != null && m.text.StartsWith("+")
                            && (m.exactPosition - animal.DrawPos).MagnitudeHorizontalSquared() < 4f)
                .ToList();
            ctx.Assert(marks.Count == 0, $"a '+N' mark is floating over {animalName} although it should not have helped");
        }
    }
}
