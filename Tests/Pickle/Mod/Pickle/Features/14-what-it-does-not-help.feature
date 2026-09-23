# _tools/FUNCTIONAL-SCENARIOS.md scenarios 5 (cutting), 6, 7, 9 (the cow) and 14, played by Pickle instead of by hand.
#
# What a companion must NOT help with, and the promise that a colony with no companion plays as it would without
# the mod. Every one of these is a guard that is one line of code, and a guard that is gone leaves no symptom
# anywhere else: a deep drill that pays, a digging animal that qualifies as a miner, a cow that milks itself.
#
# Thresholds are those of 06-assists: 80 for a steel block, 12 for a rice plant, 16 for a milking.
Feature: what a companion does not help with

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists

  # Scenario 6. The drill spawns its yield itself and never goes through Mineable.DestroyMined. The portion is
  # asserted to have appeared at all, so that an empty drill cannot make the scenario pass.
  Scenario: a deep drill gets nothing from a companion beside it
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a deep drill over a steel deposit stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: the deep drill next to "Miner" produces a portion
    Then Fieldwork Companions: the map gained at least 1 of the noted resource
    And Fieldwork Companions: the map gained less than 80 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Rex"

  # Scenario 5, the second half. Cutting a plant down is not harvesting, and the job def is what says so: the same
  # plant, the same companion at hand, the same call, and nothing. `06-assists` shows the harvest paying 12.
  Scenario: cutting a plant down gets nothing from a companion beside it
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" cuts the plant next to them
    Then Fieldwork Companions: the map gained less than 1 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Rex"

  # Scenario 7. Since Odyssey an animal trained to dig mines on its own, and DestroyMined receives it in the same
  # parameter as a colonist. Without the humanlike guard, a digging animal would pass for the worker and another
  # obedient animal of the same master would "assist" it.
  @requires:Odyssey
  Scenario: an animal that mines on its own is never assisted
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: "Rex" has learned the "Dig" training
    And Fieldwork Companions: "Fido" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: the animal "Rex" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Fido"
    And Fieldwork Companions: no bonus mark floats over "Rex"

  # Scenario 9, "the one that matters". The animal being milked is passed as `exclude` to the companion search: it is
  # the only gesture where the subject of the work is itself a candidate, and the exclusion is what stops a herd
  # from paying itself. The plain milk is asserted to have appeared, for the same reason as the drill's portion.
  Scenario: a cow that is its master's companion does not help milk itself
    Given Fieldwork Companions: "Bessie" is a milk cow of "Miner", granted obedience directly, following at work
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained at least 1 of the noted resource
    And Fieldwork Companions: the map gained less than 16 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Bessie"

  # Scenario 14. With no companion at all the mod must change nothing: no mark, no extra, and above all the
  # plant patch, which runs on every harvest of the game, must draw nothing from the random generator. The
  # symptom of a draw would be a save seed that no longer reproduces, which nobody would trace back here.
  Scenario: with no companion at all, mining, harvesting and milking give only their plain yield
    Given Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    Given Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained less than 12 of the noted resource
    Given Fieldwork Companions: a cow "Bessie", full of milk, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained less than 16 of the noted resource
    And Fieldwork Companions: no bonus mark floats anywhere
    Given Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    Then Fieldwork Companions: the plant patch draws nothing from the random generator for "Miner" when no companion is at hand
    And no errors were logged
