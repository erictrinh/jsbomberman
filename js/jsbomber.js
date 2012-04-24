// Generated by CoffeeScript 1.3.1
var Bomb, Empty, Explosion, Stone, Upgrade, Wood, can_go, check_collisions, drop_bomb, explode, explosion_logic, explosions, extinguish, game_logic, game_over_screen, game_started, get_grid_coords, init_game, intro_screen, move_down, move_left, move_right, move_up, movement_logic, objects, on_snap_x, on_snap_y, player_collision, players, set_explosion, shake_map, timer, update_map;

players = new Array();

explosions = new Array();

objects = new Array();

timer = null;

game_started = false;

intro_screen = function() {
  var center;
  center = $('#map').width() / 2;
  return $('#map').drawText({
    fillStyle: '#000',
    x: center,
    y: 100,
    text: 'JSBomber',
    font: '60pt Helvetica, sans-serif'
  }).drawText({
    fillStyle: '#000',
    x: center,
    y: 300,
    text: "Press 'spacebar' to start",
    font: '25pt Helvetica, sans-serif'
  });
};

game_over_screen = function(text) {
  var center;
  center = $('#map').width() / 2;
  return $('#map').drawText({
    fillStyle: '#000',
    x: center,
    y: 100,
    text: text,
    font: '50pt Helvetica, sans-serif'
  }).drawText({
    fillStyle: '#000',
    x: center,
    y: 300,
    text: "Play again? (Spacebar)",
    font: '25pt Helvetica, sans-serif'
  });
};

Empty = function() {
  this.type = 'empty';
  this.destructible = false;
  return this.walkable = true;
};

Stone = function() {
  this.type = 'stone';
  this.destructible = false;
  return this.walkable = false;
};

Wood = function() {
  this.type = 'wood';
  this.destructible = true;
  return this.walkable = false;
};

Bomb = function(r, pid, t) {
  this.type = 'bomb';
  this.destructible = true;
  this.walkable = false;
  this.range = r;
  this.player_id = pid;
  return this.timer = t;
};

Explosion = function() {
  this.type = 'explosion';
  this.destructible = false;
  this.walkable = true;
  return this.count = 1;
};

Upgrade = function(k) {
  this.type = 'upgrade';
  this.destructible = false;
  this.walkable = true;
  return this.kind = k;
};

init_game = function() {
  var c_index, object, r_index, row, _i, _j, _len, _len1;
  game_started = true;
  explosions = [];
  objects = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];
  for (r_index = _i = 0, _len = objects.length; _i < _len; r_index = ++_i) {
    row = objects[r_index];
    for (c_index = _j = 0, _len1 = row.length; _j < _len1; c_index = ++_j) {
      object = row[c_index];
      if (object === 0) {
        objects[r_index][c_index] = new Empty();
      } else if (object === 1) {
        objects[r_index][c_index] = new Stone();
      }
    }
  }
  players[0] = {
    position: {
      x: 25,
      y: 25
    },
    facing: 'down',
    speed: 5,
    num_bombs: 3,
    bomb_range: 10,
    controls: {
      up: 87,
      down: 83,
      left: 65,
      right: 68,
      drop: 88
    },
    up: false,
    down: false,
    right: false,
    left: false,
    dead: false
  };
  return players[1] = {
    facing: 'up',
    position: {
      x: 725,
      y: 425
    },
    speed: 5,
    num_bombs: 3,
    bomb_range: 3,
    controls: {
      up: 80,
      down: 186,
      left: 76,
      right: 222,
      drop: 191
    },
    up: false,
    down: false,
    right: false,
    left: false,
    dead: false
  };
};

on_snap_x = function(player) {
  var x, x_distance;
  x = player.position.x;
  x_distance = (x - 25) % 50;
  if (x_distance > 0) {
    if (x_distance < 25) {
      return x - x_distance;
    } else {
      return x + (50 - x_distance);
    }
  } else {
    return x;
  }
};

on_snap_y = function(player) {
  var y, y_distance;
  y = player.position.y;
  y_distance = (y - 25) % 50;
  if (y_distance > 0) {
    if (y_distance < 25) {
      return y - y_distance;
    } else {
      return y + (50 - y_distance);
    }
  } else {
    return y;
  }
};

