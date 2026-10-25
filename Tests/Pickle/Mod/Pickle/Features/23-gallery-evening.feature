# The photograph for the Workshop page, image 3 of the series: evening at the rice paddy, Nelim harvesting with Rex at her side.
#
# STORY (criterion k, shotlist v3 in STATUS.md, 2026-10-25): same day as 20 and 22. Episode 3, evening (hour 18, the light low and
# warm, a lit TorchLamp as the field lamp): CLOSING TIGHT shot (zoom 4) at the edge of the paddy, east of the house. Same teal shirt
# and ochre trousers as the whole day, hair "Flowy" loose, bare-headed (the tuque was for the dawn's stone dust), her own relaxed face.
# Instant: the sickle is mid-cut on a ripe Plant_Rice, a second ripe plant stays in frame (the next cut), the "+N" rises over Rex,
# who looks East toward that second plant (profile: the front view of the series is image 1). Nelim stands right of centre, Rex left.
#
# STAGED (GALLERY.md). The assertion that a harvest is assisted is 06-assists'; this one is for a person.
# Place "rice-paddy" (230, 122), bare brown soil between the sprouts and the bamboo edge (photo SanctuaryBacklot/Art/Locations/33):
# the cells below are read from that photo and not yet seen in a run. The ticket decides; the capture is read before any verdict.
@part2 @review @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.interfacescale @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: evening at the rice paddy, a companion beside a harvesting colonist

  Scenario: a plant is harvested, the companion beside the colonist, the mark over the companion
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 18
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Sanctuary: I am at the sanctuary "rice-paddy"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "rice-paddy"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: the temperature of the map is 21 degrees
    And Nelim's Pickle Tools: "Nelim" stands at (227, 121) facing South
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Flowy"
    And Nelim's Pickle Tools: the area from (224, 118) to (231, 124) is cleared
    And Nelim's Sanctuary: Nelim has her own face
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Nelim" at work
    And Nelim's Pickle Tools: "Rex" faces East
    And Fieldwork Companions: a ripe "Plant_Rice" stands next to "Nelim"
    And Fieldwork Companions: the scene decor "Plant_Rice" stands 2 cells right of and 1 cell below "Nelim"
    And Fieldwork Companions: the scene decor "TorchLamp" stands -3 cells right of and -2 cells below "Nelim"
    # The harvested plant leaves the frame; the second ripe plant stays in it, so the rice shows.
    And Nelim's Pickle Tools: I frame the animal "Rex" at zoom 4
    And Fieldwork Companions: the camera is placed so that "Nelim" stands -3 cells left of and 0 cells above the pointer
    And Nelim's Pickle Tools: the interface scale is 200 percent
    And Nelim's Pickle Tools: studio presentation mode is enabled
    When Fieldwork Companions: "Nelim" harvests the plant next to them
    Then Fieldwork Companions: a bonus mark floats over "Rex" within 20 seconds
    And game speed is paused
    And Fieldwork Companions: the picture settles for 4 real seconds
    When I take a screenshot "evening harvest, the mark over the companion"
    And Fieldwork Companions: the scene decor is cleared
    And I close all dialogs
    Then no errors were logged
