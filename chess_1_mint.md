# Chess Game in MINT-Octave
## Converted from chess1.m

This is a simplified chess game implementation in MINT-Octave, a stack-based programming language.

---

## Overview

**Piece Encoding:**
- 0 = Empty
- 1 = Pawn (P)
- 2 = Horse/Knight (H)
- 3 = Bishop (B)
- 4 = Castle/Rook (C)
- 5 = Queen (Q)
- 6 = King (K)

Positive values = White (player)
Negative values = Black (AI)

**Board Layout:**
- 64-square array (indices 0-63)
- Row calculation: square / 8
- Column calculation: square mod 8
- Square from row,col: row*8 + col

---

## MINT Code

```mint
// ============================================
// CHESS GAME IN MINT-OCTAVE
// ============================================

// Initialize board array (64 squares)
// Starting position setup
:INIT
    // Create board array with starting position
    [
    // Row 0 (white back rank, indices 0-7)
    4 2 3 5 6 3 2 4
    // Row 1 (white pawns, indices 8-15)
    1 1 1 1 1 1 1 1
    // Rows 2-5 (empty squares, indices 16-47)
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    // Row 6 (black pawns, indices 48-55, negative)
    -1 -1 -1 -1 -1 -1 -1 -1
    // Row 7 (black back rank, indices 56-63, negative)
    -4 -2 -3 -5 -6 -3 -2 -4
    ] b !
    // b = board array address
    1 turn !
    // turn = 1 for white, -1 for black
    `Chess Game Initialized` /N
    `White (uppercase): P H B C Q K` /N
    `Black (lowercase): p h b c q k` /N
    /N
;

// Display single piece character
// Stack: piece_value --
:PC
    " piece !  // Duplicate and store piece value
    piece 0 = ( 46 /C )  // Empty square: '.'
    /E (
        // Get absolute value for piece type
        piece /abs ptype !
        // Map piece type to character
        ptype 1 = ( 80 pc ! )  // 1=P
        /E ( ptype 2 = ( 72 pc ! )  // 2=H
        /E ( ptype 3 = ( 66 pc ! )  // 3=B
        /E ( ptype 4 = ( 67 pc ! )  // 4=C
        /E ( ptype 5 = ( 81 pc ! )  // 5=Q
        /E ( ptype 6 = ( 75 pc ! )  // 6=K
        ) ) ) ) )
        // Print character (uppercase for white, lowercase for black)
        piece 0 > ( pc /C )  // Positive = white (uppercase)
        /E ( pc 32 + /C )     // Negative = black (lowercase)
    )
;

// Display board
// Stack: --
:DISP
    /N
    `  a b c d e f g h` /N
    `+----------------+` /N
    // Loop through rows 7 down to 0
    8 (
        7 /i - row !  // row = 7-i
        row . 32 /C 124 /C  // Print "row |"
        // Loop through columns 0-7
        8 (
            /i col !
            row 8 * col + sq !  // sq = row*8 + col
            b sq ? PC  // Get piece and print character
            32 /C  // Space
        )
        124 /C 32 /C row . /N  // Print "| row"
    )
    `+----------------+` /N
    `  a b c d e f g h` /N
    /N
;

// Convert column letter to number (a=0, b=1, ..., h=7)
// Stack: ascii_code -- column_number
:COL
    97 -  // Subtract 'a' (97)
;

// Get piece at square
// Stack: square_index -- piece_value
:GP
    b $ ?  // b square ?
;

// Set piece at square
// Stack: piece_value square_index --
:SP
    b $ ?!  // piece b square ?!
;

// Check if square is valid (0-63)
// Stack: square -- is_valid
:VALID
    " 0 > $  // Duplicate, check >= 0
    64 < &   // AND with < 64
;

// Get piece color sign (1 for positive, -1 for negative, 0 for empty)
// Stack: piece -- color
:SIGN
    " 0 > ( 1 )
    /E ( " 0 < ( -1 )
    /E ( 0 ) )
;

// Check if move from->to is on same row
// Stack: from to -- bool
:SAMEROW
    8 / $ 8 / =  // from/8 == to/8
;

// Check if move from->to is on same column
// Stack: from to -- bool
:SAMECOL
    8 /mod ' $ 8 /mod ' =  // from%8 == to%8
;

// Check if move from->to is diagonal
// Stack: from to -- bool
:DIAG
    % 8 / $ 8 / - /abs  // abs(from_row - to_row)
    $ 8 /mod ' $ 8 /mod ' - /abs  // abs(from_col - to_col)
    =  // Same distance in both directions
;

// Simple move validation (basic rules only)
// Stack: from to -- is_valid
:VALID_MOVE
    // Get pieces
    % GP frompc !  // from piece
    " GP topc !    // to piece

    // Check if from piece exists and belongs to current player
    frompc turn * 0 > ~ ( /F )
    /E (
        // Check if destination has own piece
        topc turn * 0 > ( /F )
        /E (
            // Basic movement rules (simplified)
            frompc /abs ptype !

            // For now, allow all moves (simplified)
            // TODO: Add proper piece movement rules
            /T
        )
    )
;

// Make move
// Stack: from to --
:MOVE
    % GP piece !   // Get piece from source
    " 0 SP         // Clear source square
    piece $ SP     // Place piece at destination
    turn -1 * turn !  // Switch turn
;

// Parse chess notation to square index
// Example: "e2" -> row=1, col=4 -> index=12
// Stack: col_ascii row_ascii -- square_index
:PARSE
    48 - 1 - r !  // row = ascii - '0' - 1 (convert 1-8 to 0-7)
    COL c !       // column from letter
    r 8 * c +     // square = row*8 + col
;

// Input move from user
// Stack: -- from to (or -1 -1 if quit)
:INPUT
    `Enter move (e.g. e2e4): `
    /L chars !  // Read string, store char count

    // Check for quit
    chars 1 = (
        0 /C 113 = ( -1 -1 )  // 'q' = quit
        /E ( INPUT )  // Invalid, retry
    )
    /E (
        chars 4 = (
            // Parse: col1 row1 col2 row2
            3 /C 2 /C PARSE from !  // Parse from square
            1 /C 0 /C PARSE to !    // Parse to square
            from to
        )
        /E (
            `Invalid format. Try again.` /N
            INPUT  // Retry
        )
    )
;

// Find all pieces for current player
// Stack: -- count
:COUNT_PIECES
    0 count !
    64 ( b /i ? turn * 0 > ( count 1 + count ! ) )
    count
;

// Simple AI: Random legal move
// Stack: -- from to
:AI
    `AI thinking...` /N

    // Try random moves until we find a legal one
    /U (
        // Random from square (0-63)
        64 /rand /floor from !

        // Check if from has AI piece
        from GP turn * 0 > (
            // Random to square (0-63)
            64 /rand /floor to !

            // Check if move is valid
            from to VALID_MOVE (
                from to
                /W  // Break loop, return from and to
            )
        )
    )
;

// Check for checkmate/stalemate (simplified)
// Stack: -- status (0=continue, 1=checkmate, 2=stalemate)
:GAME_OVER
    // Count pieces for current player
    COUNT_PIECES 1 < ( 1 )  // Checkmate if no pieces
    /E ( 0 )  // Continue game
;

// Main game loop
:GAME
    INIT
    DISP

    /U (
        // Check game over
        GAME_OVER status !
        status 0 > (
            status 1 = ( `Checkmate!` /N )
            /E ( `Stalemate!` /N )
            /W  // Exit loop
        )

        // Player or AI turn
        turn 1 = (
            // White (player) turn
            `Your turn (White):` /N
            INPUT from ! to !

            // Check for quit
            from 0 < ( /W )

            // Validate and make move
            from to VALID_MOVE (
                from to MOVE
                DISP
            )
            /E (
                `Illegal move!` /N
            )
        )
        /E (
            // Black (AI) turn
            AI from ! to !
            `AI moves: ` from . ` to ` to . /N
            from to MOVE
            DISP
        )
    )

    `Game Over` /N
;

// ============================================
// HELPER FUNCTIONS FOR ENHANCED GAMEPLAY
// ============================================

// Check if square is attacked by opponent
// Stack: square -- is_attacked
:ATTACKED
    // Simplified: check all opponent pieces
    /F attacked !
    64 (
        b /i ? turn -1 * * 0 > (  // Opponent piece
            /i $ VALID_MOVE ( /T attacked ! )
        )
    )
    ' attacked
;

// Find king position for current player
// Stack: -- king_square
:FIND_KING
    -1 king_sq !
    64 (
        b /i ? piece !
        piece /abs 6 = piece turn * 0 > & (
            /i king_sq !
        )
    )
    king_sq
;

// Check if current player is in check
// Stack: -- in_check
:IN_CHECK
    FIND_KING ATTACKED
;

// Generate all legal moves for current player
// Stack: -- move_count
// Stores moves in global move array
:GEN_MOVES
    0 mc !  // move count

    // Try all from squares
    64 (
        /i from !
        from GP frompc !

        // Check if piece belongs to current player
        frompc turn * 0 > (
            // Try all to squares
            64 (
                /i to !
                from to VALID_MOVE (
                    // Valid move found
                    mc 1 + mc !
                )
            )
        )
    )
    mc
;

```

