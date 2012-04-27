## the following defines the types of objects that can be found on the map

# this is an empty space
Empty = ->
	this.type ='empty'
	# is this object affected by bombs?
	this.destructible = false
	# can you walk through/on top of this object?
	this.walkable = true
# this is a stone object
Stone = ->
	this.type = 'stone'
	this.destructible = false
	this.walkable = false
# this is a wood object, contains upgrade?
Wood = (upg=false) ->
	this.type = 'wood'
	this.destructible = true
	this.walkable = false
	this.upgrade = upg
# this is a bomb, also stores range and the player_id (index of the player that dropped it) 
Bomb = (r, pid, t) ->
	this.type = 'bomb'
	this.destructible = true
	this.walkable = false
	this.range = r
	this.player_id = pid
	this.timer = t
# this is an explosion
Explosion = ->
	this.type = 'explosion'
	this.destructible = false
	this.walkable = true
	# explosions can overlap, so we'll have a counter to see how many explosions we have stacked
	this.count = 1
# this is an upgrade
### 
	kinds of upgrades
	bomb up
	range up
	x-ray goggles?
###
Upgrade = (k) ->
	this.type = 'upgrade'
	this.destructible = false
	this.walkable = true
	this.kind = k