get_grid_coords = function(player) {
  var c, r, x, y;
  x = on_snap_x(player);
  y = on_snap_y(player);
  c = (x - 25) / 50;
  r = (y - 25) / 50;
  return {
    row: r,
    col: c
  };
};

can_go = function(player) {
  var coords, d, l, r, u;
  coords = get_grid_coords(player);
  u = true;
  d = true;
  l = true;
  r = true;
  if (coords.col === 0 && player.position.x !== 25) {
    l = true;
  } else if (player.position.x === 25 || coords.col === 0 || !objects[coords.row][coords.col - 1].walkable) {
    l = false;
  }
  if (coords.col === 14 && player.position.x !== 725) {
    r = true;
  } else if (player.position.x === 725 || coords.col === 14 || !objects[coords.row][coords.col + 1].walkable) {
    r = false;
  }
  if (coords.row === 0 && player.position.y !== 25) {
    u = true;
  } else if (player.position.y === 25 || coords.row === 0 || !objects[coords.row - 1][coords.col].walkable) {
    u = false;
  }
  if (coords.row === 8 && player.position.y !== 425) {
    d = true;
  } else if (player.position.y === 425 || coords.row === 8 || !objects[coords.row + 1][coords.col].walkable) {
    d = false;
  }
  return {
    up: u,
    down: d,
    left: l,
    right: r
  };
};

move_up = function(player) {
  player.facing = 'up';
  return player.position.y -= player.speed;
};

move_down = function(player) {
  player.facing = 'down';
  return player.position.y += player.speed;
};

move_left = function(player) {
  player.facing = 'left';
  return player.position.x -= player.speed;
};

move_right = function(player) {
  player.facing = 'right';
  return player.position.x += player.speed;
};

movement_logic = function(player) {
  if (player.up) {
    if (on_snap_x(player) !== player.position.x) {
      if (can_go(player).up) {
        if (on_snap_x(player) > player.position.x) {
          return move_right(player);
        } else {
          return move_left(player);
        }
      } else {
        if (on_snap_x(player) > player.position.x) {
          return move_left(player);
        } else {
          return move_right(player);
        }
      }
    } else {
      if (can_go(player).up) {
        return move_up(player);
      } else {
        return player.facing = 'up';
      }
    }
  } else if (player.down) {
    if (on_snap_x(player) !== player.position.x) {
      if (can_go(player).down) {
        if (on_snap_x(player) > player.position.x) {
          return move_right(player);
        } else {
          return move_left(player);
        }
      } else {
        if (on_snap_x(player) > player.position.x) {
          return move_left(player);
        } else {
          return move_right(player);
        }
      }
    } else {
      if (can_go(player).down) {
        return move_down(player);
      } else {
        return player.facing = 'down';
      }
    }
  } else if (player.left) {
    if (on_snap_y(player) !== player.position.y) {
      if (can_go(player).left) {
        if (on_snap_y(player) > player.position.y) {
          return move_down(player);
        } else {
          return move_up(player);
        }
      } else {
        if (on_snap_y(player) > player.position.y) {
          return move_up(player);
        } else {
          return move_down(player);
        }
      }
    } else {
      if (can_go(player).left) {
        return move_left(player);
      } else {
        return player.facing = 'left';
      }
    }
  } else if (player.right) {
    if (on_snap_y(player) !== player.position.y) {
      if (can_go(player).right) {
        if (on_snap_y(player) > player.position.y) {
          return move_down(player);
        } else {
          return move_up(player);
        }
      } else {
        if (on_snap_y(player) > player.position.y) {
          return move_up(player);
        } else {
          return move_down(player);
        }
      }
    } else {
      if (can_go(player).right) {
        return move_right(player);
      } else {
        return player.facing = 'right';
      }
    }
  }
};

game_logic = function() {
  var player, _i, _len;
  for (_i = 0, _len = players.length; _i < _len; _i++) {
    player = players[_i];
    movement_logic(player);
  }
  update_map();
  if (check_collisions()) {
    clearTimeout(timer);
    return game_started = false;
  } else {
    return timer = setTimeout("game_logic()", 25);
  }
};

