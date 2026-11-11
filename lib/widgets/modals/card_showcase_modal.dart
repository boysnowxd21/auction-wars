import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../services/sound_service.dart';
import '../../theme/game_theme.dart';
import '../card_view.dart';
import '../tactile_button.dart';

/// Full-Screen Detailed Card Showcase & Appraisal Modal
class CardShowcaseModal extends StatelessWidget {
  final AuctionCard card;
  final VoidCallback? onPlayAction;
  final VoidCallback? onPawnAction;
  final String? playActionLabel;

  const CardShowcaseModal({
    super.key,
    required this.card,
    this.onPlayAction,
    this.onPawnAction,
    this.playActionLabel,
  });

  static Future<void> show(
    BuildContext context,
    AuctionCard card, {
    VoidCallback? onPlayAction,
    VoidCallback? onPawnAction,
    String? playActionLabel,
  }) {
    SoundService.instance.playClick();
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => CardShowcaseModal(
        card: card,
        onPlayAction: onPlayAction,
        onPawnAction: onPawnAction,
        playActionLabel: playActionLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final modalWidth = (screenSize.width * 0.92).clamp(600.0, 960.0);
    final modalHeight = (screenSize.height * 0.88).clamp(420.0, 560.0);

    Color themeColor;
    String typeLabel;
    IconData typeIcon;

    switch (card.cardType) {
      case CardType.positive:
        themeColor = GameColors.greenMoney;
        typeLabel = 'VALUABLE POSITIVE ASSET';
        typeIcon = Icons.stars_rounded;
        break;
      case CardType.junk:
        themeColor = GameColors.redHazard;
        typeLabel = 'JUNK / HAZARD LIABILITY';
        typeIcon = Icons.warning_amber_rounded;
        break;
      case CardType.specialOps:
        themeColor = GameColors.blueOps;
        typeLabel = 'TACTICAL SPECIAL OPS';
        typeIcon = Icons.bolt_rounded;
        break;
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: modalWidth,
          height: modalHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF381A0B), Color(0xFF1E0E05)],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: GameColors.goldBright, width: 4.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0xDD000000),
                blurRadius: 36,
                offset: Offset(0, 12),
              ),
              BoxShadow(
                color: Color(0x55F59E0B),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Stack(
              children: [
                // Inner Decorative Border
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: GameColors.goldOrange.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  child: Column(
                    children: [
                      // Top Header Bar
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(typeIcon, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.name.toUpperCase(),
                                style: const TextStyle(
                                  color: GameColors.goldBright,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(color: Colors.black, offset: Offset(2, 2)),
                                  ],
                                ),
                              ),
                              Text(
                                '$typeLabel • ${card.tag}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Close X Button
                          TactileButton(
                            onTap: () {
                              SoundService.instance.playClick();
                              Navigator.of(context).pop();
                            },
                            baseColor: GameColors.redHazard,
                            shadowColor: GameColors.redDark,
                            height: 38,
                            width: 38,
                            borderRadius: 12,
                            padding: EdgeInsets.zero,
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Two-Column Showcase Area
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Left: Big Card View
                            Container(
                              width: 250,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white12, width: 2),
                              ),
                              child: AuctionCardWidget(
                                card: card,
                                width: 220,
                                height: 320,
                                isSelected: true,
                              ),
                            ),

                            const SizedBox(width: 18),

                            // Right: Dossier Stats & Lore Details
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDFBF7),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: GameColors.inkBorder, width: 3),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 1. Valuation & Financial Badges
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: [
                                          if (card.isPositive) ...[
                                            _buildMetricBadge(
                                              'FACE VALUATION',
                                              '+\$${card.value}',
                                              GameColors.greenMoney,
                                              GameColors.greenDark,
                                              Icons.monetization_on_rounded,
                                            ),
                                            _buildMetricBadge(
                                              '50% PAWN PAYOUT',
                                              '+\$${card.pawnValue}',
                                              const Color(0xFF0284C7),
                                              const Color(0xFF0369A1),
                                              Icons.account_balance_wallet_rounded,
                                            ),
                                          ] else if (card.isJunk) ...[
                                            _buildMetricBadge(
                                              'DISPOSAL PENALTY',
                                              '-\$${card.value.abs()}',
                                              GameColors.redHazard,
                                              GameColors.redDark,
                                              Icons.delete_sweep_rounded,
                                            ),
                                            _buildMetricBadge(
                                              'PAWN VALUE',
                                              '\$0 (SCRAP)',
                                              Colors.grey.shade600,
                                              Colors.grey.shade800,
                                              Icons.do_not_disturb_on_rounded,
                                            ),
                                          ] else ...[
                                            _buildMetricBadge(
                                              'TRIGGER WINDOW',
                                              card.actionWindow,
                                              GameColors.blueOps,
                                              GameColors.blueDark,
                                              Icons.timer_rounded,
                                            ),
                                            _buildMetricBadge(
                                              'SHOP PRICE',
                                              '\$300 BID CASH',
                                              GameColors.goldOrange,
                                              GameColors.brassShadow,
                                              Icons.shopping_cart_rounded,
                                            ),
                                          ],
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                      // 2. Full Description Box
                                      const Text(
                                        'SPECIAL RULES & APPRAISAL',
                                        style: TextStyle(
                                          color: GameColors.oakDark,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: GameColors.goldOrange, width: 2),
                                        ),
                                        child: Text(
                                          card.description,
                                          style: const TextStyle(
                                            color: Color(0xFF451A03),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      // 3. Strategic Synergy & Tactical Combo
                                      const Text(
                                        'AUCTION WAR TACTICS',
                                        style: TextStyle(
                                          color: GameColors.oakDark,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: GameColors.inkBorder, width: 1.5),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.lightbulb_rounded, color: GameColors.goldBright, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                card.isSpecialOps
                                                    ? 'Play during ${card.actionWindow} to disrupt opponent bidding strategies or reveal sealed contents!'
                                                    : card.isPositive
                                                        ? 'Keep in vault for highest match net worth, or pawn at the side shop for immediate +50% bid cash if loans run dry.'
                                                        : 'Watch out! Junk assets cost you money if won. Use Special Ops or fold early when crate hint tags look suspicious.',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // 4. Action Buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if (onPlayAction != null) ...[
                                            TactileButton(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                onPlayAction!();
                                              },
                                              baseColor: GameColors.blueOps,
                                              shadowColor: GameColors.blueDark,
                                              height: 44,
                                              padding: const EdgeInsets.symmetric(horizontal: 18),
                                              child: Text(
                                                playActionLabel ?? 'PLAY THIS CARD',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                          if (onPawnAction != null) ...[
                                            TactileButton(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                onPawnAction!();
                                              },
                                              baseColor: GameColors.greenMoney,
                                              shadowColor: GameColors.greenDark,
                                              height: 44,
                                              padding: const EdgeInsets.symmetric(horizontal: 18),
                                              child: Text(
                                                'PAWN FOR +\$${card.pawnValue}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                          TactileButton(
                                            onTap: () => Navigator.of(context).pop(),
                                            baseColor: GameColors.goldBright,
                                            shadowColor: GameColors.brassShadow,
                                            height: 44,
                                            padding: const EdgeInsets.symmetric(horizontal: 22),
                                            child: const Text(
                                              'CLOSE SHOWCASE',
                                              style: TextStyle(
                                                color: GameColors.inkBorder,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildMetricBadge(String title, String value, Color bg, Color border, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 3),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
