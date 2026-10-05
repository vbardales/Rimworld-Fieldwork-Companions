# scripts/FUNCTIONAL-SCENARIOS.md scenario 10, last paragraph, and scenario 16, "Odyssey is optional", played by
# Pickle instead of by hand: the pass that leaves Odyssey out.
#
# Without the DLC neither `Dig` nor `Forage` exists, so there is nothing to require: every obedient animal helps at
# the base chance. The mod looks the two trainings up by name and silently, so their absence must cost nothing:
# no error at startup, and a companion that still helps with the requirement ticked. The first scenario says the
# pass dropped only the DLC it meant to, which is what makes the other one worth reading.
#
# The second scenario does NOT load the shared save "test-colony": that save was made with Odyssey and holds an Orbit
# planet layer, which the game cannot read without the DLC (first play, 2026-09-28: NullReferenceException in
# PlanetLayer.InitializeLayer, then in WorldGrid.CreateRequiredLayers, the load never ended and both scenarios of the
# first version timed out after 175 s). It starts a new colony instead, which is what a player without the DLC has.
# A new colony is not reproducible and is played once, in a ticket of its own; the ticket passes
# -Extra "-pickle-scenario-timeout=400" (Pickle's watchdog kills at 120 s).
#
# Played by the pass `sans-odyssey`, whose map leaves the DLC out and stages the steps that read ModsConfig and start
# a colony:
#   -DepMap wsl-deps.sans-odyssey.map -Filter '17-without-odyssey.feature' -Extra "-pickle-scenario-timeout=400"
@requires:nelim.pickletools.expansions @requires:nelim.pickletools.newcolony @part3
Feature: without Odyssey the companion falls back on obedience alone

  Scenario: the pass really leaves Odyssey out, and only Odyssey
    Then Nelim's Pickle Tools: the expansion "Ludeon.RimWorld.Odyssey" is not active
    And mod "Ludeon.RimWorld.Odyssey" is not loaded
    And Nelim's Pickle Tools: the expansion "Ludeon.RimWorld.Ideology" is active
    And no def "Dig" exists
    And no def "Forage" exists
    And mod "nelim.fieldworkcompanions" is loaded
    And no errors were logged

  # The requirement is ticked and it changes nothing: the specialty is null when the game has none. The base chance is
  # what is left, with no step bonus: the intended degradation, not a failure.
  @timeout:240
  Scenario: an obedient animal helps with the requirement ticked, at the base chance, since no training exists to require
    Given the main menu is open
    And Nelim's Pickle Tools: the new colony's seed is "fieldwork-without-odyssey"
    When Nelim's Pickle Tools: a new colony is started
    And Nelim's Pickle Tools: any open message dialog is accepted
    And Nelim's Pickle Tools: the new colony's colonists have landed
    Given Fieldwork Companions always helps, at the largest share
    And Fieldwork Companions requires the matching training
    And a colonist "Miner" exists
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"
    Given Fieldwork Companions settings are at their documented defaults
    Then Fieldwork Companions: the chance of "Rex" helping "Miner" with Mining is 15 percent
    And Fieldwork Companions: the chance of "Rex" helping "Miner" with Harvest is 15 percent
    And no errors were logged
