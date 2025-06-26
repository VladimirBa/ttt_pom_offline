import 'package:flutter/material.dart';
import 'game_setup_page.dart';
import 'bot_game_setup_page.dart';
import '../widgets/neon_button.dart';

class PlayerSetupPage extends StatefulWidget {
  final bool isBotGame;
  const PlayerSetupPage({super.key, required this.isBotGame});

  @override
  State<PlayerSetupPage> createState() => _PlayerSetupPageState();
}

class _PlayerSetupPageState extends State<PlayerSetupPage> {
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  int botDifficulty = 1;
  String? _errorMessage;
  bool _showError = false;
  final int _maxLength = 12; // Добавляем константу для максимальной длины

  @override
  void initState() {
    super.initState();
    // Слушатели для обновления состояния при изменении текста
    _player1Controller.addListener(() {
      setState(() {});
      _updateErrorState();
    });
    _player2Controller.addListener(() {
      setState(() {});
      _updateErrorState();
    });
  }

  void _updateErrorState() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
        _showError = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _showError = true;
    });
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
                    widget.isBotGame ? 'Setup Bot Game' : 'Setup Players',
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
                    TextField(
                      controller: _player1Controller,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                            children: const [
                              TextSpan(
                                text: 'Player 1 Name ',
                              ),
                              TextSpan(
                                text: '(Default: Turn first, ',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),

                              ),
                              TextSpan(
                                text: 'Red',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              TextSpan(
                                text: ', X)',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
                              ),
                            ],
                          ),
                        ),
                        hintText: 'Enter Player 1 Name',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: const OutlineInputBorder(),
                        helperText: '${_player1Controller.text.length}/$_maxLength',
                        helperStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        counterText: '', // Убираем счётчик справа ниже
                      ),
                      maxLength: _maxLength,
                      style: TextStyle(
                        fontSize: _player1Controller.text.length == _maxLength ? 14 : 16,
                        fontFamily: 'Roboto',
                      ),
                      onChanged: (value) {
                        setState(() {}); // Обновляем UI при изменении текста
                      },
                    ),
                    const SizedBox(height: 10),
                    if (!widget.isBotGame)
                      TextField(
                        controller: _player2Controller,
                        decoration: InputDecoration(
                          label: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                              children: const [
                                TextSpan(
                                  text: 'Player 2 Name ',
                                ),
                                TextSpan(
                                  text: '(Default: Turn next, ',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
                                ),
                                TextSpan(
                                  text: 'Blue',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ', O)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
                                ),
                              ],
                            ),
                          ),
                          hintText: 'Enter Player 2 Name',
                          hintStyle: const TextStyle(fontSize: 14),
                          border: const OutlineInputBorder(),
                          helperText: '${_player2Controller.text.length}/$_maxLength',
                          helperStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          counterText: '', // Убираем счётчик справа ниже
                        ),
                        maxLength: _maxLength,
                        style: TextStyle(
                          fontSize: _player2Controller.text.length == _maxLength ? 14 : 16,
                          fontFamily: 'Roboto',
                        ),
                        onChanged: (value) {
                          setState(() {}); // Обновляем UI при изменении текста
                        },
                      ),
                    if (widget.isBotGame)
                      DropdownButton<int>(
                        value: botDifficulty,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Easy')),
                          DropdownMenuItem(value: 2, child: Text('Medium')),
                          DropdownMenuItem(value: 3, child: Text('Hard')),
                        ],
                        onChanged: (value) => setState(() => botDifficulty = value!),
                      ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _showError ? 40 : 0,
                      child: _showError
                          ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage ?? '',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                      height: 50,
                      child: NeonButton(
                        text: 'Next',
                        icon: Icons.arrow_forward,
                        onPressed: () {
                          String player1Name = _player1Controller.text.trim();
                          String player2Name = _player2Controller.text.trim();

                          if (player1Name.isEmpty || (!widget.isBotGame && player2Name.isEmpty)) {
                            _showErrorMessage('Enter valid names');
                            return;
                          }

                          if (!widget.isBotGame && player1Name == player2Name) {
                            _showErrorMessage('Names must be unique');
                            return;
                          }

                          if (widget.isBotGame && player1Name.toLowerCase() == 'bot') {
                            _showErrorMessage('Name "Bot" is reserved for the bot');
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => widget.isBotGame
                                  ? BotGameSetupPage(
                                playerName: player1Name,
                                botDifficulty: botDifficulty,
                              )
                                  : GameSetupPage(
                                player1Name: player1Name,
                                player2Name: player2Name,
                                isBotGame: false,
                                botDifficulty: 0,
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

  @override
  void dispose() {
    _player1Controller.removeListener(() {
      setState(() {});
      _updateErrorState();
    });
    _player2Controller.removeListener(() {
      setState(() {});
      _updateErrorState();
    });
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }
}