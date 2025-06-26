import 'dart:async';
import 'package:flutter/material.dart';
import '../logic/game_logic.dart';

part 'timer_widget_state.dart';

// TimerWidget отвечает за отображение таймера и передачу управления состоянием в TimerWidgetState.
class TimerWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback onTimeUp;
  final GameLogic gameLogic;

  const TimerWidget({
    super.key,
    required this.seconds,
    required this.onTimeUp,
    required this.gameLogic,
  });

  @override
  TimerWidgetState createState() => TimerWidgetState();
}