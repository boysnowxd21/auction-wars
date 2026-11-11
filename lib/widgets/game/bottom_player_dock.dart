import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../models/player_model.dart';
import '../../theme/game_theme.dart';
import '../card_view.dart';
import '../cel_character_painter.dart';
import '../modals/card_showcase_modal.dart';

class BottomPlayerDock extends StatelessWidget {
  final PlayerModel player;
  final String liveNarrativeToast;
  final Function(AuctionCard card)? onPlayOpsCard;

  const BottomPlayerDock({
    super.key,
    required this.player,
    required this.liveNarrativeToast,
    this.onPlayOpsCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF45220F), Color(0xFF2B1408)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: GameColors.oakBorder, width: 4.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Circular Avatar Frame with YOU Badge & Dual Prominent Metric Pills
          _buildPlayerProfile(),

          const SizedBox(width: 14),

          // Center: Upright Wooden Card Tray holding hand of Special Ops Cards (max 6)
          Expanded(
            child: _buildOpsCardTray(context),
          ),

          const SizedBox(width: 14),

          // Right: Floating Comic Toast Bubble providing Live Turn Narratives
          _buildLiveToastBubble(),
        ],
      ),
    );
  }

  Widget _buildPlayerProfile() {
    return Container(
      width: 215,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1005),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GameColors.goldBright, width: 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CartoonAvatarWidget(
                avatarKey: 'you',
                radius: 28,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: GameColors.goldBright,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: GameColors.inkBorder, width: 1.5),
                    ),
                    child: const Text(
                      'YOU',
                      style: TextStyle(
                        color: GameColors.inkBorder,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Metric Pill 1: BID MONEY: $X,XXX (Bright green pill)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: GameTheme.greenMoneyPillDeco,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'BID MONEY:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${player.bidMoney}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Metric Pill 2: ITEM MONEY: +$X,XXX (Warm gold pill)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: GameTheme.goldMoneyPillDeco,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'ITEM MONEY:',
                      style: TextStyle(
                        color: GameColors.inkBorder,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '+\$${player.itemMoney}',
                    style: const TextStyle(
                      color: GameColors.inkBorder,
                      fontSize: 13,
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

  Widget _buildOpsCardTray(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF190C05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5E2E14), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.style_rounded, color: GameColors.blueOps, size: 18),
              const SizedBox(width: 6),
              Text(
                'SPECIAL OPS CARD TRAY (${player.opsHand.length} / 6)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              const Text(
                'TAP CARD TO INSPECT & ACTIVATE',
                style: TextStyle(
                  color: GameColors.goldBright,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Cards Row (Large, visible, high-impact cards with full art)
          Expanded(
            child: player.opsHand.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: player.opsHand.map((c) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: AuctionCardWidget(
                            card: c,
                            width: 125,
                            height: 148,
                            onTap: () {
                              CardShowcaseModal.show(
                                context,
                                c,
                                onPlayAction: onPlayOpsCard != null
                                    ? () => onPlayOpsCard!(c)
                                    : null,
                                playActionLabel: 'ACTIVATE SPECIAL OPS',
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const Center(
                    child: Text(
                      'No Special Ops cards in dock. Buy cards from the shop!',
                      style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveToastBubble() {
    return Container(
      width: 215,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GameColors.inkBorder, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.campaign_rounded, color: GameColors.redHazard, size: 22),
              SizedBox(width: 6),
              Text(
                'AUCTION DESK',
                style: TextStyle(
                  color: GameColors.redDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            liveNarrativeToast,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: GameColors.inkBorder,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
