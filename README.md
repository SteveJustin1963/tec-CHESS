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
:DO_MOVE   \[  MOVE   ]   \[    MOVE   \@   \\ get the starting position of the piece  
\[  \]   \> \i   \\ initialize the current position
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
## 1k chess
sudo code
```
FUNCTION Kybd():
SETUP machine control of keyboard to accept only key codes from 29 and 38
DEFINE subroutine TKP()
SCAN keyboard for appropriate key depression
TRANSLATE alpha-numeric entry to board address
END subroutine
END function

FUNCTION STR(board_address):
DETERMINE whether contents at board_address are:
DIFFERENT from current mover colour
EMPTY
BOARD SURROUND
SAME colour as current mover
END function

FUNCTION Piece():
SETUP pointers to possible move tables and number of steps and directions
END function

FUNCTION Move():
GENERATE list of all legal moves available to piece under consideration
END function

FUNCTION Pawn():
GENERATE list of all possible legal moves including initial double moves
END function

FUNCTION Check():
LOCATE current mover's King and store position in attack register
END function

FUNCTION Square Attack():
DETERMINE whether opposition can attack square in attack register
END function

FUNCTION Score():
EVALUATE move score based on:
"To" position resulting in taking of a piece
"From" position being attacked
"To" position being attacked
"To" position enabling computer to obtain a check
"From" position being defended
COMPARE current move score to previous best
IF superior, SAVE move as best so far
END function

FUNCTION Shift():
MOVE current move list to safe position while check is being evaluated
RECOVER move list on completion
USE to shift best move so far up into move list
END function

FUNCTION PSC():
ASSIGN score to chess piece: Q(5), R(4), B(3), N(2), P(1)
END function

FUNCTION MPScan():
SCAN board for computer pieces
USING Move and Score, DETERMINE all legal moves and SAVE best
END function

FUNCTION INC():
DETERMINE whether a square is being attacked
END function

FUNCTION Driver():
MAIN control logic, using all other subroutines to provide program control
END function

FUNCTION TestList():
TEST to see if there are any moves in the move list
END function

FUNCTION AddList():
ADD to current legal move list another entry on the end
END function
```
## GA
To write a genetic algorithm (GA) program for chess, you can follow these steps:

1. Define the problem: In this case, the problem is to find a good chess strategy that can be used to play chess effectively.
2. Define the parameters of the GA: This includes things like the size of the population, the number of generations, the selection method, the crossover rate, and the mutation rate.
3. Represent the solutions: In this case, the solutions will be chess strategies. One way to represent a chess strategy is to use a set of rules or heuristics that dictate how the chess pieces should be moved.
4. Create an initial population: The initial population should be a set of random chess strategies.
5. Evaluate the fitness of each solution: To evaluate the fitness of a chess strategy, you can have it play against other strategies or against a human opponent and see how well it performs.
6. Select the best solutions: Use the selection method to choose the best solutions from the current population. These solutions will be used to create the next generation of strategies.
7. Crossover and mutation: Use the crossover rate to determine how often two solutions should be combined to create a new solution, and use the mutation rate to determine how often a solution should be modified slightly to create a new solution.
8. Repeat the process: Use the new generation of solutions to repeat the process of evaluating fitness, selecting the best solutions, and generating new solutions until the desired number of generations has been reached.
9. Choose the best solution: After the desired number of generations has been reached, choose the best-performing solution as the final chess strategy.


This program outlines the basic structure of a GA program for chess. You will need to implement the functions that evaluate the fitness of each strategy, select the best solutions, crossover, and mutate in order to complete the program. You may also need to adjust the values of the constants (e.g. POPULATION_SIZE, NUM_GENERATIONS, etc.) to suit your needs.
```
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define POPULATION_SIZE 100
#define NUM_GENERATIONS 50
#define SELECTION_RATE 0.2
#define CROSSOVER_RATE 0.7
#define MUTATION_RATE 0.001

typedef struct {
  int rules[10];  // a chess strategy is represented as a set of rules
} ChessStrategy;

// function prototypes
void evaluateFitness(ChessStrategy *strategies);
void selectBest(ChessStrategy *strategies);
void crossover(ChessStrategy *strategies);
void mutate(ChessStrategy *strategies);
void printBestStrategy(ChessStrategy *strategies);

int main(void) {
  ChessStrategy strategies[POPULATION_SIZE];
  int i;

  // seed the random number generator
  srand(time(NULL));

  // create an initial population of random strategies
  for (i = 0; i < POPULATION_SIZE; i++) {
    int j;
    for (j = 0; j < 10; j++) {
      strategies[i].rules[j] = rand();
    }
  }

  for (i = 0; i < NUM_GENERATIONS; i++) {
    evaluateFitness(strategies);
    selectBest(strategies);
    crossover(strategies);
    mutate(strategies);
  }

  printBestStrategy(strategies);

  return 0;
}

// evaluate the fitness of each strategy by having it play against other strategies or a human opponent
void evaluateFitness(ChessStrategy *strategies) {
  // TODO: implement this function
}

// select the best solutions from the current population using the selection method
void selectBest(ChessStrategy *strategies) {
  // TODO: implement this function
}

// use crossover to create new solutions by combining the best solutions from the current population
void crossover(ChessStrategy *strategies) {
  // TODO: implement this function
}

// use mutation to create new solutions by slightly modifying the best solutions from the current population
void mutate(ChessStrategy *strategies) {
  // TODO: implement this function
}

// print the best strategy from the final population
void printBestStrategy(ChessStrategy *strategies) {
  // TODO: implement this function
}
```





## Ref

- https://en.wikipedia.org/wiki/1K_ZX_Chess
- http://users.ox.ac.uk/~uzdm0006/scans/1kchess/
- https://www.chessprogramming.org/1K_ZX_Chess
- http://ersby.blogspot.com/2011/03/chess-in-1k.html
- https://www.freecodecamp.org/news/simple-chess-ai-step-by-step-1d55a9266977/
- 

## Iterate
https://www.epanorama.net/documents/pc/lightpen.html

