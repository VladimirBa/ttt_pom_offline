import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformUtils {
  static double getBoardSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final availableHeight = size.height - padding.top - padding.bottom - 300;
    final availableWidth = size.width - 32;

    const minBoardSize = 300.0;
    const maxBoardSize = 500.0;

    double boardSize = availableWidth < availableHeight ? availableWidth : availableHeight;

    if (boardSize < minBoardSize) {
      boardSize = minBoardSize;
    } else if (boardSize > maxBoardSize) {
      boardSize = maxBoardSize;
    }

    return boardSize;
  }
}