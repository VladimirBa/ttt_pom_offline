import 'package:flutter/material.dart';
import '../logic/game_logic.dart';
//import '../utils/constants.dart';
import '../utils/platform_utils.dart';
import '../utils/cross_painter.dart';
import '../utils/circle_painter.dart';

class GameAnalysisPage extends StatefulWidget {
  final GameLogic gameLogic;
  final String player1Name;
  final String player2Name;
  final Color player1Color;
  final Color player2Color;
  final bool isTraditional;

  const GameAnalysisPage({
    Key? key,
    required this.gameLogic,
    required this.player1Name,
    required this.player2Name,
    required this.player1Color,
    required this.player2Color,
    required this.isTraditional,
  }) : super(key: key);

  @override
  State<GameAnalysisPage> createState() => _GameAnalysisPageState();
}

class _GameAnalysisPageState extends State<GameAnalysisPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Exit Confirmation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          content: const Text(
            'Are you sure you want to exit the game analysis?',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTournamentWinner =
        widget.gameLogic.player1Score != widget.gameLogic.player2Score;
    String winnerName = widget.gameLogic.player1Score > widget.gameLogic.player2Score
        ? widget.player1Name
        : widget.player2Name;
    bool isDraw = widget.gameLogic.lastRoundWinner == null &&
        widget.gameLogic.isBoardFull();
    double boardSize = PlatformUtils.getBoardSize(context);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: _showExitConfirmationDialog,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Game Analysis',
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
                  ),
                  const SizedBox(width: 48), // Balance icon button padding
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: boardSize,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Stats:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.player1Name,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.player1Color,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.gameLogic.player1MissedTurns > 0
                          ? 'Spent: ${_formatTime(widget.gameLogic.player1TotalTime)}s. Missed: ${widget.gameLogic.player1MissedTurns} turns'
                          : 'Spent: ${_formatTime(widget.gameLogic.player1TotalTime)}s',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.player2Name,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.player2Color,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.gameLogic.player2MissedTurns > 0
                          ? 'Spent: ${_formatTime(widget.gameLogic.player2TotalTime)}s. Missed: ${widget.gameLogic.player2MissedTurns} turns'
                          : 'Spent: ${_formatTime(widget.gameLogic.player2TotalTime)}s',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (isDraw)
                      const Text(
                        'Draw!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (!isDraw && widget.gameLogic.lastRoundWinner != null)
                      Text(
                        'Winner: ${widget.gameLogic.lastRoundWinner == 1 ? widget.player1Name : widget.player2Name}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (isTournamentWinner && widget.gameLogic.currentRound >= widget.gameLogic.rounds)
                      Text(
                        'Tournament Winner: $winnerName',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: boardSize,
                    height: boardSize,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.gameLogic.gridSize,
                        ),
                        itemCount: widget.gameLogic.gridSize * widget.gameLogic.gridSize,
                        itemBuilder: (context, index) {
                          int row = index ~/ widget.gameLogic.gridSize;
                          int col = index % widget.gameLogic.gridSize;

                          // Отладочный вывод для проверки индексов
                          debugPrint('Rendering cell: row=$row, col=$col, index=$index, gridSize=${widget.gameLogic.gridSize}');

                          // Проверка на выход за границы
                          if (row >= widget.gameLogic.gridSize || col >= widget.gameLogic.gridSize) {
                            return const SizedBox.shrink();
                          }

                          int cellValue = widget.gameLogic.board[row][col];
                          bool isWinningCell =
                          widget.gameLogic.winningCells.contains(index);
                          var move = widget.gameLogic.moveHistory.firstWhere(
                                (m) => m['row'] == row && m['col'] == col,
                            orElse: () => {},
                          );

                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: isWinningCell ? _blinkAnimation.value : 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: isWinningCell ? Colors.yellow : Colors.black,
                                      width: isWinningCell ? 2.0 : 1.0,
                                    ),
                                    borderRadius: widget.isTraditional
                                        ? BorderRadius.zero
                                        : BorderRadius.circular(8.0),
                                    boxShadow: widget.isTraditional
                                        ? null
                                        : [
                                      BoxShadow(
                                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.5,
                                        offset: const Offset(0.5, 0.5),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      if (cellValue != 0)
                                        widget.isTraditional
                                            ? Center(
                                          child: CustomPaint(
                                            size: const Size(20, 20),
                                            painter: cellValue == 1
                                                ? CrossPainter(opacity: 0.7)
                                                : CirclePainter(opacity: 0.7),
                                          ),
                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: RadialGradient(
                                                center: Alignment.center,
                                                radius: 0.5,
                                                colors: [
                                                  Color.fromRGBO(
                                                    cellValue == 1
                                                        ? widget.player1Color.red
                                                        : widget.player2Color.red,
                                                    cellValue == 1
                                                        ? widget.player1Color.green
                                                        : widget.player2Color.green,
                                                    cellValue == 1
                                                        ? widget.player1Color.blue
                                                        : widget.player2Color.blue,
                                                    0.5,
                                                  ),
                                                  cellValue == 1
                                                      ? widget.player1Color
                                                      : widget.player2Color,
                                                ],
                                                stops: const [0.3, 1.0],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                    cellValue == 1
                                                        ? widget.player1Color.red
                                                        : widget.player2Color.red,
                                                    cellValue == 1
                                                        ? widget.player1Color.green
                                                        : widget.player2Color.green,
                                                    cellValue == 1
                                                        ? widget.player1Color.blue
                                                        : widget.player2Color.blue,
                                                    0.7,
                                                  ),
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                  offset: const Offset(3.0, 3.0),
                                                ),
                                                const BoxShadow(
                                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                                  blurRadius: 5.0,
                                                  spreadRadius: 1.0,
                                                  offset: Offset(-2.0, -2.0),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: isWinningCell
                                                  ? const Icon(
                                                Icons.star,
                                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                                size: 20.0,
                                              )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      if (move.isNotEmpty)
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(8.0),
                                              ),
                                            ),
                                            child: Text(
                                              move['moveNumber'].toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}