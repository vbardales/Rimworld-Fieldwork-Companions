---
mod:        Fieldwork Companions
packageId:  nelim.fieldworkcompanions
depot:      Rimworld-Fieldwork-Companions
visibilite: public
detache:    oui
etape:      done
licence:    original
licence_ou: écrit de zéro, MIT ; seule l'idée vient d'un autre jeu
vitrine:    complete
teste_le:
workshop:   
reste:
  - non_verifie: jamais vu tourner en jeu
session:    local_0080fea9-b65b-4cd4-9e3e-06491ff4de8c
maj:        2026-09-12, releve automatique
---

# Fieldwork Companions — etat

Fiche d'etat, lue par une passe sur tous les mods plutot qu'en interrogeant les fils un a un.
Elle vit a la racine, jamais dans `Mod/`, donc Steam ne la recoit pas.

Les champs ci-dessus ont ete deduits du disque le 2026-09-12. Trois ne peuvent pas l'etre et
attendent la session qui tient ce mod :

- **`etape`** — pre-rempli depuis le groupe de session quand il existe, a confirmer.
- **`teste_le`** — la date du dernier essai en jeu. Vide veut dire jamais.
- **`reste`** — ce qu'il reste a faire, en trois categories : `feature` pour une
  fonctionnalite manquante au premier jet, `defaut` pour un defaut connu non corrige,
  `non_verifie` pour ce qui n'a pas pu etre verifie. La ligne posee d'office dit le vrai
  pour presque tout le depot ; la remplacer des qu'elle cesse de l'etre.

Vocabulaire de `licence` : `open` licence explicite, `silent` aucune licence et source morte,
`alive` aucune licence mais source vivante, `forbidden` refus ecrit, `original` rien de repris.
