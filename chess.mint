 
//Here is a program in Mint that will check the next move for 8 chess pawns. 
This program assumes that the pawns are stored in an array called PAWNS, 
with each element of the array representing the position of a pawn on the chessboard. 
The program will print out the next possible position for each pawn.
To use this program, you will need to replace PAWNS with the address of the array that stores the positions of the pawns. 
The CHECK_PAWN command will check the next possible position for a single pawn, 
and the MAIN command will loop through the CHECK_PAWN command for each pawn in the array.
//

```
:CHECK_PAWN   \[   1 +   \[  0  1  ]   \@ PAWNS   \> \i
  0 =   \[  0 -1  ]   \@ PAWNS   \> \i
  \]   \i   ;

:MAIN   \[  1  2  3  4  5  6  7  8  ]   CHECK_PAWN   ;
```
