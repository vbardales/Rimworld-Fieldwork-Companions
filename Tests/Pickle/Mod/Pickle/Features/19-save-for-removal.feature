# _tools/FUNCTIONAL-SCENARIOS.md scenario 13, second half: the mod taken out of a game that was saved with it.
#
# First launch (this file): a game with a companion that has just done its work, saved, checked for any trace of the
# mod outside its mod list, and handed to the companion Tests/Pickle/Removal, which does not depend on the mod. Second
# launch (Removal/Mod/Pickle/Features/removal-check.feature), with the mod out of the mod list: the game is loaded and
# played.
# Played with:  -DepMap wsl-deps.retrait.map -Filter '19-save-for-removal.feature' -Then 'removal-check'
#                 -ThenWithout nelim.fieldworkcompanions,nelim.fieldworkcompanions.pickletests
@part3 @requires:nelim.fieldworkcompanions.pickleremoval
Feature: a game saved with the mod, for the launch without it

  Scenario: the save holds nothing of the mod and is handed over
    Given the save "test-colony" is loaded
    And game speed is paused
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"
    When Fieldwork Companions saves the game as "fieldwork-companions-with-mod"
    Then Fieldwork Companions save "fieldwork-companions-with-mod" holds no data of this mod outside its mod list
    When Fieldwork Companions hands the saved game "fieldwork-companions-with-mod" to the mod "nelim.fieldworkcompanions.pickleremoval"
    Then no errors were logged
