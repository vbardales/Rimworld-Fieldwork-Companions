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
@review
Feature: the settings page, as a player sees it

  Background:
    Given the save "test-colony" is loaded
    And Fieldwork Companions settings are at their documented defaults
    And I close all dialogs

  Scenario: the top of the page
    When I open the Fieldwork Companions settings dialog
    Then Fieldwork Companions sees a settings dialog open for itself
    When Fieldwork Companions hides the interface around the windows on screen
    And I take a screenshot "settings page, top, as this pass runs it"
    And Fieldwork Companions brings the interface back
    And I close all dialogs

  # @film: this is the scenario that answers "does the page scroll", so it leaves a filmstrip of the
  # steps as well as the two captures. The scroll position is also asserted, with viewHeight in the
  # message, so the answer does not rest on a picture alone.
  @film
  Scenario: the bottom of the page, with the reset button
    When I open the Fieldwork Companions settings dialog
    And Fieldwork Companions scrolls its settings window to the bottom
    Then the Fieldwork Companions settings page has scrolled down
    When Fieldwork Companions hides the interface around the windows on screen
    And I take a screenshot "settings page, bottom, as this pass runs it"
    And Fieldwork Companions brings the interface back
    And Fieldwork Companions scrolls its settings window back to the top
    And I close all dialogs

  # @wip: the reset button sits at the bottom of a scroll view, and a Pickle click needs its rect on
  # screen and tagged. Never run; if the click does not resolve, the failure will say so and this
  # is the scenario to correct. The confirmation is cancelled, so nothing is reset.
  @wip
  Scenario: the reset button asks before it resets
    When I open the Fieldwork Companions settings dialog
    And Fieldwork Companions scrolls its settings window to the bottom
    And I click button "FieldworkCompanions.Settings.Reset"
    Then window "Dialog_MessageBox" is open
    When I take a screenshot "reset confirmation"
    And I close all dialogs
