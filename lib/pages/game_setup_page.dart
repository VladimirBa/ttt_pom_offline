import 'package:flutter/material.dart';
import 'game_page.dart';
import 'custom_setup_page.dart';
import '../widgets/neon_button.dart';

class GameSetupPage extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final bool isBotGame;
  final int botDifficulty;

  const GameSetupPage({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.isBotGame,
    required this.botDifficulty,
  });

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  int rounds = 1;
  int timerSeconds = 7;
  int winCondition = 5; // Новая переменная состояния для winCondition
  final _roundsController = TextEditingController(text: '1');
  final _timerController = TextEditingController(text: '7');

  @override
  void dispose() {
    _roundsController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _showInvalidInputSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            padding: const EdgeInsets.only(top: 10),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    'Game Setup',
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
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    SizedBox(
                      width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                      height: 50,
                      child: NeonButton(
                        text: 'Back',
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Number of Rounds', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [1, 2, 3, 5, 7, 9, 15].map((value) {
                        return ChoiceChip(
                          label: Text('$value'),
                          selected: rounds == value,
                          onSelected: (selected) {
                            if (selected) setState(() => rounds = value);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Time per Turn', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [7, 10, 15, 30].map((value) {
                        return ChoiceChip(
                          label: Text('$value s'),
                          selected: timerSeconds == value,
                          onSelected: (selected) {
                            if (selected) setState(() => timerSeconds = value);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Winning Condition', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [3, 4, 5, 6].map((value) {
                        return ChoiceChip(
                          label: Text('$value in a row'),
                          selected: winCondition == value,
                          onSelected: (selected) {
                            if (selected) setState(() => winCondition = value);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                      height: 50,
                      child: NeonButton(
                        text: 'Custom/Classic Setup',
                        icon: Icons.settings,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomSetupPage(
                                player1Name: widget.player1Name,
                                player2Name: widget.player2Name,
                                isBotGame: widget.isBotGame,
                                botDifficulty: widget.botDifficulty,
                                title: 'Game Custom/Classic Setup',
                                rounds: rounds,
                                timeLimit: timerSeconds,
                                winCondition: winCondition, // Передаем winCondition
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                      height: 50,
                      child: NeonButton(
                        text: 'Start Game',
                        icon: Icons.play_arrow,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GamePage(
                                player1Name: widget.player1Name,
                                player2Name: widget.player2Name,
                                rounds: rounds,
                                player1Color: Colors.red,
                                player2Color: Colors.blue,
                                timeLimit: timerSeconds,
                                isBotGame: widget.isBotGame,
                                botDifficulty: widget.botDifficulty,
                                gridSize: 10,
                                winCondition: winCondition, // Используем выбранное значение
                              ),
                            ),
                          );
                        },
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