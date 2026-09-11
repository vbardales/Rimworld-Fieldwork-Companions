using Verse;

namespace FieldworkCompanions
{
    public class FieldworkCompanionsSettings : ModSettings
    {
        // Ce que le compagnon aide a faire.
        public bool assistMining = true;
        public bool assistHarvest = true;
        public bool assistFishing = true;
        public bool assistGathering = true;

        // Le calcul de la chance.
        public float baseChance = 0.15f;
        public float perStepBonus = 0.10f;
        public float bondBonus = 0.15f;

        // Ce qu'il rapporte, en part du rendement nominal du geste.
        public float bonusShare = 0.25f;

        // A quelle distance il compte comme present.
        public int radius = 8;

        // Faut-il le dressage qui correspond au geste, quand il en existe un.
        public bool requireSpecialty = true;

        // Le lien qui se noue a force de travailler ensemble, par assistance reussie.
        public float bondChance = 0.005f;

        public bool showMote = true;

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
        }
    }
}
