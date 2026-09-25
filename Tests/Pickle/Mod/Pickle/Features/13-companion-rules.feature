# _tools/FUNCTIONAL-SCENARIOS.md scenarios 2, 3, 4 and 11, played by Pickle instead of by hand.
#
# Who counts as a companion, how far it may stand, where the extra lands, how small it can be, and how the bond
# forms. Each rule is broken on its own with the same preset as 06-assists (always helps, largest share), so a
# scenario that shows "nothing" cannot be a scenario where the chance simply did not fall. The gesture is the
# vanilla call the job driver ends with, for the reasons given in FieldworkSteps.cs.
#
# Thresholds, from the vanilla 1.6 defs: MineableSteel yields 40, so the bonus at the largest share is 80 and a
# plain block gives at most 50; Plant_Rice yields 6, so the bonus is 12 and PlantCollected drops no base yield.
@part3
Feature: whose animal helps, how far it may stand, and where the extra lands

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists

  # Scenario 2. The follow-at-work box and the master are what make an animal a companion; another colonist's
  # animal standing right there is only an animal.
  Scenario: an animal that belongs to another colonist never helps
    Given a colonist "Other" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Other" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Rex"
    When Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    And Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"

  Scenario: an animal whose follow-at-work box is unticked never helps, though it keeps its master
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: "Rex" stops following at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Rex"

  # Scenario 3. Distance is measured from the worker, at the default radius of 8; the same distance is within reach
  # once the radius is 30.
  Scenario: an animal beyond the radius does not help, and does once the radius is widened
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: "Rex" stands 15 cells from "Miner"
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Rex"
    When Fieldwork Companions setting "radius" is set to "30"
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    And Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"

  # Scenario 4. The extra appears at the worked cell, not under the animal.
  Scenario: the extra ore lands where the block stood
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource within 2 cells of the target

  # Scenario 4, second half. The share floors at one: a companion that succeeds always turns up something.
  # 5 per cent of a rice plant's 6 is 0.3, and the mod rounds it up to 1.
  Scenario: a tiny share still turns up one unit, and no more
    Given Fieldwork Companions setting "bonusShare" is set to "0.05"
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained at least 1 of the noted resource
    And Fieldwork Companions: the map gained less than 2 of the noted resource

  # Scenario 11. The mod ties no relation of its own: it calls the game's TryDevelopBondRelation with the configured
  # chance on every successful assist. At the largest chance, 5 per cent, three thousand assists leave a bond
  # unformed with a probability that is not worth writing down; the loop stops at the first one.
  Scenario: working side by side ties the bond, through the game's own call
    Given Fieldwork Companions setting "bondChance" is set to "0.05"
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: "Miner" may bond with "Rex"
    When Fieldwork Companions: "Miner" mines beside "Rex" until they bond, at most 3000 times
    Then Fieldwork Companions: "Miner" and "Rex" are bonded
    And no errors were logged

  Scenario: with the bond chance at zero no bond forms
    Given Fieldwork Companions setting "bondChance" is set to "0"
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    When Fieldwork Companions: "Miner" mines beside "Rex" until they bond, at most 500 times
    Then Fieldwork Companions: "Miner" and "Rex" are not bonded
