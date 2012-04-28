This is a game made using javascript (jQuery) and HTML5 Canvas. It is admittedly heavily inspired by my favorite flash game of all time, Balloono, which is itself an online multiplayer clone of Bomberman. I wanted to see if I could make a Balloono/Bomberman clone using javascript and HTML5's canvas.

The project is in its early stages, i.e. no graphics work, so the game can be summarized as follows:

	Two squares do mortal combat using laser-emitting bombs.

To see a working demo, open up 'jsbomber.html' in your favorite modern web browser.

Player 1 controls:

	movement: WASD
	drop a bomb: X

Player 2 controls:

	movement: PL;' (semicolon and single quote)
	drop a bomb: / (forward slash)

GREY blocks are indestructible blocks

BROWN blocks are destructible blocks, which when destroyed may drop ORANGE blocks (upgrades)

ORANGE blocks are labeled with 'b' (increases player's max number of bombs that can be dropped), 'r' (increases range of player's bombs), 's' (increases player's speed)

BLUE blocks are bombs that explode within a certain time interval (read: get out of the way!)