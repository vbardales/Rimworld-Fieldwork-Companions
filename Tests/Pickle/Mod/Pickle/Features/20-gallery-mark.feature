# The photograph for the Workshop page: a companion beside a colonist at work, and the mark over it.
#
# Not a functional scenario: the assertions that the extra lands and the mark floats are in 06-assists, on the
# instantaneous call. This one is for a person, and it is STAGED (owner's rule of 2026-10-02: every gallery capture is a
# set-up photograph except the menus). The story is in PUBLICATION.md: Mara, a round and cosy miner in a mustard tuque
# and copper pigtails, took her husky Rex to work; the vein pays a little more than it should, and the camera catches Rex
# under the "+N". Her body, hair and clothes are chosen, never random.
#
# Scene: the Sanctuary of Nelim (fixture "Nelims-tribe", PickleTools/docs/GALERIE.md), place "emerald-clearing": a 14 x 14
# square of bare earth, the closest thing the map has to a quarry floor, with nothing to clear and no wall. Nelim, the only
# colonist of the fixture, is Virginie and is left alone: Mara is a guest colonist this scenario adds. The decor (two
# flowers) is placed relative to Mara and taken away again; nothing is emptied, cleared or razed.
#
# What to look for: Mara at the rock, Rex beside her, a readable "+N" over Rex, ore chunks on the ground, flowers at
# the foot of the scene, no tooltip, no other pawn in the frame. The vanometric power cell stands at the east edge of the
# square (x 205) and may show at the right of the frame: it belongs to the place.
@part2 @review @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: a companion beside a colonist at work

  Scenario: a real mining job, the animal beside the colonist, the mark over the animal
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Pickle Tools: I am at the sanctuary "emerald-clearing"
    And a colonist "Mara" exists
    And Nelim's Pickle Tools: "Mara" gender is female
    And Nelim's Pickle Tools: "Mara" body type is Fat
    And Nelim's Pickle Tools: "Mara" hairstyle is "Pigtails"
    And Nelim's Pickle Tools: "Mara" hair colour is rgb (190, 90, 40)
    And Nelim's Pickle Tools: "Mara" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Mara" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: "Mara" wears "Apparel_Tuque" dyed rgb (230, 170, 40)
    And Nelim's Pickle Tools: "Mara" stands at (195, 152)
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Mara" at work
    And Fieldwork Companions: a "MineableSteel" rock and "Rex" stand right beside "Mara"
    And Fieldwork Companions: the scene decor "Plant_Daylily" stands 0 cells right of and 3 cells below "Mara"
    And Fieldwork Companions: the scene decor "Plant_Dandelion" stands 2 cells right of and 3 cells below "Mara"
    And Fieldwork Companions: the camera is placed so that "Mara" stands 5 cells left of and 3 cells above the pointer
    And I zoom all the way in
    When Fieldwork Companions: "Mara" is ordered to mine the rock beside them
    And game speed is ultrafast
    And Fieldwork Companions: the rock beside "Mara" is nearly mined within 240 seconds
    And game speed is normal
    Then Fieldwork Companions: a bonus mark floats over "Rex" within 120 seconds
    When I take a screenshot "the companion at work, the mark over it"
    And Fieldwork Companions: the scene decor is cleared
    And I close all dialogs
    Then no errors were logged
