% CHESS1.M - Text-based Chess Game with AI
% Improved implementation based on Microchess pseudo code
% Piece codes: Empty=0, Pawn=1, Knight=2, Bishop=3, Rook=4, Queen=5, King=6
% White pieces: positive (1-6), Black pieces: negative (-1 to -6)

function chess1()
    % Initialize game
    global board gameOver bestMove aiDepth pieceValues;
    aiDepth = 3;  % Search depth for AI
    pieceValues = [0, 1, 3, 3, 5, 9, 999];  % [empty, pawn, knight, bishop, rook, queen, king]

    board = initBoard();
    gameOver = false;
    playerColor = 1;  % 1 for white (player), -1 for black (AI)

    disp('=== CHESS GAME ===');
    disp('You are White (normal display, bottom rows 1-2).');
    disp('AI is Black (inverse colors, top rows 7-8).');
    disp('Pieces: P=Pawn, H=Horse, B=Bishop, C=Castle, Q=Queen, K=King');
    disp('Enter moves in chess notation (e.g., e2e4 or e2-e4)');
    disp('Enter "q" to quit');
    disp(' ');

    displayBoard(board);

    while ~gameOver
        if playerColor == 1
            % Player's turn (White)
            disp('Your turn (White):');
            move = getPlayerMove(board, playerColor);

            if isempty(move)
                disp('Exiting game...');
                break;
            end

            board = applyMove(board, move);
        else
            % AI's turn (Black)
            disp('AI thinking...');
            tic;
            [bestValue, bestMove] = minimax(board, aiDepth, -Inf, Inf, playerColor);
            elapsed = toc;

            if isempty(bestMove)
                disp('AI has no legal moves. You win!');
                gameOver = true;
                break;
            end

            moveStr = moveToChessNotation(bestMove);
            disp(sprintf('AI move (%.2f sec, eval=%.1f): %s', ...
                elapsed, bestValue, moveStr));
            board = applyMove(board, bestMove);
        end

        displayBoard(board);

        % Check game over conditions
        if isCheckmate(board, -playerColor)
            if playerColor == 1
                disp('Checkmate! You win!');
            else
                disp('Checkmate! AI wins!');
            end
            gameOver = true;
        elseif isStalemate(board, -playerColor)
            disp('Stalemate! Draw.');
            gameOver = true;
        end

        % Switch turn
        playerColor = -playerColor;
    end

    disp('Game Over.');
end

%% Initialize board to starting position
function b = initBoard()
    b = zeros(8, 8);

    % Black pieces (top, negative values)
    b(8, :) = [-4, -2, -3, -5, -6, -3, -2, -4];  % Back rank
    b(7, :) = -1 * ones(1, 8);  % Pawns

    % White pieces (bottom, positive values)
    b(2, :) = ones(1, 8);  % Pawns
    b(1, :) = [4, 2, 3, 5, 6, 3, 2, 4];  % Back rank
end

%% Display board
function displayBoard(b)
    disp(' ');
    disp('    a  b  c  d  e  f  g  h');
    disp('  +------------------------+');

    for row = 8:-1:1
        fprintf('%d |', row);
        for col = 1:8
            piece = b(row, col);
            fprintf(' %s ', pieceToChar(piece));
        end
        fprintf('| %d\n', row);
    end

    disp('  +------------------------+');
    disp('    a  b  c  d  e  f  g  h');
    disp(' ');
end

%% Convert piece code to character
function c = pieceToChar(piece)
    chars = ['.', 'P', 'H', 'B', 'C', 'Q', 'K'];
    if piece == 0
        c = '.';
    elseif piece > 0
        c = chars(abs(piece) + 1);  % White: normal
    else
        % Black: inverse video using ANSI escape codes
        pieceChar = chars(abs(piece) + 1);
        % Use char(27) for ESC character
        c = sprintf('%c[7m%s%c[0m', char(27), pieceChar, char(27));
    end
end

%% Convert move to chess notation
function str = moveToChessNotation(move)
    cols = 'abcdefgh';
    fromCol = cols(move(2));
    fromRow = num2str(move(1));
    toCol = cols(move(4));
    toRow = num2str(move(3));
    str = [fromCol fromRow toCol toRow];
end

