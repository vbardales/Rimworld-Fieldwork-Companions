# _tools/FUNCTIONAL-SCENARIOS.md scenarios 9 (shearing) and 12 (the switches), played by Pickle instead of by hand.
#
# Each work switch turns off one gesture and leaves the others alone: a switch that also silenced its neighbours,
# or that did nothing, is the failure. Mining is asserted against 80, a rice harvest against 12, a milking against
# 16 and a shearing against 90: a sheep gives 45 wool by vanilla's defs, so the bonus at the largest share is 90.
# The fishing switch is in 16-fishing.feature, next to the lake it needs.
Feature: the work switches, and shearing

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work

  Scenario: with mining switched off, mining gets nothing and harvesting and milking still help
    Given Fieldwork Companions setting "assistMining" is set to "False"
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    Given Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained at least 12 of the noted resource
    Given Fieldwork Companions: a cow "Bessie", full of milk, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained at least 16 of the noted resource

  Scenario: with harvesting switched off, harvesting gets nothing and mining and milking still help
    Given Fieldwork Companions setting "assistHarvest" is set to "False"
    And Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained less than 12 of the noted resource
    Given Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    Given Fieldwork Companions: a cow "Bessie", full of milk, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained at least 16 of the noted resource

  # Milking and shearing share one switch: the one gesture patch covers both.
  Scenario: with milking and shearing switched off, neither helps and mining and harvesting still do
    Given Fieldwork Companions setting "assistGathering" is set to "False"
    And Fieldwork Companions: a cow "Bessie", full of milk, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained less than 16 of the noted resource
    Given Fieldwork Companions: a sheep "Woolly", full of wool, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "WoolSheep"
    And Fieldwork Companions: "Miner" shears the sheep next to them
    Then Fieldwork Companions: the map gained less than 90 of the noted resource
    Given Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    Given Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained at least 12 of the noted resource

  # Scenario 9, shearing: extra wool beside the sheep, the mark over the companion.
  Scenario: shearing with a companion at hand turns up extra wool
    Given Fieldwork Companions: a sheep "Woolly", full of wool, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "WoolSheep"
    And Fieldwork Companions: "Miner" shears the sheep next to them
    Then Fieldwork Companions: the map gained at least 90 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"

  Scenario: shearing with the companion too far away gives only the plain wool
    Given Fieldwork Companions: "Rex" stands 15 cells from "Miner"
    And Fieldwork Companions: a sheep "Woolly", full of wool, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "WoolSheep"
    And Fieldwork Companions: "Miner" shears the sheep next to them
    Then Fieldwork Companions: the map gained at least 1 of the noted resource
    And Fieldwork Companions: the map gained less than 90 of the noted resource
