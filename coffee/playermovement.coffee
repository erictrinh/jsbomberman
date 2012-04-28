# check if player can go up, down, left, right
# returns object literal with possible moves
can_go = (player) ->
	coords = get_grid_coords(player)
	u = true
	d = true
	l = true
	r = true
	# cross reference object map
	
	# we're on the (left) edge of glory but haven't quite gotten there yet
	# we'll let you get there
	if coords.col is 0 && player.position.x isnt 25
		l = true
	# you're on the edge now, can't let you move that way anymore, sorry
	else if player.position.x is 25 || coords.col is 0 || !objects[coords.row][coords.col-1].walkable
		if coords.col>0 && !objects[coords.row][coords.col-1].walkable && player.position.x-get_cartesian(coords.row, coords.col).x>0
			l = true
		else
			l = false
	if coords.col is 8 && player.position.x isnt 425
		r = true
	else if player.position.x is 425 || coords.col is 8 || !objects[coords.row][coords.col+1].walkable
		if coords.col<8 && !objects[coords.row][coords.col+1].walkable && get_cartesian(coords.row, coords.col).x-player.position.x>0
			r = true
		else
			r = false
	if coords.row is 0 && player.position.y isnt 25
		u = true
	else if player.position.y is 25 || coords.row is 0 || !objects[coords.row-1][coords.col].walkable
		if coords.row>0 && !objects[coords.row-1][coords.col].walkable && player.position.y-get_cartesian(coords.row, coords.col).y>0
			u = true
		else
			u = false
	if coords.row is 8 && player.position.y isnt 425
		d = true
	else if player.position.y is 425 || coords.row is 8 || !objects[coords.row+1][coords.col].walkable
		if coords.row<8 && !objects[coords.row+1][coords.col].walkable && get_cartesian(coords.row, coords.col).y-player.position.y>0
			d = true
		else
			d = false
	return {up: u, down: d, left: l, right: r}

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
			if can_go(player).up
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
			if can_go(player).up
				move_up(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'up'
	# player is holding down the down key
	else if player.down
		# not on a snap axis
		if on_snap_x(player) isnt player.position.x
			# if no obstacle there, move towards the snap coordinate
			if can_go(player).down
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
			if can_go(player).down
				move_down(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'down'
	# player is holding down the left key
	else if player.left
		# not on a snap axis
		if on_snap_y(player) isnt player.position.y
			# if no obstacle there, move towards the snap coordinate
			if can_go(player).left
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
			if can_go(player).left
				move_left(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'left'
	# player is holding down the right key
	else if player.right
		# not on a snap axis
		if on_snap_y(player) isnt player.position.y
			# if no obstacle there, move towards the snap coordinate
			if can_go(player).right
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
			if can_go(player).right
				move_right(player, unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'right'
				
	setTimeout("movement_logic(players[#{player.id}])", rate)