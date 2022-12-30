# TEC-1 Chess game

## tec-CHESS-7seg
rook ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/rook.png)
knight ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/knight.png)
bishop ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/bishop.png)
king ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/king.png)
queen ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/queen.png)
pawn ![](https://github.com/SteveJustin1963/tec-CHESS-7seg/blob/master/pics/pawn.png)

## project
- pieces hand moved on board following 7seg displayed
- https://github.com/SteveJustin1963/tec-SPEECH can say the moves and comments
- code to be inspired by 1k code examples
- try in MINT

## tec-CHESS-BOT
- played with BOT gripper 
- code to be inspired by 1k code examples



## tec-CHESS-LCD 
play on DAT's LCD display
* pieces to be moved by bot gripper


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


## Alpha-beta pruning 
is a technique that is used to optimize the minimax algorithm, which is a search algorithm that is often used in two-player, zero-sum games, such as chess, to determine the best move for a player. It works by eliminating branches of the search tree that cannot possibly affect the final result, reducing the number of nodes that need to be evaluated and improving the efficiency of the algorithm.

The alpha-beta pruning algorithm uses two values, alpha and beta, to track the best score that has been achieved by the current player and the opponent, respectively. As the search progresses, the algorithm updates these values based on the scores of the possible moves. If the alpha value becomes greater than or equal to the beta value at any point during the search, the algorithm can safely prune the remaining branches of the tree, because it is guaranteed that the current player will not choose a move that will result in a worse score.

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


## Ref

- https://en.wikipedia.org/wiki/1K_ZX_Chess
- http://users.ox.ac.uk/~uzdm0006/scans/1kchess/
- https://www.chessprogramming.org/1K_ZX_Chess
- http://ersby.blogspot.com/2011/03/chess-in-1k.html

## Iterate
https://www.epanorama.net/documents/pc/lightpen.html

