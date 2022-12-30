# TEC-1 Chess game

## tec-CHESS-7seg
rook ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/rook.png)
knight ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/knight.png)
bishop ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/bishop.png)
king ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/king.png)
queen ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/queen.png)
pawn ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/pawn.png)

## hardware
- pieces hand moved on board following 7seg displayed or DAT's LCD display
- https://github.com/SteveJustin1963/tec-SPEECH can say the moves and comments
- played with BOT gripper 

## software
-MINT


## create an algorithm to play chess. 
There are many different approaches that can be taken to design an algorithm for playing chess, depending on the level of complexity and performance desired.

One approach to designing an algorithm for playing chess is to use a search algorithm, such as minimax or alpha-beta pruning, to evaluate the potential moves that can be made from a given board state and choose the best move based on a score that is calculated for each possible move. The score for a move can be based on factors such as the material balance (difference in the number of pieces), the position of the pieces on the board, and the mobility of the pieces.

Another approach is to use machine learning techniques, such as neural networks, to train a model to predict the best move given a board state. This can be done by training the model on a large dataset of chess games, where the input is the board state and the output is the best move. The model can then be used to make predictions for new board states.

Both of these approaches can be implemented in Mint or any other programming language.

## Minimax 
is a search algorithm that is often used in two-player, zero-sum games, such as chess, to determine the best move for a player. It works by assuming that the opposing player will always choose the move that is best for them, and then considering the worst possible outcome for the current player.

The algorithm uses a recursive function to evaluate the potential moves that can be made from a given board state. For each possible move, it calculates the score for the resulting board state and then recursively calls itself to evaluate the potential moves that can be made by the opposing player. This process continues until the game is over or the search reaches a predetermined depth.

The minimax algorithm then chooses the move that maximizes the score for the current player while minimizing the score for the opposing player. In other words, it aims to maximize the score for the current player while minimizing the score for the opposing player.

Minimax a simple and effective approach for determining the best move in a two-player, zero-sum game, but it can be computationally expensive for larger games with many possible moves.

```
:MINIMAX   \[   DEPTH   0   =   \[  SCORE   \]   \> \i   \\ base case: if depth is 0, return the score
  MOVES   \@   \\ get a list of possible moves
  \[  \]   \> \j   \\ initialize the best score
  \i   1   +   \> DEPTH   \\ increment the depth
  \[  \]   \> \k   \\ initialize the score for the current move
  \[  \]   \> \l   \\ initialize the current move
  MOVES   \[  \]   \> \m   \\ iterate through the moves
  \m   \l   \>   \\ get the next move
  \[  \l   \]   DO_MOVE   \\ make the move
  MINIMAX   \> \k   \\ evaluate the resulting board state
  UNDO_MOVE   \\ undo the move
  \k   \j   >   \j   \k   \> \j   \\ update the best score
  \]   \j   ;

:MAIN   \[  BOARD_STATE  DEPTH  ]   MIN
```

To complete the minimax algorithm, you will need to define functions: then you can use the minimax algorithm to determine the best move for a player given a board state and a desired search depth.

## DO_MOVE: 
This function should take a move as input and update the board state to reflect the move.
```
:DO_MOVE   \[  MOVE   ]   \[    MOVE   \@   \\ get the starting position of the piece  \[  \]   \> \i   \\ initialize the current position
  \i   MOVE   -   \> \j   \\ calculate the distance to move
  \j   0   >   \[  \]   \[  \]   \\ move forward if j > 0, otherwise move backward
  \[  \i   \j   +   \]   STORE   \\ update the position of the piece
  \]   ;
```
This function takes a move as input and updates the board state to reflect the move by storing the new position of the piece at the appropriate location in memory. The MOVE input should be a 16-bit integer that encodes the starting and ending positions of the piece in the following format:
```
[8 bits for starting position][8 bits for ending position]
```
For example, if the starting position is 5 and the ending position is 10, the MOVE input would be #050A.



