import 'package:flutter/material.dart';
import 'game_page.dart';
import 'custom_setup_page.dart';
import '../widgets/neon_button.dart';

class BotGameSetupPage extends StatefulWidget {
  final String playerName;
  final int botDifficulty;

  const BotGameSetupPage({
    super.key,
    required this.playerName,
    required this.botDifficulty,
  });

  @override
  State<BotGameSetupPage> createState() => _BotGameSetupPageState();
}

class _BotGameSetupPageState extends State<BotGameSetupPage> {
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Bot Game Setup',
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
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
                        ),
                        const SizedBox(height: 16),
                        const Text('Time per Turn', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
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
                        ),
                        const SizedBox(height: 16),
                        const Text('Winning Condition', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                          height: 50,
                          child: NeonButton(
                            text: 'Custom/Traditional Setup',
                            icon: Icons.settings,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CustomSetupPage(
                                    player1Name: widget.playerName,
                                    player2Name: 'Bot',
                                    isBotGame: true,
                                    botDifficulty: widget.botDifficulty,
                                    title: 'Bot Game Custom/Traditional Setup',
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
                                    player1Name: widget.playerName,
                                    player2Name: 'Bot',
                                    rounds: rounds,
                                    player1Color: Colors.red,
                                    player2Color: Colors.blue,
                                    timeLimit: timerSeconds,
                                    isBotGame: true,
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
        ),
      ),
    );
  }
}