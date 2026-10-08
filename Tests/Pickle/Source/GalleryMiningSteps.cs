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
            var rockCell = free.FirstOrDefault(c => c == worker.Position + new IntVec3(0, 0, -1));
            if (rockCell == IntVec3.Zero) rockCell = free[0];
            var animalCell = free.Where(c => c != rockCell).OrderBy(c => c.z != worker.Position.z).ThenBy(c => c.x).First();

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

        // The decor of the photograph is placed relative to the colonist, because her cell is not known in advance, and
        // taken away again afterwards so that nothing of the set is left in the shared fixture.
        private static readonly System.Collections.Generic.List<Thing> sceneDecor = new System.Collections.Generic.List<Thing>();

        [Given("Fieldwork Companions: the scene decor {string} stands {int} cells right of and {int} cells below {string}")]
        public void SceneDecor(PickleContext ctx, string defName, int right, int below, string colonistName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var def = Def(ctx, defName);
            var cell = worker.Position + new IntVec3(right, 0, -below);
            var map = worker.Map;
            ctx.Require(cell.InBounds(map) && cell.Standable(map) && cell.GetEdifice(map) == null && cell.GetFirstItem(map) == null
                        && cell.GetPlant(map) == null && !map.thingGrid.ThingsListAt(cell).Any(t => t is Pawn),
                $"the decor cell {cell} ({right} right, {below} below {colonistName} at {worker.Position}) is not free");
            var thing = GenSpawn.Spawn(ThingMaker.MakeThing(def, def.MadeFromStuff ? GenStuff.DefaultStuffFor(def) : null), cell, map);
            var fuel = thing.TryGetComp<CompRefuelable>();
            if (fuel != null) fuel.Refuel(fuel.Props.fuelCapacity);
            sceneDecor.Add(thing);
        }

        /// <summary>
        /// The game is paused, so nothing moves, but frames keep being drawn: waiting a few real seconds lets the picture
        /// settle (mote text, shadows) before the capture, which a capture taken on the very frame of the pause can miss.
        /// </summary>
        [When("Fieldwork Companions: the picture settles for {int} real seconds", TimeoutSeconds = 30f)]
        public async Task PictureSettles(PickleContext ctx, int seconds)
        {
            ctx.Require(seconds >= 1 && seconds <= 20, "ask for 1 to 20 seconds");
            var until = Time.realtimeSinceStartup + seconds;
            while (Time.realtimeSinceStartup < until) await ctx.WaitFrames(5);
        }


        /// <summary>
        /// Nelim of the Sanctuary fixture has Asthma and a bad back (run 91fa): she mined, but too slowly for the mark to
        /// rise in time. For the picture she is cured of her chronic conditions, in the run only: nothing is saved.
        /// </summary>
        [Given("Fieldwork Companions: {string} is cured of every chronic condition")]
        public void CuredOfChronic(PickleContext ctx, string colonistName)
        {
            var pawn = Driver.PawnNamed(ctx, colonistName);
            foreach (var h in pawn.health.hediffSet.hediffs.Where(h => h.def.chronic).ToList())
                pawn.health.RemoveHediff(h);
        }
        [When("Fieldwork Companions: the scene decor is cleared")]
        public void SceneDecorCleared(PickleContext ctx)
        {
            foreach (var t in sceneDecor.Where(t => !t.Destroyed)) t.Destroy();
            sceneDecor.Clear();
        }

        [When("Fieldwork Companions: {string} is ordered to mine the rock beside them")]
        public void OrderedToMine(PickleContext ctx, string colonistName)
        {
            var worker = Driver.PawnNamed(ctx, colonistName);
            var rock = ctx.Get<Target>().Thing;
            ctx.Require(rock != null && rock.Spawned, "no rock is standing: use 'a rock and an animal stand right beside' first");
            ctx.Require(!worker.WorkTypeIsDisabled(WorkTypeDefOf.Mining),
                $"{colonistName} cannot mine at all (a backstory or a trait disables the work type)");

            // On the Sanctuary map the colonist found plants to cut forty cells away (run 4f85, 2026-10-08) and never came to the
            // rock: every other kind of work is switched off for the picture, mining alone stays on.
            foreach (var type in DefDatabase<WorkTypeDef>.AllDefsListForReading)
                if (type != WorkTypeDefOf.Mining && !worker.WorkTypeIsDisabled(type))
                    worker.workSettings.SetPriority(type, 0);
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
                var mark = map.dynamicDrawManager.DrawThings.OfType<MoteText>().FirstOrDefault(m => m.text != null && m.text.StartsWith("+")
                        && (m.exactPosition - animal.DrawPos).MagnitudeHorizontalSquared() < 4f);
                if (mark != null)
                {
                    // Mote_Text ages in real seconds (realTime, solidTime 2.2): it is transparent about 2 s after it is
                    // made, pause or not. The picture is taken after a settling wait, so the mark is kept opaque.
                    mark.overrideTimeBeforeStartFadeout = 120f;
                    // Paused on the very frame the mark is found: at the high speed the colonist walks away from the rock in the
                    // frames before the next step pauses (run 761e, Nelim stood three cells from the vein).
                    Find.TickManager.CurTimeSpeed = TimeSpeed.Paused;
                    return;
                }
                await ctx.WaitFrames(2);
            }
            var marks = map.dynamicDrawManager.DrawThings.OfType<MoteText>().Where(m => m.text != null).Select(m => m.text).ToList();
            var master = animal.playerSettings?.Master;
            var masterState = master == null ? "no master" : $"{master.LabelShort} job={(master.CurJob?.def.defName ?? "none")} downed={master.Downed} hediffs=[{string.Join(", ", master.health.hediffSet.hediffs.Select(h => h.def.defName))}] mining prio={master.workSettings?.GetPriority(WorkTypeDefOf.Mining)}";
            ctx.Assert(false, $"no '+N' mark rose over {animalName} in {seconds} s ({masterState}); text motes on the map: " +
                (marks.Count == 0 ? "none" : string.Join(", ", marks)) + $"; tick {Find.TickManager.TicksGame}");
        }
    }
}
