# TESTING.md, family "settings page": what a player sees when opening Options -> Mod options ->
# Fieldwork Companions.
#
# @review throughout: these scenarios attach captures for a person to look at, and assert nothing
# about their content. Clipping, a control running past the window edge, a tooltip cut short and the
# layout at this resolution are things only an eye catches. Their green says the trip happened, not
# that the picture is right, and must not be counted as a visual check until someone has opened them.
#
# The page is a scrolling window of about thirty rows, so it is photographed twice: at the top and
# at the bottom. The bottom is where the radius, the bond chance, the mark checkbox and the reset
# button live, and the part most likely to be clipped in French.
#
# What the settings LOGIC does (clamps, defaults, reset, chance arithmetic) is proved out of game and
# is not repeated here.
@review @requires:nelim.pickletools.screenshotmode
Feature: the settings page, as a player sees it

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults
    And I close all dialogs

  Scenario: the top of the page
    When I open the Fieldwork Companions settings dialog
    Then Fieldwork Companions sees a settings dialog open for itself
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "settings page, top, as this pass runs it"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  # The film, plus the asserted scroll position, answers "does the page scroll" without a person
  # having to repeat the gesture. The capture remains for visual review of the bottom controls.
  @requires:nelim.pickletools.filmticks
  Scenario: the bottom of the page, with the reset button
    When I open the Fieldwork Companions settings dialog
    And game speed is normal
    And Nelim's Pickle Tools: I film every 1 ticks as "settings-page-scroll"
    And Fieldwork Companions scrolls its settings window to the bottom
    Then the Fieldwork Companions settings page has scrolled down
    When Nelim's Pickle Tools: I stop filming
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "settings page, bottom, as this pass runs it"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And Fieldwork Companions scrolls its settings window back to the top
    And I close all dialogs

  # The shared diagnostic click waits for the keyed control to settle, checks what window owns the
  # pointer, and names the covering window if the click is lost. The confirmation is cancelled, so
  # the settings sandbox never has to infer whether reset took effect.
  @requires:nelim.pickletools.clickdiagnostics
  Scenario: the reset button asks before it resets
    When I open the Fieldwork Companions settings dialog
    And Fieldwork Companions scrolls its settings window to the bottom
    And Nelim's Pickle Tools: the button keyed "FieldworkCompanions.Settings.Reset" has stood still
    And Nelim's Pickle Tools: the button keyed "FieldworkCompanions.Settings.Reset" is reachable in "Dialog_ModSettings"
    And Nelim's Pickle Tools: I click the button keyed "FieldworkCompanions.Settings.Reset" and the window "Dialog_MessageBox" opens
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "reset confirmation"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
