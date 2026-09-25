# _tools/FUNCTIONAL-SCENARIOS.md scenario 10, last paragraph, and scenario 16, "Odyssey is optional", played by
# Pickle instead of by hand: the pass that leaves Odyssey out.
#
# Without the DLC neither `Dig` nor `Forage` exists, so there is nothing to require: every obedient animal helps at
# the base chance. The mod looks the two trainings up by name and silently, so their absence must cost nothing:
# no error at startup, and a companion that still helps with the requirement ticked. The first scenario says the
# pass dropped only the DLC it meant to, which is what makes the other two worth reading.
#
# Played by the pass `sans-odyssey`, whose map leaves the DLC out and stages the two steps that read ModsConfig:
#   -DepMap wsl-deps.sans-odyssey.map -Filter '17-without-odyssey.feature'
@requires:nelim.pickletools.expansions @part3
Feature: without Odyssey the companion falls back on obedience alone

  Scenario: the pass really leaves Odyssey out, and only Odyssey
    Then Nelim's Pickle Tools: the expansion "Ludeon.RimWorld.Odyssey" is not active
    And mod "Ludeon.RimWorld.Odyssey" is not loaded
    And Nelim's Pickle Tools: the expansion "Ludeon.RimWorld.Ideology" is active
    And no def "Dig" exists
    And no def "Forage" exists
    And mod "nelim.fieldworkcompanions" is loaded
    And no errors were logged

  # The requirement is ticked, and it changes nothing: the specialty is null when the game has none.
  Scenario: an obedient animal helps with the requirement ticked, since no training exists to require
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And Fieldwork Companions requires the matching training
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"
    And no errors were logged

  # The chance is the base rate, with no step bonus: the intended degradation, not a failure.
  Scenario: the chance is the base rate
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    Then Fieldwork Companions: the chance of "Rex" helping "Miner" with Mining is 15 percent
    And Fieldwork Companions: the chance of "Rex" helping "Miner" with Harvest is 15 percent