update_map = function() {
  var arc_end, arc_start, c_index, column, grid_square, num, overlay, player, r_index, row, template, _i, _j, _k, _l, _len, _len1, _len2, _len3, _results;
  $('#map').clearCanvas();
  template = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
  overlay = (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = template.length; _i < _len; _i++) {
      num = template[_i];
      _results.push(num * 50);
    }
    return _results;
  })();
  for (_i = 0, _len = overlay.length; _i < _len; _i++) {
    num = overlay[_i];
    $('#map').drawLine({
      strokeStyle: "#cfcfcf",
      strokeWidth: 1,
      x1: num,
      y1: 0,
      x2: num,
      y2: 450
    });
    if (num <= 425) {
      $('#map').drawLine({
        strokeStyle: "#cfcfcf",
        strokeWidth: 1,
        x1: 0,
        y1: num,
        x2: 750,
        y2: num
      });
    }
  }
  for (r_index = _j = 0, _len1 = objects.length; _j < _len1; r_index = ++_j) {
    row = objects[r_index];
    for (c_index = _k = 0, _len2 = row.length; _k < _len2; c_index = ++_k) {
      column = row[c_index];
      grid_square = objects[r_index][c_index];
      if (grid_square.type === 'stone') {
        $('#map').drawRect({
          fillStyle: '#777777',
          x: c_index * 50 + 25,
          y: r_index * 50 + 25,
          width: 50,
          height: 50,
          fromCenter: true
        });
      } else if (grid_square.type === 'explosion') {
        $('#map').drawRect({
          fillStyle: '#f90c22',
          x: c_index * 50 + 25,
          y: r_index * 50 + 25,
          width: 50,
          height: 50,
          fromCenter: true
        });
      } else if (grid_square.type === 'bomb') {
        $('#map').drawRect({
          fillStyle: '#0c9df9',
          x: c_index * 50 + 25,
          y: r_index * 50 + 25,
          width: 40,
          height: 40,
          fromCenter: true
        });
      }
    }
  }
  _results = [];
  for (_l = 0, _len3 = players.length; _l < _len3; _l++) {
    player = players[_l];
    $('#map').drawRect({
      fillStyle: '#fff',
      x: player.position.x,
      y: player.position.y,
      width: 25,
      height: 25,
      fromCenter: true,
      strokeStyle: '#000',
      strokeWidth: 1
    });
    if (player.facing === 'right') {
      arc_start = 45;
      arc_end = 135;
    } else if (player.facing === 'down') {
      arc_start = 135;
      arc_end = 225;
    } else if (player.facing === 'left') {
      arc_start = 225;
      arc_end = 315;
    } else if (player.facing === 'up') {
      arc_start = 315;
      arc_end = 45;
    }
    _results.push($('#map').drawArc({
      strokeStyle: "#000",
      strokeWidth: 1,
      x: player.position.x,
      y: player.position.y,
      radius: 18,
      start: arc_start,
      end: arc_end
    }));
  }
  return _results;
};

drop_bomb = function(x_pos, y_pos, pid, brange) {
  var c, r;
  c = (x_pos - 25) / 50;
  r = (y_pos - 25) / 50;
  return objects[r][c] = new Bomb(brange, pid, setTimeout("explode(" + r + "," + c + ")", 3000));
};

explode = function(r, c) {
  var bomb, offset, pid, range, times;
  bomb = objects[r][c];
  clearTimeout(bomb.timer);
  pid = bomb.player_id;
  players[pid].num_bombs += 1;
  range = bomb.range;
  explosion_logic(r, c, range);
  offset = range;
  times = Math.ceil(range / 5);
  return shake_map(offset, times);
};

