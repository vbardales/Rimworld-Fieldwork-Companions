# scripts/FUNCTIONAL-SCENARIOS.md scenario 13, first half: the mod added to a game that was saved without it.
#
# The fixture "test-colony" comes with Pickle and was written long before this mod existed, and every scenario of this
# suite loads it with the mod active. This one says so out loud, then checks that the game runs and saves again with the
# mod in it. The second half, the mod taken out of a game saved with it, is 19-save-for-removal.feature.
@part3
Feature: the mod added to a game in progress

  Scenario: a game saved without the mod loads with it, runs, and saves again
    Given the save "test-colony" is loaded
    Then Fieldwork Companions: the loaded game was saved without this mod
    And mod "nelim.fieldworkcompanions" is loaded
    And no errors were logged
    When I save and reload
    Then no errors were logged
    And the engine is alive
