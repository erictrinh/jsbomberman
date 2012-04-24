# global vars
players = new Array()
bombs = new Array()
explosions = new Array()
objects = new Array()
timer = null
game_started = false

intro_screen = ->
	center = $('#map').width()/2
	$('#map').drawText
		fillStyle: '#000'
		x: center
		y: 100
		text: 'JSBomber'
		font: '60pt Helvetica, sans-serif'
	.drawText
		fillStyle: '#000'
		x: center
		y: 300
		text: "Press 'spacebar' to start"
		font: '25pt Helvetica, sans-serif'

game_over_screen = (text) ->
	center = $('#map').width()/2
	$('#map').drawText
		fillStyle: '#000'
		x: center
		y: 100
		text: text
		font: '50pt Helvetica, sans-serif'
	.drawText
		fillStyle: '#000'
		x: center
		y: 300
		text: "Play again? (Spacebar)"
		font: '25pt Helvetica, sans-serif'

# initialize the game with 2 players
init_game = ->
	game_started = true
	bombs = []
	explosions = []
	# initialize objects as a 2d array and add stone blocks
	objects = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
	players[0] = 
		position:
			x: 25
			y: 25
		facing: 'down'
		speed: 5
		num_bombs: 3
		bomb_range: 3
		controls:
			up: 87
			down: 83
			left: 65
			right: 68
			drop: 88
		up: false
		down: false
		right: false
		left: false
		dead: false
	players[1] = 
		facing: 'up'
		position:
			x: 725
			y: 425
		speed: 5
		num_bombs: 3
		bomb_range: 3
		controls:
			up: 80
			down: 186
			left: 76
			right: 222
			drop: 191
		up: false
		down: false
		right: false
		left: false
		dead: false

# give the destination snap coordinates
# returns player coordinates if on a snap coordinate
on_snap_x = (player) ->
	x = player.position.x
	# distance past a snap coordinate
	x_distance = (x-25)%50
	
	if x_distance > 0
		if x_distance < 25
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
		if y_distance < 25
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
	else if player.position.x is 25 || coords.col is 0 || objects[coords.row][coords.col-1] is 1
		l = false
	if coords.col is 14 && player.position.x isnt 725
		r = true
	else if player.position.x is 725 || coords.col is 14 || objects[coords.row][coords.col+1] is 1
		r = false
	if coords.row is 0 && player.position.y isnt 25
		u = true
	else if player.position.y is 25 || coords.row is 0 || objects[coords.row-1][coords.col] is 1
		u = false
	if coords.row is 8 && player.position.y isnt 425
		d = true
	else if player.position.y is 425 || coords.row is 8 || objects[coords.row+1][coords.col] is 1
		d = false
	return {up: u, down: d, left: l, right: r}
	
move_up = (player) ->
	player.facing = 'up'
	player.position.y -= player.speed
move_down = (player) ->
	player.facing = 'down'
	player.position.y += player.speed
move_left = (player) ->
	player.facing = 'left'
	player.position.x -= player.speed
move_right = (player) ->
	player.facing = 'right'
	player.position.x += player.speed

game_logic = ->
	for player in players
		# player is holding down the up key
		if player.up
			# not on a snap axis
			if on_snap_x(player) isnt player.position.x
				# if no obstacle there, move towards the snap coordinate
				if can_go(player).up
					if on_snap_x(player) > player.position.x
						move_right(player)
					else
						move_left(player)
				# otherwise, move in the opposite direction
				else
					if on_snap_x(player) > player.position.x
						move_left(player)
					else
						move_right(player)
			# this is on a snap axis, so move normally IF no obstacle there
			else
				if can_go(player).up
					move_up(player)
		# player is holding down the down key
		else if player.down
			# not on a snap axis
			if on_snap_x(player) isnt player.position.x
				# if no obstacle there, move towards the snap coordinate
				if can_go(player).down
					if on_snap_x(player) > player.position.x
						move_right(player)
					else
						move_left(player)
				# otherwise, move in the opposite direction
				else
					if on_snap_x(player) > player.position.x
						move_left(player)
					else
						move_right(player)
			# this is on a snap axis, so move normally
			else
				if can_go(player).down
					move_down(player)
		# player is holding down the left key
		else if player.left
			# not on a snap axis
			if on_snap_y(player) isnt player.position.y
				# if no obstacle there, move towards the snap coordinate
				if can_go(player).left
					if on_snap_y(player) > player.position.y
						move_down(player)
					else
						move_up(player)
				# otherwise, move in the opposite direction
				else
					if on_snap_y(player) > player.position.y
						move_up(player)
					else
						move_down(player)
			# this is on a snap axis, so move normally
			else
				if can_go(player).left
					move_left(player)
		# player is holding down the right key
		else if player.right
			# not on a snap axis
			if on_snap_y(player) isnt player.position.y
				# if no obstacle there, move towards the snap coordinate
				if can_go(player).right
					if on_snap_y(player) > player.position.y
						move_down(player)
					else
						move_up(player)
				# otherwise, move in the opposite direction
				else
					if on_snap_y(player) > player.position.y
						move_up(player)
					else
						move_down(player)
			# this is on a snap axis, so move normally
			else
				if can_go(player).right
					move_right(player)

	update_map()
	if check_collisions()
		# game over
		clearTimeout(timer)
		game_started = false
	else
		timer=setTimeout("game_logic()",25)

