// Generated by CoffeeScript 1.3.1
var game_over_screen, intro_screen;

intro_screen = function() {
  var center;
  center = $('#map').width() / 2;
  return $('#map').drawText({
    fillStyle: '#000',
    x: center,
    y: 100,
    text: '{JSBomber}',
    font: '50pt Helvetica, serif'
  }).drawText({
    fillStyle: '#000',
    x: center,
    y: 300,
    text: "Press 'spacebar' to start",
    font: '20pt Helvetica, serif'
  });
};

game_over_screen = function(text) {
  var center;
  center = $('#map').width() / 2;
  return $('#overlay').drawText({
    fillStyle: '#000',
    x: center,
    y: 100,
    text: text,
    font: '50pt Helvetica, serif'
  }).drawText({
    fillStyle: '#000',
    x: center,
    y: 300,
    text: "Play again? (Spacebar)",
    font: '25pt Helvetica, serif'
  });
};