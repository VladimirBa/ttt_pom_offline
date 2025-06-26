import 'package:flutter/material.dart';
import '../logic/game_logic.dart';
import '../utils/platform_utils.dart';

class GameFooterWidget extends StatelessWidget {
  final GameLogic gameLogic;
  final String player1Name;
  final String player2Name;
  final VoidCallback onNextRound;
  final VoidCallback onReset;
  final VoidCallback onEndTournament;
  final VoidCallback onAnalyze;

  const GameFooterWidget({
    super.key,
    required this.gameLogic,
    required this.player1Name,
    required this.player2Name,
    required this.onNextRound,
    required this.onReset,
    required this.onEndTournament,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    bool isTournamentFinished = gameLogic.currentRound >= gameLogic.rounds;
    double boardSize = PlatformUtils.getBoardSize(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          width: boardSize,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              if (gameLogic.gameOver)
                _buildButton(
                  text: isTournamentFinished ? "Tournament Finished" : "Next Round",
                  onPressed: isTournamentFinished ? onEndTournament : onNextRound,
                  color: Colors.blue,
                ),
              const SizedBox(height: 8),
              _buildButton(
                text: "Analyze the Game",
                onPressed: onAnalyze,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              _buildButton(
                text: "Tournament Result",
                onPressed: onEndTournament,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}