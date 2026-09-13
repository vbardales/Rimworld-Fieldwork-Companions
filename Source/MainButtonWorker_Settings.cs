using RimWorld;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>Optional access to the same native dialog as Mod options.</summary>
    public class MainButtonWorker_Settings : MainButtonWorker
    {
        public override void Activate()
        {
            Find.WindowStack.Add(new Dialog_ModSettings(FieldworkCompanionsMod.Instance));
        }
    }
}