%% Get player move
function move = getPlayerMove(b, color)
    move = [];

    while true
        input_str = input('Enter move (e.g., e2e4 or e2-e4): ', 's');

        if strcmp(input_str, 'q') || strcmp(input_str, 'Q')
            return;
        end

        % Remove spaces and dashes
        input_str = strrep(input_str, ' ', '');
        input_str = strrep(input_str, '-', '');

        % Parse chess notation (e.g., "e2e4")
        if length(input_str) == 4
            fromCol = input_str(1);
            fromRow = str2num(input_str(2));
            toCol = input_str(3);
            toRow = str2num(input_str(4));

            % Convert column letters to numbers (a=1, b=2, ..., h=8)
            fromColNum = double(lower(fromCol)) - double('a') + 1;
            toColNum = double(lower(toCol)) - double('a') + 1;

            % Validate
            if isempty(fromRow) || isempty(toRow) || ...
               fromColNum < 1 || fromColNum > 8 || ...
               toColNum < 1 || toColNum > 8 || ...
               fromRow < 1 || fromRow > 8 || ...
               toRow < 1 || toRow > 8
                disp('Invalid input. Use format: e2e4 (column=a-h, row=1-8)');
                continue;
            end

            move = [fromRow, fromColNum, toRow, toColNum];
        else
            disp('Invalid input. Use format: e2e4 (column=a-h, row=1-8)');
            continue;
        end

        if ~isValidMove(b, move, color)
            disp('Illegal move. Try again.');
            move = [];
            continue;
        end

        break;
    end
end

%% Check if move is valid
function valid = isValidMove(b, move, color)
    valid = false;

    fromRow = move(1); fromCol = move(2);
    toRow = move(3); toCol = move(4);

    % Check bounds
    if fromRow < 1 || fromRow > 8 || fromCol < 1 || fromCol > 8 || ...
       toRow < 1 || toRow > 8 || toCol < 1 || toCol > 8
        return;
    end

    piece = b(fromRow, fromCol);

    % Check if piece belongs to player
    if sign(piece) ~= sign(color) || piece == 0
        return;
    end

    % Check if move is in legal moves
    moves = generatePieceMoves(b, fromRow, fromCol, color);

    for i = 1:size(moves, 1)
        if moves(i, 3) == toRow && moves(i, 4) == toCol
            % Check if move leaves king in check
            testBoard = applyMove(b, move);
            if ~isInCheck(testBoard, color)
                valid = true;
                return;
            end
        end
    end
end

%% Generate all legal moves for a color
function moves = generateMoves(b, color)
    moves = [];

    for row = 1:8
        for col = 1:8
            piece = b(row, col);
            if sign(piece) == sign(color) && piece ~= 0
                pieceMoves = generatePieceMoves(b, row, col, color);
                moves = [moves; pieceMoves];
            end
        end
    end
end

%% Generate moves for a specific piece
function moves = generatePieceMoves(b, row, col, color)
    moves = [];
    piece = abs(b(row, col));

    switch piece
        case 1  % Pawn
            moves = generatePawnMoves(b, row, col, color);
        case 2  % Knight
            moves = generateKnightMoves(b, row, col, color);
        case 3  % Bishop
            moves = generateBishopMoves(b, row, col, color);
        case 4  % Rook
            moves = generateRookMoves(b, row, col, color);
        case 5  % Queen
            moves = generateQueenMoves(b, row, col, color);
        case 6  % King
            moves = generateKingMoves(b, row, col, color);
    end
end

%% Generate pawn moves
function moves = generatePawnMoves(b, row, col, color)
    moves = [];
    direction = sign(color);  % White moves up (+1), Black moves down (-1)

    % Forward one square
    newRow = row + direction;
    if newRow >= 1 && newRow <= 8 && b(newRow, col) == 0
        moves = [moves; row, col, newRow, col];

        % Forward two squares from starting position
        if (color == 1 && row == 2) || (color == -1 && row == 7)
            newRow2 = row + 2*direction;
            if b(newRow2, col) == 0
                moves = [moves; row, col, newRow2, col];
            end
        end
    end

    % Captures (diagonal)
    for dCol = [-1, 1]
        newRow = row + direction;
        newCol = col + dCol;
        if newRow >= 1 && newRow <= 8 && newCol >= 1 && newCol <= 8
            target = b(newRow, newCol);
            if target ~= 0 && sign(target) ~= sign(color)
                moves = [moves; row, col, newRow, newCol];
            end
        end
    end
end

