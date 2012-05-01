## the following defines the types of objects that can be found on the map

# this is an empty space
class Empty
	type: 'empty'
	# is this object affected by bombs?
	destructible: false
	# can you walk through/on top of this object?
	walkable: true
# this is a stone object
class Stone
	type: 'stone'
	destructible: false
	walkable: false
# this is a wood object, contains upgrade?
class Wood
	constructor: (upg=false) ->
		@upgrade = upg
	type: 'wood'
	destructible: true
	walkable: false
	
# this is a bomb, also stores range and the player_id (index of the player that dropped it) 
class Bomb
	constructor: (r, pid, t) ->
		@range = r
		@player_id = pid
		@timer = t
	type: 'bomb'
	destructible: true
	walkable: false
# this is an explosion
class Explosion
	type: 'explosion'
	destructible: false
	walkable: true
	# explosions can overlap, so we'll have a counter to see how many explosions we have stacked
	count: 1
# this is an upgrade
### 
	kinds of upgrades
	bomb up
	range up
	x-ray goggles?
###
class Upgrade
	constructor: (k) ->
		@kind = k
	type: 'upgrade'
	destructible: false
	walkable: true