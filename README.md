# Goblins vs. Fishfolk

## Milestone 1 - multiplayer goblins

- [DeltaBlock font CC0](https://www.fontspace.com/delta-block-font-f108775)
- [Youtube tutorial: Godot 4 / Blender - Third Person Character From Scratch](https://youtu.be/VasHZZyPpYU?si=uVCYltNUYqa3C8hG)
- [timescale in AnimationTree](https://github.com/godotengine/godot-proposals/issues/463#issuecomment-585551999)
- goblin model and scene, can run and jump
- 1-5 players, 1 keyboard, up to 4 controllers

## Milestone 2 - interactive tree(s)

- [Highlight closest tree with outline mesh](https://www.reddit.com/r/godot/comments/16ulxqs/does_anybody_knows_how_this_3d_model_outline_is/)
- [Coloration of terrain close to tree](https://www.reddit.com/r/godot/comments/gok070/need_help_getting_world_coordinates_in_shader/)
- Open menu on B
- Use menu with L

## Milestone 3 - Convert a tree into an arrow-tower
- [x] [Show the range of the tower while selecting](https://godotshaders.com/shader/sdf-range-rings-3d/)
- [x] make the tower rise out of the ground when built
- [x] fell all the trees within the radius of the tower
- [x] point the tower at something (a goblin)
- [x] animate the tower shooting (bow string)
- [x] point the tower at the first something within range (a goblin)
- [x] show the range of the tower and highlight the tower when hugging the tower
- [x] make both towers and trees huggable
- [x] goblin can only hug 1 thing at at time


## Milestone 4 - Monsters
- [x] make a monster model
- [x] make arrow towers point at the closest monster within range
- [x] animate the monster
- [x] make an arrow model
- [x] align the arrow model to the shaft of the arrow tower model
- [x] let the monster walk along a path
- [x] make the arrow towers shoot arrows at the closest monster within range with the speed of the released bow string
- [x] spawn in a new arrow aligned with the shaft and the tightening bowstring

## Milestone 5 - Cannon tower
- [x] add cannon tower to the Tree context menu options for Ground
- [x] make a cannon tower model
- [x] write `_point_at` code in `cannon_tower.gd`
- [x] write `_shoot` code
- [x] use a different range when highlighting (5 metres)
- [x] make a cannonball sphere
- [x] use a radius to deal impact damage scaled by distance from epicenter of impact
- [x] animate the lighted fuse with particles
- [x] cannonball  [smoke](https://www.youtube.com/watch?v=jVdgmbn67G8) particles
- [x] use particles to animate the explosion
- [x] use a shader to show impact tattooed on the terrain

## Milestone 6 - Monster-life, Monster-afterlife

- [x] allow the monsters to die when HP runs out
- [x] make monster model react to being hit
- [x] make monster model react to dying (spinning around 3 axes, flying through the air like the little fish chibi's they are)
- [x] give the monsters HP bars
- [x] flying damage numbers

## Milestone 7 - Flying fish, Anti-Air

- [x] model aerial defense tower
- [x] shoot some sort of projectile(s)
- [x] cannot shoot grounded monsters
- [x] cannon will not target flying monsters
- [x] model flying fish
- [x] create flying route for flying fish

## Milestone 8 - Capitalism

- [x] model out builder gems
- [x] make monsters drop currency
- [x] model out magic crystals
- [x] keep track of currency (start with 300 builder gems)
- [x] more readable [font for numbers](https://www.fontspace.com/alpha-prota-font-f83519)
- [x] make towers cost currency in context menu
- [x] in a nice [price tag icon](https://svgsilh.com/image/151102.html)

## Milestone 9 - Giant turtle
- [x] create a turtle model
- [x] use a [photo](https://commons.wikimedia.org/wiki/Image:Chelonia_mydas_(green_sea_turtle)_(San_Salvador_Island,_Bahamas)_4_(16158070626).jpg?uselang=nl) by [photographer](https://www.flickr.com/people/47445767@N05) as texture
- [x] and another [photo](https://commons.wikimedia.org/wiki/File:Chelonia_mydas_176500422.jpg) for the flippers and head <-- did not go as planned
- [x] animate the model, dragging over the sand
- [x] use tattooed-shader for dragging coloration on terrain
- [x] use dust to hide flipper-clipping

## Milestone 10 - Editable stages
- [x] Add MonsterPath scene with anchors that auto-generates a Curve3D to follow
- [x] Add a MonsterTargetZone area that despawns monsters for now
- [x] Add Spawner with MonsterPath and Timed Wave scenes
- [x] Add Wave scenes with child PackedScene resource as monster type to be released using timer
- [x] Create a second stage which can be run with the `debug.gd` script
- [x] create true level terrain, with water for the fish-folk to crawl out of

## Milestone 11 - Surfing
- [x] Make goblin piggyback on turtle
- [x] Add surfing animation for goblin
- [x] Make goblin surf on flying fish

## Milestone 12 - Stage select 1
- [x] Make a main game scene which handles the title screen and menus
- [x] Extract 2 reusable stage scenes
- [x] Make a StageHolder to hold the current stage
- [x] Make it possible to switch between stages (select in title screen)
- [x] Use a stage in the StageHolder as a nice background for the title screen
- [x] Add a title screen, which detects controller device via start button
- [ ] Add some MonsterSpawners with a couple of infinite waves to both scenes

## Milestone 13  - Stage Expansion
- [ ] create a cute goblin village (model a small house, 3 of which makes a village)
- [ ] with little baby goblins in cribs (model a crib with a cute baby in it, 20 of which make a nice target for the monsters to attack)
- [ ] make an attack animation when reaching the goal
- [ ] make the baby goblin and the attacking monster disappear
- [ ] make a baby goblin counter
- [ ] Make lose condition and win condition for stage
- [ ] Implement a MonsterWaveTimer in the HUD, which starts waves and indicates duration until next wave


## Looking forward - Damage types and upgrades
- [ ] Add a stage select menu
- [ ] add blunt (=area) and piercing damage types
- [ ] add elemental damage maybe?
- [ ] make turtle very insensitive to pierce and extra sensitive to blunt
- [ ] let flying fish and fish chibi remain equally sensitive to both damage types
- [ ] new upgrade system using 'skill'-trees
