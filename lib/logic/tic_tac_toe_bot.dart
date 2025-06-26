import 'dart:math';
import 'package:flutter/material.dart';

class TicTacToeBot {
  final int difficulty;
  final int gridSize;
  final int winCondition; // Добавляем новое поле
  final Random _random = Random();
  static final Map<String, bool> _moveHistory = {};

  TicTacToeBot({
    required this.difficulty,
    required this.gridSize,
    required this.winCondition, // Добавляем параметр
  });

  Map<String, int>? makeBotMove(List<List<int>> board) {
    debugPrint("Bot difficulty: $difficulty");
    String boardKey = _boardToString(board);
    debugPrint("Bot analyzing board: $boardKey");

    Map<String, int>? bestMove;

    switch (difficulty) {
      case 1: // Easy: случайный ход рядом с ходом игрока
        bestMove = _findNearbyMove(board) ?? _findCenterMove(board) ?? _findRandomMove(board);
        debugPrint("Bot (level 1): Nearby move $bestMove");
        break;

      case 2: // Medium: проверка на победу, блокировку, два в ряд, умная блокировка, центр, случайный ход
        bestMove = _findWinningMove(board, 2) ??
            _findBlockingMove(board, 1) ??
            _findTwoInRowWithOpenEnds(board, 2) ??
            _findTwoInRowWithOpenEnds(board, 1) ??
            _findSmartBlockingMove(board, 1) ??
            _findCenterMove(board) ??
            _findRandomMove(board);
        debugPrint("Bot (level 2): Move $bestMove");
        break;

      case 3: // Hard: добавляем проверку форков, двух в ряд, Minimax
        bestMove = _findWinningMove(board, 2) ??
            _findBlockingMove(board, 1) ??
            _findForkBlockingMove(board, 1) ??
            _findForkCreatingMove(board, 2) ??
            _findTwoInRowWithOpenEnds(board, 1) ??
            _findBestMove(board);
        debugPrint("Bot (level 3): Move $bestMove");
        break;

      default:
        bestMove = _findRandomMove(board);
        debugPrint("Bot: Default random move $bestMove");
    }

    if (bestMove != null) {
      int row = bestMove['row']!;
      int col = bestMove['col']!;
      List<List<int>> newBoard = board.map((row) => List<int>.from(row)).toList();
      newBoard[row][col] = 2;
      String newBoardKey = _boardToString(newBoard);
      _moveHistory[newBoardKey] = true;
    }

    return bestMove;
  }

  String _boardToString(List<List<int>> board) {
    return board.map((row) => row.join()).join('|');
  }