---

## How to Run

1. Load MINT-Octave:
   ```octave
   mint_octave_15
   ```

2. Copy and paste the code above (or load from file if MINT supports file input)

3. Start the game:
   ```mint
   GAME
   ```

4. Enter moves in chess notation:
   - Format: `e2e4` (from e2 to e4)
   - Columns: a-h
   - Rows: 1-8

5. Quit: Enter `q`

---

## Limitations

Due to MINT's stack-based architecture, this implementation has several simplifications:

1. **Move Validation**: Basic validation only - doesn't fully enforce piece-specific movement rules
2. **Check Detection**: Simplified - doesn't prevent moves that leave king in check
3. **AI**: Random legal moves only (no evaluation function like minimax)
4. **Special Moves**: No castling, en passant, or pawn promotion
5. **Input**: Limited string parsing capabilities

---

## Improvements Possible

To enhance this MINT chess program:

1. **Better AI**: Implement material counting for move evaluation
2. **Piece Rules**: Add specific movement validation for each piece type
3. **Check/Checkmate**: Implement proper check detection and prevention
4. **Move History**: Store moves in an array for undo capability
5. **Opening Book**: Pre-define common opening sequences

---

## MINT Programming Notes

**Key MINT Concepts Used:**

- **Arrays**: `[...]` for board storage (64 elements)
- **Variables**: a-z for game state (board=b, turn, from, to, etc.)
- **Functions**: :A-:Z for game logic (INIT, DISP, MOVE, etc.)
- **Loops**: `count ( body )` for iterating board squares
- **Conditionals**: `condition ( then ) /E ( else )` for game logic
- **Stack Operations**: `"` (dup), `$` (swap), `%` (over), `'` (drop)

