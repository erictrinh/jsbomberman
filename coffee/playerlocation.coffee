# give the destination snap coordinates
# returns player coordinates if on a snap coordinate
on_snap_x = (player) ->
	x = player.position.x
	# distance past a snap coordinate
	x_distance = (x-25)%50
	
	if x_distance > 0
		if x_distance <= 25
			return x-x_distance
		else
			return x+(50-x_distance)
	else
		return x

on_snap_y = (player) ->
	y = player.position.y
	# distance past a snap coordinate
	y_distance = (y-25)%50
	
	if y_distance > 0
		if y_distance <= 25
			return y-y_distance
		else
			return y+(50-y_distance)
	else
		return y

# get the grid coordinates for a player
get_grid_coords = (player) ->
	x = on_snap_x(player)
	y = on_snap_y(player)
	c = (x-25)/50
	r = (y-25)/50
	return {row: r, col: c}

# given row/col coordinates, convert to x and y
get_cartesian = (r, c) ->
	x = c*50+25
	y = r*50+25
	return {x: x, y: y}