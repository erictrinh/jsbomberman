intro_screen = ->
	center = $('#map').width()/2
	$('#map').drawText
		fillStyle: '#000'
		x: center
		y: 100
		text: '{JSBomber}'
		font: '50pt Helvetica, serif'
	.drawText
		fillStyle: '#000'
		x: center
		y: 300
		text: "Press 'spacebar' to start"
		font: '20pt Helvetica, serif'

game_over_screen = (text) ->
	center = $('#map').width()/2
	$('#overlay').drawText
		fillStyle: '#000'
		x: center
		y: 100
		text: text
		font: '50pt Helvetica, serif'
	.drawText
		fillStyle: '#000'
		x: center
		y: 300
		text: "Play again? (Spacebar)"
		font: '25pt Helvetica, serif'