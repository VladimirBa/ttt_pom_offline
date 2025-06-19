import 'package:flutter/material.dart';
import 'online_game_setup_page.dart';
import '../widgets/neon_button.dart';

class PlayerRoleSelectionPage extends StatelessWidget {
  const PlayerRoleSelectionPage({super.key});

  void _showExitConfirmationDialog(BuildContext context) {
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
            'Are you sure you want to leave role selection?',
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
                Navigator.pop(context); // Закрыть диалог
                Navigator.pop(context); // Вернуться назад
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
                    onPressed: () => _showExitConfirmationDialog(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select Your Role',
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
                  const SizedBox(width: 48), // Для симметрии
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
                        const Text(
                          'Choose your role to start the online game',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                          height: 50,
                          child: NeonButton(
                            text: 'Host',
                            icon: Icons.create,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OnlineGameSetupPage(isHost: true),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                          height: 50,
                          child: NeonButton(
                            text: 'Guest',
                            icon: Icons.login,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OnlineGameSetupPage(isHost: false),
                                ),
                              );
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