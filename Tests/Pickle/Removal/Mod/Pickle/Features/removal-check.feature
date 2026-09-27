# The second launch of 19-save-for-removal.feature: the mod is out of the mod list, the game saved with it is loaded.
Feature: a game saved with Fieldwork Companions, loaded without it

  Scenario: the game loads and runs without the mod
    Given mod "nelim.fieldworkcompanions" is not loaded
    And the save "fieldwork-companions-with-mod" is loaded
    And game speed is fast
    When I wait 250 ticks
    Then no errors were logged
    And the engine is alive
    When I save and reload as "fieldwork-companions-without-mod"
    Then no errors were logged
    And the engine is alive
