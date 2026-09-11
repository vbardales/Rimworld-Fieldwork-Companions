using HarmonyLib;
using UnityEngine;
using Verse;

namespace FieldworkCompanions
{
    public class FieldworkCompanionsMod : Mod
    {
        public const string HarmonyId = "nelim.fieldworkcompanions";

        public static FieldworkCompanionsMod Instance { get; private set; }
        public static FieldworkCompanionsSettings Settings { get; private set; }
        public static Harmony HarmonyInstance { get; private set; }

        private Vector2 scrollPosition;
        private float viewHeight;

        public FieldworkCompanionsMod(ModContentPack content) : base(content)
        {
            Instance = this;
            Settings = GetSettings<FieldworkCompanionsSettings>();

            HarmonyInstance = new Harmony(HarmonyId);
            HarmonyInstance.PatchAll();
        }

        public override string SettingsCategory() => "Fieldwork Companions";

        public override void DoSettingsWindowContents(Rect inRect)
        {
            var settings = Settings;
            var viewRect = new Rect(0f, 0f, inRect.width - 20f, Mathf.Max(viewHeight, inRect.height));

            Widgets.BeginScrollView(inRect, ref scrollPosition, viewRect);
            var listing = new Listing_Standard();
            listing.Begin(viewRect);

            listing.Label("FieldworkCompanions.Settings.Intro".Translate());
            listing.GapLine();

            listing.Label("FieldworkCompanions.Settings.WorkHeader".Translate());
            listing.CheckboxLabeled("FieldworkCompanions.Settings.Mining".Translate(),
                ref settings.assistMining, "FieldworkCompanions.Settings.MiningTip".Translate());
            listing.CheckboxLabeled("FieldworkCompanions.Settings.Harvest".Translate(),
                ref settings.assistHarvest, "FieldworkCompanions.Settings.HarvestTip".Translate());
            listing.CheckboxLabeled("FieldworkCompanions.Settings.Fishing".Translate(),
                ref settings.assistFishing, "FieldworkCompanions.Settings.FishingTip".Translate());
            listing.CheckboxLabeled("FieldworkCompanions.Settings.Gathering".Translate(),
                ref settings.assistGathering, "FieldworkCompanions.Settings.GatheringTip".Translate());

            listing.Gap();
            listing.CheckboxLabeled("FieldworkCompanions.Settings.RequireSpecialty".Translate(),
                ref settings.requireSpecialty,
                "FieldworkCompanions.Settings.RequireSpecialtyTip".Translate());

            listing.GapLine();

            listing.Label("FieldworkCompanions.Settings.ChanceHeader".Translate());
            settings.baseChance = PercentRow(listing, "FieldworkCompanions.Settings.BaseChance",
                settings.baseChance, 0f, 100f, "FieldworkCompanions.Settings.BaseChanceTip");
            settings.perStepBonus = PercentRow(listing, "FieldworkCompanions.Settings.PerStep",
                settings.perStepBonus, 0f, 50f, "FieldworkCompanions.Settings.PerStepTip");
            settings.bondBonus = PercentRow(listing, "FieldworkCompanions.Settings.Bond",
                settings.bondBonus, 0f, 100f, "FieldworkCompanions.Settings.BondTip");

            listing.Label("FieldworkCompanions.Settings.Ceiling".Translate(
                Mathf.RoundToInt(Mathf.Clamp01(
                    settings.baseChance + 3f * settings.perStepBonus + settings.bondBonus) * 100f)));

            listing.GapLine();

            listing.Label("FieldworkCompanions.Settings.RewardHeader".Translate());
            settings.bonusShare = PercentRow(listing, "FieldworkCompanions.Settings.Share",
                settings.bonusShare, 5f, 200f, "FieldworkCompanions.Settings.ShareTip");

            listing.Gap();
            settings.radius = Mathf.RoundToInt(listing.SliderLabeled(
                "FieldworkCompanions.Settings.Radius".Translate(settings.radius),
                settings.radius, 2f, 30f, 0.62f,
                "FieldworkCompanions.Settings.RadiusTip".Translate()));

            listing.GapLine();

            settings.bondChance = PercentRow(listing, "FieldworkCompanions.Settings.BondChance",
                settings.bondChance, 0f, 5f, "FieldworkCompanions.Settings.BondChanceTip", 1);

            listing.CheckboxLabeled("FieldworkCompanions.Settings.ShowMote".Translate(),
                ref settings.showMote, "FieldworkCompanions.Settings.ShowMoteTip".Translate());

            listing.Gap();
            if (listing.ButtonText("FieldworkCompanions.Settings.Reset".Translate()))
            {
                Find.WindowStack.Add(Dialog_MessageBox.CreateConfirmation(
                    "FieldworkCompanions.Settings.ConfirmReset".Translate(),
                    settings.Reset,
                    destructive: true));
            }

            viewHeight = listing.CurHeight + 12f;
            listing.End();
            Widgets.EndScrollView();
        }

        /// <summary>
        /// Curseur affiche en pourcentage, stocke en fraction. <paramref name="decimals"/> sert
        /// aux valeurs tres basses, comme la chance de nouer un lien.
        /// </summary>
        private static float PercentRow(Listing_Standard listing, string key, float value,
            float min, float max, string tooltipKey = null, int decimals = 0)
        {
            float percent = value * 100f;
            string shown = decimals > 0
                ? percent.ToString("0." + new string('0', decimals))
                : Mathf.RoundToInt(percent).ToString();

            string label = key.Translate(shown);
            string tooltip = tooltipKey == null ? null : (string)tooltipKey.Translate();

            float updated = listing.SliderLabeled(label, percent, min, max, 0.62f, tooltip);

            float step = decimals > 0 ? Mathf.Pow(10f, -decimals) : 1f;
            updated = Mathf.Round(updated / step) * step;

            return Mathf.Clamp(updated, min, max) / 100f;
        }
    }
}
