class Player
	constructor: (pid, pos_x, pos_y, cont_up, cont_down, cont_left, cont_right, cont_drop) ->
		@id = pid
		@position =
			x: pos_x
			y: pos_y
		@facing = 'down'
		@speed = 1
		@bomb_supply =
			max_number: 1
			number: 1
			range: 1
		@controls =
			up: cont_up
			down: cont_down
			left: cont_left
			right: cont_right
			drop: cont_drop
		@up = false
		@down = false
		@right = false
		@left = false
		@dead = false
		@movement = movement_logic(this)
	
	# give the destination snap coordinates
	# returns player coordinates if on a snap coordinate
	on_snap_x: =>
		x = @position.x
		# distance past a snap coordinate
		x_distance = (x-25)%50
		
		if x_distance > 0
			if x_distance <= 25
				return x-x_distance
			else
				return x+(50-x_distance)
		else
			return x
	
	on_snap_y: =>
		y = @position.y
		# distance past a snap coordinate
		y_distance = (y-25)%50
		
		if y_distance > 0
			if y_distance <= 25
				return y-y_distance
			else
				return y+(50-y_distance)
		else
			return y
			
	# get the grid coordinates for a player
	get_grid_coords: =>
		x = @on_snap_x()
		y = @on_snap_y()
		c = (x-25)/50
		r = (y-25)/50
		return {row: r, col: c}
		
	can_go_right: =>
		coords = @get_grid_coords()
		
		if @position.x is 425
			return false
		else if coords.col is 8
			return true
		if objects[coords.row][coords.col+1].walkable
			return true
		else if @position.x isnt @on_snap_x()
			return true
		else
			return false
	
	can_go_left: =>
		coords = @get_grid_coords()
		
		if @position.x is 25
			return false
		else if coords.col is 0
			return true
		if objects[coords.row][coords.col-1].walkable
			return true
		else if @position.x isnt @on_snap_x()
			return true
		else
			return false
			
	can_go_down: =>
		coords = @get_grid_coords()
		
		if @position.y is 425
			return false
		else if coords.row is 8
			return true
		if objects[coords.row+1][coords.col].walkable
			return true
		else if @position.y isnt @on_snap_y()
			return true
		else
			return false
			
	can_go_up: =>
		coords = @get_grid_coords()
		
		if @position.y is 25
			return false
		else if coords.row is 0
			return true
		if objects[coords.row-1][coords.col].walkable
			return true
		else if @position.y isnt @on_snap_y()
			return true
		else
			return false
	
	move_up: (unit) =>
		@facing = 'up'
		@position.y -= unit
		if !is_odd(@position.y) && unit is 2
			@position.y -=1
	move_down: (unit) =>
		@facing = 'down'
		@position.y += unit
		if !is_odd(@position.y) && unit is 2
			@position.y +=1
	move_left: (unit) =>
		@facing = 'left'
		@position.x -= unit
		if !is_odd(@position.x) && unit is 2
			@position.x -=1
	move_right: (unit) =>
		@facing = 'right'
		@position.x += unit
		if !is_odd(@position.x) && unit is 2
			@position.x +=1
	