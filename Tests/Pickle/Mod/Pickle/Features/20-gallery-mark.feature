# The picture for the Workshop page: a companion beside a colonist at work, and the mark over it.
#
# Not a functional scenario: the assertions that the extra lands and the mark floats are in 06-assists, on the
# instantaneous call. This one is for a person. The colonist mines a real rock through the game's own job, the animal
# that follows its master at work stands beside them, and the picture is taken the moment the mark is over the animal.
#
# What to look for: the colonist at the rock, the animal next to them, a readable "+N" over the animal, a few chunks of
# ore on the ground, the three of them large enough in the frame to tell who is who.
@part2 @review @timeout:240
Feature: a companion beside a colonist at work

  Scenario: a real mining job, the animal beside the colonist, the mark over the animal
    Given the save "test-colony" is loaded
    And game speed is paused
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock and "Rex" stand right beside "Miner"
    And Fieldwork Companions: the camera is placed so that "Miner" stands 5 cells left of and 3 cells above the pointer
    And I zoom all the way in
    When Fieldwork Companions: "Miner" is ordered to mine the rock beside them
    And game speed is ultrafast
    And Fieldwork Companions: the rock beside "Miner" is nearly mined within 240 seconds
    And game speed is normal
    Then Fieldwork Companions: a bonus mark floats over "Rex" within 120 seconds
    When I take a screenshot "the companion at work, the mark over it"
    And I close all dialogs
    Then no errors were logged
