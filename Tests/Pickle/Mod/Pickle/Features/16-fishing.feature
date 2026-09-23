# _tools/FUNCTIONAL-SCENARIOS.md scenario 8, played by Pickle instead of by hand.
#
# Fishing is Odyssey's, and the shared test colony has no water body with fish, so each scenario builds a lake of
# 21 by 21 deep-water cells next to the colonist (see FieldworkRulesSteps.LakeNear). The vanilla method the mod's
# postfix hangs on, FishingUtility.GetCatchesFor, is then called on a cell of that lake, which is what the fishing
# job driver does when the line comes up. A rare catch replaces the whole list and is cast again: the assertions
# are about an ordinary catch.
#
# "One extra fish" is exact: one unit, of a kind that was actually landed, whatever the size of the haul. The
# fishing switch, and an animal fishing on its own, are the two ways it must not happen.
@requires:Odyssey
Feature: a companion turns up one extra fish

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a lake lies near "Miner"

  Scenario: fishing with a companion at hand lands exactly one extra fish
    When Fieldwork Companions: "Miner" fishes at the lake
    Then Fieldwork Companions: the catch holds one extra fish, a single unit of a kind that was landed
    And Fieldwork Companions: a bonus mark floats over "Rex"
    And no errors were logged

  # The fishing switch turns off this gesture and no other.
  Scenario: with fishing switched off the catch is only what was landed
    Given Fieldwork Companions setting "assistFishing" is set to "False"
    When Fieldwork Companions: "Miner" fishes at the lake
    Then Fieldwork Companions: the catch holds nothing beyond what was landed
    And Fieldwork Companions: no bonus mark floats over "Rex"

  # `animalFishing` keeps a companion from assisting another animal: here the fisher is an animal, and a second
  # companion of the colonist stands by.
  Scenario: an animal fishing on its own is never assisted
    Given Fieldwork Companions: "Fido" is an obedient "Husky" that follows "Miner" at work
    When Fieldwork Companions: the animal "Rex" fishes at the lake
    Then Fieldwork Companions: the catch holds nothing beyond what was landed
    And Fieldwork Companions: no bonus mark floats over "Fido"
