using System;
using System.Linq;
using System.Reflection;
using HarmonyLib;
using RimWorks.Pickle;
using Verse;

namespace FieldworkCompanions.PickleSteps
{
    /// <summary>
    /// Whether the four Harmony patches actually took in the running game. Out of game the
    /// _tools harness proves the four targets exist with the expected shape; only a live Harmony
    /// can say that the patches are installed, by this mod, and on the runtime the game really uses.
    /// </summary>
    [PickleSteps]
    public class HookSteps
    {
        [Then("Fieldwork Companions has patched {string}")]
        public void AssertPatched(PickleContext ctx, string typeAndMethod)
        {
            var dot = typeAndMethod.LastIndexOf('.');
            ctx.Require(dot > 0, $"write the target as Type.Method, not '{typeAndMethod}'");
            var typeName = typeAndMethod.Substring(0, dot);
            var methodName = typeAndMethod.Substring(dot + 1);

            var type = GenTypes.GetTypeInAnyAssembly(typeName);
            ctx.Require(type != null, $"no type named '{typeName}' in the loaded assemblies");

            var method = type.GetMethod(methodName, BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
            ctx.Require(method != null, $"{typeName} has no method '{methodName}'");

            var info = Harmony.GetPatchInfo(method);
            var owners = info == null
                ? new string[0]
                : info.Prefixes.Concat(info.Postfixes).Concat(info.Transpilers).Concat(info.Finalizers).Select(p => p.owner).Distinct().ToArray();

            ctx.Assert(owners.Contains(FieldworkCompanionsMod.HarmonyId),
                $"{typeAndMethod} is not patched by '{FieldworkCompanionsMod.HarmonyId}'. Patched by: "
                + (owners.Length == 0 ? "nobody" : string.Join(", ", owners)));
        }
    }
}
