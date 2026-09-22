# TESTING.md, family "assists": _tools/FUNCTIONAL-SCENARIOS.md scenarios 1, 4, 5 and 9, the part a
# running game can play for itself.
#
# What this settles is not the arithmetic (proved out of game) but that the patches fire in the
# runtime the game really uses, and that the mod's reads of three members that are not public in the
# real Assembly-CSharp (ResourceDef, ResourceAmount, GetSteps) succeed there. Those reads run under
# the access waiver in Source/AccessChecks.cs, whose cost on RimWorld's Mono has never been
# established: nobody has produced a Player.log with the exception in it. These scenarios are where
# it would show, as a MethodAccessException in the failure message of the milking one.
#
# The vanilla method each gesture ends with is called directly (see FieldworkSteps.cs for why). The
# size of the yield is the evidence: at the largest share the bonus is TWICE the nominal yield,
# which is more than the plain gesture can produce, so a threshold between the two says whether the
# companion helped. The numbers come from the vanilla 1.6 defs:
#
#   MineableSteel   mineableYield 40   -> bonus 80; a plain block gives at most 50 (stat cap 1.25)
#   Plant_Rice      harvestYield 6     -> bonus 12; PlantCollected drops no base yield, so a plain
#                                         call gives 0
#   Cow milk        8 per milking      -> bonus 16 on top of the 8 the pail always gives
#
# A def that changes in a game update moves these thresholds, and the failure message prints what
# the map actually gained.
#
# Fishing is not here, on purpose: it needs a water body with fish, which the shared test colony
# does not have. It stays a manual scenario, and TESTING.md says so.
Feature: a companion at hand makes the work turn up more, through the real hooks

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions always helps, at the largest share
    And a colonist "Miner" exists

  Scenario: mining, with an obedient companion at hand
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"
    And no errors were logged

  # Obedience is the floor: without it the game itself has the animal ignore its master.
  Scenario: mining, with a companion that has not learned obedience
    Given Fieldwork Companions: "Rex" is a "Husky" that follows "Miner" at work but has not learned obedience
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    And Fieldwork Companions: no bonus mark floats over "Rex"

  Scenario: mining, alone
    Given Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource

  Scenario: harvesting, with an obedient companion at hand
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained at least 12 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"

  Scenario: harvesting, alone
    Given Fieldwork Companions: a ripe "Plant_Rice" stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "RawRice"
    And Fieldwork Companions: "Miner" harvests the plant next to them
    Then Fieldwork Companions: the map gained less than 12 of the noted resource

  # The one that reads the two protected members of the real game. The pail always gives 8: a gain
  # of 16 or more can only be the companion.
  Scenario: milking, with an obedient companion at hand
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a cow "Bessie", full of milk, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained at least 16 of the noted resource
    And Fieldwork Companions: a bonus mark floats over "Rex"
    And no errors were logged

  Scenario: milking, alone
    Given Fieldwork Companions: a cow "Bessie", full of milk, stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Milk"
    And Fieldwork Companions: "Miner" milks the cow next to them
    Then Fieldwork Companions: the map gained less than 16 of the noted resource

  # The specialty gate, against the real DefDatabase: with the requirement on, mining wants the
  # Dig training Odyssey adds, and an obedient animal without it does not qualify even at 100 %.
  @requires:Odyssey
  Scenario: mining needs the Dig training when the requirement is on
    Given Fieldwork Companions requires the matching training
    And Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained less than 80 of the noted resource
    When Fieldwork Companions: "Rex" has learned the "Dig" training
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    And Fieldwork Companions notes what the map holds of "Steel"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: the map gained at least 80 of the noted resource

  # The mark lives about two seconds, so the camera is put on the companion before the gesture and
  # the capture is taken straight after it, with nothing waited in between. For a person to look at:
  # the +N should sit over the dog, be readable, and not be hidden behind the colonist.
  @review @requires:nelim.pickletools.filmticks
  Scenario: the mark over the companion that found the extra
    Given Fieldwork Companions: "Rex" is an obedient "Husky" that follows "Miner" at work
    And Fieldwork Companions: a "MineableSteel" rock stands next to "Miner"
    When Fieldwork Companions: the camera looks at "Rex"
    And I zoom all the way in
    And game speed is normal
    And Nelim's Pickle Tools: I film every 1 ticks as "companion-bonus-mark"
    And Fieldwork Companions: "Miner" brings down the rock next to them
    Then Fieldwork Companions: a bonus mark floats over "Rex"
    When Nelim's Pickle Tools: I stop filming
    And I take a screenshot "the mark over the companion"
