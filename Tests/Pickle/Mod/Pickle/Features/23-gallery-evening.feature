# The photograph for the Workshop page, image 3 of the series: evening on the river bank, Nelim gathering with Rex at her side.
#
# The story of the series is in PUBLICATION.md ("A day on the river bank"): morning at the jade (20-gallery-mark), noon fishing
# (22-gallery-fishing), evening harvesting (this one). Nelim, bare-headed, relaxed (her own face, nothing forced), a ripe rice
# plant beside her in the last light; Rex at her feet; the "+N" over him as the plant comes down. Same bank as the other two, the
# same shirt and trousers: the day is one outfit, the light is what changes (hour 18).
#
# STAGED (GALLERY.md). The assertion that a harvest is assisted is 06-assists'; this one is for a person.
@part2 @review @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.interfacescale @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: evening on the river bank, a companion beside a harvesting colonist

  Scenario: a plant is harvested, the companion beside the colonist, the mark over the companion
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 18
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Sanctuary: I am at the sanctuary "right-bank"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "right-bank"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: the temperature of the map is 21 degrees
    And Nelim's Pickle Tools: "Nelim" stands at (148, 131) facing South
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Sanctuary: Nelim has her own face
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Nelim" at work
    And Fieldwork Companions: a ripe "Plant_Rice" stands next to "Nelim"
    And Nelim's Pickle Tools: I frame the animal "Rex" at zoom 5
    And Nelim's Pickle Tools: the interface scale is 200 percent
    And Nelim's Pickle Tools: studio presentation mode is enabled
    When Fieldwork Companions: "Nelim" harvests the plant next to them
    Then Fieldwork Companions: a bonus mark floats over "Rex" within 20 seconds
    And game speed is paused
    And Fieldwork Companions: the picture settles for 4 real seconds
    When I take a screenshot "evening harvest, the mark over the companion"
    And I close all dialogs
    Then no errors were logged
