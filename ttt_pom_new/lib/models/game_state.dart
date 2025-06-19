class GameState {
  final List<List<int>> board;
  final int currentPlayer;
  final bool gameOver;
  final int player1Score;
  final int player2Score;
  final int currentRound;
  final int rounds;
  final List<int> winningCells;

  GameState({
    required this.board,
    required this.currentPlayer,
    required this.gameOver,
    required this.player1Score,
    required this.player2Score,
    required this.currentRound,
    required this.rounds,
    required this.winningCells,
  });

  GameState copyWith({
    List<List<int>>? board,
    int? currentPlayer,
    bool? gameOver,
    int? player1Score,
    int? player2Score,
    int? currentRound,
    int? rounds,
    List<int>? winningCells,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      gameOver: gameOver ?? this.gameOver,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      currentRound: currentRound ?? this.currentRound,
      rounds: rounds ?? this.rounds,
      winningCells: winningCells ?? this.winningCells,
    );
  }
}