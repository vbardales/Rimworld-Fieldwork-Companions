# Empty photograph (2026-10-18): the place rice-paddy with no animal and no pawn in the frame, to read its free cells on the picture.
# Not a gallery capture. Read by the session to write the cells in STATUS.md and to send to NPT for SANCTUAIRE-CASES.md.
@review @requires:nelim.pickletools.camerazoom @requires:nelim.pickletools.screenshotstudio @timeout:180
Feature: the rice-paddy place, empty

  Scenario: rice-paddy empty, read the free cells
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 17
    And I close all dialogs
    And Nelim's Sanctuary: I am at the sanctuary "rice-paddy"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "rice-paddy"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: I frame the cell (230, 122) at zoom 8
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    When I take a screenshot "rice-paddy empty"
    And I close all dialogs
    Then no errors were logged
