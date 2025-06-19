import 'package:flutter/material.dart';
import 'game_setup_page.dart';
import '../widgets/neon_button.dart';

class OnlineGameRoomPage extends StatelessWidget {
  final String playerName;
  final String roomId;
  final bool isHost;
  final String hostName;
  final String? guestName; // Может быть null, если гость ещё не подключился

  const OnlineGameRoomPage({
    super.key,
    required this.playerName,
    required this.roomId,
    required this.isHost,
    required this.hostName,
    this.guestName,
  });

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
            colors: [Colors.grey, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Online Game Room',
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
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: Container(
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
                        Text(
                          'Room ID: $roomId',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Host: $hostName',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Guest: ${guestName ?? 'Waiting for player...'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your role: ${isHost ? 'Host' : 'Guest'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: screenWidth * 0.4 < 300 ? 300 : screenWidth * 0.4, // Исправлено screenWidth * 4 на screenWidth * 0.4
                          height: 50,
                          child: NeonButton(
                            text: 'Next',
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              if (guestName != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GameSetupPage(
                                      player1Name: hostName,
                                      player2Name: guestName!,
                                      isBotGame: false,
                                      botDifficulty: 0,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
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