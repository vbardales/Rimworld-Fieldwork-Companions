# A control for the gallery photograph (20): does Nelim's hair show under her tuque?
#
# Not a functional scenario and not for the Workshop page: one close portrait of Nelim facing the camera, in the same tuque as the
# photograph, played on two passes. wsl-deps.sanctuary.map stages Show Hair Under Stuff (RaccoonCuddler.ShowHair, on by default: hair under
# upper headgear and under full headgear); wsl-deps.sanctuary-noshowhair.map is the same list without it. The two captures are compared: if the
# hair appears only with the mod, the mod does its work on this tuque; if neither shows hair, the tuque hides it for another reason.
@review @requires:nelim.pickletools.camerazoom @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:180
Feature: Nelim's hair under her tuque

  Scenario: hair under the tuque, front view, close
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
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Tuque" dyed rgb (230, 170, 40)
    And Nelim's Pickle Tools: I frame the cell (178, 143) at zoom 6
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    When I take a screenshot "hair under the tuque"
    And I close all dialogs
    Then no errors were logged
