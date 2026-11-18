using UnityEngine;
using Verse;

namespace FieldworkCompanions
{
    /// <summary>
    /// The "+N" floating over the animal. The game's text mote has a fixed font, so on a small
    /// image it reads as a speck; this one draws the same text scaled by the setting "markScale".
    /// </summary>
    public class AssistMark : MoteText
    {
        public float scale = 1f;

        public static void Throw(Vector3 loc, Map map, string text, float timeBeforeStartFadeout)
        {
            if (!loc.ToIntVec3().InBounds(map)) return;

            var mark = (AssistMark)ThingMaker.MakeThing(DefDatabase<ThingDef>.GetNamed("FieldworkCompanions_AssistMark"));
            mark.exactPosition = loc;
            mark.SetVelocity(Rand.Range(5, 35), Rand.Range(0.42f, 0.45f));
            mark.text = text;
            mark.overrideTimeBeforeStartFadeout = timeBeforeStartFadeout;
            mark.scale = FieldworkCompanionsMod.Settings.markScale;
            GenSpawn.Spawn(mark, loc.ToIntVec3(), map);
        }

        public override void DrawGUIOverlay()
        {
            if (scale <= 1.01f)
            {
                base.DrawGUIOverlay();
                return;
            }

            // Same screen point as GenMapUI.DrawText, so the text grows around where it would sit.
            Vector2 at = Find.Camera.WorldToScreenPoint(new Vector3(exactPosition.x, 0f, exactPosition.z)) / Prefs.UIScale;
            at.y = UI.screenHeight - at.y;

            Matrix4x4 before = GUI.matrix;
            GUI.matrix = before
                * Matrix4x4.Translate(new Vector3(at.x, at.y, 0f))
                * Matrix4x4.Scale(new Vector3(scale, scale, 1f))
                * Matrix4x4.Translate(new Vector3(-at.x, -at.y, 0f));
            base.DrawGUIOverlay();
            GUI.matrix = before;
        }
    }
}
