
	' TIC TAC TOE by Rick Adams

	' Randomize the RND function
	x = rnd(-timer)

	' Reset machine on BREAK
	on brk goto 1000

	' Init video
	rgb
	width 40
	palette 0, 0	' background: black
	palette 9, 25 	' foreground: cyan

	' Allocate arrays
	dim a(9), l(24)

	' Define the 8 winning lines
	for i = 1 to 24
		read l(i)
	next i

	' 3 horizontal lines
	data 1, 2, 3
	data 4, 5, 6
	data 7, 8, 9

	' 3 vertical lines
	data 1, 4, 7
	data 2, 5, 8
	data 3, 6, 9

	' 2 diagonal lines
	data 1, 5, 9
	data 3, 5, 7

	' Game title
5	print
	print "TIC TAC TOE"

	' Show board positions
	for i = 1 to 9
		a(i) = i + 16 ' "1" through "9"
	next i
	gosub 100

	' Clear board
	for i = 1 to 9
		a(i) = 0
	next i

	' Input player's move
10	print
	print "Your move";
	input m

	' Validate move
	m = int(m)
	if m < 1 or m > 9 then
		print "Illegal move"
		goto 10
	end if
	if a(m) > 0 then
		print "Illegal move"
		goto 10
	end if

	' Make player's move
25	a(m) = 56 ' "X"

	' Display the board
	gosub 100

	' Evaluate game state
	gosub 300
	if x = 3 then
		print
		print "Player wins!"
		goto 5
	end if
	if n = 24 then
		print
		print "Tie game!"
		goto 5
	end if

	' Make computer move
	gosub 200

	' Display the board
	gosub 100

	' Evaluate game state
	gosub 300
	if o = 3 then
		print
		print "Computer wins!"
		goto 5
	end if
	if n = 24 then
		print
		print "Tie game!"
		goto 5
	end if

	' Keep playing
	goto 10

	' Display Tic Tac Toe board
100	print
	for i = 1 to 3
		print " ";
		for j = 1 to 3
			k = (i - 1) * 3 + j
			print chr$(a(k) + 32);
			if j < 3 then
				print " ! ";
			end if
		next j
		print
		if i <> 3 then
			print "---+---+---"
		end if
	next i
	return

	' Make the computer's move
200	gosub 400		' Look for winning or blocking move
	if m <> 0 then		' Found a winning or blocking move?
		goto 220
	end if
	if a(5) > 0 then	' No: can we take the center square?
		goto 210
		m = 5		' Take the center square
	end if
210	m = int(9 * rnd(0)) + 1	' Try random move as a Hail Mary
	if a(m) <> 0 then	' Keep trying till an empty cell found
		goto 210
	end if
220	a(m) = 47 ' "O"		' Make the move
	print
	print "Computer's move:"; m
	return

	' Evaluate game state
300	n = 0
	for i = 1 to 22 step 3		' Examine each of 8 lines
		x = 0			' Number of Xs in line
		o = 0			' Number of Os in line
		for j = i to i + 2
			v = a(l(j))
			if v > 0 then
				n = n + 1	' One more occupied square
			end if
			if v = 56 then
				x = x + 1	' One more X in this line
			end if
			if v = 47 then
				o = o + 1	' One more O in this line
			end if
		next j
		if x = 3 or o = 3 then
			return			' Line is all Xs or Os
		end if
	next i
	return

	' Find any winning or blocking moves for computer's turn
400	m = 0				' No move decision yet
	for i = 1 to 22 step 3		' Examine each of 8 lines
		n = 0			' Number of Xs and Os in line
		x = 0			' Number of Xs in line
		o = 0			' Number of Os in line
		e = 0			' Index of empty square
		for j = i to i + 2
			if a(l(j)) = 56 then
				x = x + 1	' One more X in this line
			else if a(l(j)) = 47 then
				o = o + 1	' One more O in this line
			end if
			if a(l(j)) = 0 then
				e = l(j)	' Index of empty square
			else
				n = n + 1	' One more occupied square
			end if
		next j
		if n < 3 and o = 2 then		' Line has two Os?
			m = e			' Winning move
			return
		end if
		if n < 3 and x = 2 then		' Line has two Xs?
			m = e			' Blocking move
			return
		end if
	next i
	return

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b
