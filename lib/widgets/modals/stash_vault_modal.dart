import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../models/player_model.dart';
import '../../services/sound_service.dart';
import '../../theme/game_theme.dart';
import '../card_view.dart';
import '../tactile_button.dart';
import 'card_showcase_modal.dart';

/// Full-Screen Modal to view, browse, and liquidate all won cards in the player's stash vault
class StashVaultModal extends StatefulWidget {
  final PlayerModel player;
  final Function(AuctionCard card)? onPawnCard;

  const StashVaultModal({
    super.key,
    required this.player,
    this.onPawnCard,
  });

  static Future<void> show(
    BuildContext context, {
    required PlayerModel player,
    Function(AuctionCard card)? onPawnCard,
  }) {
    SoundService.instance.playClick();
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => StashVaultModal(
        player: player,
        onPawnCard: onPawnCard,
      ),
    );
  }

  @override
  State<StashVaultModal> createState() => _StashVaultModalState();
}

class _StashVaultModalState extends State<StashVaultModal> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogW = min(920.0, screenSize.width * 0.94);
    final dialogH = min(560.0, screenSize.height * 0.92);

    final stash = widget.player.stash;
    final positiveItems = stash.where((c) => c.isPositive).toList();
    final junkItems = stash.where((c) => c.isJunk).toList();
    final totalFaceValue = stash.fold(0, (sum, c) => sum + c.value);
    final totalPawnAvailable = positiveItems.fold(0, (sum, c) => sum + c.pawnValue);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(
        child: Container(
          width: dialogW,
          height: dialogH,
          decoration: BoxDecoration(
            color: GameColors.oakDark,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: GameColors.oakBorder, width: 6),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 36,
                offset: Offset(0, 16),
              ),
              BoxShadow(
                color: Color(0x66F59E0B),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment(0.0, -0.4),
                  radius: 1.1,
                  colors: [
                    Color(0xFFFFFDF5),
                    Color(0xFFF7EED6),
                    Color(0xFFE4D2A9),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: GameColors.oakBorder, width: 3.5),
              ),
              child: Column(
                children: [
                  // 1. Header Bar
                  Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF78350F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      border: Border(
                        bottom: BorderSide(color: GameColors.oakBorder, width: 3.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_rounded, color: GameColors.goldBright, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'MY WON ITEMS & STASH VAULT (${stash.length} ITEMS)',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(color: Colors.black, offset: Offset(2, 2)),
                              ],
                            ),
                          ),
                        ),
                        TactileButton(
                          onTap: () {
                            SoundService.instance.playClick();
                            Navigator.of(context).pop();
                          },
                          baseColor: GameColors.redHazard,
                          shadowColor: GameColors.redDark,
                          height: 42,
                          width: 42,
                          borderRadius: 12,
                          padding: EdgeInsets.zero,
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  ),

                  // 2. Financial Metrics Bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1005),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: GameColors.goldOrange, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          'TOTAL STASH WORTH',
                          totalFaceValue >= 0 ? '+\$$totalFaceValue' : '-\$${totalFaceValue.abs()}',
                          totalFaceValue >= 0 ? GameColors.goldBright : GameColors.redHazard,
                          Icons.account_balance_rounded,
                        ),
                        Container(width: 1.5, height: 32, color: Colors.white24),
                        _buildSummaryItem(
                          'ASSETS WON',
                          '${positiveItems.length} Lots',
                          GameColors.greenMoney,
                          Icons.stars_rounded,
                        ),
                        Container(width: 1.5, height: 32, color: Colors.white24),
                        _buildSummaryItem(
                          'JUNK / HAZARDS',
                          '${junkItems.length} Items',
                          junkItems.isEmpty ? Colors.white70 : GameColors.redHazard,
                          Icons.warning_amber_rounded,
                        ),
                        Container(width: 1.5, height: 32, color: Colors.white24),
                        _buildSummaryItem(
                          'PAWN VALUE (50% CASH)',
                          '+\$$totalPawnAvailable',
                          const Color(0xFF38BDF8),
                          Icons.paid_rounded,
                        ),
                      ],
                    ),
                  ),

                  // 3. Stash Cards Gallery / Empty State
                  Expanded(
                    child: stash.isEmpty
                        ? _buildEmptyState()
                        : _buildCardGrid(context, stash),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color valueColor, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: valueColor, size: 22),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0x33B45309),
              shape: BoxShape.circle,
              border: Border.all(color: GameColors.goldOrange, width: 3),
            ),
            child: const Icon(Icons.lock_open_rounded, size: 54, color: GameColors.goldBright),
          ),
          const SizedBox(height: 12),
          const Text(
            'YOUR VAULT IS CURRENTLY EMPTY',
            style: TextStyle(
              color: GameColors.oakDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Win mystery crate lots at the felt auction table to inspect, collect, and pawn valuable rare assets for huge liquid profits!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF78350F),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardGrid(BuildContext context, List<AuctionCard> stash) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 175,
          childAspectRatio: 0.58,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: stash.length,
        itemBuilder: (context, index) {
          final card = stash[index];
          return _buildStashCardTile(context, card);
        },
      ),
    );
  }

  Widget _buildStashCardTile(BuildContext context, AuctionCard card) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E1508),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: card.isPositive ? GameColors.goldBright : GameColors.redHazard,
          width: 2.2,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          // Card Thumbnail (Tappable to showcase)
          Expanded(
            child: GestureDetector(
              onTap: () {
                CardShowcaseModal.show(
                  context,
                  card,
                  onPawnAction: card.isPositive && widget.onPawnCard != null
                      ? () {
                          widget.onPawnCard!(card);
                          setState(() {});
                        }
                      : null,
                );
              },
              child: AuctionCardWidget(
                card: card,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Valuation Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: card.isPositive ? GameColors.greenDark : GameColors.redDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              card.isPositive ? 'VALUE: +\$${card.value}' : 'JUNK: -\$${card.value.abs()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Pawn / Action Button
          if (card.isPositive)
            TactileButton(
              onTap: widget.onPawnCard != null
                  ? () {
                      widget.onPawnCard!(card);
                      setState(() {});
                    }
                  : null,
              baseColor: GameColors.greenMoney,
              shadowColor: GameColors.greenDark,
              height: 36,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'PAWN +\$${card.pawnValue}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'CANNOT PAWN',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
