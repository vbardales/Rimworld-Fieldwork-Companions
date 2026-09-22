# TESTING.md, family "language": the half of the translation check that only a running game settles.
#
# The language is never switched inside a scenario. SelectLanguage clears and reloads every def and
# pulls the game out from under the runner, so the language is chosen at launch and this feature
# asserts against whichever language the pass runs. Covering both languages therefore takes two
# passes:
#
#   Run-PickleWsl.ps1 -Mod FieldworkCompanions
#   Run-PickleWsl.ps1 -Mod FieldworkCompanions -Language French
#
# The French one is the one that matters, and it needs looking at rather than counting. In developer
# mode, which every Pickle run is, a key missing from the active language does not fall back to
# plain English: it comes out accented letter by letter (a -> a-grave, c -> c-cedilla, n -> n with a
# hook). Accented gibberish means a missing key; clean English inside a French interface means a
# literal that never went through Translate. The assertions catch the first, only the capture
# catches the second, and a capture taken without developer mode proves nothing about either.
@review @requires:nelim.pickletools.screenshotmode
Feature: the settings page and the shortcut, in the language this pass runs

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults
    And I close all dialogs

  Scenario: every text the mod owns exists in the language of this pass
    Then every Fieldwork Companions text exists in the language this pass runs
    And Fieldwork Companions key "FieldworkCompanions.Settings.Intro" does not read as a raw key
    And Fieldwork Companions key "FieldworkCompanions.Settings.RequireSpecialtyTip" does not read as a raw key
    And Fieldwork Companions key "FieldworkCompanions.Settings.ConfirmReset" does not read as a raw key

  # DefInjected, not Keyed: the shortcut's own description comes from the Def in English and from
  # Languages/French/DefInjected in French. The step asserts the one written for the language of the
  # pass, and says so plainly when the pass runs a language the mod does not ship.
  Scenario: the shortcut reads as written for this language
    Then the Fieldwork Companions shortcut reads as written for the language this pass runs

  Scenario: the settings page, top and bottom, in this language
    When I open the Fieldwork Companions settings dialog
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "language, settings page top"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And Fieldwork Companions scrolls its settings window to the bottom
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "language, settings page bottom"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And Fieldwork Companions scrolls its settings window back to the top
    And I close all dialogs