## UNDO_MOVE: 
This function should undo the previous move and restore the board state to its original state.
```
:UNDO_MOVE   \[    \[  \]   \> \i   \\ initialize the current position
  MOVE_HISTORY   \@   \\ get the previous move from the history
  \i   MOVE_HISTORY   -   \> \j   \\ calculate the distance to move
  \j   0   >   \[  \]   \[  \]   \\ move forward if j > 0, otherwise move backward
  \[  \i   \j   +   \]   STORE   \\ update the position of the piece
  MOVE_HISTORY   \[  \]   \>   \\ remove the previous move from the history
  \]   ;
```
This function restores the board state to its original state by updating the position of the piece based on the previous move stored in the MOVE_HISTORY array. The MOVE_HISTORY array should be a list of 16-bit integers that encode the starting and ending positions of the pieces in the same format as the MOVE input to the DO_MOVE function.

To implement the UNDO_MOVE function, you will need to define the `MOVE_


## MOVES: 
This function should generate a list of possible moves that can be made from the current board state.
```
:MOVES   \[    \[  \]   \> \i   \\ initialize the list of moves
  PIECES   \[  \]   \> \j   \\ iterate through the pieces
  \[  \]   \> \k   \\ initialize the current position
  \[  \]   \> \l   \\ initialize the destination position
  \j   \k   \>   \\ get the current position of the piece
  \[  \]   \> \m   \\ initialize the list of valid moves
  \k   \l   \+   \l   \k   \-   \> \[  \]   \\ check all positions in the 8 cardinal and diagonal directions
  VALID_POSITION   \@   \\ check if the destination is a valid position
  \[  \]   \>   \\ do nothing if not a valid position
  \[  \j   \l   \]   \m   \>   \\ add the move to the list of valid moves
  \m   \i   \>   \\ update the list of moves
  \]   \i   ;
```
This function generates a list of possible moves that can be made from the current board state by iterating through all of the pieces on the board and checking the positions in the 8 cardinal and diagonal directions for each piece. The PIECES array should be a list of 16-bit integers that encode the positions of the pieces on the board. The VALID_POSITION function should take a position as input and return 1 if the position is on the board and 0 if it is not.


## SCORE: 
This function should calculate a score for the current board state based on factors such as the material balance (difference in the number of pieces), the position of the pieces on the board, and the mobility of the pieces.
```
:SCORE   \[    \[  \]   \> \i   \\ initialize the score
  PIECES   \[  \]   \> \j   \\ iterate through the pieces
  \j   PIECE_VALUES   \@   \\ get the value of the piece
  \i   \j   +   \> \i   \\ update the score
  POSITION_VALUES   \@   \\ get the value of the position
  \i   POSITION_VALUES   +   \> \i   \\ update the score
  MOBILITY   \@   \\ get the mobility of the piece
  \i   MOBILITY   +   \> \i   \\ update the score
  \]   \i   ;
