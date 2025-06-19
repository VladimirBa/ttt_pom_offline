import 'package:flutter/material.dart';

class TournamentResultsPage extends StatelessWidget {
  final String player1Name;
  final String player2Name;
  final int player1Score;
  final int player2Score;
  final int rounds;
  final int currentRound;
  final Color player1Color; // Новый параметр
  final Color player2Color; // Новый параметр

  const TournamentResultsPage({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.player1Score,
    required this.player2Score,
    required this.rounds,
    required this.currentRound,
    required this.player1Color, // Новый параметр
    required this.player2Color, // Новый параметр
  });

  @override
  Widget build(BuildContext context) {
    bool isTournamentFinished = currentRound >= rounds;
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth < 400 ? 24 : 28;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Tournament Results',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                // Контейнер с информацией
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isTournamentFinished)
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.yellow,
                          size: 100,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        isTournamentFinished ? 'Tournament Finished!' : 'Current Round: $currentRound / $rounds',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$player1Name: $player1Score',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          color: player1Color, // Используем кастомный цвет
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$player2Name: $player2Score',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          color: player2Color, // Используем кастомный цвет
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (isTournamentFinished) ...[
                        const SizedBox(height: 16),
                        Text(
                          player1Score > player2Score
                              ? '$player1Name WINS the Tournament!'
                              : player1Score < player2Score
                              ? '$player2Name WINS the Tournament!'
                              : 'Draw!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.yellowAccent,
                            shadows: const [
                              Shadow(
                                color: Colors.green,
                                offset: Offset(4, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Кнопка "Back"
                SizedBox(
                  width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isTournamentFinished) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      isTournamentFinished
                          ? 'Back to the Main Menu'
                          : 'Back to the Tournament',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}