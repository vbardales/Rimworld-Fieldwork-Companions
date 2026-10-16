# Diagnostic (2026-10-17): is the yellow dome in the gallery captures the tuque itself? The same tuque, dyed blue here.
# If a blue dome shows, the shape is the tuque's. Not a gallery capture: a control, not for the Workshop page.
@review @requires:nelim.pickletools.camerazoom @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:180
Feature: the tuque dyed blue, front view

  Scenario: a tuque dyed blue, close, to see its shape
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
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Tuque" dyed rgb (30, 80, 220)
    And Nelim's Pickle Tools: I frame the cell (178, 143) at zoom 6
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    When I take a screenshot "tuque dyed blue"
    And I close all dialogs
    Then no errors were logged
