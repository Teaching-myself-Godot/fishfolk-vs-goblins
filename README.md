# Goblins vs. Fishfolk

A fan-game of [Pixeljunk's "Monsters 2"](https://store.steampowered.com/app/749800/PixelJunk_Monsters_2/).

My (our) first 3D game, powered by [godot 4](https://godotengine.org/download).

Many thanks go out to my creative manager, son, and author of the musical scores: ['Yoia' at bandlab](https://www.bandlab.com/yoia_). Without him, there would have been no HP bars, no damage indicators shouting "Overkill", no sound and no music in this game.

## The creative process

Next up is a listing of the milestones I tagged (except mileston 0 of course).

### Milestone 0 - the inception (April 20th 2024)

- We were playing Monsters 2 a lot on the switch
- We loved the local multiplayer co-op
- I wanted to make a 2D tower defense game
- The family thought the tree-mechanic was cool
- ...that only works well in 3D

### [Milestone 1](tree/milestone-1) - multiplayer goblins (April 25th 2024)

- [DeltaBlock font CC0](https://www.fontspace.com/delta-block-font-f108775)
- [Youtube tutorial: Godot 4 / Blender - Third Person Character From Scratch](https://youtu.be/VasHZZyPpYU?si=uVCYltNUYqa3C8hG)
- [timescale in AnimationTree](https://github.com/godotengine/godot-proposals/issues/463#issuecomment-585551999)
- goblin model and scene, can run and jump
- 1-5 players, 1 keyboard, up to 4 controllers

### [Milestone 2](tree/milestone-2) - interactive tree(s) (April 30th 2024)

- [Highlight closest tree with outline mesh](https://www.reddit.com/r/godot/comments/16ulxqs/does_anybody_knows_how_this_3d_model_outline_is/)
- [Coloration of terrain close to tree](https://www.reddit.com/r/godot/comments/gok070/need_help_getting_world_coordinates_in_shader/)
- Open menu on B
- Use menu with L

### [Milestone 3](tree/milestone-3) - Convert a tree into an arrow-tower (May 3rd 2024)
- [Show the range of the tower while selecting](https://godotshaders.com/shader/sdf-range-rings-3d/)
- make the tower rise out of the ground when built
- fell all the trees within the radius of the tower
- point the tower at something (a goblin)
- animate the tower shooting (bow string)
- point the tower at the first something within range (a goblin)
- show the range of the tower and highlight the tower when hugging the tower
- make both towers and trees huggable
- goblin can only hug 1 thing at at time


### [Milestone 4](tree/milestone-4) - Monsters (May 5th 2024)
- make a monster model
- make arrow towers point at the closest monster within range
- animate the monster
- make an arrow model
- align the arrow model to the shaft of the arrow tower model
- let the monster walk along a path
- make the arrow towers shoot arrows at the closest monster within range with the speed of the released bow string
- spawn in a new arrow aligned with the shaft and the tightening bowstring

### [Milestone 5](tree/milestone-5) - Cannon tower (May 9th 2024)
- add cannon tower to the Tree context menu options for Ground
- make a cannon tower model
- write `_point_at` code in `cannon_tower.gd`
- write `_shoot` code
- use a different range when highlighting (5 metres)
- make a cannonball sphere
- use a radius to deal impact damage scaled by distance from epicenter of impact
- animate the lighted fuse with particles
- cannonball  [smoke](https://www.youtube.com/watch?v=jVdgmbn67G8) particles
- use particles to animate the explosion
- use a shader to show impact tattooed on the terrain

### [Milestone 6](tree/milestone-6) - Monster-life, Monster-afterlife (May 10th 2024)

- allow the monsters to die when HP runs out
- make monster model react to being hit
- make monster model react to dying (spinning around 3 axes, flying through the air like the little fish chibi's they are)
- give the monsters HP bars
- flying damage numbers

### [Milestone 7](tree/milestone-7) - Flying fish, Anti-Air (May 13th 2024)

- model aerial defense tower
- shoot some sort of projectile(s)
- cannot shoot grounded monsters
- cannon will not target flying monsters
- model flying fish
- create flying route for flying fish

### [Milestone 8](tree/milestone-8) - Capitalism (May 16th 2024)

- model out builder gems
- make monsters drop currency
- model out magic crystals
- keep track of currency (start with 300 builder gems)
- more readable [font for numbers](https://www.fontspace.com/alpha-prota-font-f83519)
- make towers cost currency in context menu
- in a nice [price tag icon](https://svgsilh.com/image/151102.html)

### [Milestone 9](tree/milestone-9) - Giant turtle (May 20th 2024)
- create a turtle model
- use a [photo](https://commons.wikimedia.org/wiki/Image:Chelonia_mydas_(green_sea_turtle)_(San_Salvador_Island,_Bahamas)_4_(16158070626).jpg?uselang=nl) by [photographer](https://www.flickr.com/people/47445767@N05) as texture
- and another [photo](https://commons.wikimedia.org/wiki/File:Chelonia_mydas_176500422.jpg) for the flippers and head <-- did not go as planned
- animate the model, dragging over the sand
- use tattooed-shader for dragging coloration on terrain
- use dust to hide flipper-clipping

### [Milestone 10](tree/milestone-10) - Editable stages (June 1st 2024)
- Add MonsterPath scene with anchors that auto-generates a Curve3D to follow
- Add a MonsterTargetZone area that despawns monsters for now
- Add Spawner with MonsterPath and Timed Wave scenes
- Add Wave scenes with child PackedScene resource as monster type to be released using timer
- Create a second stage which can be run with the `debug.gd` script
- create true level terrain, with water for the fish-folk to crawl out of

### [Milestone 11](tree/milestone-11) - Surfing (June 1st 2024)
- Make goblin piggyback on turtle
- Add surfing animation for goblin
- Make goblin surf on flying fish

### [Milestone 12](tree/milestone-12) - Stage select (June 2nd 2024)
- Make a main game scene which handles the title screen and menus
- Extract 2 reusable stage scenes
- Make a StageHolder to hold the current stage
- Make it possible to switch between stages (select in title screen)
- Use a stage in the StageHolder as a nice background for the title screen
- Add a title screen, which detects controller device via start button
- Add some MonsterSpawners with a couple of infinite waves to both scenes

### [Milestone 13](tree/milestone-13) - UI controls (June 12th 2024)
- fix game joining / keep better track of controllers input in one singleton
- make all menus use controls, so when paused no buggy stuff
- add an (optional) goblin spawn pos to the stage
- add cooldown times for confirm and pause actions for button overloading
- hide mouse cursor when middle mouse button is held
- give the game over spash screen a working delay


### [Milestone 14](tree/milestone-14) - Game over (June 12th 2024)
- with little baby goblins in cribs (model a crib with a cute baby in it, 20 of which make a nice target for the monsters to attack)
- make an attack animation when reaching the goal
- make the baby goblin and the attacking monster disappear in a cloud of dust
- Make lose condition -> all goblin babies gone
- Show gameover splash
- show a baby goblin counter

### [Milestone 15](tree/milestone-15) - Winning the game, prepping soft launch (July 13th 2024)

- add stage music by: https://www.bandlab.com/yoia_
- show current wave progression
- Implement a MonsterWaveEmitter, which starts waves and reports which wave of how many just started
- Make win condition for stage (all waves passed)
- intro with back story
- tutorial stage for gamepad and keyboard+mouse
- Short screen recordings for promo and intro
- Windows installer (maybe test other platforms? - Linux worked)


### Milestone 16 - Release
- [ ] Publish code by opening up the repo with MIT license
- [ ] Soft Launch to itch.io
- [ ] Make the promo-videos on Youtube listed
- [ ] Grab a little attention via socials (I use almost none so that'll do fine :D)


## Future ideas ?
- [ ] Short tutorial on making your own stage
- [ ] Short tutorial on contributing by forking
- [ ] show player scores (towers built, gems picked up, damage dealt, kills, gems spent, crystals picked up, etc.)
- [ ] add dismantle option to tower menu
- [ ] add tower menu system using stat-upgrades (damage, range, projectile speed)
- [ ] Make camera look behind player more when zoomed in
- [ ] add leave game option to pause menu
- [ ] add blunt (=area) and piercing damage types
- [ ] add elemental damage maybe?
- [ ] make turtle very insensitive to pierce and extra sensitive to blunt
- [ ] let flying fish and fish chibi remain equally sensitive to both damage types
- [ ] create a cute goblin village (model a small house, 3 of which makes a village)