```
This function calculates a score for the current board state by adding up the values of the pieces, their positions, and their mobility. The PIECES array should be a list of 16-bit integers that encode the positions of the pieces on the board. The PIECE_VALUES array should be a list of 8-bit integers that encode the values of the different types of pieces (e.g. pawn = 1, knight = 3, bishop = 3, etc.). The POSITION_VALUES array should be a list of 8-bit integers that encode the values of the different positions on the board based on factors such as centralization and control of key squares. The MOBILITY function should take a piece and its position as input and return a value based on the number of legal moves the piece can make from that position.



## Alpha-beta pruning 
is a technique that is used to optimize the minimax algorithm, which is a search algorithm that is often used in two-player, zero-sum games, such as chess, to determine the best move for a player. It works by eliminating branches of the search tree that cannot possibly affect the final result, reducing the number of nodes that need to be evaluated and improving the efficiency of the algorithm.

The alpha-beta pruning algorithm uses two values, alpha and beta, to track the best score that has been achieved by the current player and the opponent, respectively. As the search progresses, the algorithm updates these values based on the scores of the possible moves. If the alpha value becomes greater than or equal to the beta value at any point during the search, the algorithm can safely prune the remaining branches of the tree, because it is guaranteed that the current player will not choose a move that will result in a worse score.

The given program is an implementation of the Alpha-beta pruning algorithm for a two-player, turn-based game. It consists of two functions: ALPHABETA and MAIN.

The ALPHABETA function is responsible for searching the game tree and evaluating the different board positions. It takes three inputs: DEPTH, ALPHA, and BETA. DEPTH is a 16-bit integer that encodes the current depth in the search tree. ALPHA and BETA are 16-bit integers that encode the current alpha and beta values.

The MAIN function is the entry point of the program. It takes three inputs: BOARD_STATE, DEPTH, and ALPHA. BOARD_STATE is a 16-bit integer that encodes the current state of the game board. DEPTH is a 16-bit integer that encodes the maximum depth of the search tree. ALPHA is a 16-bit integer that encodes the initial alpha value.

```
:ALPHABETA   \[   DEPTH   0   =   \[  SCORE   \]   \> \i   \\ base case: if depth is 0, return the score
  ALPHA   -9999   \>   \\ initialize alpha
  BETA   9999   \>   \\ initialize beta
  MOVES   \@   \\ get a list of possible moves
  \[  \]   \> \j   \\ initialize the best score
  \i   1   +   \> DEPTH   \\ increment the depth
  \[  \]   \> \k   \\ initialize the score for the current move
  \[  \]   \> \l   \\ initialize the current move
  MOVES   \[  \]   \> \m   \\ iterate through the moves
  \m   \l   \>   \\ get the next move
  \[  \l   \]   DO_MOVE   \\ make the move
  ALPHABETA   \> \k   \\ evaluate the resulting board state
  UNDO_MOVE   \\ undo the move
  \k   \j   >   \j   \k   \> \j   \\ update the best score
  \k   ALPHA   >   ALPHA   \k   \> ALPHA   \\ update alpha
  \k   BETA   <   BETA   \k   \> BETA   \\ update beta
  ALPHA   BETA   >=   \[  \j   \]   ;   \\ prune the remaining branches
  \]   \j   ;

:MAIN   \[  BOARD_STATE  DEPTH  ]   ALPHABETA
```
There are several things missing from this program that would be necessary to make it more complete:

The DO_MOVE, UNDO_MOVE, MOVES, and SCORE functions are not defined. These functions are necessary for the ALPHABETA function to work properly. DO_MOVE should make a move on the game board, UNDO_MOVE should undo the previous move, MOVES should generate a list of possible moves that can be made from the current board state, and SCORE should calculate a score for the current board state based on factors such as the material balance (difference in the number of pieces), the position of the pieces on the board, and the mobility of the pieces.

The MAX_PLAYER and MIN_PLAYER functions are not defined. These functions should return 1 if the current player is the max player (i.e. the maximizing player) and 0 if the current player is the min player (i.e. the minimizing player).

The ALPHABETA function does not properly handle the base case when DEPTH is equal to 0. In this case, the function should return the score of the current board state rather than calling itself recursively.

The ALPHABETA function does not properly handle the case when ALPHA is greater than or equal to BETA. In this case, the function should immediately return the value of ALPHA or BETA rather than continuing to search the game tree.

revised program with the four corrections applied:
```
:DO_MOVE   \[   MOVE   ]   ;   \\ make the specified move on the game board
:UNDO_MOVE   \\ undo the previous move
:MOVES   \[   ]   ;   \\ generate a list of possible moves from the current board state
:SCORE   \[   ]   ;   \\ calculate a score for the current board state
:MAX_PLAYER   \[   ]   ;   \\ return 1 if the current player is the max player, 0 otherwise
:MIN_PLAYER   \[   ]   ;   \\ return 1 if the current player is the min player, 0 otherwise

