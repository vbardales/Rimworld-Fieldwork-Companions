# TESTING.md, family "chance": _tools/FUNCTIONAL-SCENARIOS.md scenarios 10 and 11, in the one respect
# a running game can add.
#
# The formula (base + steps * bonus + bond, capped at 100 %) is proved out of game against the
# delivered DLL. What is not, is the per-step part: it reads the number of steps of a training from
# Pawn_TrainingTracker.GetSteps, which is INTERNAL in the real Assembly-CSharp and reached under the
# access waiver. An answer here, with a trained animal, means that read works in the running game.
#
# The defaults are asserted, so this feature starts from them; the other features use the 100 % preset.
Feature: the chance follows the training and the bond

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work

  Scenario: an obedient companion with no further training
    Then Fieldwork Companions: the chance of "Rex" helping "Miner" with Mining is 15 percent
    And Fieldwork Companions: the chance of "Rex" helping "Miner" with Fishing is 15 percent

  # Bonded, 15 + 15. Fishing has no training, so the steps count for nothing there.
  Scenario: bonded, the chance rises
    Given Fieldwork Companions: "Rex" is bonded to "Miner"
    Then Fieldwork Companions: the chance of "Rex" helping "Miner" with Fishing is 30 percent
    And Fieldwork Companions: the chance of "Rex" helping "Miner" with Gathering is 30 percent

  # Dig has three steps: 15 + 3 * 10 = 45, and 60 when bonded. Harvesting looks at Forage, which this
  # animal has not learned, so it stays at the base.
  @requires:Odyssey
  Scenario: a fully trained, bonded companion reaches the documented ceiling
    Given Fieldwork Companions: "Rex" has learned the "Dig" training
    Then Fieldwork Companions: the chance of "Rex" helping "Miner" with Mining is 45 percent
    And Fieldwork Companions: the chance of "Rex" helping "Miner" with Harvest is 15 percent
    When Fieldwork Companions: "Rex" is bonded to "Miner"
    Then Fieldwork Companions: the chance of "Rex" helping "Miner" with Mining is 60 percent
    And no errors were logged
