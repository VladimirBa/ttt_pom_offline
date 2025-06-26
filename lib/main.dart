import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/game_mode_selection_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const TTTPomApp());
  });
}

class TTTPomApp extends StatelessWidget {
  const TTTPomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTT Pom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shadowColor: Colors.blueAccent,
            elevation: 5,
          ),
        ),
      ),
      initialRoute: '/gameModeSelection',
      routes: {
        '/gameModeSelection': (context) => const GameModeSelectionPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}