  Map<String, int>? _findNearbyMove(List<List<int>> board) {
    List<Map<String, int>> nearbyMoves = [];
    Set<String> checked = {};
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 1) {
          for (int dRow = -1; dRow <= 1; dRow++) {
            for (int dCol = -1; dCol <= 1; dCol++) {
              if (dRow == 0 && dCol == 0) continue;
              int newRow = row + dRow;
              int newCol = col + dCol;
              if (_isInBounds(newRow, newCol) && board[newRow][newCol] == 0) {
                String key = '$newRow,$newCol';
                if (!checked.contains(key)) {
                  nearbyMoves.add({'row': newRow, 'col': newCol});
                  checked.add(key);
                }
              }
            }
          }
        }
      }
    }
    return nearbyMoves.isNotEmpty ? nearbyMoves[_random.nextInt(nearbyMoves.length)] : null;
  }

  Map<String, int>? _findRandomMove(List<List<int>> board) {
    List<Map<String, int>> emptyCells = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (board[i][j] == 0) {
          emptyCells.add({'row': i, 'col': j});
        }
      }
    }
    return emptyCells.isNotEmpty ? emptyCells[_random.nextInt(emptyCells.length)] : null;
  }

  Map<String, int>? _findCenterMove(List<List<int>> board) {
    int center = gridSize ~/ 2;
    List<Map<String, int>> centerMoves = [
      {'row': center, 'col': center},
      {'row': center, 'col': center - 1},
      {'row': center - 1, 'col': center},
      {'row': center - 1, 'col': center - 1},
      {'row': center, 'col': center + 1},
      {'row': center + 1, 'col': center},
      {'row': center - 1, 'col': center + 1},
      {'row': center + 1, 'col': center - 1},
    ];
    for (var move in centerMoves) {
      int row = move['row']!;
      int col = move['col']!;
      if (_isInBounds(row, col) && board[row][col] == 0) {
        return move;
      }
    }
    return null;
  }

  Map<String, int>? _findSmartBlockingMove(List<List<int>> board, int player) {
    List<Map<String, int>> blockingMoves = [];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 0) {
          List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
          tempBoard[row][col] = player;
          int horizontal = _countInDirection(tempBoard, 1, 0, row, col, player);
          int vertical = _countInDirection(tempBoard, 0, 1, row, col, player);
          int diagonal1 = _countInDirection(tempBoard, 1, 1, row, col, player);
          int diagonal2 = _countInDirection(tempBoard, 1, -1, row, col, player);
          tempBoard[row][col] = 0;
          if (horizontal >= 2 || vertical >= 2 || diagonal1 >= 2 || diagonal2 >= 2) {
            blockingMoves.add({'row': row, 'col': col});
          }
        }
      }
    }
    return blockingMoves.isNotEmpty ? blockingMoves[_random.nextInt(blockingMoves.length)] : null;
  }

  int _countInDirection(List<List<int>> board, int dRow, int dCol, int startRow, int startCol, int player) {
    int count = 0;
    for (int i = 1; i < winCondition; i++) { // Заменяем AppConstants.winCondition
      int newRow = startRow + dRow * i;
      int newCol = startCol + dCol * i;
      if (_isInBounds(newRow, newCol) && board[newRow][newCol] == player) count++;
      else break;
    }
    for (int i = 1; i < winCondition; i++) { // Заменяем AppConstants.winCondition
      int newRow = startRow - dRow * i;
      int newCol = startCol - dCol * i;
      if (_isInBounds(newRow, newCol) && board[newRow][newCol] == player) count++;
      else break;
    }
    return count;
  }

  Map<String, int>? _findWinningMove(List<List<int>> board, int player) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 0) {
          List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
          tempBoard[row][col] = player;
          if (_checkWin(tempBoard, row, col, player)) {
            return {'row': row, 'col': col};
          }
        }
      }
    }
    return null;
  }

  Map<String, int>? _findBlockingMove(List<List<int>> board, int player) {
    return _findWinningMove(board, player);
  }

  Map<String, int>? _findForkBlockingMove(List<List<int>> board, int player) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 0) {
          List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
          tempBoard[row][col] = player;
          int winningLines = _countPotentialWinningLines(tempBoard, player);
          if (winningLines >= 2) {
            return {'row': row, 'col': col};
          }
        }
      }
    }
    return null;
  }

  Map<String, int>? _findForkCreatingMove(List<List<int>> board, int player) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 0) {
          List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
          tempBoard[row][col] = player;
          int winningLines = _countPotentialWinningLines(tempBoard, player);
          if (winningLines >= 2) {
            return {'row': row, 'col': col};
          }
        }
      }
    }
    return null;
  }

  int _countPotentialWinningLines(List<List<int>> board, int player) {
    int count = 0;
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 0) {
          List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
          tempBoard[row][col] = player;
          if (_checkWin(tempBoard, row, col, player)) {
            count++;
          }
        }
      }
    }
    return count;
  }

  Map<String, int>? _findTwoInRowWithOpenEnds(List<List<int>> board, int player) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == player) {
          Map<String, int>? blockMove = _checkTwoInRow(board, row, col, player);
          if (blockMove != null) {
            return blockMove;
          }
        }
      }
    }
    return null;
  }

  Map<String, int>? _checkTwoInRow(List<List<int>> board, int row, int col, int player) {
    List<List<int>> directions = [[1, 0], [0, 1], [1, 1], [1, -1]];

    for (var dir in directions) {
      int dRow = dir[0];
      int dCol = dir[1];

      int nextRow = row + dRow;
      int nextCol = col + dCol;
      int prevRow = row - dRow;
      int prevCol = col - dCol;

      if (_isInBounds(nextRow, nextCol) && board[nextRow][nextCol] == player) {
        int beforeRow = prevRow;
        int beforeCol = prevCol;
        int afterRow = row + 2 * dRow;
        int afterCol = col + 2 * dCol;

        if (_isInBounds(beforeRow, beforeCol) && board[beforeRow][beforeCol] == 0 &&
            _isInBounds(afterRow, afterCol) && board[afterRow][afterCol] == 0) {
          return {'row': beforeRow, 'col': beforeCol};
        }
      }

      if (_isInBounds(prevRow, prevCol) && board[prevRow][prevCol] == player) {
        int beforeRow = prevRow - dRow;
        int beforeCol = prevCol - dCol;
        int afterRow = row + dRow;
        int afterCol = col + dCol;

        if (_isInBounds(beforeRow, beforeCol) && board[beforeRow][beforeCol] == 0 &&
            _isInBounds(afterRow, afterCol) && board[afterRow][afterCol] == 0) {
          return {'row': afterRow, 'col': afterCol};
        }
      }
    }
    return null;
  }

  Map<String, int> _findBestMove(List<List<int>> board) {
    int bestScore = -1000;
    Map<String, int>? bestMove;
    List<Map<String, int>> moves = _getNearbyMoves(board);
    debugPrint("Hard bot: Available moves for Minimax: $moves");

    if (moves.isEmpty) {
      debugPrint("Hard bot: No available moves found!");
      return {'row': 0, 'col': 0};
    }

    int emptyCells = board.expand((row) => row).where((cell) => cell == 0).length;
    int maxDepth = emptyCells > (gridSize * gridSize * 0.7).toInt() ? 1 : 2;

    for (var move in moves) {
      List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
      tempBoard[move['row']!][move['col']!] = 2;
      String boardKey = _boardToString(tempBoard);
      int score = _moveHistory.containsKey(boardKey) && !_moveHistory[boardKey]!
          ? -1000
          : _minimax(tempBoard, 0, false, -1000, 1000, maxDepth);
      debugPrint("Hard bot: Move at row=${move['row']}, col=${move['col']} has score=$score");
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    debugPrint("Hard bot: Best move chosen: $bestMove with score=$bestScore");
    return bestMove ?? moves[_random.nextInt(moves.length)];
  }

  List<Map<String, int>> _getNearbyMoves(List<List<int>> board) {
    List<Map<String, int>> moves = [];
    Set<String> checked = {};
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] != 0) {
          for (int dRow = -1; dRow <= 1; dRow++) {
            for (int dCol = -1; dCol <= 1; dCol++) {
              int newRow = row + dRow;
              int newCol = col + dCol;
              if (_isInBounds(newRow, newCol) && board[newRow][newCol] == 0) {
                String key = '$newRow,$newCol';
                if (!checked.contains(key)) {
                  moves.add({'row': newRow, 'col': newCol});
                  checked.add(key);
                }
              }
            }
          }
        }
      }
    }
    if (moves.isEmpty || board.expand((row) => row).where((cell) => cell != 0).length < 4) {
      int center = gridSize ~/ 2;
      List<Map<String, int>> centerMoves = [
        {'row': center, 'col': center},
        {'row': center, 'col': center - 1},
        {'row': center - 1, 'col': center},
        {'row': center - 1, 'col': center - 1},
        {'row': center, 'col': center + 1},
        {'row': center + 1, 'col': center},
        {'row': center - 1, 'col': center + 1},
        {'row': center + 1, 'col': center - 1},
      ];
      for (var move in centerMoves) {
        int row = move['row']!;
        int col = move['col']!;
        if (_isInBounds(row, col) && board[row][col] == 0) return [move];
      }
    }
    return moves.isEmpty ? [_findRandomMove(board)!] : moves;
  }

  int _minimax(List<List<int>> board, int depth, bool isMaximizing, int alpha, int beta, int maxDepth) {
    String boardKey = _boardToString(board);
    if (_moveHistory.containsKey(boardKey)) {
      return _moveHistory[boardKey]! ? 1000 : -1000;
    }

    if (depth >= maxDepth || _isGameOver(board)) {
      int score = _evaluateBoard(board);
      debugPrint("Minimax: Depth=$depth, Score=$score, isMaximizing=$isMaximizing");
      return score;
    }

    if (isMaximizing) {
      int maxEval = -1000;
      List<Map<String, int>> moves = _getNearbyMoves(board);
      for (var move in moves) {
        int row = move['row']!;
        int col = move['col']!;
        List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
        tempBoard[row][col] = 2;
        int eval = _minimax(tempBoard, depth + 1, false, alpha, beta, maxDepth);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) break;
      }
      return maxEval;
    } else {
      int minEval = 1000;
      List<Map<String, int>> moves = _getNearbyMoves(board);
      for (var move in moves) {
        int row = move['row']!;
        int col = move['col']!;
        List<List<int>> tempBoard = board.map((row) => List<int>.from(row)).toList();
        tempBoard[row][col] = 1;
        int eval = _minimax(tempBoard, depth + 1, true, alpha, beta, maxDepth);
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) break;
      }
      return minEval;
    }
  }

  bool _isGameOver(List<List<int>> board) {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (board[r][c] != 0 && _checkWin(board, r, c, board[r][c])) return true;
      }
    }
    return board.every((row) => row.every((cell) => cell != 0));
  }

  bool _checkWin(List<List<int>> board, int row, int col, int player) {
    for (var direction in [[0, 1], [1, 0], [1, 1], [1, -1]]) {
      int count = 1;
      for (int i = 1; i < winCondition; i++) { // Заменяем AppConstants.winCondition
        int r = row + direction[0] * i;
        int c = col + direction[1] * i;
        if (r < 0 || r >= gridSize || c < 0 || c >= gridSize || board[r][c] != player) break;
        count++;
      }
      for (int i = 1; i < winCondition; i++) { // Заменяем AppConstants.winCondition
        int r = row - direction[0] * i;
        int c = col - direction[1] * i;
        if (r < 0 || r >= gridSize || c < 0 || c >= gridSize || board[r][c] != player) break;
        count++;
      }
      if (count >= winCondition) return true; // Заменяем AppConstants.winCondition
    }
    return false;
  }

  int _evaluateBoard(List<List<int>> board) {
    int score = 0;
    score += _countLines(board, 2, 4) * 200;
    score += _countLines(board, 2, 3) * 100;
    score += _countLines(board, 2, 2) * 20;
    score -= _countLines(board, 1, 4) * 2000;
    score -= _countLines(board, 1, 3) * 1000;
    score -= _countLines(board, 1, 2) * 200;
    score -= _countPotentialWinningLines(board, 1) * 500;

    int centerScore = 0;
    int center = gridSize ~/ 2;
    for (int row = center - 1; row <= center + 1; row++) {
      for (int col = center - 1; col <= center + 1; col++) {
        if (_isInBounds(row, col)) {
          if (board[row][col] == 1) centerScore -= 50;
          if (board[row][col] == 2) centerScore += 20;
        }
      }
    }
    score += centerScore;

    return score;
  }

  int _countLines(List<List<int>> board, int player, int length) {
    int count = 0;
    List<List<int>> directions = [[1, 0], [0, 1], [1, 1], [1, -1]];

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == player) {
          for (var dir in directions) {
            int dRow = dir[0];
            int dCol = dir[1];
            int lineCount = 1;

            for (int i = 1; i < winCondition; i++) { // Заменяем AppConstants.winCondition
              int newRow = row + dRow * i;
              int newCol = col + dCol * i;
              if (_isInBounds(newRow, newCol) && board[newRow][newCol] == player) lineCount++;
              else break;
            }
            for (int i = 1; i < winCondition; i++) { // Заменяем AppConstants.winCondition
              int newRow = row - dRow * i;
              int newCol = col - dCol * i;
              if (_isInBounds(newRow, newCol) && board[newRow][newCol] == player) lineCount++;
              else break;
            }

            if (lineCount >= length) {
              int beforeRow = row - dRow;
              int beforeCol = col - dCol;
              int afterRow = row + dRow * length;
              int afterCol = col + dCol * length;
              bool openBefore = _isInBounds(beforeRow, beforeCol) && board[beforeRow][beforeCol] == 0;
              bool openAfter = _isInBounds(afterRow, afterCol) && board[afterRow][afterCol] == 0;
              if (openBefore || openAfter) count++;
            }
          }
        }
      }
    }
    return count;
  }

  bool _isInBounds(int row, int col) {
    return row >= 0 && row < gridSize && col >= 0 && col < gridSize;
  }
}