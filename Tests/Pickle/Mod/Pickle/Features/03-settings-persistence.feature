# TESTING.md, family "settings persistence": first use, and the real file.
#
# The Scribe round trip is proved out of game with the game's own saver and loader, and so are the
# clamps on older or out-of-range files. What only a running game shows is that the mod's real
# ModSettings is written where the game writes it, in the game's own culture handling, and that the
# game's own reader gives the values back.
#
# What stays manual, and cannot be otherwise from here: a real restart. The in-memory object still
# holds the values in this process, so a restart cannot be faked by re-reading the file.
Feature: settings are written to the game's own file and read back

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults

  # A float and an integer and a boolean, so a decimal separator or a boolean spelling that the game
  # writes differently from what the reader expects shows up here and nowhere else.
  Scenario: changed values reach the file and come back from it
    When Fieldwork Companions setting "baseChance" is set to "0.4"
    And Fieldwork Companions setting "radius" is set to "12"
    And Fieldwork Companions setting "showMote" is set to "False"
    And Fieldwork Companions settings are written to disk
    Then the Fieldwork Companions settings file records "baseChance" as "0.4"
    And the Fieldwork Companions settings file records "radius" as "12"
    And the Fieldwork Companions settings file records "showMote" as "False"
    And Fieldwork Companions reading its settings file back gives "baseChance" as "0.4"
    And Fieldwork Companions reading its settings file back gives "radius" as "12"
    And Fieldwork Companions reading its settings file back gives "showMote" as "False"
    And no errors were logged

  # The settings window writes when it closes; that is what "saved when this window closes" in the
  # page's own introduction promises, so it is checked through the window rather than by calling the
  # write directly.
  Scenario: closing the settings window saves what was changed
    When I open the Fieldwork Companions settings dialog
    And Fieldwork Companions setting "bondBonus" is set to "0.3"
    And I close all dialogs
    Then the Fieldwork Companions settings file records "bondBonus" as "0.3"
