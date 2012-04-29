// Generated by CoffeeScript 1.3.1
var can_go_down, can_go_left, can_go_right, can_go_up, is_odd, move_down, move_left, move_right, move_up, movement_logic;

can_go_right = function(player) {
  var coords;
  coords = get_grid_coords(player);
  if (player.position.x === 425) {
    return false;
  } else if (coords.col === 8) {
    return true;
  }
  if (objects[coords.row][coords.col + 1].walkable) {
    return true;
  } else if (player.position.x !== on_snap_x(player)) {
    return true;
  } else {
    return false;
  }
};

can_go_left = function(player) {
  var coords;
  coords = get_grid_coords(player);
  if (player.position.x === 25) {
    return false;
  } else if (coords.col === 0) {
    return true;
  }
  if (objects[coords.row][coords.col - 1].walkable) {
    return true;
  } else if (player.position.x !== on_snap_x(player)) {
    return true;
  } else {
    return false;
  }
};

can_go_down = function(player) {
  var coords;
  coords = get_grid_coords(player);
  if (player.position.y === 425) {
    return false;
  } else if (coords.row === 8) {
    return true;
  }
  if (objects[coords.row + 1][coords.col].walkable) {
    return true;
  } else if (player.position.y !== on_snap_y(player)) {
    return true;
  } else {
    return false;
  }
};

can_go_up = function(player) {
  var coords;
  coords = get_grid_coords(player);
  if (player.position.y === 25) {
    return false;
  } else if (coords.row === 0) {
    return true;
  }
  if (objects[coords.row - 1][coords.col].walkable) {
    return true;
  } else if (player.position.y !== on_snap_y(player)) {
    return true;
  } else {
    return false;
  }
};

is_odd = function(num) {
  return num % 2 === 1;
};

move_up = function(player, unit) {
  player.facing = 'up';
  player.position.y -= unit;
  if (!is_odd(player.position.y) && unit === 2) {
    return player.position.y -= 1;
  }
};

move_down = function(player, unit) {
  player.facing = 'down';
  player.position.y += unit;
  if (!is_odd(player.position.y) && unit === 2) {
    return player.position.y += 1;
  }
};

move_left = function(player, unit) {
  player.facing = 'left';
  player.position.x -= unit;
  if (!is_odd(player.position.x) && unit === 2) {
    return player.position.x -= 1;
  }
};

move_right = function(player, unit) {
  player.facing = 'right';
  player.position.x += unit;
  if (!is_odd(player.position.x) && unit === 2) {
    return player.position.x += 1;
  }
};

movement_logic = function(player) {
  var rate, unit;
  unit = null;
  rate = null;
  switch (player.speed) {
    case 1:
      unit = 1;
      rate = 10;
      break;
    case 2:
      unit = 1;
      rate = 7;
      break;
    case 3:
      unit = 2;
      rate = 10;
      break;
    case 4:
      unit = 2;
      rate = 8;
      break;
    case 5:
      unit = 2;
      rate = 6;
      break;
    case 6:
      unit = 2;
      rate = 5;
      break;
    case 7:
      unit = 1;
      rate = 2;
      break;
    case 8:
      unit = 2;
      rate = 3;
      break;
    case 9:
      unit = 2;
      rate = 2;
      break;
    case 10:
      unit = 2;
      rate = 1;
  }
  if (player.up) {
    if (on_snap_x(player) !== player.position.x) {
      if (can_go_up(player)) {
        if (on_snap_x(player) > player.position.x) {
          move_right(player, unit);
        } else {
          move_left(player, unit);
        }
      } else {
        if (on_snap_x(player) > player.position.x) {
          move_left(player, unit);
        } else {
          move_right(player, unit);
        }
      }
    } else {
      if (can_go_up(player)) {
        move_up(player, unit);
      } else {
        player.facing = 'up';
      }
    }
  } else if (player.down) {
    if (on_snap_x(player) !== player.position.x) {
      if (can_go_down(player)) {
        if (on_snap_x(player) > player.position.x) {
          move_right(player, unit);
        } else {
          move_left(player, unit);
        }
      } else {
        if (on_snap_x(player) > player.position.x) {
          move_left(player, unit);
        } else {
          move_right(player, unit);
        }
      }
    } else {
      if (can_go_down(player)) {
        move_down(player, unit);
      } else {
        player.facing = 'down';
      }
    }
  } else if (player.left) {
    if (on_snap_y(player) !== player.position.y) {
      if (can_go_left(player)) {
        if (on_snap_y(player) > player.position.y) {
          move_down(player, unit);
        } else {
          move_up(player, unit);
        }
      } else {
        if (on_snap_y(player) > player.position.y) {
          move_up(player, unit);
        } else {
          move_down(player, unit);
        }
      }
    } else {
      if (can_go_left(player)) {
        move_left(player, unit);
      } else {
        player.facing = 'left';
      }
    }
  } else if (player.right) {
    if (on_snap_y(player) !== player.position.y) {
      if (can_go_right(player)) {
        if (on_snap_y(player) > player.position.y) {
          move_down(player, unit);
        } else {
          move_up(player, unit);
        }
      } else {
        if (on_snap_y(player) > player.position.y) {
          move_up(player, unit);
        } else {
          move_down(player, unit);
        }
      }
    } else {
      if (can_go_right(player)) {
        move_right(player, unit);
      } else {
        player.facing = 'right';
      }
    }
  }
  return player.movement = setTimeout("movement_logic(players[" + player.id + "])", rate);
};
