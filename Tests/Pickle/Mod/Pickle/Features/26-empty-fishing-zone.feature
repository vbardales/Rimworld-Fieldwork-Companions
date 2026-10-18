# Empty photograph (2026-10-18): the place fishing-zone with no animal and no pawn in the frame, to read its free cells on the picture.
# Not a gallery capture. Read by the session to write the cells in STATUS.md and to send to NPT for SANCTUAIRE-CASES.md.
@review @requires:nelim.pickletools.camerazoom @requires:nelim.pickletools.screenshotstudio @timeout:180
Feature: the fishing-zone place, empty

  Scenario: fishing-zone empty, read the free cells
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I close all dialogs
    And Nelim's Sanctuary: I am at the sanctuary "fishing-zone"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "fishing-zone"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: I frame the cell (114, 68) at zoom 6
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    When I take a screenshot "fishing-zone empty"
    And I close all dialogs
    Then no errors were logged
