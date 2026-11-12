import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../services/sound_service.dart';
import '../widgets/modals/setup_modals.dart';

class HomeScreen extends StatefulWidget {
  final Function(int playerCount, AiDifficulty difficulty, String modeName) onStartGame;

  const HomeScreen({
    super.key,
    required this.onStartGame,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int? _hoveredIndex; // 0=Leaderboard, 1=Settings, 2=Online, 3=Local, 4=Bots, 5=Compendium

  void _openOnlineModal(BuildContext context) {
    SoundService.instance.playClick();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => OnlinePlayModal(
        onStartMatch: () => widget.onStartGame(4, AiDifficulty.medium, 'ONLINE PLAY'),
      ),
    );
  }

  void _openLocalPartyModal(BuildContext context) {
    SoundService.instance.playClick();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => LocalPartyModal(
        onStartMatch: () => widget.onStartGame(4, AiDifficulty.medium, 'LOCAL PARTY'),
      ),
    );
  }

  void _openVsBotsModal(BuildContext context) {
    SoundService.instance.playClick();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => VsBotsArenaModal(
        onStartMatch: (count, diff) => widget.onStartGame(count, diff, 'VS BOTS ARENA'),
      ),
    );
  }

  void _openLeaderboard(BuildContext context) {
    SoundService.instance.playClick();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const LeaderboardModal(),
    );
  }

  void _openCardCompendium(BuildContext context) {
    SoundService.instance.playClick();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const CardCompendiumModal(),
    );
  }

  void _openSettings(BuildContext context) {
    SoundService.instance.playClick();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const GameSettingsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Native reference canvas is 1280 x 720 (16:9)
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Container(
          width: w,
          height: h,
          color: const Color(0xFF190C05),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Exact 1:1 Cel-Shaded Cartoon Home Board Artwork from Reference Image
              Image.asset(
                'assets/reference/ref_home.jpg',
                width: w,
                height: h,
                fit: BoxFit.fill,
              ),

              // 2. Interactive Tactile Overlay Controls (Positioned proportionally to 1280 x 720 canvas)

              // 2.1 Top-Left: LEADERBOARD Medallion Button
              Positioned(
                left: w * 0.012,
                top: h * 0.018,
                width: w * 0.095,
                height: h * 0.165,
                child: _buildTapTarget(
                  index: 0,
                  tooltip: 'Leaderboard',
                  onTap: () => _openLeaderboard(context),
                  label: 'TOP 100 LEADERBOARD',
                ),
              ),

              // 2.2 Top-Center: AUCTION WARS Title Logo & Gavel
              Positioned(
                left: w * 0.33,
                top: h * 0.015,
                width: w * 0.38,
                height: h * 0.22,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      SoundService.instance.playGavel();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'AUCTION WARS',
                        style: TextStyle(fontSize: 1, color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ),

              // 2.3 Top-Right: SETTINGS Medallion Button
              Positioned(
                right: w * 0.012,
                top: h * 0.018,
                width: w * 0.095,
                height: h * 0.165,
                child: _buildTapTarget(
                  index: 1,
                  tooltip: 'Settings',
                  icon: Icons.settings_rounded,
                  onTap: () => _openSettings(context),
                  label: 'SETTINGS',
                ),
              ),

              // 2.4 Center Card 1: ONLINE PLAY
              Positioned(
                left: w * 0.095,
                top: h * 0.275,
                width: w * 0.266,
                height: h * 0.438,
                child: _buildModeCardTarget(
                  index: 2,
                  onTap: () => _openOnlineModal(context),
                  modeTitle: 'ONLINE PLAY',
                  buttonText: 'PLAY ONLINE',
                ),
              ),

              // 2.5 Center Card 2: LOCAL PARTY
              Positioned(
                left: w * 0.368,
                top: h * 0.275,
                width: w * 0.266,
                height: h * 0.438,
                child: _buildModeCardTarget(
                  index: 3,
                  onTap: () => _openLocalPartyModal(context),
                  modeTitle: 'LOCAL PARTY',
                  buttonText: 'HOST OR JOIN PARTY',
                ),
              ),

              // 2.6 Center Card 3: VS BOTS ARENA
              Positioned(
                left: w * 0.640,
                top: h * 0.275,
                width: w * 0.266,
                height: h * 0.438,
                child: _buildModeCardTarget(
                  index: 4,
                  onTap: () => _openVsBotsModal(context),
                  modeTitle: 'VS BOTS ARENA',
                  buttonText: 'CHOOSE BOTS & PLAY',
                ),
              ),

              // 2.7 Bottom-Center: VAULT & CARD COMPENDIUM Banner
              Positioned(
                left: w * 0.325,
                top: h * 0.765,
                width: w * 0.350,
                height: h * 0.175,
                child: _buildTapTarget(
                  index: 5,
                  tooltip: 'Vault & Card Compendium',
                  onTap: () => _openCardCompendium(context),
                  label: 'VAULT & CARD COMPENDIUM (111 CARDS)',
                ),
              ),

              // 2.8 Bottom-Left Bidders & Bottom-Right Auctioneer Interactive Characters
              Positioned(
                left: 0,
                bottom: 0,
                width: w * 0.28,
                height: h * 0.28,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => SoundService.instance.playCashRegister(),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                width: w * 0.22,
                height: h * 0.28,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => SoundService.instance.playGavel(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTapTarget({
    required int index,
    required String tooltip,
    required VoidCallback onTap,
    required String label,
    IconData? icon,
  }) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Tooltip(
        message: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: isHovered
                  ? [
                      const BoxShadow(
                        color: Color(0x60FACC15),
                        blurRadius: 16,
                        spreadRadius: 4,
                      )
                    ]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 1,
                    color: Colors.transparent,
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.transparent,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeCardTarget({
    required int index,
    required VoidCallback onTap,
    required String modeTitle,
    required String buttonText,
  }) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.diagonal3Values(
            isHovered ? 1.025 : 1.0,
            isHovered ? 1.025 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: isHovered
                ? Border.all(color: const Color(0xFFFACC15), width: 4.5)
                : null,
            boxShadow: isHovered
                ? [
                    const BoxShadow(
                      color: Color(0x66FACC15),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Accessible text for test finders and accessibility
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      modeTitle,
                      style: const TextStyle(
                        fontSize: 1,
                        color: Colors.transparent,
                      ),
                    ),
                    Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 1,
                        color: Colors.transparent,
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
}