%% Generate knight moves
function moves = generateKnightMoves(b, row, col, color)
    moves = [];
    deltas = [2,1; 2,-1; -2,1; -2,-1; 1,2; 1,-2; -1,2; -1,-2];

    for i = 1:size(deltas, 1)
        newRow = row + deltas(i, 1);
        newCol = col + deltas(i, 2);

        if newRow >= 1 && newRow <= 8 && newCol >= 1 && newCol <= 8
            target = b(newRow, newCol);
            if target == 0 || sign(target) ~= sign(color)
                moves = [moves; row, col, newRow, newCol];
            end
        end
    end
end

%% Generate bishop moves
function moves = generateBishopMoves(b, row, col, color)
    moves = generateLineMoves(b, row, col, color, [1,1; 1,-1; -1,1; -1,-1]);
end

%% Generate rook moves
function moves = generateRookMoves(b, row, col, color)
    moves = generateLineMoves(b, row, col, color, [1,0; -1,0; 0,1; 0,-1]);
end

%% Generate queen moves
function moves = generateQueenMoves(b, row, col, color)
    moves = generateLineMoves(b, row, col, color, [1,0; -1,0; 0,1; 0,-1; 1,1; 1,-1; -1,1; -1,-1]);
end

%% Generate king moves
function moves = generateKingMoves(b, row, col, color)
    moves = [];
    deltas = [1,0; -1,0; 0,1; 0,-1; 1,1; 1,-1; -1,1; -1,-1];

    for i = 1:size(deltas, 1)
        newRow = row + deltas(i, 1);
        newCol = col + deltas(i, 2);

        if newRow >= 1 && newRow <= 8 && newCol >= 1 && newCol <= 8
            target = b(newRow, newCol);
            if target == 0 || sign(target) ~= sign(color)
                moves = [moves; row, col, newRow, newCol];
            end
        end
    end
end

%% Generate line moves (for bishops, rooks, queens)
function moves = generateLineMoves(b, row, col, color, directions)
    moves = [];

    for i = 1:size(directions, 1)
        dRow = directions(i, 1);
        dCol = directions(i, 2);

        newRow = row + dRow;
        newCol = col + dCol;

        while newRow >= 1 && newRow <= 8 && newCol >= 1 && newCol <= 8
            target = b(newRow, newCol);

            if target == 0
                moves = [moves; row, col, newRow, newCol];
            elseif sign(target) ~= sign(color)
                moves = [moves; row, col, newRow, newCol];
                break;  % Can't move past capture
            else
                break;  % Own piece blocking
            end

            newRow = newRow + dRow;
            newCol = newCol + dCol;
        end
    end
end

%% Apply move to board
function newBoard = applyMove(b, move)
    newBoard = b;
    fromRow = move(1); fromCol = move(2);
    toRow = move(3); toCol = move(4);

    piece = newBoard(fromRow, fromCol);
    newBoard(toRow, toCol) = piece;
    newBoard(fromRow, fromCol) = 0;

    % Pawn promotion (simple: always promote to queen)
    if abs(piece) == 1
        if (piece > 0 && toRow == 8) || (piece < 0 && toRow == 1)
            newBoard(toRow, toCol) = sign(piece) * 5;  % Promote to queen
        end
    end
end

%% Check if king is in check
function inCheck = isInCheck(b, color)
    inCheck = false;

    % Find king position
    kingRow = 0; kingCol = 0;
    for row = 1:8
        for col = 1:8
            if b(row, col) == sign(color) * 6
                kingRow = row;
                kingCol = col;
                break;
            end
        end
        if kingRow > 0
            break;
        end
    end

    if kingRow == 0
        inCheck = true;  % King not found (captured)
        return;
    end

    % Check if any opponent piece can attack king
    opponentMoves = generateMoves(b, -color);

    for i = 1:size(opponentMoves, 1)
        if opponentMoves(i, 3) == kingRow && opponentMoves(i, 4) == kingCol
            inCheck = true;
            return;
        end
    end
end

%% Check if checkmate
function mate = isCheckmate(b, color)
    mate = false;

    if ~isInCheck(b, color)
        return;
    end

    % If in check, see if any legal move gets out of check
    moves = generateMoves(b, color);

    for i = 1:size(moves, 1)
        testBoard = applyMove(b, moves(i, :));
        if ~isInCheck(testBoard, color)
            return;  % Found escape move
        end
    end

    mate = true;  % No escape moves
end

