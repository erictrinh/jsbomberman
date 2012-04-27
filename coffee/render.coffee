# draws the entire map at the beginning
init_draw = ->
	# draw the overlay
	template = [1..8]
	overlay = (num*50 for num in template)
	for num in overlay
		$('#overlay').drawLine
			strokeStyle: "#cfcfcf"
			strokeWidth: 1
			x1: num
			y1: 0
			x2: num
			y2: 450
		if num <= 425
			$('#overlay').drawLine
				strokeStyle: "#cfcfcf"
				strokeWidth: 1
				x1: 0
				y1: num
				x2: 450
				y2: num
	# draw the things on the map, using objects array as a template
	for row, r_index in objects
		for column, c_index in row
			update_map(r_index, c_index)

draw_player = ->
	$('#player').clearCanvas()
	for player in players
		$('#player').drawRect
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
		$('#player').drawArc
		  strokeStyle: "#000"
		  strokeWidth: 1
		  x: player.position.x
		  y: player.position.y
		  radius: 18
		  start: arc_start
		  end: arc_end
		  
# draw the bomb layer
draw_bomb = ->
	$('#bomb').clearCanvas()
	for row, r_index in objects
		for column, c_index in row
			sq = objects[r_index][c_index]
			if sq.type is 'explosion'
				$('#bomb').drawRect
					fillStyle: '#f90c22'
					x: c_index*50+25
					y: r_index*50+25
					width: 50
					height: 50
					fromCenter: true
			else if sq.type is 'bomb'
				$('#bomb').drawRect
					fillStyle: '#0c9df9'
					x: c_index*50+25
					y: r_index*50+25
					width: 40
					height: 40
					fromCenter: true

# update a section of the map
update_map = (r, c) ->
	cartesian = get_cartesian(r, c)
	x = cartesian.x
	y = cartesian.y
	$('#map').clearCanvas
		x: x
		y: y
		width: 50
		height: 50
	sq = objects[r][c]
	if sq.type is 'stone'
		$('#map').drawRect
			fillStyle: '#777777'
			x: x
			y: y
			width: 45
			height: 45
			fromCenter: true
			cornerRadius: 10
	else if sq.type is 'wood'
		$('#map').drawRect
			fillStyle: '#593f00'
			x: x
			y: y
			width: 40
			height: 40
			fromCenter: true
			cornerRadius: 10
	else if sq.type is 'upgrade'
		$('#map').drawRect
			fillStyle: '#ffad0f'
			x: x
			y: y
			width: 40
			height: 40
			fromCenter: true
		.drawText
			fillStyle: '#000'
			x: x
			y: y
			text: sq.kind.substring(0,1)
			font: '12pt Helvetica, sans-serif'