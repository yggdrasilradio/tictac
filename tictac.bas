        ' TIC TAC TOE by Rick Adams

	' Randomize the RND function
	x = rnd(-timer)

	' Reset machine on BREAK
	on brk goto 1000

	' Init video
	rgb
	width 40
	palette 0, 0	' background: black
	palette 8, 25 	' foreground: cyan

        ' Allocate arrays
        dim a(9), b(4), c(24), d(4), e(4)

        ' Define the 8 winning lines
        for i = 1 to 24
                read c(i)
        next i

        ' Horizontal lines
        data 1, 2, 3
        data 4, 5, 6
        data 7, 8, 9

        ' Vertical lines
        data 1, 4, 7
        data 2, 5, 8
        data 3, 6, 9

        ' Diagonal lines
        data 1, 5, 9
        data 3, 5, 7

        ' Define the 4 side squares
        for i = 1 to 4
                read b(i)
        next i
        data 2, 4, 6, 8

        ' Define the 4 corner squares
        for i = 1 to 4
                read d(i)
        next i
        data 1, 3, 7, 9

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
10      print
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
	a(m) = 56 ' "X"

        ' Display the board
        gosub 100

        ' Evaluate game state
        gosub 300
        if x = 3 then		' Player wins?
		goto 30
	end if
        if n = 24 then		' Tie game?
		goto 40
	end if

        ' Make computer move
        gosub 200

        ' Display the board
        gosub 100

        ' Evaluate game state
        gosub 300
        if o = 3 then		' Computer wins?
		goto 35
	end if
        if n = 24 then		' Tie game?
		goto 40
	end if

        ' Keep playing
        goto 10

30      print
        print "Player wins!"
        goto 5

35      print
        print "Computer wins!"
        goto 5

40      print
        print "Tie game!"
        goto 5

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

        ' WIN: Look for winning or blocking move
200     gosub 400
        if m > 0 then
		goto 220
	end if

        ' DUMB: Make a dumb move every once in a while
        ' Otherwise this thing is pretty much unbeatable
        gosub 900
        if m > 0 then
		goto 220
	end if

        ' CENTER: Take the center if you can
        gosub 500
        if m > 0 then
		goto 220
	end if

        ' NOFORK: Block corner fork trap
        gosub 600
        if m > 0 then
		goto 220
	end if

        ' CORNER: Take a corner if possible
        gosub 700
        if m > 0 then
		goto 220
	end if

        ' RANDOM: Make a random move
	gosub 800

220     a(m) = 47 ' "O"         ' Make the move
        print
        print "Computer's move:"; m;
        print "("; f$; ")";     ' DEBUG
        print
        return

        ' Evaluate game state
300     n = 0                           ' Number of occupied cells
        s = 0
        for i = 1 to 9                  ' Serialize game board state
                s = s * 3
                if a(i) = 47 then
                        s = s + 1
		end if
		if a(i) = 56 then
                        s = s + 2
		end if
	next i
        for i = 1 to 22 step 3          ' Examine each of 8 lines
                x = 0                   ' Number of Xs in line
                o = 0                   ' Number of Os in line
                for j = i to i + 2
                        if a(c(j)) > 0 then
                                n = n + 1       ' One more occupied cell
			end if
			if a(c(j)) = 56 then
                                x = x + 1       ' One more X in this line
			end if
			if a(c(j)) = 47 then
                                o = o + 1       ' One more O in this line
			end if
		next j
                if x = 3 then		' Line has all Xs?
                        return          ' X wins
		end if
		if o = 3 then		' Line has all Os?
                        return          ' O wins
		end if
		if n = 24 then		' Every cell of every line filled?
                        return          ' Tie game
		end if
	next i
        return

        ' Find any winning or blocking moves for computer's turn
400     m = 0   ' No move decision yet
        w = 0   ' No winning move yet
        b = 0   ' No blocking move yet
        for i = 1 to 22 step 3          ' Examine each of 8 lines
                n = 0                   ' Number of Xs and Os in line
                x = 0                   ' Number of Xs in line
                o = 0                   ' Number of Os in line
                e = 0                   ' Index of empty cell
                for j = i to i + 2
                        if a(c(j)) > 0 then
                                n = n + 1
			end if
                        if a(c(j)) = 56 then
                                x = x + 1       ' One more X in this line
			end if
			if a(c(j)) = 47 then
                                o = o + 1       ' One more O in this line
			end if
			if a(c(j)) = 0 then
                                e = c(j)        ' Index of empty cell
			end if
		next j
                if n < 3 and o = 2 then		' Line has two Os and an unoccupied cell?
                        w = e			' Winning move
		end if
		if n < 3 and x = 2 then		' Line has two Xs and an unoccupied cell?
                        b = e			' Blocking move
		end if
	next i
        if w > 0 then		' Take winning move if there is one
                m = w
                f$ = "WIN"
		return
	end if
	if b > 0 then		' Take blocking move if there is one
                m = b
                f$ = "BLOCK"
	end if
	return

        ' CENTER
500     f$ = "CENTER"
        if a(5) = 0 then
		m = 5           ' Take center square
	end if
	return

        ' NOFORK
600     f$ = "NOFORK"
	if s = 13205 or s = 1557 then
		m = b(int(4 * rnd(0)) + 1)      ' Block with a side square
	end if
	return

        ' CORNER
700     c = 0
        f$ = "CORNER"
        for i = 1 to 4			' Try to find a corner square
                if a(d(i)) = 0 then
                        c = c + 1
                        e(c) = d(i)	' Found one
		end if
	next i
        if c > 0 then
                m = e(int(c * rnd(0)) + 1) ' Choose random corner
	end if
	return

        ' RANDOM
800     f$ = "RANDOM"
810     m = int(9 * rnd(0)) + 1	' Try random move as a Hail Mary
        if a(m) <> 0 then
		goto 810	' Keep trying till an empty cell found
	end if
        return

        ' DUMB
900     f$ = "DUMB"
        if int(100 * rnd(0)) + 1 < 20 then	' 20% chance of making a dumb move
		gosub 810
	end if
	return

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b
