import 'package:flutter/material.dart';
import 'player_setup_page.dart';
import '../widgets/neon_button.dart';

class GameModeSelectionPage extends StatelessWidget {
  const GameModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth < 400 ? 36 : 48;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey, // Как в GameHeaderWidget
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок
                Text(
                  'Tic Tactic Toe',
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
                const SizedBox(height: 40),
                // Контейнер для кнопок
                Container(
                  padding: const EdgeInsets.all(16),
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
                    children: [
                      _buildMenuButton(
                        context: context,
                        label: 'Play with Friend',
                        icon: Icons.group,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PlayerSetupPage(isBotGame: false)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuButton(
                        context: context,
                        label: 'Play with Bot',
                        icon: Icons.smart_toy,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PlayerSetupPage(isBotGame: true)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuButton(
                        context: context,
                        label: 'Play Online (Soon)',
                        icon: Icons.cloud,
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Online mode coming soon!')),
                        ),
                        isDisabled: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isDisabled = false,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.7;
    if (buttonWidth < 300) buttonWidth = 300;

    return SizedBox(
      width: buttonWidth,
      height: 50,
      child: NeonButton(
        text: label,
        icon: icon,
        onPressed: onPressed,
        isDisabled: isDisabled,
      ),
    );
  }
}