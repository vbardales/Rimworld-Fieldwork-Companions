# Control (2026-10-18): does Show Hair Under Stuff show Nelim's hair at all, with no headgear? Not a gallery capture.
# With 21 (hair under the tuque) it separates the mod from the tuque: hair here, not there = the tuque hides it; no hair here = the mod or the hairstyle.
@review @requires:nelim.pickletools.camerazoom @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:180
Feature: Nelim's hair with no headgear, front view

  Scenario: hair bare, front, close
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 10
    And I close all dialogs
    And Nelim's Sanctuary: I am at the sanctuary "gravel-yard"
    And Nelim's Sanctuary: the sanctuary "gravel-yard" is emptied
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: "Nelim" stands at (178, 143) facing South
    And Fieldwork Companions: "Nelim" is cured of every chronic condition
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: I frame the cell (178, 143) at zoom 6
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    When I take a screenshot "hair bare"
    And I close all dialogs
    Then no errors were logged
