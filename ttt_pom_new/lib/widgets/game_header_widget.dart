import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

class GameHeaderWidget extends StatelessWidget {
  final String player1Name;
  final String player2Name;
  final int player1Score;
  final int player2Score;
  final int currentRound;
  final int totalRounds;
  final Color player1Color;
  final Color player2Color;
  final int currentPlayer;
  final int remainingSeconds;

  const GameHeaderWidget({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.player1Score,
    required this.player2Score,
    required this.currentRound,
    required this.totalRounds,
    required this.player1Color,
    required this.player2Color,
    required this.currentPlayer,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    double boardSize = PlatformUtils.getBoardSize(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              Text(
                'Round $currentRound/$totalRounds',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                player1Name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: player1Color,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                player2Name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: player2Color,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Text(
                '$player1Score - $player2Score',
                style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Text(
                      "Now it's ${currentPlayer == 1 ? player1Name : player2Name}'s turn",
                      style: TextStyle(
                        fontSize: 13,
                        color: currentPlayer == 1 ? player1Color : player2Color,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          const TextSpan(
                            text: "Time left: ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "$remainingSeconds s",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: remainingSeconds <= 5 ? Colors.red : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}