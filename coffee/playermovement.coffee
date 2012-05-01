is_odd = (num) ->
	return num%2 is 1

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
		if player.on_snap_x() isnt player.position.x
			# if no obstacle there, move towards the snap coordinate
			if player.can_go_up()
				if player.on_snap_x() > player.position.x
					player.move_right(unit)
				else
					player.move_left(unit)
			# otherwise, move in the opposite direction
			else
				if player.on_snap_x() > player.position.x
					player.move_left(unit)
				else
					player.move_right(unit)
		# this is on a snap axis, so move normally IF no obstacle there
		else
			if player.can_go_up()
				player.move_up(unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'up'
	# player is holding down the down key
	else if player.down
		# not on a snap axis
		if player.on_snap_x() isnt player.position.x
			# if no obstacle there, move towards the snap coordinate
			if player.can_go_down()
				if player.on_snap_x() > player.position.x
					player.move_right(unit)
				else
					player.move_left(unit)
			# otherwise, move in the opposite direction
			else
				if player.on_snap_x() > player.position.x
					player.move_left(unit)
				else
					player.move_right(unit)
		# this is on a snap axis, so move normally
		else
			if player.can_go_down()
				player.move_down(unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'down'
	# player is holding down the left key
	else if player.left
		# not on a snap axis
		if player.on_snap_y() isnt player.position.y
			# if no obstacle there, move towards the snap coordinate
			if player.can_go_left()
				if player.on_snap_y() > player.position.y
					player.move_down(unit)
				else
					player.move_up(unit)
			# otherwise, move in the opposite direction
			else
				if player.on_snap_y() > player.position.y
					player.move_up(unit)
				else
					player.move_down(unit)
		# this is on a snap axis, so move normally
		else
			if player.can_go_left()
				player.move_left(unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'left'
	# player is holding down the right key
	else if player.right
		# not on a snap axis
		if player.on_snap_y() isnt player.position.y
			# if no obstacle there, move towards the snap coordinate
			if player.can_go_right()
				if player.on_snap_y() > player.position.y
					player.move_down(unit)
				else
					player.move_up(unit)
			# otherwise, move in the opposite direction
			else
				if player.on_snap_y() > player.position.y
					player.move_up(unit)
				else
					player.move_down(unit)
		# this is on a snap axis, so move normally
		else
			if player.can_go_right()
				player.move_right(unit)
			# if we can't go that way, at least orient the player that way so it's responsive
			else
				player.facing = 'right'
				
	player.movement = setTimeout("movement_logic(players[#{player.id}])", rate)