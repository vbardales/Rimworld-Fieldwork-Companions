# The photograph for the Workshop page: a companion beside a colonist at work, and the mark over it.
#
# STORY (criterion k, shotlist v3 in STATUS.md, 2026-10-25): one day for Nelim, the Sanctuary's only colonist, and her husky Rex, on the
# east side. Same teal shirt and ochre trousers all day, long loose hair "Flowy"; the mustard tuque is for the stone dust, at dawn only.
# Episode 1, dawn (hour 7, low light, lit TorchLamp): OPENING WIDE shot (zoom 8) at a jade vein on the cleared bare patch.
# Instant: the pickaxe has just come down, the rock is at 20 percent, the "+N" has just risen over Rex, who looks back (faces South,
# the one front view of the series) toward the path they came by; one Jade item is already at her feet (the haul so far).
# Face: brows squared, mouth neutral (effort; the plan's justification for a non-smile). Next: 22 at noon on the bank, 23 at the rice.
#
# Not a functional scenario: the assertions that the extra lands and the mark floats are in 06-assists, on the
# instantaneous call. This one is for a person, and it is STAGED (owner's rule of 2026-10-02: every gallery capture is a
# set-up photograph except the menus). The story is in PUBLICATION.md: Nelim, in work clothes and a mustard tuque, took her
# husky Rex to the jade vein; the vein pays a little more than it should, and the camera catches the "+N" as the block comes down.
#
# Scene: the Sanctuary of Nelim (fixture "Nelims-tribe", in the SanctuaryBacklot repository: SanctuaryBacklot/docs/GALERIE.md), place "bare-clearing" (2026-10-18, SANCTUAIRE-LIEUX): the east
# bank of the river, grass, bushes and a few red-leaved trees, the water and the wooden bridge in the frame (2026-10-13: the
# "gravel-yard" take showed bare soil and no setting, and the mark drifted away from the dog). The place is NOT
# emptied (its plants are the setting); only its animals are removed. Nelim, the
# only colonist of the fixture, is Virginie: on her instruction of 2026-10-08 she is the colonist of the photograph. Her
# looks are left alone except the clothes (teal shirt, ochre pants, mustard tuque); for the run only she is cured of her
# chronic conditions (Asthma and a bad back made her too slow, run 91fa) and the map is held at 21 degrees (heat step of
# NPT, not yet proven). The decor (two stone chunks) is placed relative to Nelim and taken away again.
#
# Step prefixes: "Nelim's Sanctuary:" steps belong to SanctuaryBacklot (the place: frame, empty, animals of a place); "Nelim's Pickle Tools:"
# steps belong to PickleTools (NPT: pawn, interface scale, presentation mode, framing an animal, temperature); "Fieldwork Companions:" steps are
# this suite's own. Pass map: Tests/Pickle/wsl-deps.sanctuary.map (the Backlot's minimum mod list, with Show Hair Under Stuff, plus three tools).
#
# What to look for: Nelim at the vein, Rex beside her, a readable "+N" over Rex, jade on the ground, the stone
# chunks at the foot of the scene, hair visible under the tuque, no HUD (presentation mode), no tooltip, no other pawn or
# animal in the frame.
@part2 @review @requires:nelim.pickletools.stagedecor @requires:ab.vplrf @requires:nelim.pickletools.interfacescale @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: a companion beside a colonist at work

  Scenario: a real mining job, the animal beside the colonist, the mark over the animal
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 7
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the floor of the sanctuary "bare-clearing" is bared
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: the temperature of the map is 21 degrees
    And Nelim's Pickle Tools: "Nelim" stands at (195, 152)
    And Fieldwork Companions: "Nelim" is cured of every chronic condition
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Tuque" dyed rgb (230, 170, 40)
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Flowy"
    And Nelim's Pickle Tools: the area from (191, 147) to (204, 157) is cleared
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" brows are "BrowSquare"
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthNormal"
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Nelim" at work
    And Nelim's Pickle Tools: the animal "Rex" stands at (195, 150) facing South
    And Nelim's Pickle Tools: I advance the paused game by exactly 10 ticks
    And Fieldwork Companions: a "MineableJade" rock and "Rex" stand right beside "Nelim"
    And Fieldwork Companions: the scene decor "Jade" stands 0 cells right of and 3 cells below "Nelim"
    And Fieldwork Companions: the scene decor "TorchLamp" stands 4 cells left of and 1 cell below "Nelim"
    And Nelim's Pickle Tools: I frame the animal "Rex" at zoom 8
    And Fieldwork Companions: the camera is placed so that "Nelim" stands 3 cells left of and 0 cells above the pointer
    And Nelim's Pickle Tools: the interface scale is 200 percent
    And Nelim's Pickle Tools: studio presentation mode is enabled
    When Fieldwork Companions: "Nelim" is ordered to mine the rock beside them
    And game speed is ultrafast
    And Fieldwork Companions: the rock beside "Nelim" is nearly mined within 240 seconds
    Then Fieldwork Companions: a bonus mark floats over "Rex" within 140 seconds
    And game speed is paused
    And Fieldwork Companions: the picture settles for 4 real seconds
    When I take a screenshot "the companion at work, the mark over it"
    And Fieldwork Companions: the scene decor is cleared
    And I close all dialogs
    Then no errors were logged
