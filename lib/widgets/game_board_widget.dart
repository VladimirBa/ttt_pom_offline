import 'package:flutter/material.dart';
import '../logic/game_logic.dart';
import '../utils/platform_utils.dart';
import '../utils/cross_painter.dart';
import '../utils/circle_painter.dart';

class GameBoardWidget extends StatefulWidget {
  final GameLogic gameLogic;
  final Color player1Color;
  final Color player2Color;
  final VoidCallback? onTap;
  final bool isTraditional;

  const GameBoardWidget({
    super.key,
    required this.gameLogic,
    required this.player1Color,
    required this.player2Color,
    this.onTap,
    this.isTraditional = false,
  });

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _opacityAnimation;
  bool _shouldBlink = false;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.gameLogic.winningCells.isNotEmpty) {
      _startBlinking();
    }
  }

  void _startBlinking() {
    if (!_shouldBlink) {
      _shouldBlink = true;
      _blinkController.repeat(reverse: true);
    }
  }

  void _stopBlinking() {
    if (_shouldBlink) {
      _shouldBlink = false;
      _blinkController.stop();
    }
  }

  @override
  void didUpdateWidget(covariant GameBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gameLogic.winningCells.isNotEmpty &&
        widget.gameLogic.gameOverNotifier.value) {
      _startBlinking();
    } else {
      _stopBlinking();
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  Widget _buildCell(int row, int col) {
    bool isWinningCell = widget.gameLogic.winningCells.contains(
        row * widget.gameLogic.gridSize + col);
    int cellValue = widget.gameLogic.board[row][col];

    return GestureDetector(
      onTap: () => widget.gameLogic.handleTap(row, col, widget.onTap ?? () {}),
      child: AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Opacity(
            opacity: isWinningCell && _shouldBlink
                ? _opacityAnimation.value
                : 1.0,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: widget.isTraditional
                ? BorderRadius.zero // Прямые углы для традиционного режима
                : BorderRadius.circular(8.0), // Закругления для цветного
            border: Border.all(
              color: isWinningCell ? Colors.yellow : Colors.black,
              width: isWinningCell ? 2.0 : 1.0,
            ),
            boxShadow: widget.isTraditional
                ? null // Без теней в традиционном режиме
                : [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 1.0,
                spreadRadius: 0.5,
                offset: const Offset(0.5, 0.5),
              ),
            ],
          ),
          child: Center(
            child: widget.isTraditional
                ? (cellValue == 1
                ? CustomPaint(
              painter: CrossPainter(),
              size: const Size(20, 20),
            )
                : cellValue == 2
                ? CustomPaint(
              painter: CirclePainter(),
              size: const Size(20, 20),
            )
                : null)
                : (cellValue == 0
                ? null
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
                    BoxShadow(
                      color: const Color.fromRGBO(255, 255, 255, 0.5),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: const Offset(-2.0, -2.0),
                    ),
                  ],
                ),
                child: Center(
                  child: isWinningCell
                      ? Icon(
                    Icons.star,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                    size: 20.0,
                  )
                      : null,
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;
        double boardSize = PlatformUtils.getBoardSize(context);
        boardSize = boardSize
            .clamp(0, maxWidth)
            .toDouble()
            .clamp(0, maxHeight)
            .toDouble();

        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: ValueListenableBuilder<bool>(
              valueListenable: widget.gameLogic.gameOverNotifier,
              builder: (context, gameOver, child) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.gameLogic.gridSize,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: widget.gameLogic.gridSize * widget.gameLogic.gridSize,
                  itemBuilder: (context, index) {
                    int row = index ~/ widget.gameLogic.gridSize;
                    int col = index % widget.gameLogic.gridSize;
                    return _buildCell(row, col);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}