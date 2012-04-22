# global vars
player1 =
	position:
		x: 25
		y: 25
	speed: 5
	up: false
	down: false
	right: false
	left: false

player2 =
	position:
		x: 475
		y: 475
	speed: 5
	up: false
	down: false
	right: false
	left: false

bombs = new Array()
explosions = new Array()
timer = null

game_logic = ->
	if player1.up
		player1.position.y -= player1.speed
	# keyplayer1.down is s
	else if player1.down
		player1.position.y += player1.speed
	# keyplayer1.down is a
	else if player1.left
		player1.position.x -= player1.speed
	# keyplayer1.down is d
	else if player1.right
		player1.position.x += player1.speed
	
	if player2.up
		player2.position.y -= player2.speed
	# keyplayer1.down is s
	else if player2.down
		player2.position.y += player2.speed
	# keyplayer1.down is a
	else if player2.left
		player2.position.x -= player2.speed
	# keyplayer1.down is d
	else if player2.right
		player2.position.x += player2.speed

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
	$('#map').drawRect
		fillStyle: '#3d454b'
		x: player1.position.x
		y: player1.position.y
		width: 25
		height: 25
		fromCenter: true
		strokeStyle: '#000'
		strokeWidth: 1
	.drawRect
		fillStyle: '#fff'
		x: player2.position.x
		y: player2.position.y
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
	explosions.push({x: x_pos, y: y_pos})
	setTimeout("extinguish_explosion()",1000)

extinguish_explosion = ->
	explosions.splice(0,1)

check_collisions = ->
	for elem in explosions
		if player_collision(player1, elem) && player_collision(player2, elem)
			console.log('both players dead')
			return true
		else if player_collision(player1, elem)
			console.log('player 1 dead')
			return true
		else if player_collision(player2, elem)
			console.log('player 2 dead')
			return true
		else
			return false
player_collision = (player, explosion) ->
	if player.position.x-25/2 < explosion.x < player.position.x+25/2 || player.position.y-25/2 < explosion.y < player.position.y+25/2
		return true
	else
		return false
$ ->
	game_logic()

$(document).bind 'keydown', (e) ->
	unless event.metaKey
		# keydown is w
		if e.which is 87
			player1.up = true
		# keydown is s
		else if e.which is 83
			player1.down = true
		# keydown is a
		else if e.which is 65
			player1.left = true
		# keydown is d
		else if e.which is 68
			player1.right = true
		# keydown is x
		else if e.which is 88
			drop_bomb(player1.position.x, player1.position.y)
		
		# keydown is p
		if e.which is 80
			player2.up = true
		# keydown is ;
		else if e.which is 186
			player2.down = true
		# keydown is l
		else if e.which is 76
			player2.left = true
		# keydown is '
		else if e.which is 222
			player2.right = true
		# keydown is comma
		else if e.which is 191
			drop_bomb(player2.position.x, player2.position.y)
			
		return false
.bind 'keyup', (e) ->
	unless event.metaKey
		# keydown is w
		if e.which is 87
			player1.up = false
		# keydown is s
		else if e.which is 83
			player1.down = false
		# keydown is a
		else if e.which is 65
			player1.left = false
		# keydown is d
		else if e.which is 68
			player1.right = false
			
		# keydown is p
		if e.which is 80
			player2.up = false
		# keydown is l
		else if e.which is 186
			player2.down = false
		# keydown is ;
		else if e.which is 76
			player2.left = false
		# keydown is '
		else if e.which is 222
			player2.right = false
			
		return false