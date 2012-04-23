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
		text: "Press 'spacebar' to continue"
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
	players[0] = 
		position:
			x: 25
			y: 25
		speed: 5
		num_bombs: 3
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
		position:
			x: 475
			y: 475
		speed: 5
		num_bombs: 3
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

game_logic = ->
	for player in players
		if player.up
			player.position.y -= player.speed
		# keyplayers[0].down is s
		else if player.down
			player.position.y += player.speed
		# keyplayers[0].down is a
		else if player.left
			player.position.x -= player.speed
		# keyplayers[0].down is d
		else if player.right
			player.position.x += player.speed
		
		if player.position.y < 25/2
			player.position.y = 25/2
		else if player.position.y > 475+25/2
			player.position.y = 475+25/2
		if player.position.x < 25/2
			player.position.x = 25/2
		else if player.position.x > 475+25/2
			player.position.x = 475+25/2

	update_map()
	if check_collisions()
		# game over
		clearTimeout(timer)
		game_started = false
	else
		timer=setTimeout("game_logic()",25)

update_map = ->
	$('#map').clearCanvas()
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
			y1: 0
			x2: elem.x
			y2: 500
		.drawLine
			strokeStyle: "#f90c22"
			strokeWidth: 2
			x1: 0
			y1: elem.y
			x2: 500
			y2: elem.y
	for player in players
		$('#map').drawRect
			fillStyle: '#3d454b'
			x: player.position.x
			y: player.position.y
			width: 25
			height: 25
			fromCenter: true
			strokeStyle: '#000'
			strokeWidth: 1

drop_bomb = (x_pos, y_pos, pid) ->
	bombs.push({x: x_pos, y: y_pos, player_id: pid, timer: setTimeout("explode_bomb()",3000)})

explode_bomb = (index=0) ->
	clearTimeout(bombs[index].timer)
	# replenish bomb supply
	pid = bombs[index].player_id
	players[pid].num_bombs += 1
	explosion(bombs[index].x, bombs[index].y)
	bombs.splice(index,1)

explosion = (x_pos, y_pos) ->
	shake_map(5)
	
	explosions.push({x: x_pos, y: y_pos})
	
	setTimeout("extinguish_explosion()",1000)

chain_explosions = ->
	for index in explosions2b
		explode_bomb(index)
	# clear the explosions2b array
	explosions2b = []

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
	if player.position.x-25/2 < explosion.x < player.position.x+25/2 || player.position.y-25/2 < explosion.y < player.position.y+25/2
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
					drop_bomb(player.position.x, player.position.y, player_id)
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