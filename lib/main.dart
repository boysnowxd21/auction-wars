import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/player_model.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Strict Landscape Mode Specification Mandate
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const AuctionWarsApp());
}

class AuctionWarsApp extends StatelessWidget {
  const AuctionWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auction Wars',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF150A05),
      ),
      home: const LandscapeViewportContainer(),
    );
  }
}

/// Locks viewport to 16:9 aspect ratio at native 1920x1080 with strictly ZERO horizontal or vertical scrolling.
class LandscapeViewportContainer extends StatefulWidget {
  const LandscapeViewportContainer({super.key});

  @override
  State<LandscapeViewportContainer> createState() =>
      _LandscapeViewportContainerState();
}

class _LandscapeViewportContainerState extends State<LandscapeViewportContainer> {
  bool _isInGame = false;
  int _playerCount = 4;
  AiDifficulty _difficulty = AiDifficulty.medium;
  String _modeName = 'VS BOTS ARENA';

  void _startGame(int playerCount, AiDifficulty difficulty, String modeName) {
    setState(() {
      _playerCount = playerCount;
      _difficulty = difficulty;
      _modeName = modeName;
      _isInGame = true;
    });
  }

  void _exitToMenu() {
    setState(() {
      _isInGame = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF190C05),
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: 1920,
            height: 1080,
            child: _isInGame
                ? GameScreen(
                    playerCount: _playerCount,
                    difficulty: _difficulty,
                    gameMode: _modeName,
                    onExitToMenu: _exitToMenu,
                  )
                : HomeScreen(
                    onStartGame: _startGame,
                  ),
          ),
        ),
      ),
    );
  }
}
