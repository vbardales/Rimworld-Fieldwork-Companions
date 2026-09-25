# TESTING.md, family "save": _tools/FUNCTIONAL-SCENARIOS.md scenario 13, the part a running game can
# settle.
#
# README promises that nothing is written to the save, so that the mod can be added to or removed
# from a game in progress. That is a claim about a file, and the file only exists once a game has
# saved one. The save is written after an assist has happened, since that is the moment the mod
# would have had something to remember.
#
# What stays manual, and cannot be otherwise from here: loading a save made WITHOUT the mod with it
# added, and one made WITH it with it removed. Pickle stages one mod set per run.
@part2
Feature: the mod leaves nothing in the save

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists

  Scenario: after an assist, the saved game holds nothing of the mod and reloads cleanly
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions: "Miner" brings down the rock next to them
    And I save and reload as "fieldwork-companions-roundtrip"
    Then the saved game "fieldwork-companions-roundtrip" holds nothing written by Fieldwork Companions
    And no errors were logged
