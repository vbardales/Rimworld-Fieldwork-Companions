# TESTING.md, family "loading": the part only a running game can answer.
#
# Every other scenario in this suite depends on this one. If the Harmony patches did not take, a
# colonist simply never gets any help and every failure below would point at the wrong thing.
#
# _tools/Run-Functional-Tests.ps1 already proves, out of game, that each of the four targets exists
# with the expected shape and that nothing overrides it. What it cannot prove is that the patches
# were INSTALLED, by this mod, in the runtime the game really uses (Mono, not the desktop CLR the
# harness runs on). That is the whole point of the third scenario.
#
# No save is loaded. Mods and defs are settled before a game exists, so these run at the main menu
# in about a second, against ten to fifteen for a scenario that loads the fixture.
@part1
Feature: Fieldwork Companions loads, and its four hooks are live

  Scenario: the mod is loaded, after Harmony
    Then mod "nelim.fieldworkcompanions" is loaded
    And mod "nelim.fieldworkcompanions" loads after "brrainz.harmony"

  # A throw in PatchAll is logged rather than fatal, so without this check a half-patched mod would
  # go on to fail the scenarios below one by one instead of failing here once. It also stands for
  # the Odyssey-absent case: the two trainings are looked up silently, and a line here in a pass
  # without the DLC would be a regression.
  Scenario: loading logged no error
    Then no errors were logged

  Scenario: the four vanilla methods are patched, by this mod
    Then Fieldwork Companions has patched "Mineable.DestroyMined"
    And Fieldwork Companions has patched "Plant.PlantCollected"
    And Fieldwork Companions has patched "FishingUtility.GetCatchesFor"
    And Fieldwork Companions has patched "CompHasGatherableBodyResource.Gathered"

  # First use, in the only place it can be observed: before anything has reset the settings. The
  # staged profile of a Pickle run has no settings file of its own, so what the game loaded is the
  # mod's initializers. This is deliberately NOT preceded by a "settings are at their defaults"
  # step: that would make it read back what it had just written. The out-of-game harness proves
  # Reset() and the field initializers agree; this proves the running game, on a clean profile,
  # arrives at the same numbers. On a profile where someone has already opened the options it
  # would read their choices instead, which is why the WSL profile is the one it is written for.
  Scenario: a clean profile loads the documented defaults
    Then Fieldwork Companions setting "baseChance" reads "0.15"
    And Fieldwork Companions setting "perStepBonus" reads "0.1"
    And Fieldwork Companions setting "bondBonus" reads "0.15"
    And Fieldwork Companions setting "bonusShare" reads "0.25"
    And Fieldwork Companions setting "radius" reads "8"
    And Fieldwork Companions setting "requireSpecialty" reads "True"
    And Fieldwork Companions setting "showMote" reads "True"

  # The optional shortcut RIMMSQOL and its kind are meant to be able to reveal. Its default
  # visibility is checked in 04, in a game, because the main bar's worker has no opinion at the main
  # menu.
  Scenario: the hidden settings shortcut is declared
    Then def "FieldworkCompanions_Settings" of type "MainButtonDef" exists
