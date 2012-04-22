# global vars
players = new Array()
bombs = new Array()
explosions = new Array()
timer = null

# initialize the game with 2 players
init_game = ->
	players[0] = 
		position:
			x: 25
			y: 25
		speed: 5
		up: false
		down: false
		right: false
		left: false
	players[1] = 
		position:
			x: 475
			y: 475
		speed: 5
		up: false
		down: false
		right: false
		left: false

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

	update_map()
	if check_collisions()
		clearTimeout(timer)
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

drop_bomb = (x_pos, y_pos) ->
	bombs.push({x: x_pos, y: y_pos})
	setTimeout("explode_bomb()",2000)

explode_bomb = ->
	explosion(bombs[0].x, bombs[0].y)
	bombs.splice(0,1)

explosion = (x_pos, y_pos) ->
	shake_map(5)
	explosions.push({x: x_pos, y: y_pos})
	setTimeout("extinguish_explosion()",1000)

extinguish_explosion = ->
	explosions.splice(0,1)

check_collisions = ->
	for elem in explosions
		if player_collision(players[0], elem) && player_collision(players[1], elem)
			console.log('both players dead')
			return true
		else if player_collision(players[0], elem)
			console.log('player 1 dead')
			return true
		else if player_collision(players[1], elem)
			console.log('player 2 dead')
			return true
		else
			return false
player_collision = (player, explosion) ->
	if player.position.x-25/2 < explosion.x < player.position.x+25/2 || player.position.y-25/2 < explosion.y < player.position.y+25/2
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
	init_game()
	game_logic()

$(document).bind 'keydown', (e) ->
	unless event.metaKey
		# keydown is w
		if e.which is 87
			players[0].up = true
		# keydown is s
		else if e.which is 83
			players[0].down = true
		# keydown is a
		else if e.which is 65
			players[0].left = true
		# keydown is d
		else if e.which is 68
			players[0].right = true
		# keydown is x
		else if e.which is 88
			drop_bomb(players[0].position.x, players[0].position.y)
		
		# keydown is p
		if e.which is 80
			players[1].up = true
		# keydown is ;
		else if e.which is 186
			players[1].down = true
		# keydown is l
		else if e.which is 76
			players[1].left = true
		# keydown is '
		else if e.which is 222
			players[1].right = true
		# keydown is comma
		else if e.which is 191
			drop_bomb(players[1].position.x, players[1].position.y)
			
		return false
.bind 'keyup', (e) ->
	unless event.metaKey
		# keydown is w
		if e.which is 87
			players[0].up = false
		# keydown is s
		else if e.which is 83
			players[0].down = false
		# keydown is a
		else if e.which is 65
			players[0].left = false
		# keydown is d
		else if e.which is 68
			players[0].right = false
			
		# keydown is p
		if e.which is 80
			players[1].up = false
		# keydown is l
		else if e.which is 186
			players[1].down = false
		# keydown is ;
		else if e.which is 76
			players[1].left = false
		# keydown is '
		else if e.which is 222
			players[1].right = false
			
		return false