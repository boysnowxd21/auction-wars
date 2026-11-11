import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';
import '../widgets/bottom_vault_banner.dart';
import '../widgets/cartoon_frame.dart';
import '../widgets/decorative_corners.dart';
import '../widgets/header_bar.dart';
import '../widgets/modals/setup_modals.dart';
import '../widgets/mode_hero_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int playerCount, AiDifficulty difficulty, String modeName) onStartGame;

  const HomeScreen({
    super.key,
    required this.onStartGame,
  });

  @override
  Widget build(BuildContext context) {
    return CartoonPictureFrame(
      child: Stack(
        children: [
          // 1. Main 16:9 Content Layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Column(
              children: [
                // 1.1 Top Header Bar
                HomeHeaderBar(
                  onLeaderboardTap: () => _openLeaderboard(context),
                  onSettingsTap: () => _openSettings(context),
                ),

                const SizedBox(height: 12),

                // 1.2 Center Mode Selection (Three Large Illustrated Hero Cards)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card 1 — ONLINE PLAY (Sky Blue Theme)
                        ModeHeroCard(
                          modeType: ModeCardType.onlinePlay,
                          onTap: () => _openOnlineModal(context),
                        ),

                        // Card 2 — LOCAL PARTY (Emerald Green Theme)
                        ModeHeroCard(
                          modeType: ModeCardType.localParty,
                          onTap: () => _openLocalPartyModal(context),
                        ),

                        // Card 3 — VS BOTS ARENA (Ruby Red Theme)
                        ModeHeroCard(
                          modeType: ModeCardType.vsBotsArena,
                          onTap: () => _openVsBotsModal(context),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 1.3 Bottom Banner: VAULT & CARD COMPENDIUM (111 CARDS)
                BottomVaultBanner(
                  onTap: () => _openCardCompendium(context),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),

          // 2. Decorative Corners (Fanned Decks top-left/right, Bidders bottom-left, Auctioneer bottom-right)
          const DecorativeCorners(),
        ],
      ),
    );
  }

  void _openOnlineModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => OnlinePlayModal(
        onStartMatch: () => onStartGame(4, AiDifficulty.medium, 'ONLINE PLAY'),
      ),
    );
  }

  void _openLocalPartyModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => LocalPartyModal(
        onStartMatch: () => onStartGame(4, AiDifficulty.medium, 'LOCAL PARTY'),
      ),
    );
  }

  void _openVsBotsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => VsBotsArenaModal(
        onStartMatch: (count, diff) => onStartGame(count, diff, 'VS BOTS ARENA'),
      ),
    );
  }

  void _openLeaderboard(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const LeaderboardModal(),
    );
  }

  void _openCardCompendium(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const CardCompendiumModal(),
    );
  }

  void _openSettings(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => WoodenPlaqueModal(
        title: 'AUDIO & GAME SETTINGS',
        width: 520,
        height: 380,
        onClose: () => Navigator.of(context).pop(),
        content: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.volume_up_rounded, color: GameColors.goldDeep, size: 30),
              title: const Text(
                'Sound & SFX',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              trailing: StatefulBuilder(
                builder: (context, setState) {
                  return Switch(
                    value: !SoundService.instance.isMuted,
                    activeThumbColor: GameColors.greenMoney,
                    onChanged: (val) {
                      setState(() {
                        SoundService.instance.toggleSound();
                      });
                    },
                  );
                },
              ),
            ),
            const Divider(color: GameColors.oakBorder, thickness: 1.5),
            const ListTile(
              leading: Icon(Icons.aspect_ratio_rounded, color: GameColors.blueOps, size: 30),
              title: Text(
                'Native Display',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              subtitle: Text(
                '1920x1080 Landscape Locked • Zero Scroll',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Divider(color: GameColors.oakBorder, thickness: 1.5),
            const Spacer(),
            const Text(
              'AUCTION WARS v1.0 • CEL-SHADED CARTOON EDITION',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
