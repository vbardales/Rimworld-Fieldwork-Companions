using System;
using Verse;

namespace FieldworkCompanions
{
    public class FieldworkCompanionsSettings : ModSettings
    {
        // What the companion helps with.
        public bool assistMining = true;
        public bool assistHarvest = true;
        public bool assistFishing = true;
        public bool assistGathering = true;

        // How the chance is worked out.
        public float baseChance = 0.15f;
        public float perStepBonus = 0.10f;
        public float bondBonus = 0.15f;

        // What it turns up, as a share of the gesture's nominal yield.
        public float bonusShare = 0.25f;

        // How close it counts as being at hand.
        public int radius = 8;

        // Whether the training matching the gesture is required, when one exists.
        public bool requireSpecialty = true;

        // The bond that ties from working together, per successful assist.
        public float bondChance = 0.005f;

        public bool showMote = true;

        // Also validate stored values: sliders alone cannot protect an older settings file.
        public void Normalize()
        {
            baseChance = Bound(baseChance, 0f, 1f, 0.15f);
            perStepBonus = Bound(perStepBonus, 0f, 0.5f, 0.10f);
            bondBonus = Bound(bondBonus, 0f, 1f, 0.15f);
            bonusShare = Bound(bonusShare, 0.05f, 2f, 0.25f);
            bondChance = Bound(bondChance, 0f, 0.05f, 0.005f);
            radius = Math.Max(2, Math.Min(30, radius));
        }

        private static float Bound(float value, float min, float max, float fallback)
        {
            return float.IsNaN(value) || float.IsInfinity(value)
                ? fallback : Math.Max(min, Math.Min(max, value));
        }

        public float AssistChance(int trainingSteps, bool bonded)
        {
            return Math.Max(0f, Math.Min(1f,
                baseChance + perStepBonus * trainingSteps + (bonded ? bondBonus : 0f)));
        }

        public bool WithinRadius(int distanceSquared) => distanceSquared <= radius * radius;

        public void Reset()
        {
            assistMining = true;
            assistHarvest = true;
            assistFishing = true;
            assistGathering = true;
            baseChance = 0.15f;
            perStepBonus = 0.10f;
            bondBonus = 0.15f;
            bonusShare = 0.25f;
            radius = 8;
            requireSpecialty = true;
            bondChance = 0.005f;
            showMote = true;
        }

        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Values.Look(ref assistMining, "assistMining", true);
            Scribe_Values.Look(ref assistHarvest, "assistHarvest", true);
            Scribe_Values.Look(ref assistFishing, "assistFishing", true);
            Scribe_Values.Look(ref assistGathering, "assistGathering", true);
            Scribe_Values.Look(ref baseChance, "baseChance", 0.15f);
            Scribe_Values.Look(ref perStepBonus, "perStepBonus", 0.10f);
            Scribe_Values.Look(ref bondBonus, "bondBonus", 0.15f);
            Scribe_Values.Look(ref bonusShare, "bonusShare", 0.25f);
            Scribe_Values.Look(ref radius, "radius", 8);
            Scribe_Values.Look(ref requireSpecialty, "requireSpecialty", true);
            Scribe_Values.Look(ref bondChance, "bondChance", 0.005f);
            Scribe_Values.Look(ref showMote, "showMote", true);
            if (Scribe.mode == LoadSaveMode.LoadingVars) Normalize();
        }
    }
}
