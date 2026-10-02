# The photograph for the Workshop page: a companion beside a colonist at work, and the mark over it.
#
# Not a functional scenario: the assertions that the extra lands and the mark floats are in 06-assists, on the
# instantaneous call. This one is for a person, and it is STAGED (owner's rule of 2026-10-02: every gallery capture is a
# set-up photograph except the menus). The story is in PUBLICATION.md: Mara, a round and cosy miner in a mustard tuque
# and copper pigtails, took her husky Rex to work; the vein pays a little more than it should, and the camera catches Rex
# under the "+N". Her body, hair and clothes are chosen, never random; a lit torch and two flowers stand about the vein
# and are taken away again after the shot.
#
# The decor cells are relative to Mara (her cell is not known in advance). If one is not free the step says which, and
# the offset is moved: that is what the first scouting run is for.
#
# What to look for: Mara at the rock, Rex beside her, a readable "+N" over Rex, ore chunks on the ground, the torch lit,
# the flowers at the foot of the rock, no tooltip, no other pawn, no filth in the frame.
@part2 @review @requires:nelim.pickletools.colonistrace @timeout:240
Feature: a companion beside a colonist at work

  Scenario: a real mining job, the animal beside the colonist, the mark over the animal
    Given the save "test-colony" is loaded
    And game speed is paused
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Mara" exists
    And Nelim's Pickle Tools: "Mara" body type is Fat
    And Nelim's Pickle Tools: "Mara" hairstyle is "Pigtails"
    And Nelim's Pickle Tools: "Mara" hair colour is rgb (190, 90, 40)
    And Nelim's Pickle Tools: "Mara" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Mara" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: "Mara" wears "Apparel_Tuque" dyed rgb (230, 170, 40)
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Mara" at work
    And Fieldwork Companions: a "MineableSteel" rock and "Rex" stand right beside "Mara"
    And Fieldwork Companions: the scene decor "TorchLamp" stands 3 cells right of and 0 cells below "Mara"
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