%% Check if stalemate
function stale = isStalemate(b, color)
    stale = false;

    if isInCheck(b, color)
        return;  % Not stalemate if in check
    end

    % Check if player has any legal moves
    moves = generateMoves(b, color);

    for i = 1:size(moves, 1)
        testBoard = applyMove(b, moves(i, :));
        if ~isInCheck(testBoard, color)
            return;  % Found legal move
        end
    end

    stale = true;  % No legal moves
end

%% Minimax algorithm with alpha-beta pruning
function [value, bestMove] = minimax(b, depth, alpha, beta, color)
    global pieceValues;
    bestMove = [];

    % Terminal conditions
    if depth == 0
        value = evaluateBoard(b, color);
        return;
    end

    if isCheckmate(b, color)
        value = -9999;
        return;
    end

    if isCheckmate(b, -color)
        value = 9999;
        return;
    end

    moves = generateMoves(b, color);

    % No legal moves
    if isempty(moves)
        value = 0;  % Stalemate
        return;
    end

    % Filter out moves that leave king in check
    legalMoves = [];
    for i = 1:size(moves, 1)
        testBoard = applyMove(b, moves(i, :));
        if ~isInCheck(testBoard, color)
            legalMoves = [legalMoves; moves(i, :)];
        end
    end

    if isempty(legalMoves)
        if isInCheck(b, color)
            value = -9999;  % Checkmate
        else
            value = 0;  % Stalemate
        end
        return;
    end

    % Sort moves (captures first for better pruning)
    legalMoves = sortMoves(b, legalMoves);

    if color == -1  % Maximizing for AI (black)
        value = -Inf;
        for i = 1:size(legalMoves, 1)
            newBoard = applyMove(b, legalMoves(i, :));
            [childValue, ~] = minimax(newBoard, depth - 1, alpha, beta, -color);

            if childValue > value
                value = childValue;
                bestMove = legalMoves(i, :);
            end

            alpha = max(alpha, value);
            if beta <= alpha
                break;  % Beta cutoff
            end
        end
    else  % Minimizing for player (white)
        value = Inf;
        for i = 1:size(legalMoves, 1)
            newBoard = applyMove(b, legalMoves(i, :));
            [childValue, ~] = minimax(newBoard, depth - 1, alpha, beta, -color);

            if childValue < value
                value = childValue;
                bestMove = legalMoves(i, :);
            end

            beta = min(beta, value);
            if beta <= alpha
                break;  % Alpha cutoff
            end
        end
    end
end

%% Sort moves (captures first)
function sortedMoves = sortMoves(b, moves)
    scores = zeros(size(moves, 1), 1);

    for i = 1:size(moves, 1)
        target = b(moves(i, 3), moves(i, 4));
        if target ~= 0
            scores(i) = abs(target) * 10;  % Prioritize captures
        end
    end

    [~, idx] = sort(scores, 'descend');
    sortedMoves = moves(idx, :);
end

%% Evaluate board position
function score = evaluateBoard(b, color)
    global pieceValues;

    materialScore = 0;
    mobilityScore = 0;
    positionScore = 0;

    % Material count
    for row = 1:8
        for col = 1:8
            piece = b(row, col);
            if piece ~= 0
                pieceType = abs(piece);
                value = pieceValues(pieceType + 1);

                if sign(piece) == -1  % Black (AI)
                    materialScore = materialScore + value;

                    % Position bonuses for AI
                    if pieceType == 1  % Pawn
                        positionScore = positionScore + (8 - row) * 0.1;  % Advance pawns
                    elseif pieceType ~= 6  % Non-king pieces
                        if row >= 4 && row <= 5 && col >= 3 && col <= 6
                            positionScore = positionScore + 0.3;  % Center control
                        end
                    end
                else  % White (player)
                    materialScore = materialScore - value;

                    if pieceType == 1
                        positionScore = positionScore - (row - 1) * 0.1;
                    elseif pieceType ~= 6
                        if row >= 4 && row <= 5 && col >= 3 && col <= 6
                            positionScore = positionScore - 0.3;
                        end
                    end
                end
            end
        end
    end

    % Mobility (number of legal moves)
    aiMoves = generateMoves(b, -1);
    playerMoves = generateMoves(b, 1);
    mobilityScore = (size(aiMoves, 1) - size(playerMoves, 1)) * 0.1;

    score = materialScore + mobilityScore + positionScore;
end