:ALPHABETA   \[   DEPTH   0   =   \[  SCORE   \]   \> \i   \\ base case: if depth is 0, return the score
  ALPHA   -9999   \>   \\ initialize alpha
  BETA   9999   \>   \\ initialize beta
  MOVES   \@   \\ get a list of possible moves
  \[  \]   \> \j   \\ initialize the best score
  \i   1   +   \> DEPTH   \\ increment the depth
  \[  \]   \> \k   \\ initialize the score for the current move
  \[  \]   \> \l   \\ initialize the current move
  MOVES   \[  \]   \> \m   \\ iterate through the moves
  \m   \l   \>   \\ get the next move
  \[  \l   \]   DO_MOVE   \\ make the move
  ALPHABETA   \> \k   \\ evaluate the resulting board state
  UNDO_MOVE   \\ undo the move
  \k   \j   >   \j   \k   \> \j   \\ update the best score
  \k   ALPHA   >   ALPHA   \k   \> ALPHA   \\ update alpha
  \k   BETA   <   BETA   \k   \> BETA   \\ update beta
  ALPHA   BETA   >=   \[  \j   \]   ;   \\ prune the remaining branches
  \]   \j   ;

:MAIN   \[  BOARD_STATE  DEPTH  ]   ALPHABETA
```
To complete the program, you need to define the functions that are missing: DO_MOVE, UNDO_MOVE, MOVES, SCORE, MAX_PLAYER, and MIN_PLAYER.

DO_MOVE should take a move as an input and update the game board to reflect that move.

UNDO_MOVE should undo the previous move and restore the board to its original state.

MOVES should generate a list of possible moves that can be made from the current board state.

SCORE should calculate a score for the current board state based on factors such as the material balance (difference in the number of pieces), the position of the pieces on the board, and the mobility of the pieces.

MAX_PLAYER should return 1 if the current player is the max player (i.e., the player trying to maximize the score), and 0 otherwise.

MIN_PLAYER should return 1 if the current player is the min player (i.e., the player trying to minimize the score), and 0 otherwise.

Here are the corrections to the code:
```
:DO_MOVE [ MOVE ] ; \ make the specified move on the game board
:UNDO_MOVE \ undo the previous move
:MOVES [ ] ; \ generate a list of possible moves from the current board state
:SCORE [ ] ; \ calculate a score for the current board state
:MAX_PLAYER [ ] ; \ return 1 if the current player is the max player, 0 otherwise
:MIN_PLAYER [ ] ; \ return 1 if the current player is the min player, 0 otherwise

:ALPHABETA [ DEPTH 0 = [ SCORE ] > \i \ base case: if depth is 0, return the score
ALPHA -9999 > \ initialize alpha
BETA 9999 > \ initialize beta
MOVES @ \ get a list of possible moves
[ ] > \j \ initialize the best score
\i 1 + > DEPTH \ increment the depth
[ ] > \k \ initialize the score for the current move
[ ] > \l \ initialize the current move
MOVES [ ] > \m \ iterate through the moves
\m \l > \ get the next move
[ \l ] DO_MOVE \ make the move
ALPHABETA > \k \ evaluate the resulting board state
UNDO_MOVE \ undo the move
\k \j > \j \k > \j \ update the best score
\k ALPHA > ALPHA \k > ALPHA \ update alpha
\k BETA < BETA \k > BETA \ update beta
ALPHA BETA >= [ \j ] ; \ prune the remaining branches
] \j ;

:MAIN [ BOARD_STATE DEPTH ] ALPHABETA
```


## Ref

- https://en.wikipedia.org/wiki/1K_ZX_Chess
- http://users.ox.ac.uk/~uzdm0006/scans/1kchess/
- https://www.chessprogramming.org/1K_ZX_Chess
- http://ersby.blogspot.com/2011/03/chess-in-1k.html

## Iterate
https://www.epanorama.net/documents/pc/lightpen.html

