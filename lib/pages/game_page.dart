import 'package:flutter/material.dart';
import '../logic/game_logic.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/game_header_widget.dart';
import '../widgets/game_footer_widget.dart';
import '../widgets/timer_widget.dart';
import 'tournament_results_page.dart';
import 'game_analysis_page.dart';
import '../utils/platform_utils.dart';

class GamePage extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final int rounds;
  final Color player1Color;
  final Color player2Color;
  final int timeLimit;
  final bool isBotGame;
  final int botDifficulty;
  final bool isTraditional;
  final int gridSize;
  final int winCondition;

  const GamePage({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.rounds,
    required this.player1Color,
    required this.player2Color,
    required this.timeLimit,
    required this.isBotGame,
    required this.botDifficulty,
    this.isTraditional = false,
    required this.gridSize,
    required this.winCondition,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  late GameLogic gameLogic;
  late GlobalKey<TimerWidgetState> _timerKey;

  @override
  void initState() {
    super.initState();
    _timerKey = GlobalKey<TimerWidgetState>();
    gameLogic = GameLogic(
      rounds: widget.rounds,
      isBotGame: widget.isBotGame,
      botDifficulty: widget.botDifficulty,
      gridSize: widget.gridSize,
      winCondition: widget.winCondition,
    );
    WidgetsBinding.instance.addObserver(this);
    if (widget.timeLimit > 0) {
      _timerKey.currentState?.startTimer();
    }
    if (widget.isBotGame && gameLogic.currentPlayer == 2) {
      _scheduleBotMove();
    }
  }

  void _onTimeUp() {
    setState(() {
      gameLogic.onTimeUp();
      _timerKey.currentState?.resetTimer();
      if (!gameLogic.gameOver) {
        _timerKey.currentState?.startTimer();
        if (widget.isBotGame && gameLogic.currentPlayer == 2) {
          _scheduleBotMove();
        }
      }
    });
  }

  void _updateGameState() {
    setState(() {
      if (!gameLogic.gameOver) {
        gameLogic.switchPlayer();
        _timerKey.currentState?.resetTimer();
        _timerKey.currentState?.startTimer();
        if (widget.isBotGame && gameLogic.currentPlayer == 2) {
          _scheduleBotMove();
        }
      }
    });
  }

  void _scheduleBotMove() {
    if (gameLogic.canMove && gameLogic.currentPlayer == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameLogic.handleBotMove(_updateGameState);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timerKey.currentState?.stopTimer();
    } else if (state == AppLifecycleState.resumed && !gameLogic.gameOver) {
      _timerKey.currentState?.startTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerKey.currentState?.stopTimer();
    super.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Exit Game'),
                          content: const Text('Are you sure you want to exit the game?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Exit', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Good Luck!',
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
              const SizedBox(height: 8),
              TimerWidget(
                key: _timerKey,
                seconds: widget.timeLimit,
                onTimeUp: _onTimeUp,
                gameLogic: gameLogic,
              ),
              ValueListenableBuilder<int>(
                valueListenable: _timerKey.currentState?.remainingSeconds ?? ValueNotifier(widget.timeLimit),
                builder: (context, remainingSeconds, child) {
                  return GameHeaderWidget(
                    player1Name: widget.player1Name,
                    player2Name: widget.player2Name,
                    player1Score: gameLogic.player1Score,
                    player2Score: gameLogic.player2Score,
                    currentRound: gameLogic.currentRound,
                    totalRounds: widget.rounds,
                    player1Color: widget.player1Color,
                    player2Color: widget.player2Color,
                    currentPlayer: gameLogic.currentPlayer,
                    remainingSeconds: remainingSeconds,
                  );
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    GameBoardWidget(
                      gameLogic: gameLogic,
                      player1Color: widget.player1Color,
                      player2Color: widget.player2Color,
                      onTap: _updateGameState,
                      isTraditional: widget.isTraditional,
                    ),
                    if (gameLogic.gameOver)
                      Positioned(
                        bottom: -20,
                        left: 0,
                        right: 0,
                        child: GameFooterWidget(
                          gameLogic: gameLogic,
                          player1Name: widget.player1Name,
                          player2Name: widget.player2Name,
                          onNextRound: () {
                            setState(() {
                              gameLogic.nextRound();
                              _timerKey.currentState?.stopTimer();
                              _timerKey.currentState?.resetTimer();
                              if (widget.timeLimit > 0) {
                                _timerKey.currentState?.startTimer();
                              }
                              if (widget.isBotGame && gameLogic.currentPlayer == 2) {
                                _scheduleBotMove();
                              }
                            });
                          },
                          onReset: () {
                            setState(() {
                              gameLogic.resetGame();
                              _timerKey.currentState?.stopTimer();
                              _timerKey.currentState?.resetTimer();
                              if (widget.timeLimit > 0) {
                                _timerKey.currentState?.startTimer();
                              }
                              if (widget.isBotGame && gameLogic.currentPlayer == 2) {
                                _scheduleBotMove();
                              }
                            });
                          },
                          onEndTournament: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TournamentResultsPage(
                                  player1Name: widget.player1Name,
                                  player2Name: widget.player2Name,
                                  player1Score: gameLogic.player1Score,
                                  player2Score: gameLogic.player2Score,
                                  rounds: widget.rounds,
                                  currentRound: gameLogic.currentRound,
                                  player1Color: widget.player1Color,
                                  player2Color: widget.player2Color,
                                ),
                              ),
                            );
                          },
                          onAnalyze: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GameAnalysisPage(
                                  isTraditional: widget.isTraditional,
                                  gameLogic: gameLogic,
                                  player1Name: widget.player1Name,
                                  player2Name: widget.player2Name,
                                  player1Color: widget.player1Color,
                                  player2Color: widget.player2Color,
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