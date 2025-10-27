TICTAC: BASIC TIc Tac Toe game for Tandy Color Computer 3
==========

![](images/screenshot.jpg)

I wrote this Tic Tac Toe game in BASIC for a Tandy Color Computer 3.

The tictactoe strategy the program uses is:

- Take a winning move if there is one (WIN)
- Block the player from winning if needed (BLOCK)
- Block a fork with a side square (NOFORK)
- Take the center square if it's available (CENTER)
- Take a corner square (CORNER)

If none of those situations is present, it does a Hail Mary pass: it chooses any available square at random. (RANDOM)

For each move there is a 20% chance the computer will make a dumb move (DUMB).  Otherwise this thing would be pretty much
unbeatable.

The program is written to use my BASIC preprocessor so the code can be all pretty, and the preprocessor converts it to
sensible, legal BASIC for the Coco3.  See my [preprocessor](https://github.com/yggdrasilradio/preprocessor) repository for that.

Look in the [redistribute](https://github.com/yggdrasilradio/tictac/tree/master/redistribute) folder for the program in normal DECB ASCII format.