explosion_logic = function(r, c, range) {
  var countdown, temp_c, temp_r;
  set_explosion(r, c);
  setTimeout("extinguish(" + r + "," + c + ")", 1000);
  countdown = range;
  temp_r = r - 1;
  while (countdown > 0 && temp_r >= 0 && objects[temp_r][c].walkable) {
    set_explosion(temp_r, c);
    setTimeout("extinguish(" + temp_r + "," + c + ")", 1000);
    temp_r -= 1;
    countdown -= 1;
  }
  if (countdown > 0 && temp_r >= 0 && objects[temp_r][c].type === 'bomb') {
    explode(temp_r, c);
  }
  countdown = range;
  temp_r = r + 1;
  while (countdown > 0 && temp_r <= 8 && objects[temp_r][c].walkable) {
    set_explosion(temp_r, c);
    setTimeout("extinguish(" + temp_r + "," + c + ")", 1000);
    temp_r += 1;
    countdown -= 1;
  }
  if (countdown > 0 && temp_r <= 8 && objects[temp_r][c].type === 'bomb') {
    explode(temp_r, c);
  }
  countdown = range;
  temp_c = c - 1;
  while (countdown > 0 && temp_c >= 0 && objects[r][temp_c].walkable) {
    set_explosion(r, temp_c);
    setTimeout("extinguish(" + r + "," + temp_c + ")", 1000);
    temp_c -= 1;
    countdown -= 1;
  }
  if (countdown > 0 && temp_c >= 0 && objects[r][temp_c].type === 'bomb') {
    explode(r, temp_c);
  }
  countdown = range;
  temp_c = c + 1;
  while (countdown > 0 && temp_c <= 14 && objects[r][temp_c].walkable) {
    set_explosion(r, temp_c);
    setTimeout("extinguish(" + r + "," + temp_c + ")", 1000);
    temp_c += 1;
    countdown -= 1;
  }
  if (countdown > 0 && temp_c <= 14 && objects[r][temp_c].type === 'bomb') {
    return explode(r, temp_c);
  }
};

set_explosion = function(r, c) {
  if (objects[r][c].type !== 'explosion') {
    return objects[r][c] = new Explosion();
  } else {
    return objects[r][c].count += 1;
  }
};

extinguish = function(r, c) {
  if (objects[r][c].type === 'explosion') {
    if (objects[r][c].count === 1) {
      return objects[r][c] = new Empty();
    } else {
      return objects[r][c].count -= 1;
    }
  }
};

check_collisions = function() {
  var player, _i, _len;
  for (_i = 0, _len = players.length; _i < _len; _i++) {
    player = players[_i];
    if (player_collision(player)) {
      player.dead = true;
    }
  }
  if (players[0].dead && players[1].dead) {
    game_over_screen('double suicide');
    return true;
  } else if (players[0].dead) {
    game_over_screen('player 1 dead');
    return true;
  } else if (players[1].dead) {
    game_over_screen('player 2 dead');
    return true;
  } else {
    return false;
  }
};

player_collision = function(player) {
  var c, coords, r;
  coords = get_grid_coords(player);
  r = coords.row;
  c = coords.col;
  if (objects[r][c].type === 'explosion') {
    return true;
  } else {
    return false;
  }
};

shake_map = function(offset, times) {
  var anitime;
  if (times > 0) {
    anitime = 100 / times;
    return $('#map').animate({
      left: '+=' + offset
    }, anitime, function() {
      return $('#map').animate({
        left: '-=' + offset
      }, anitime, function() {
        return shake_map(offset, times - 1);
      });
    });
  }
};

$(function() {
  return intro_screen();
});

$(document).bind('keydown', function(e) {
  var player, player_id, _i, _len;
  if (!event.metaKey) {
    if (!game_started) {
      if (e.which === 32) {
        init_game();
        game_logic();
      }
    }
    for (player_id = _i = 0, _len = players.length; _i < _len; player_id = ++_i) {
      player = players[player_id];
      if (e.which === player.controls.up) {
        player.up = true;
      } else if (e.which === player.controls.down) {
        player.down = true;
      } else if (e.which === player.controls.left) {
        player.left = true;
      } else if (e.which === player.controls.right) {
        player.right = true;
      } else if (e.which === player.controls.drop) {
        if (player.num_bombs > 0) {
          drop_bomb(on_snap_x(player), on_snap_y(player), player_id, player.bomb_range);
          player.num_bombs -= 1;
        }
      }
    }
    return false;
  }
}).bind('keyup', function(e) {
  var player, player_id, _i, _len;
  if (!event.metaKey) {
    for (player_id = _i = 0, _len = players.length; _i < _len; player_id = ++_i) {
      player = players[player_id];
      if (e.which === player.controls.up) {
        player.up = false;
      } else if (e.which === player.controls.down) {
        player.down = false;
      } else if (e.which === player.controls.left) {
        player.left = false;
      } else if (e.which === player.controls.right) {
        player.right = false;
      }
    }
    return false;
  }
});
