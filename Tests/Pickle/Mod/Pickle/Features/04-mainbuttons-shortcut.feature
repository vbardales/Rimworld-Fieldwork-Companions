# TESTING.md, family "shortcut": the contract MOD_SETTINGS.md puts on the optional MainButtons entry.
#
# Available for a customization mod to reveal, hidden by default (neither visible nor greyed), and
# opening the SAME settings as Mod options. The def and its French fields are checked by the
# out-of-game harness; what only a game can answer is what the main bar's own worker does with them,
# and which mod the dialog that opens belongs to.
#
# What RIMMSQOL does when a player reveals the button is move MainButtonDef.buttonVisible. These
# scenarios move that same field and then ask RimWorld's own worker what the bar would draw. What
# stays manual, and cannot be otherwise from here: revealing it inside RIMMSQOL's own interface, and
# whether RIMMSQOL's visibility choice survives a restart. Both are RIMMSQOL's behaviour, and staging
# it would mean mounting a mod to test code that is not ours.
@requires:nelim.pickletools.screenshotmode
Feature: the hidden MainButtons shortcut opens this mod's own settings

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults
    And I close all dialogs

  # Both halves matter: a def can be drawn and still be dead, and a greyed shortcut is as forbidden
  # as a visible one.
  Scenario: hidden on a clean configuration, drawn and live once revealed, gone again when hidden
    Then the Fieldwork Companions shortcut is hidden on a clean configuration
    When Fieldwork Companions reveals its shortcut, as a customization mod would
    Then the Fieldwork Companions shortcut is drawn in the bar
    When Fieldwork Companions hides its shortcut again
    Then the Fieldwork Companions shortcut is not drawn in the bar

  # The real claim is not "a settings window opened" but "the same settings opened": a dialog built
  # for another mod is indistinguishable in a screenshot, so the window is asked which mod it is for.
  Scenario: activating it opens the settings of this mod and no other
    When Fieldwork Companions activates its shortcut
    Then Fieldwork Companions sees a settings dialog open for itself
    And no errors were logged
    When I close all dialogs

  # Same settings means same values: a change made through one door is there through the other.
  Scenario: a change made through the shortcut is there through Mod options
    When Fieldwork Companions activates its shortcut
    And Fieldwork Companions setting "baseChance" is set to "0.55"
    And I close all dialogs
    And I open the Fieldwork Companions settings dialog
    Then Fieldwork Companions setting "baseChance" reads "0.55"
    And the Fieldwork Companions settings file records "baseChance" as "0.55"
    When I close all dialogs

  @review
  Scenario: the settings page opened through the shortcut, for a person to look at
    When Fieldwork Companions activates its shortcut
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "settings page opened by the MainButtons shortcut"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
