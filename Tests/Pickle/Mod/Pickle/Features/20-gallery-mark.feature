# The photograph for the Workshop page: a companion beside a colonist at work, and the mark over it.
#
# Not a functional scenario: the assertions that the extra lands and the mark floats are in 06-assists, on the
# instantaneous call. This one is for a person, and it is STAGED (owner's rule of 2026-10-02: every gallery capture is a
# set-up photograph except the menus). The story is in PUBLICATION.md: Nelim, a round and cosy miner in a mustard tuque
# and copper pigtails, took her husky Rex to work; the vein pays a little more than it should, and the camera catches Rex
# under the "+N". Her body, hair and clothes are chosen, never random.
#
# Scene: the Sanctuary of Nelim (fixture "Nelims-tribe", in the SanctuaryBacklot repository: SanctuaryBacklot/docs/GALERIE.md), place "gravel-yard": a flat 35 x 25
# yard of gravel, the closest thing the map has to a quarry floor (the first try on "emerald-clearing", 2026-10-06, stood on
# a viridian carpet, with the HUD drawn and horses in the frame). The place is emptied of its furniture and animals, as
# GALERIE.md allows; no bamboo is cleared. Nelim, the only colonist of the fixture, is Virginie and is left alone: Nelim is a
# guest colonist this scenario adds. The decor (two stone chunks) is placed relative to Nelim and taken away again.
#
# Step prefixes: "Nelim's Sanctuary:" steps belong to SanctuaryBacklot (the place: frame, empty, animals of a place); "Nelim's Pickle Tools:"
# steps belong to PickleTools (NPT: pawn, interface scale, presentation mode, framing an animal); "Fieldwork Companions:" steps are
# this suite's own. Pass map: Tests/Pickle/wsl-deps.sanctuary.map (the Backlot's minimum mod list plus three tools).
#
# What to look for: Nelim at the rock, Rex beside her, a readable "+N" over Rex, ore chunks on the ground, stone chunks at
# the foot of the scene, no HUD (presentation mode), no tooltip, no other pawn or animal in the frame, and the three
# of them large enough to tell who is who.
@part2 @review @requires:ab.vplrf @requires:nelim.pickletools.interfacescale @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: a companion beside a colonist at work

  Scenario: a real mining job, the animal beside the colonist, the mark over the animal
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Sanctuary: I am at the sanctuary "gravel-yard"
    And Nelim's Sanctuary: the sanctuary "gravel-yard" is emptied
    And Nelim's Sanctuary: the animals are removed from the sanctuary "gravel-yard"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: the temperature of the map is 21 degrees
    And Nelim's Pickle Tools: "Nelim" stands at (178, 143)
    And Fieldwork Companions: "Nelim" is cured of every chronic condition
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Tuque" dyed rgb (230, 170, 40)
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Nelim" at work
    And Fieldwork Companions: a "MineableJade" rock and "Rex" stand right beside "Nelim"
    And Fieldwork Companions: the scene decor "ChunkSlate" stands 0 cells right of and 3 cells below "Nelim"
    And Fieldwork Companions: the scene decor "ChunkLimestone" stands 2 cells right of and 3 cells below "Nelim"
    And Fieldwork Companions: the scene decor "TorchLamp" stands 3 cells right of and 1 cells below "Nelim"
    And Nelim's Pickle Tools: I frame the animal "Rex" at zoom 4
    And Fieldwork Companions: the camera is placed so that "Nelim" stands 2 cells left of and 0 cells above the pointer
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
