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

## Milestone 6 (DONE) - Monster-life, Monster-afterlife

- [x] allow the monsters to die when HP runs out
- [x] make monster model react to being hit
- [x] make monster model react to dying (spinning around 3 axes, flying through the air like the little fish chibi's they are)
- [x] give the monsters HP bars
- [x] flying damage numbers 

Milestone 7 (DOING) - Flying fish, Anti-Air
- [ ] model flying fish
- [ ] model aerial defense tower
- [ ] shoot some sort of projectile(s) 
- [ ] cannot shoot grounded monsters
- [ ] cannon will not target flying monsters

## Milestone 8 (TOOD) - Expansion
- [ ] create a cute goblin village (model a small house, 3 of which makes a village)
- [ ] with little baby goblins in cribs (model a crib with a cute baby in it, 20 of which make a nice target for the monsters to attack)
- [ ] make an attack animation when reaching the goal
- [ ] make the baby goblin and the attacking monster disappear
- [ ] make a baby goblin counter
- [ ] create true level terrain, with water for the fish-folk to crawl out of

## Milestone 7 - Capitalism

- [ ] model out coins
- [ ] keep track of coins (start with 300)
- [ ] make towers cost coins in context menu
- [ ] make monsters drop coins
