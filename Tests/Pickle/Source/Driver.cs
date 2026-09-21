using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using RimWorks.Pickle;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// Shared lookups for every step class here.
    ///
    /// Two rules run through all of it. Nothing is cached: a save reload replaces every object in
    /// the game, and a helper holding yesterday's pawn would assert against something nothing draws
    /// from any more. And every miss names itself: a report keeps no stack trace, so an unguarded
    /// hop through reflection comes back as "Object reference not set to an instance of an object"
    /// and the run that produced it is already over.
    /// </summary>
    public static class Driver
    {
        internal const BindingFlags StaticAny = BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic;
        internal const BindingFlags InstanceAny = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;

        public static FieldworkCompanionsMod Mod(PickleContext ctx)
        {
            var mod = LoadedModManager.GetMod<FieldworkCompanionsMod>();
            ctx.Require(mod != null,
                "LoadedModManager.GetMod<FieldworkCompanionsMod>() returned nothing: FieldworkCompanions.dll "
                + "is not loaded in this session, so no step here can reach its settings");
            return mod;
        }

        /// <summary>Read through the mod's static property every time, never kept.</summary>
        public static FieldworkCompanionsSettings Settings(PickleContext ctx)
        {
            Mod(ctx);
            ctx.Require(FieldworkCompanionsMod.Settings != null,
                "FieldworkCompanionsMod.Settings is null: the mod constructor did not run, so the "
                + "assembly loaded but its Mod class did not");
            return FieldworkCompanionsMod.Settings;
        }

        public static Map Map(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null,
                "no current map: load the fixture ('the save \"test-colony\" is loaded') before this step");
            return Find.CurrentMap;
        }

        /// <summary>
        /// A pawn by the name a scenario gave it. Colonists made by Pickle carry a NameTriple and
        /// answer to their nickname; the animals this suite makes are given a NameSingle. Both are
        /// matched, and so is the label.
        /// </summary>
        public static Pawn PawnNamed(PickleContext ctx, string name)
        {
            IReadOnlyList<Pawn> spawned = Map(ctx).mapPawns.AllPawnsSpawned;
            Pawn found = spawned.FirstOrDefault(p =>
                (p.Name is NameTriple triple && triple.Nick == name)
                || (p.Name is NameSingle single && single.Name == name)
                || p.LabelShort == name);
            ctx.Require(found != null,
                $"no spawned pawn named \"{name}\"; the map holds: "
                + string.Join(", ", spawned.Select(p => p.LabelShort).ToArray()));
            return found;
        }

        public static FieldInfo Field(PickleContext ctx, Type owner, string name, BindingFlags flags)
        {
            var field = owner.GetField(name, flags);
            ctx.Require(field != null,
                $"{owner.FullName}.{name} no longer exists: the game or the mod renamed it, update the steps");
            return field;
        }

        public static MethodInfo Method(PickleContext ctx, Type owner, string name, BindingFlags flags)
        {
            var method = owner.GetMethod(name, flags);
            ctx.Require(method != null,
                $"{owner.FullName}.{name}() no longer exists: the game renamed it, update the steps");
            return method;
        }

        public static string SettingsFilePath(PickleContext ctx)
        {
            var mod = Mod(ctx);
            var method = Method(ctx, typeof(LoadedModManager), "GetSettingsFilename", StaticAny);
            return (string)method.Invoke(null, new object[] { mod.Content.FolderName, mod.GetType().Name });
        }
    }
}
