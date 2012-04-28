# global vars
players = new Array()
objects = new Array()
timer = null
game_started = false


# initialize the game with 2 players
init_game = ->
	$('#stats').css('color', 'black')
	$('#numbombs1').text(1)
	$('#numbombs2').text(1)
	$('#rangebombs1').text(1)
	$('#rangebombs2').text(1)
	$('#awesomeness').html('&#8734;')
	game_started = true
	# initialize objects as a 2d array and add stone blocks
	# objects
	# stone, wood, bomb, explosion, upgrade
	objects = [[5,5,0,0,0,0,0,0,0],[5,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,0],[0,0,0,0,0,0,0,0,0],[0,1,0,1,0,1,0,1,5],[0,0,0,0,0,0,0,5,5]]
	for row, r_index in objects
		for object, c_index in row
			# object is a reserved empty space
			if object is 5
				objects[r_index][c_index] = new Empty()
			else if object is 0
				# approx. 0.7 chance of there being a wooden block
				if Math.random() < 0.7
					# 0.3 chance of wooden block containing upgrade
					if Math.random() < 0.3
						# 0.5 chance of either bomb up or range up upgrade
						if Math.random() < 0.5
							objects[r_index][c_index] = new Wood('range_up')
						else
							objects[r_index][c_index] = new Wood('bomb_up')
					else
						objects[r_index][c_index] = new Wood()
				else
					objects[r_index][c_index] = new Empty()
			else if object is 1
				objects[r_index][c_index] = new Stone()
	
	players[0] = 
		id: 0
		position:
			x: 25
			y: 25
		facing: 'down'
		speed: 5
		bomb_supply:
			max_number: 1
			number: 1
			range: 1
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
		drop: false
		dead: false
	players[1] = 
		id: 1
		facing: 'up'
		position:
			x: 425
			y: 425
		speed: 5
		bomb_supply:
			max_number: 1
			number: 1
			range: 1
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
		drop: false
		dead: false

game_logic = ->
	for player in players
		movement_logic(player)
		walkover_logic(player)
	draw_player()
	if check_collisions()
		# game over
		clearTimeout(timer)
		game_started = false
	else
		timer=setTimeout("game_logic()",25)

# determines the logic of walked over items and terrain
# mainly upgrade behavior
walkover_logic = (player) ->
	coords = get_grid_coords(player)
	# if it's an upgrade, modify the player in some way
	if objects[coords.row][coords.col].type is 'upgrade'
		kind = objects[coords.row][coords.col].kind
		if kind is 'bomb_up' && player.bomb_supply.max_number < 10 # max number of bombs
			player.bomb_supply.max_number+=1
			player.bomb_supply.number+=1
			$('#numbombs'+(player.id+1)).text(player.bomb_supply.max_number)
		else if kind is 'range_up'&& player.bomb_supply.range < 10 # max range
			player.bomb_supply.range+=1
			$('#rangebombs'+(player.id+1)).text(player.bomb_supply.range)
		
		# delete the upgrade once you've picked it up
		objects[coords.row][coords.col] = new Empty()
		update_map(coords.row, coords.col)

drop_bomb = (r, c, pid, brange) ->
	objects[r][c] = new Bomb(brange, pid, setTimeout("explode("+r+","+c+")",2500))
	update_bomb(r, c)

# explode bomb at the coordinates
explode = (r, c) ->
	bomb = objects[r][c]
	# clear the timer from the bomb
	clearTimeout(bomb.timer)
	
	# replenish bomb supply of the player whose bomb this is
	pid = bomb.player_id
	players[pid].bomb_supply.number += 1
	
	# get the range of the bomb
	range = bomb.range
	
	# figure out the confines of the explosion
	explosion_logic(r, c, range)
	
	# figure out how much to shake the map
	# based off range of bombs 10
	offset = range
	times = Math.ceil(range/5)

