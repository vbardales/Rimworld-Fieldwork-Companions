# The photograph for the Workshop page, image 1 of the series: dawn at the jade vein, Nelim mining with Yuki at her side.
#
# STORY (criterion k, shotlist v4 in STATUS.md, 2026-11-08): one day for Nelim (the Sanctuary's only colonist, as her sheet says: high
# ponytail, her own face, teal shirt and ochre trousers all day, no headgear) and the husky Yuki (NSB animal, Soren's bond; here she
# follows Nelim through the mod's own step), east side of the Sanctuary. Each image leaves one more pile on the ground: Jade, then fish,
# then rice, so the dog's extra adds up. Episode 1, dawn (hour 7, Clear, low light, lit TorchLamp and lit Campfire): the Jade vein at the
# bare-clearing, zoom 5. Instant: one jade block has just broken and a fresh Jade stack lies south of Yuki, who looks at it (faces
# South: the one front view of the series), the "+N" has just risen over Yuki, Nelim has lowered her pickaxe and turns to a second,
# intact MineableJade. Mouth neutral (effort, written: the plan's reason for a non-smile). Next: 22 at noon on the bank, 23 at the rice.
#
# SHOOTING PLAN (shotlist v4, one story shot per file):
#   1. workshop-1-dawn: bare-clearing (195, 152), hour 7, Clear, zoom 5; Nelim (195, 152) teal shirt rgb (30, 140, 150), ochre pants rgb (150, 100, 50), Yuki husky, Apparel_leatherdogcollar #D1008F; TorchLamp, Campfire, Stool, MineableJade, ChunkGranite, Plant_TallGrass, Plant_Berry, Jade.
#
# The yield comes when the rock breaks, so there is no 20 percent rock in this frame: the picture is taken on the tick the mark appears.
# Place "bare-clearing" (195, 152), a free zone: the mod poses its own decor (TorchLamp, Campfire, Stool, Plant_TallGrass, Plant_Berry,
# ChunkGranite, the second rock, the Jade stack) and removes it after the shot ("the scene decor is cleared"). Nelim cured of her
# chronic conditions for the run only (Asthma and a bad back made her too slow, run 91fa); map held at 21 degrees.
#
# Step prefixes: "Nelim's Sanctuary:" steps belong to SanctuaryBacklot; "Nelim's Pickle Tools:" steps to PickleTools (NPT); "Fieldwork
# Companions:" steps are this suite's own. Pass map: Tests/Pickle/wsl-deps.sanctuary.map.
#
# What to look for: Nelim at the vein, Yuki in front, a readable "+N" over Yuki at 268 px, the Jade stack, the lit fire and lamp,
# grass and berries, no HUD, no tooltip, no other pawn or animal in the frame.
@part2 @review @requires:nelim.pickletools.stagedecor @requires:ab.vplrf @requires:nelim.pickletools.interfacescale @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.screenshotstudio @timeout:240
Feature: a companion beside a colonist at work

  Scenario: a real mining job, the animal beside the colonist, the mark over the animal
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 7
    And I set the weather to "Clear"
    And I close all dialogs
    And Fieldwork Companions always helps, at the largest share
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the floor of the sanctuary "bare-clearing" is bared
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Pickle Tools: all animals are removed
    And Nelim's Pickle Tools: the temperature of the map is 21 degrees
    And Nelim's Pickle Tools: "Nelim" stands at (195, 152)
    And Fieldwork Companions: "Nelim" is cured of every chronic condition
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (30, 140, 150)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (150, 100, 50)
    And Nelim's Pickle Tools: the area from (191, 147) to (204, 157) is cleared
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Nelim" mouth is "MouthNormal"
    And Fieldwork Companions: "Yuki" is an obedient "Husky" that follows "Nelim" at work
    And Nelim's Pickle Tools: the animal "Yuki" is dressed in "Apparel_leatherdogcollar" dyed "#D1008F"
    And Nelim's Pickle Tools: the animal "Yuki" stands at (195, 150) facing South
    And Nelim's Pickle Tools: I advance the paused game by exactly 10 ticks
    And Fieldwork Companions: a "MineableJade" rock and "Yuki" stand right beside "Nelim"
    And Fieldwork Companions: the scene decor "Jade" stands 0 cells right of and 3 cells below "Nelim"
    And Fieldwork Companions: the scene decor "TorchLamp" stands 4 cells left of and 1 cell below "Nelim"
    And Fieldwork Companions: the scene decor "Campfire" stands 3 cells left of and 3 cells below "Nelim"
    And Fieldwork Companions: the scene decor "Stool" stands 4 cells left of and 4 cells below "Nelim"
    And Fieldwork Companions: the scene decor "MineableJade" stands 3 cells left of and 1 cell above "Nelim"
    And Fieldwork Companions: the scene decor "ChunkGranite" stands 1 cell left of and 2 cells below "Nelim"
    And Fieldwork Companions: the scene decor "Plant_TallGrass" stands 2 cells left of and 2 cells below "Nelim"
    And Fieldwork Companions: the scene decor "Plant_TallGrass" stands 4 cells right of and 3 cells below "Nelim"
    And Fieldwork Companions: the scene decor "Plant_Berry" stands 5 cells right of and 2 cells below "Nelim"
    And Nelim's Pickle Tools: I frame the animal "Yuki" at zoom 5
    And Fieldwork Companions: the camera is placed so that "Nelim" stands 3 cells left of and 0 cells above the pointer
    And Nelim's Pickle Tools: the interface scale is 200 percent
    And Nelim's Pickle Tools: studio presentation mode is enabled
    When Fieldwork Companions: "Nelim" is ordered to mine the rock beside them
    And game speed is ultrafast
    Then Fieldwork Companions: a bonus mark floats over "Yuki" within 140 seconds
    And game speed is paused
    And Fieldwork Companions: the picture settles for 4 real seconds
    When I take a screenshot "the companion at work, the mark over it"
    And Fieldwork Companions: the scene decor is cleared
    And I close all dialogs
    Then no errors were logged
