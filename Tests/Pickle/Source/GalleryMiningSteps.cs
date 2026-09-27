using System.Linq;
using System.Threading.Tasks;
using RimWorks.Pickle;
using RimWorld;
using UnityEngine;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// The picture for the Workshop page is a real mining job, not the instantaneous call the functional scenarios use:
    /// the colonist walks to the rock and works at it, the animal that follows its master at work stands beside them,
    /// and the mark rises over the animal when the block comes down. The placement is fixed instead of random, one cell
    /// each, so that the three of them fit in the same frame at the closest zoom.
    /// </summary>
    public partial class FieldworkSteps
    {
        // The animal follows its master at work and wanders a few cells off; for the picture it is put back beside them.
        private static (Pawn animal, Pawn worker, IntVec3 cell) keptBeside;

        private static void KeepBeside()
        {
            var (animal, worker, cell) = keptBeside;
            if (animal == null || !animal.Spawned || !worker.Spawned) return;
            if (animal.Position.DistanceToSquared(worker.Position) > 4 && worker.Map == animal.Map)
            {
                animal.Position = cell;
                animal.Notify_Teleported(true, false);
            }
        }

        [Given("Fieldwork Companions: a {string} rock and {string} stand right beside {string}")]
        public void SceneBeside(PickleContext ctx, string rockDefName, string animalName, string colonistName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var animal = Driver.PawnNamed(ctx, animalName);
            var def = Def(ctx, rockDefName);
            ctx.Require(def.building?.mineableThing != null, $"'{rockDefName}' is not a mineable rock");
            var map = worker.Map;

            var free = GenAdj.AdjacentCells.Select(o => worker.Position + o)
                .Where(c => c.InBounds(map) && c.Standable(map) && c.GetEdifice(map) == null
                            && c.GetFirstItem(map) == null && c.GetPlant(map) == null)
                .ToList();
            ctx.Require(free.Count >= 2, $"fewer than two free cells around {colonistName} at {worker.Position}: {free.Count}");

            // The rock on one side, the animal on another: the two cells farthest apart, so that neither hides the other.
            var rockCell = free[0];
            var animalCell = free.OrderByDescending(c => c.DistanceToSquared(rockCell)).First();

            if (animal.Spawned) animal.DeSpawn();
            GenSpawn.Spawn(animal, animalCell, map);
            var rock = GenSpawn.Spawn(ThingMaker.MakeThing(def), rockCell, map);
            ctx.Set(new Target { Thing = rock, Cell = rockCell });
            keptBeside = (animal, worker, animalCell);
        }

        /// <summary>
        /// Pickle's pointer sits at the centre of the screen, and the game draws the tooltips of whatever is under it: a
        /// scene centred on the figures (the first capture, 2026-09-25) has two tooltips over the lower right. The camera
        /// is put so that the figures stand up and to the left of the pointer instead.
        /// </summary>
        [When("Fieldwork Companions: the camera is placed so that {string} stands {int} cells left of and {int} cells above the pointer")]
        public void CameraOffCentre(PickleContext ctx, string name, int left, int above)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            Find.CameraDriver.JumpToCurrentMapLoc(pawn.Position + new IntVec3(left, 0, -above));
        }

        [When("Fieldwork Companions: {string} is ordered to mine the rock beside them")]
        public void OrderedToMine(PickleContext ctx, string colonistName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var rock = ctx.Get<Target>().Thing;
            ctx.Require(rock != null && rock.Spawned, "no rock is standing: use 'a rock and an animal stand right beside' first");
            ctx.Require(!worker.WorkTypeIsDisabled(WorkTypeDefOf.Mining),
                $"{colonistName} cannot mine at all (a backstory or a trait disables the work type)");

            worker.workSettings.SetPriority(WorkTypeDefOf.Mining, 1);
            worker.Map.designationManager.AddDesignation(new Designation(rock, DesignationDefOf.Mine));
        }


        /// <summary>
        /// The block takes tens of seconds of game time, and under the headless renderer the game runs far below its
        /// nominal rate at the normal speed (the first try of 2026-09-25 waited 120 s and was cut by Pickle's watchdog).
        /// So the job is played at a high speed until the rock is nearly through, and only then does the scenario slow
        /// down to normal speed for the mark, which lives about two seconds of game time.
        /// </summary>
        [Then("Fieldwork Companions: the rock beside {string} is nearly mined within {int} seconds", TimeoutSeconds = 280f)]
        public async Task RockNearlyMined(PickleContext ctx, string colonistName, int seconds)
        {
            ctx.Require(seconds <= 270, "the step allows 280 s of waiting, so ask for at most 270");
            var worker = Driver.PawnNamed(ctx, colonistName);
            var rock = ctx.Get<Target>().Thing;
            var until = Time.realtimeSinceStartup + seconds;

            while (Time.realtimeSinceStartup < until)
            {
                KeepBeside();
                if (rock.Destroyed || rock.HitPoints <= rock.MaxHitPoints * 0.2f) return;
                await ctx.WaitFrames(10);
            }
            ctx.Assert(false, $"the rock is still at {rock.HitPoints}/{rock.MaxHitPoints} after {seconds} s; {colonistName} is " +
                $"{(worker.CurJob != null ? "doing " + worker.CurJob.def.defName : "doing nothing")} at {worker.Position}, the rock is at " +
                $"{rock.Position}, the game is at speed {Find.TickManager.CurTimeSpeed} on tick {Find.TickManager.TicksGame}");
        }

        /// <summary>
        /// Waits for the mark to rise over the animal, polling every few frames. The picture is taken by the next step.
        /// </summary>
        [Then("Fieldwork Companions: a bonus mark floats over {string} within {int} seconds", TimeoutSeconds = 150f)]
        public async Task MarkOverWithin(PickleContext ctx, string animalName, int seconds)
        {
            ctx.Require(seconds <= 140, "the step allows 150 s of waiting, so ask for at most 140");
            var animal = Driver.PawnNamed(ctx, animalName);
            var map = Driver.Map(ctx);
            var until = Time.realtimeSinceStartup + seconds;

            while (Time.realtimeSinceStartup < until)
            {
                KeepBeside();
                if (map.dynamicDrawManager.DrawThings.OfType<MoteText>().Any(m => m.text != null && m.text.StartsWith("+")
                        && (m.exactPosition - animal.DrawPos).MagnitudeHorizontalSquared() < 4f))
                    return;
                await ctx.WaitFrames(2);
            }
            var marks = map.dynamicDrawManager.DrawThings.OfType<MoteText>().Where(m => m.text != null).Select(m => m.text).ToList();
            ctx.Assert(false, $"no '+N' mark rose over {animalName} in {seconds} s; text motes on the map: " +
                (marks.Count == 0 ? "none" : string.Join(", ", marks)) + $"; tick {Find.TickManager.TicksGame}");
        }
    }
}
