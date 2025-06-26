import 'package:flutter/material.dart';
import 'dart:isolate';
import 'tic_tac_toe_bot.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GameLogic {
  late List<List<int>> board;
  int currentPlayer = 1;
  int player1Score = 0;
  int player2Score = 0;
  int currentRound = 1;
  final int rounds;
  final int gridSize;
  final int winCondition;
  bool gameOver = false;
  bool hasMoved = false;
  bool canMove = true;
  List<int> winningCells = [];
  final bool isBotGame;
  final int botDifficulty;
  final ValueNotifier<bool> gameOverNotifier = ValueNotifier<bool>(false);

  int player1TotalTime = 0;
  int player2TotalTime = 0;
  DateTime? currentPlayerTurnStart;
  int player1MissedTurns = 0;
  int player2MissedTurns = 0;
  List<Map<String, dynamic>> moveHistory = [];
  int player1MoveCount = 0;
  int player2MoveCount = 0;
  int? lastRoundWinner;

  GameLogic({
    required this.rounds,
    required this.isBotGame,
    required this.botDifficulty,
    required this.gridSize,
    required this.winCondition,
  }) {
    if (winCondition > gridSize) {
      throw ArgumentError('winCondition cannot be greater than gridSize ($winCondition > $gridSize)');
    }
    if (winCondition < 3) {
      throw ArgumentError('winCondition must be at least 3 ($winCondition < 3)');
    }
    board = List.generate(
      gridSize,
          (_) => List.filled(gridSize, 0),
    );
  }

  void startPlayerTimer() {
    currentPlayerTurnStart = DateTime.now();
  }

  void stopPlayerTimer() {
    if (currentPlayerTurnStart != null) {
      final duration = DateTime.now().difference(currentPlayerTurnStart!);
      if (currentPlayer == 1) {
        player1TotalTime += duration.inSeconds;
      } else {
        player2TotalTime += duration.inSeconds;
      }
      currentPlayerTurnStart = null;
    }
  }

  void handleTap(int row, int col, VoidCallback callback) {
    if (!gameOver && !hasMoved && canMove && board[row][col] == 0) {
      board[row][col] = currentPlayer;
      hasMoved = true;
      int moveNumber = currentPlayer == 1 ? ++player1MoveCount : ++player2MoveCount;
      moveHistory.add({
        'row': row,
        'col': col,
        'player': currentPlayer,
        'moveNumber': moveNumber,
      });
      if (checkWin(row, col)) {
        gameOver = true;
        gameOverNotifier.value = true;
        if (currentPlayer == 1) {
          player1Score++;
          lastRoundWinner = 1;
        } else {
          player2Score++;
          lastRoundWinner = 2;
        }
        highlightWinningCells(row, col);
      } else if (isBoardFull()) {
        gameOver = true;
        gameOverNotifier.value = true;
        lastRoundWinner = null;
      }
      callback();
    }
  }

  void switchPlayer() {
    stopPlayerTimer();
    currentPlayer = (currentPlayer == 1) ? 2 : 1;
    hasMoved = false;
    canMove = true;
    startPlayerTimer();
  }

  bool checkWin(int row, int col) {
    int player = board[row][col];
    int count;

    count = 1;
    for (int c = col - 1; c >= 0 && board[row][c] == player; c--) {
      count++;
    }
    for (int c = col + 1; c < gridSize && board[row][c] == player; c++) {
      count++;
    }
    if (count >= winCondition) return true;

    count = 1;
    for (int r = row - 1; r >= 0 && board[r][col] == player; r--) {
      count++;
    }
    for (int r = row + 1; r < gridSize && board[r][col] == player; r++) {
      count++;
    }
    if (count >= winCondition) return true;

    count = 1;
    for (int i = 1; row - i >= 0 && col - i >= 0 && board[row - i][col - i] == player; i++) {
      count++;
    }
    for (int i = 1; row + i < gridSize && col + i < gridSize && board[row + i][col + i] == player; i++) {
      count++;
    }
    if (count >= winCondition) return true;

    count = 1;
    for (int i = 1; row - i >= 0 && col + i < gridSize && board[row - i][col + i] == player; i++) {
      count++;
    }
    for (int i = 1; row + i < gridSize && col - i >= 0 && board[row + i][col - i] == player; i++) {
      count++;
    }
    if (count >= winCondition) return true;

    return false;
  }

  bool isBoardFull() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (board[r][c] == 0) return false;
      }
    }
    return true;
  }

  void highlightWinningCells(int row, int col) {
    int player = board[row][col];
    winningCells.clear();

    void addWinningLine(int dr, int dc) {
      int r = row;
      int c = col;
      int count = 1;
      List<int> tempCells = [r * gridSize + c];

      for (int i = 1; r - i * dr >= 0 && c - i * dc >= 0 && r - i * dr < gridSize && c - i * dc < gridSize && board[r - i * dr][c - i * dc] == player; i++) {
        count++;
        tempCells.add((r - i * dr) * gridSize + (c - i * dc));
      }
      for (int i = 1; r + i * dr >= 0 && c + i * dc >= 0 && r + i * dr < gridSize && c + i * dc < gridSize && board[r + i * dr][c + i * dc] == player; i++) {
        count++;
        tempCells.add((r + i * dr) * gridSize + (c + i * dc));
      }

      if (count >= winCondition) {
        winningCells.addAll(tempCells);
      }
    }

    addWinningLine(0, 1);
    addWinningLine(1, 0);
    addWinningLine(1, 1);
    addWinningLine(1, -1);
  }

  Future<void> handleBotMove(VoidCallback callback) async {
    if (gameOver || !isBotGame || currentPlayer != 2 || !canMove) {
      return;
    }

    final bot = TicTacToeBot(
      difficulty: botDifficulty,
      gridSize: gridSize,
      winCondition: winCondition,
    );

    try {
      final move = kIsWeb
          ? bot.makeBotMove(board)
          : await _computeBotMove(bot, board);

      if (move != null) {
        final row = move['row']!;
        final col = move['col']!;

        if (board[row][col] == 0 && canMove) {
          handleTap(row, col, callback);
        } else {
          gameOver = true;
          gameOverNotifier.value = true;
          lastRoundWinner = null;
          callback();
        }
      } else {
        gameOver = true;
        gameOverNotifier.value = true;
        lastRoundWinner = null;
        callback();
      }
    } catch (e) {
      gameOver = true;
      gameOverNotifier.value = true;
      lastRoundWinner = null;
      callback();
    }
  }

  static Future<Map<String, int>?> _computeBotMove(TicTacToeBot bot, List<List<int>> board) async {
    if (kIsWeb) {
      return bot.makeBotMove(board);
    } else {
      final receivePort = ReceivePort();
      await Isolate.spawn(_isolateBotMove, [receivePort.sendPort, bot, board]);
      return await receivePort.first as Map<String, int>?;
    }
  }

  static void _isolateBotMove(List<dynamic> args) {
    final SendPort sendPort = args[0];
    final TicTacToeBot bot = args[1];
    final List<List<int>> board = args[2];
    final move = bot.makeBotMove(board);
    sendPort.send(move);
  }

  void nextRound() {
    if (currentRound < rounds) {
      currentRound++;
      resetBoard();
    }
  }

  void resetBoard() {
    board = List.generate(
      gridSize,
          (_) => List.filled(gridSize, 0),
    );
    gameOver = false;
    gameOverNotifier.value = false;
    hasMoved = false;
    canMove = true;
    winningCells.clear();
    moveHistory.clear();
    player1MoveCount = 0;
    player2MoveCount = 0;
    currentPlayer = (currentRound == 1 || lastRoundWinner == null)
        ? 1
        : lastRoundWinner!;
    stopPlayerTimer();
  }

  void resetGame() {
    resetBoard();
    player1Score = 0;
    player2Score = 0;
    player1TotalTime = 0;
    player2TotalTime = 0;
    player1MissedTurns = 0;
    player2MissedTurns = 0;
    currentRound = 1;
    lastRoundWinner = null;
  }

  void onTimeUp() {
    if (!gameOver) {
      stopPlayerTimer();
      if (!hasMoved) {
        if (currentPlayer == 1) {
          player1MissedTurns++;
        } else {
          player2MissedTurns++;
        }
      }
      switchPlayer();
    }
  }
}