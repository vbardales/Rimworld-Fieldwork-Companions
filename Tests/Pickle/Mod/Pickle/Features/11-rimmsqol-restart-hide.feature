# RIMMSQOL chain, launch 2 of 3: hide. A NEW process, which read RIMMSQOL's settings file at startup: the
# shortcut revealed by launch 1 must be drawn without anything having revealed it in THIS process. The first
# step refuses to pass when launch 1 ran in this same process. Then it is hidden again, and that choice is kept
# for launch 3.
#
# See 10-rimmsqol-restart-reveal.feature for the command and for what is left behind if the chain is cut.
@review @rimmsqol @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.screenshotstudio
Feature: a choice made in RIMMSQOL is written for the next launch (2 of 3, hide)

  Scenario: the revealed shortcut survived the restart, then RIMMSQOL hides it again
    Given the save "nelim-zen-meadow-studio" is loaded
    And game speed is paused
    And Nelim's Pickle Tools: I frame the studio "zen"
    And I close all dialogs
    And RIMMSQOL is ready to be driven
    And the choices RIMMSQOL kept in the previous launch are in place
    Then RIMMSQOL shows the main button "FieldworkCompanions_Settings" as visible
    And RIMMSQOL's settings file records the main button "FieldworkCompanions_Settings" as visible
    And the main bar draws the button "FieldworkCompanions_Settings"
    When RIMMSQOL's own window is opened on the main button "FieldworkCompanions_Settings"
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "rimmsqol, edit page of the fieldwork companions shortcut, revealed before this restart"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    When RIMMSQOL hides the main button "FieldworkCompanions_Settings"
    Then the main bar does not draw the button "FieldworkCompanions_Settings"
    And RIMMSQOL's settings file records the main button "FieldworkCompanions_Settings" as hidden
    And no errors were logged
    And RIMMSQOL's choices are kept for the next launch
