# global vars
players = new Array()
bombs = new Array()
explosions = new Array()
timer = null
game_started = false

intro_screen = ->
	$('#map').drawText
		fillStyle: '#000'
		x: 250
		y: 100
		text: 'JSBomber'
		font: '60pt Helvetica, sans-serif'
	.drawText
		fillStyle: '#000'
		x: 250
		y: 300
		text: "Press 'spacebar' to start"
		font: '25pt Helvetica, sans-serif'

game_over_screen = (text) ->
	$('#map').drawText
		fillStyle: '#000'
		x: 250
		y: 100
		text: text
		font: '50pt Helvetica, sans-serif'
	.drawText
		fillStyle: '#000'
		x: 250
		y: 300
		text: "Play again? (Spacebar)"
		font: '25pt Helvetica, sans-serif'

# initialize the game with 2 players
init_game = ->
	game_started = true
	bombs = []
	explosions = []
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
			x: 475
			y: 475
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

game_logic = ->
	for player in players
		# player is holding down the up key
		if player.up
			# not on a snap axis
			if on_snap_x(player) isnt player.position.x
				# move towards the snap coordinate
				if on_snap_x(player) > player.position.x
					player.position.x += player.speed
				else
					player.position.x -= player.speed
			# this is on a snap axis, so move normally
			else
				player.position.y -= player.speed
		# player is holding down the down key
		else if player.down
			# not on a snap axis
			if on_snap_x(player) isnt player.position.x
				# move towards the snap coordinate
				if on_snap_x(player) > player.position.x
					player.position.x += player.speed
				else
					player.position.x -= player.speed
			# this is on a snap axis, so move normally
			else
				player.position.y += player.speed
		# player is holding down the left key
		else if player.left
			# not on a snap axis
			if on_snap_y(player) isnt player.position.y
				# move towards the snap coordinate
				if on_snap_y(player) > player.position.y
					player.position.y += player.speed
				else
					player.position.y -= player.speed
			# this is on a snap axis, so move normally
			else
				player.position.x -= player.speed
		# player is holding down the right key
		else if player.right
			# not on a snap axis
			if on_snap_y(player) isnt player.position.y
				# move towards the snap coordinate
				if on_snap_y(player) > player.position.y
					player.position.y += player.speed
				else
					player.position.y -= player.speed
			# this is on a snap axis, so move normally
			else
				player.position.x += player.speed
		# make sure players stay inside map
		if player.position.y < 25
			player.position.y = 25
		else if player.position.y > 475
			player.position.y = 475
		if player.position.x < 25
			player.position.x = 25
		else if player.position.x > 475
			player.position.x = 475

	update_map()
	if check_collisions()
		# game over
		clearTimeout(timer)
		game_started = false
	else
		timer=setTimeout("game_logic()",25)

update_map = ->
	$('#map').clearCanvas()
	template = [1..9]
	overlay = (num*50 for num in template)
	for num in overlay
		$('#map').drawLine
			strokeStyle: "#cfcfcf"
			strokeWidth: 1
			x1: num
			y1: 0
			x2: num
			y2: 500
		.drawLine
			strokeStyle: "#cfcfcf"
			strokeWidth: 1
			x1: 0
			y1: num
			x2: 500
			y2: num
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
				player.facing = 'up'
			else if e.which is player.controls.down
				player.down = true
				player.facing = 'down'
			else if e.which is player.controls.left
				player.left = true
				player.facing = 'left'
			else if e.which is player.controls.right
				player.right = true
				player.facing = 'right'
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