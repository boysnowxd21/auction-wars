import 'package:flutter/material.dart';
import '../../models/player_model.dart';
import '../../theme/game_theme.dart';
import '../cel_character_painter.dart';

class OpponentSeatWidget extends StatelessWidget {
  final PlayerModel player;
  final bool isCurrentTurn;

  const OpponentSeatWidget({
    super.key,
    required this.player,
    this.isCurrentTurn = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 195,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentTurn ? const Color(0x33FDE047) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isCurrentTurn
            ? Border.all(color: GameColors.goldBright, width: 2.5)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech Bubble (If Any)
          if (player.speechBubble != null)
            _buildSpeechBubble(player.speechBubble!)
          else
            const SizedBox(height: 32),

          const SizedBox(height: 4),

          // Cheerful Cartoon Avatar with Hammer Gavel badge
          CartoonAvatarWidget(
            avatarKey: player.avatarKey,
            radius: 34,
            hasGavel: player.hasHammer,
          ),

          const SizedBox(height: 6),

          // Wooden Nameplate
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: GameColors.oakDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: GameColors.oakBorder, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  player.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                if (player.isFolded) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: GameColors.redHazard,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'FOLD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Dual Money Badges: Green Pill (Bid Money) & Gold Pill (Item Money)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green Pill: Bid Money
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: GameTheme.greenMoneyPillDeco,
                  child: Text(
                    '\$${player.bidMoney}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: GameColors.inkBorder, offset: Offset(1, 1)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // Gold Pill: Item Money
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: GameTheme.goldMoneyPillDeco,
                  child: Text(
                    '+\$${player.itemMoney}',
                    style: const TextStyle(
                      color: GameColors.inkBorder,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble(String text) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 185),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GameColors.inkBorder, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: GameColors.inkBorder,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
