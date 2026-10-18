# The photograph for the Workshop page, image 2 of the series: noon on the river bank, Nelim fishing with Rex at her side.
#
# STORY (criterion k, shotlist v2 in STATUS.md): same day as 20 (dawn at the jade). Episode 2, noon (hour 12): at the pond,
# bare-headed, a blue shirt and cream trousers; Rex at her feet. Episode 3 (23) is the evening at the rice.
#
# The story of the series is in PUBLICATION.md ("A day on the river bank"): morning at the jade (20-gallery-mark), noon fishing
# (this one), evening foraging. Nelim, bare-headed this time (the tuque is for the stone dust), her hair in the light, a plain
# smile; Rex at her feet; a fish rack and a pile of fishing gear from Fishing Village Decor and Props (zal.fishprops) on the
# bank. The catch is cast on the Sanctuary's real river, stocked with fish like the lake of 16-fishing; the camera catches the "+N".
#
# STAGED, like image 1 (GALLERY.md). Nothing here is a functional assertion: those are in 16-fishing.
@part2 @review @requires:Odyssey @requires:zal.fishprops @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.interfacescale @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: noon on the river bank, a companion beside a fishing colonist

  Scenario: a fish is landed, the companion beside the colonist, the mark over the companion
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Sanctuary: I am at the sanctuary "right-bank"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "right-bank"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: the temperature of the map is 21 degrees
    And Nelim's Pickle Tools: "Nelim" stands at (144, 131) facing West
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: the area from (142, 127) to (149, 134) is cleared
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthSmile"
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Nelim" at work
    And Nelim's Pickle Tools: "Rex" faces South
    # No step sets an animal's facing: Rex faces where he is heading. Check the capture before any verdict.
    And Fieldwork Companions: the scene decor "FishRack" stands 2 cells right of and 2 cells below "Nelim"
    And Fieldwork Companions: the scene decor "FishGear" stands 0 cells right of and 2 cells below "Nelim"
    And Fieldwork Companions: the water beside "Nelim" holds fish
    And Nelim's Pickle Tools: I frame the animal "Rex" at zoom 5
    And Nelim's Pickle Tools: the interface scale is 200 percent
    And Nelim's Pickle Tools: studio presentation mode is enabled
    # "at the lake" is the shared fishing step's wording (16-fishing); the picture is on the river bank.
    When Fieldwork Companions: "Nelim" fishes at the lake
    Then Fieldwork Companions: a bonus mark floats over "Rex" within 20 seconds
    And game speed is paused
    And Fieldwork Companions: the picture settles for 4 real seconds
    When I take a screenshot "noon fishing, the mark over the companion"
    And Fieldwork Companions: the scene decor is cleared
    And I close all dialogs
    Then no errors were logged