update_map = ->
	$('#map').clearCanvas()
	template = [1..14]
	overlay = (num*50 for num in template)
	for num in overlay
		$('#map').drawLine
			strokeStyle: "#cfcfcf"
			strokeWidth: 1
			x1: num
			y1: 0
			x2: num
			y2: 450
		if num <= 425
			$('#map').drawLine
				strokeStyle: "#cfcfcf"
				strokeWidth: 1
				x1: 0
				y1: num
				x2: 750
				y2: num
	for row, r_index in objects
		for column, c_index in row
			if objects[r_index][c_index] is 1
				$('#map').drawRect
					fillStyle: '#777777'
					x: c_index*50+25
					y: r_index*50+25
					width: 50
					height: 50
					fromCenter: true
	for elem in bombs
		$('#map').drawRect
			fillStyle: '#0c9df9'
			x: elem.x
			y: elem.y
			width: 40
			height: 40
			fromCenter: true
	for elem in explosions
		$('#map').drawLine
			strokeStyle: "#f90c22"
			strokeWidth: 2
			x1: elem.x
			y1: elem.y - elem.r*50 + 25
			x2: elem.x
			y2: elem.y + elem.r*50 + 25
		.drawLine
			strokeStyle: "#f90c22"
			strokeWidth: 2
			x1: elem.x - elem.r*50 + 25
			y1: elem.y
			x2: elem.x + elem.r*50 + 25
			y2: elem.y
	for player in players
		$('#map').drawRect
			fillStyle: '#fff'
			x: player.position.x
			y: player.position.y
			width: 25
			height: 25
			fromCenter: true
			strokeStyle: '#000'
			strokeWidth: 1
		if player.facing is 'right'
			arc_start = 45
			arc_end = 135
		else if player.facing is 'down'
			arc_start = 135
			arc_end = 225
		else if player.facing is 'left'
			arc_start = 225
			arc_end = 315
		else if player.facing is 'up'
			arc_start = 315
			arc_end = 45
		$('#map').drawArc
		  strokeStyle: "#000"
		  strokeWidth: 1
		  x: player.position.x
		  y: player.position.y
		  radius: 18
		  start: arc_start
		  end: arc_end

drop_bomb = (x_pos, y_pos, pid, brange) ->
	bombs.push({x: x_pos, y: y_pos, player_id: pid, range: brange, timer: setTimeout("explode_bomb()",3000)})

explode_bomb = (index=0) ->
	clearTimeout(bombs[index].timer)
	# replenish bomb supply
	pid = bombs[index].player_id
	players[pid].num_bombs += 1
	explosion(bombs[index].x, bombs[index].y, bombs[index].range)
	bombs.splice(index,1)

explosion = (x_pos, y_pos, range) ->
	shake_map(range)
	
	explosions.push({x: x_pos, y: y_pos, r: range})
	
	setTimeout("extinguish_explosion()",1000)

extinguish_explosion = ->
	explosions.splice(0,1)

# check if any of the explosions hit the players
check_collisions = ->
	for explosion in explosions
		for player in players
			if player_collision(player, explosion)
				player.dead = true
	if players[0].dead && players[1].dead
		game_over_screen('double suicide')
		return true
	else if players[0].dead
		game_over_screen('player 1 dead')
		return true
	else if players[1].dead
		game_over_screen('player 2 dead')
		return true
	else
		return false
player_collision = (player, explosion) ->
	if (player.position.x-25/2 < explosion.x < player.position.x+25/2 && Math.abs(player.position.y-explosion.y) < explosion.r*50+25) || (player.position.y-25/2 < explosion.y < player.position.y+25/2 && Math.abs(player.position.x-explosion.x) < explosion.r*50+25)
		return true
	else
		return false
bomb_collision = (bomb, explosion) ->
	if bomb.x-40/2 < explosion.x < bomb.x+40/2 || bomb.y-40/2 < explosion.y < bomb.y+40/2
		return true
	else
		return false

# shake the map left and right by offset during an explosion
shake_map = (offset) ->
	$('#map').animate
		left: '+=' + offset
		, 100, ->
			$('#map').animate
				left: '-=' + offset
				, 100, ->
					# callback

$ ->
	intro_screen()

$(document).bind 'keydown', (e) ->
	unless event.metaKey
		unless game_started
			if e.which is 32 # this is the spacebar
				init_game()
				game_logic()
		for player, player_id in players
			if e.which is player.controls.up
				player.up = true
			else if e.which is player.controls.down
				player.down = true
			else if e.which is player.controls.left
				player.left = true
			else if e.which is player.controls.right
				player.right = true
			else if e.which is player.controls.drop
				if player.num_bombs>0
					drop_bomb(on_snap_x(player), on_snap_y(player), player_id, player.bomb_range)
					player.num_bombs -= 1
		return false
.bind 'keyup', (e) ->
	unless event.metaKey
		for player, player_id in players
			if e.which is player.controls.up
				player.up = false
			else if e.which is player.controls.down
				player.down = false
			else if e.which is player.controls.left
				player.left = false
			else if e.which is player.controls.right
				player.right = false
		return false