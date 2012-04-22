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
bomb_timers = new Array()
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
			strokeStyle: "#000"
			strokeWidth: 2
			x1: elem.x
			y1: 0
			x2: elem.x
			y2: 500
		.drawLine
			strokeStyle: "#000"
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
		if (player1.position.x-25/2 < elem.x < player1.position.x+25/2 || player1.position.y-25/2 < elem.y < player1.position.y+25/2) && (player2.position.x-25/2 < elem.x < player2.position.x+25/2 || player2.position.y-25/2 < elem.y < player2.position.y+25/2)
			console.log('both players dead')
			return true
		else if player1.position.x-25/2 < elem.x < player1.position.x+25/2 || player1.position.y-25/2 < elem.y < player1.position.y+25/2
			console.log('player 1 dead')
			return true
		else if player2.position.x-25/2 < elem.x < player2.position.x+25/2 || player2.position.y-25/2 < elem.y < player2.position.y+25/2
			console.log('player 2 dead')
			return true
		else
			return false

$ ->
	game_logic()

$(document).bind 'keydown', (e) ->
	unless event.metaKey
		# keyplayer1.down is w
		if e.which is 87
			player1.up = true
		# keyplayer1.down is s
		else if e.which is 83
			player1.down = true
		# keyplayer1.down is a
		else if e.which is 65
			player1.left = true
		# keyplayer1.down is d
		else if e.which is 68
			player1.right = true
		# keyplayer1.down is x
		else if e.which is 88
			drop_bomb(player1.position.x, player1.position.y)
		
		# keyplayer2.down is w
		if e.which is 73
			player2.up = true
		# keyplayer2.down is s
		else if e.which is 75
			player2.down = true
		# keyplayer2.down is a
		else if e.which is 74
			player2.left = true
		# keyplayer2.down is d
		else if e.which is 76
			player2.right = true
		# keyplayer2.down is spacebar
		else if e.which is 188
			drop_bomb(player2.position.x, player2.position.y)
		return false
$(document).bind 'keyup', (e) ->
	unless event.metaKey
		# keyplayer1.down is i
		if e.which is 87
			player1.up = false
		# keyplayer1.down is k
		else if e.which is 83
			player1.down = false
		# keyplayer1.down is j
		else if e.which is 65
			player1.left = false
		# keyplayer1.down is l
		else if e.which is 68
			player1.right = false
			
		# keyplayer1.down is w
		if e.which is 73
			player2.up = false
		# keyplayer1.down is s
		else if e.which is 75
			player2.down = false
		# keyplayer1.down is a
		else if e.which is 74
			player2.left = false
		# keyplayer1.down is d
		else if e.which is 76
			player2.right = false
			
		return false