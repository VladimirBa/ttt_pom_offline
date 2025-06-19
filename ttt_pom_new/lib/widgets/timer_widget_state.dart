part of 'timer_widget.dart';

class TimerWidgetState extends State<TimerWidget> {
  late ValueNotifier<int> remainingSeconds;
  bool _isRunning = false;
  StreamSubscription<int>? _timerSubscription;

  @override
  void initState() {
    super.initState();
    remainingSeconds = ValueNotifier<int>(widget.seconds);
    widget.gameLogic.gameOverNotifier.addListener(_handleGameOver);
    
  }

  void _handleGameOver() {
    if (widget.gameLogic.gameOver && _isRunning) {
      stopTimer();
      
    }
  }

  void startTimer() {
    if (!widget.gameLogic.gameOver && widget.seconds > 0) {
      widget.gameLogic.startPlayerTimer();
      _isRunning = true;
      widget.gameLogic.canMove = true;
      _timerSubscription?.cancel();

      _timerSubscription = Stream.periodic(const Duration(seconds: 1), (x) => widget.seconds - x - 1)
          .take(widget.seconds + 1)
          .listen((data) {
        if (mounted) {
          remainingSeconds.value = data >= 0 ? data : 0;
          
          if (remainingSeconds.value <= 0) {
            _isRunning = false;
            widget.gameLogic.canMove = false;
            _timerSubscription?.cancel();
            widget.onTimeUp();
            
          }
        }
      });
    }
  }

  void resetTimer() {
    widget.gameLogic.stopPlayerTimer();
    _timerSubscription?.cancel();
    remainingSeconds.value = widget.seconds;
    _isRunning = false;
    widget.gameLogic.canMove = true;
    
  }

  void stopTimer() {
    widget.gameLogic.stopPlayerTimer();
    _timerSubscription?.cancel();
    _isRunning = false;
    widget.gameLogic.canMove = false;
    
  }

  bool isRunning() => _isRunning;

  @override
  void dispose() {
    widget.gameLogic.gameOverNotifier.removeListener(_handleGameOver);
    widget.gameLogic.stopPlayerTimer();
    _timerSubscription?.cancel();
    remainingSeconds.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}