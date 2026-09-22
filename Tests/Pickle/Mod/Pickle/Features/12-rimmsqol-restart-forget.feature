# RIMMSQOL chain, launch 3 of 3: forget. A third process: hiding the shortcut, the choice launch 2 kept, must
# have survived a restart as well, and the last steps put RIMMSQOL back so the profile is left as it was found.
# The teardown would do it anyway; this scenario says it and checks the file.
#
# See 10-rimmsqol-restart-reveal.feature for the command and for what is left behind if the chain is cut.
@rimmsqol
Feature: a choice made in RIMMSQOL is written for the next launch (3 of 3, forget)

  Scenario: hiding the shortcut survived the restart, and RIMMSQOL is put back
    Given the save "test-colony" is loaded
    And I close all dialogs
    And RIMMSQOL is ready to be driven
    And the choices RIMMSQOL kept in the previous launch are in place
    Then RIMMSQOL shows the main button "FieldworkCompanions_Settings" as hidden
    And RIMMSQOL's settings file records the main button "FieldworkCompanions_Settings" as hidden
    And the main bar does not draw the button "FieldworkCompanions_Settings"
    When RIMMSQOL forgets its choice for the main button "FieldworkCompanions_Settings"
    Then RIMMSQOL holds no choice for the main button "FieldworkCompanions_Settings"
    And RIMMSQOL's settings file records no choice for the main button "FieldworkCompanions_Settings"
    And the main bar does not draw the button "FieldworkCompanions_Settings"
    And no errors were logged