# given the coordinates of the epicenter and range of explosion
# figure out which squares will be exploded/destroyed
explosion_logic = (r, c, range) ->
	# set the epicenter grid square to an explosion square
	set_explosion(r, c)
	update_bomb(r, c)
	
	# figure out if bomb can explode upward
	countdown = range # range of the bomb
	temp_r = r-1
	while countdown > 0 && temp_r >= 0 && objects[temp_r][c].walkable
		set_explosion(temp_r, c)
		temp_r -= 1
		countdown -= 1
	if countdown > 0 && temp_r >= 0 && objects[temp_r][c].destructible
		if objects[temp_r][c].type is 'bomb'
			explode(temp_r, c)
		else if objects[temp_r][c].type is 'wood'
			set_explosion(temp_r, c)
		
	# figure out if bomb can explode downward
	countdown = range # range of the bomb
	temp_r = r+1
	while countdown > 0 && temp_r <= 8 && objects[temp_r][c].walkable
		set_explosion(temp_r, c)
		temp_r += 1
		countdown -= 1
	if countdown > 0 && temp_r <= 8 && objects[temp_r][c].destructible
		if objects[temp_r][c].type is 'bomb'
			explode(temp_r, c)
		else if objects[temp_r][c].type is 'wood'
			set_explosion(temp_r, c)
		
	# figure out if bomb can explode leftward
	countdown = range # range of the bomb
	temp_c = c-1
	while countdown > 0 && temp_c >= 0 && objects[r][temp_c].walkable
		set_explosion(r, temp_c)
		temp_c -= 1
		countdown -= 1
	if countdown > 0 && temp_c >= 0 && objects[r][temp_c].destructible
		if objects[r][temp_c].type is 'bomb'
			explode(r, temp_c)
		else if objects[r][temp_c].type is 'wood'
			set_explosion(r, temp_c)
	
	# figure out if bomb can explode rightward
	countdown = range # range of the bomb
	temp_c = c+1
	while countdown > 0 && temp_c <= 8 && objects[r][temp_c].walkable
		set_explosion(r, temp_c)
		temp_c += 1
		countdown -= 1
	if countdown > 0 && temp_c <= 8 && objects[r][temp_c].destructible
		if objects[r][temp_c].type is 'bomb'
			explode(r, temp_c)
		else if objects[r][temp_c].type is 'wood'
			set_explosion(r, temp_c)

# set an explosion at the coordinates
# explosions can stack
# extinguish these explosions later
set_explosion = (r, c) ->
	# if there's already an explosion, stack another explosion on top of it
	if objects[r][c].type is 'explosion'
		objects[r][c].count += 1
	else
		# if this is a wood block containing an upgrade, set the block to the upgrade
		# this happens after the explosion
		if objects[r][c].type is 'wood' && objects[r][c].upgrade isnt false
			setTimeout("set_upgrade("+r+","+c+",'"+objects[r][c].upgrade+"')",1000)
		else if objects[r][c].type is 'upgrade'
			setTimeout("set_upgrade("+r+","+c+",'"+objects[r][c].kind+"')",1000)
		objects[r][c] = new Explosion()
		update_bomb(r, c)
		
	
	# extinguish those explosions later
	setTimeout("extinguish("+r+","+c+")",1000)

extinguish = (r, c) ->
	if objects[r][c].type is 'explosion'
		if objects[r][c].count is 1
			objects[r][c] = new Empty()
			update_map(r, c)
			update_bomb(r, c)
		else
			objects[r][c].count -= 1

# set an upgrade at the coordinates
set_upgrade = (r, c, kind) ->
	objects[r][c] = new Upgrade(kind)
	update_map(r, c)
	update_bomb(r, c)

# check if any of the explosions hit the players
check_collisions = ->
	for player in players
		if player_collision(player)
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


player_collision = (player) ->
	coords = get_grid_coords(player)
	r = coords.row
	c = coords.col
	
	if objects[r][c].type is 'explosion'
		return true
	else
		return false

$ ->
	intro_screen()

$(document).bind 'keydown', (e) ->
	unless event.metaKey
		unless game_started
			if e.which is 32 # this is the spacebar
				init_game()
				init_draw()
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
				coords = get_grid_coords(player)
				if player.bomb_supply.number>0 && objects[coords.row][coords.col].type isnt 'bomb'
					drop_bomb(coords.row, coords.col, player_id, player.bomb_supply.range)
					player.bomb_supply.number -= 1
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