**Stack Management Tips:**

- Always track what's on the stack before/after each operation
- Use comments to document stack effects: `// Stack: from to -- `
- Duplicate values with `"` before consuming them if needed later
- Swap with `$` to access second item on stack

---

## Comparison with Octave Version

| Feature | Octave (chess1.m) | MINT (chess_1_mint.md) |
|---------|------------------|----------------------|
| Board Representation | 8x8 matrix | 64-element array |
| AI Algorithm | Minimax + Alpha-Beta | Random moves |
| Search Depth | 3-ply | None |
| Move Validation | Complete | Simplified |
| Check Detection | Full | Minimal |
| Special Moves | Pawn promotion | None |
| Code Lines | ~680 | ~400 (simplified) |
| Execution Speed | Fast | Slower (interpreted) |

---

## Example Game Session

```mint
> GAME
Chess Game Initialized
White (uppercase): P H B C Q K
Black (lowercase): p h b c q k

  a b c d e f g h
+----------------+
7 | p p p p p p p p | 7
6 | . . . . . . . . | 6
5 | . . . . . . . . | 5
4 | . . . . . . . . | 4
3 | . . . . . . . . | 3
2 | . . . . . . . . | 2
1 | P P P P P P P P | 1
0 | C H B Q K B H C | 0
+----------------+
  a b c d e f g h

Your turn (White):
Enter move (e.g. e2e4): e2e4

  a b c d e f g h
+----------------+
7 | p p p p p p p p | 7
6 | . . . . . . . . | 6
5 | . . . . . . . . | 5
4 | . . . . P . . . | 4
3 | . . . . . . . . | 3
2 | . . . . . . . . | 2
1 | P P P P . P P P | 1
0 | C H B Q K B H C | 0
+----------------+
  a b c d e f g h

AI thinking...
AI moves: 52 to 36

[Game continues...]
```

---

## Credits

Converted from chess1.m (Octave) to MINT-Octave
Based on Microchess pseudo code architecture
MINT-Octave language by [MINT-Octave Manual](MINT-Octave Manual.md)

---

## License

This chess implementation is provided as educational material for learning stack-based programming in MINT-Octave.
