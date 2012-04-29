can_go_right = (player) ->
	coords = get_grid_coords(player)
	
	if player.position.x is 425
		return false
	else if coords.col is 8
		return true
	if objects[coords.row][coords.col+1].walkable
		return true
	else if player.position.x isnt on_snap_x(player)
		return true
	else
		return false

can_go_left = (player) ->
	coords = get_grid_coords(player)
	
	if player.position.x is 25
		return false
	else if coords.col is 0
		return true
	if objects[coords.row][coords.col-1].walkable
		return true
	else if player.position.x isnt on_snap_x(player)
		return true
	else
		return false
		
can_go_down = (player) ->
	coords = get_grid_coords(player)
	
	if player.position.y is 425
		return false
	else if coords.row is 8
		return true
	if objects[coords.row+1][coords.col].walkable
		return true
	else if player.position.y isnt on_snap_y(player)
		return true
	else
		return false
		
can_go_up = (player) ->
	coords = get_grid_coords(player)
	
	if player.position.y is 25
		return false
	else if coords.row is 0
		return true
	if objects[coords.row-1][coords.col].walkable
		return true
	else if player.position.y isnt on_snap_y(player)
		return true
	else
		return false

is_odd = (num) ->
	return num%2 is 1

move_up = (player, unit) ->
	player.facing = 'up'
	player.position.y -= unit
	if !is_odd(player.position.y) && unit is 2
		player.position.y -=1
move_down = (player, unit) ->
	player.facing = 'down'
	player.position.y += unit
	if !is_odd(player.position.y) && unit is 2
		player.position.y +=1
move_left = (player, unit) ->
	player.facing = 'left'
	player.position.x -= unit
	if !is_odd(player.position.x) && unit is 2
		player.position.x -=1
move_right = (player, unit) ->
	player.facing = 'right'
	player.position.x += unit
	if !is_odd(player.position.x) && unit is 2
		player.position.x +=1

movement_logic = (player) ->
	unit = null
	rate = null
	switch player.speed
		when 1
			unit = 1
			rate = 10
		when 2
			unit = 1
			rate = 7
		when 3
			unit = 2
			rate = 10
		when 4
			unit = 2
			rate = 8
		when 5
			unit = 2
			rate = 6
		when 6
			unit = 2
			rate = 5
		when 7
			unit = 1
			rate = 2
		when 8
			unit = 2
			rate = 3
		when 9
			unit = 2
			rate = 2
		when 10
			unit = 2
			rate = 1

	# player is holding down the up key
	if player.up
		# not on a snap axis
		if on_snap_x(player) isnt player.position.x
			# if no obstacle there, move towards the snap coordinate
			if can_go_up(player)
				if on_snap_x(player) > player.position.x
					move_right(player, unit)
				else
					move_left(player, unit)
			# otherwise, move in the opposite direction
			else
				if on_snap_x(player) > player.position.x
					move_left(player, unit)
				else
					move_right(player, unit)
		# this is on a snap axis, so move normally IF no obstacle there
		else
			if can_go_up(player)
				move_up(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'up'
	# player is holding down the down key
	else if player.down
		# not on a snap axis
		if on_snap_x(player) isnt player.position.x
			# if no obstacle there, move towards the snap coordinate
			if can_go_down(player)
				if on_snap_x(player) > player.position.x
					move_right(player, unit)
				else
					move_left(player, unit)
			# otherwise, move in the opposite direction
			else
				if on_snap_x(player) > player.position.x
					move_left(player, unit)
				else
					move_right(player, unit)
		# this is on a snap axis, so move normally
		else
			if can_go_down(player)
				move_down(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'down'
	# player is holding down the left key
	else if player.left
		# not on a snap axis
		if on_snap_y(player) isnt player.position.y
			# if no obstacle there, move towards the snap coordinate
			if can_go_left(player)
				if on_snap_y(player) > player.position.y
					move_down(player, unit)
				else
					move_up(player, unit)
			# otherwise, move in the opposite direction
			else
				if on_snap_y(player) > player.position.y
					move_up(player, unit)
				else
					move_down(player, unit)
		# this is on a snap axis, so move normally
		else
			if can_go_left(player)
				move_left(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'left'
	# player is holding down the right key
	else if player.right
		# not on a snap axis
		if on_snap_y(player) isnt player.position.y
			# if no obstacle there, move towards the snap coordinate
			if can_go_right(player)
				if on_snap_y(player) > player.position.y
					move_down(player, unit)
				else
					move_up(player, unit)
			# otherwise, move in the opposite direction
			else
				if on_snap_y(player) > player.position.y
					move_up(player, unit)
				else
					move_down(player, unit)
		# this is on a snap axis, so move normally
		else
			if can_go_right(player)
				move_right(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'right'
				
	player.movement = setTimeout("movement_logic(players[#{player.id}])", rate)