import 'package:flutter/material.dart';
import 'game_page.dart';
import '../widgets/neon_button.dart';

class CustomSetupPage extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final bool isBotGame;
  final int botDifficulty;
  final String title;
  final int rounds;
  final int timeLimit;
  final int winCondition;

  const CustomSetupPage({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.isBotGame,
    required this.botDifficulty,
    required this.title,
    required this.rounds,
    required this.timeLimit,
    required this.winCondition,
  });

  @override
  State<CustomSetupPage> createState() => _CustomSetupPageState();
}

class _CustomSetupPageState extends State<CustomSetupPage> {
  Color player1Color = Colors.green;
  Color player2Color = Colors.purple;
  int gridSize = 10;

  final List<Color> availableColors = [
    Colors.green,
    Colors.brown,
    Colors.grey,
    Colors.purple,
  ];

  final List<int> availableGridSizes = [8, 10, 12];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth < 400 ? 24 : 28;

    List<Color> player1AvailableColors = availableColors.where((color) => color != player2Color).toList();
    List<Color> player2AvailableColors = availableColors.where((color) => color != player1Color).toList();

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
                      widget.title,
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
                        const SizedBox(height: 16),
                        Text(
                          '${widget.player1Name} Color',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: player1AvailableColors.map((color) {
                              return ChoiceChip(
                                label: Container(
                                  width: 30,
                                  height: 30,
                                  color: color,
                                ),
                                selected: player1Color == color,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      player1Color = color;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.isBotGame ? 'Bot Color' : '${widget.player2Name} Color',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: player2AvailableColors.map((color) {
                              return ChoiceChip(
                                label: Container(
                                  width: 30,
                                  height: 30,
                                  color: color,
                                ),
                                selected: player2Color == color,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      player2Color = color;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Board Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: availableGridSizes.map((size) {
                              return ChoiceChip(
                                label: Text('$size x $size'),
                                selected: gridSize == size,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      gridSize = size;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Winning Condition: ${widget.winCondition} in a row',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.yellow,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                          height: 50,
                          child: NeonButton(
                            text: 'Start Custom Game',
                            icon: Icons.play_arrow,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GamePage(
                                    player1Name: widget.player1Name,
                                    player2Name: widget.player2Name,
                                    rounds: widget.rounds,
                                    player1Color: player1Color,
                                    player2Color: player2Color,
                                    timeLimit: widget.timeLimit,
                                    isBotGame: widget.isBotGame,
                                    botDifficulty: widget.botDifficulty,
                                    isTraditional: false,
                                    gridSize: gridSize,
                                    winCondition: widget.winCondition,
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
                            text: 'Start Classic Game',
                            icon: Icons.play_arrow,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GamePage(
                                    player1Name: widget.player1Name,
                                    player2Name: widget.player2Name,
                                    rounds: widget.rounds,
                                    player1Color: Colors.black,
                                    player2Color: Colors.black,
                                    timeLimit: widget.timeLimit,
                                    isBotGame: widget.isBotGame,
                                    botDifficulty: widget.botDifficulty,
                                    isTraditional: true,
                                    gridSize: gridSize,
                                    winCondition: widget.winCondition,
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