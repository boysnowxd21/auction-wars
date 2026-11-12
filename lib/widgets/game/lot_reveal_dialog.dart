import 'package:flutter/material.dart';
import '../../models/crate_lot.dart';
import '../../models/player_model.dart';
import '../../services/sound_service.dart';
import '../../theme/game_theme.dart';
import '../card_view.dart';
import '../tactile_button.dart';
import '../modals/card_showcase_modal.dart';

class LotRevealDialog extends StatelessWidget {
  final CrateLot lot;
  final PlayerModel winner;
  final int winningBid;
  final VoidCallback onNextRound;

  const LotRevealDialog({
    super.key,
    required this.lot,
    required this.winner,
    required this.winningBid,
    required this.onNextRound,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogW = screenSize.width * 0.92;
    final dialogH = screenSize.height * 0.90;

    final allWonCards = lot.crates.expand((c) => c.cards).toList();
    final totalValuation = lot.totalLotValue;
    final netProfit = totalValuation - winningBid;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: Container(
          width: dialogW.clamp(560.0, 840.0),
          height: dialogH.clamp(360.0, 540.0),
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
            ],
          ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
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
                // Header
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: GameColors.oakMedium,
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
                      const Icon(Icons.stars_rounded, color: GameColors.goldBright, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'LOT #${lot.round} UNPACK CEREMONY!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: winner.isUser ? GameColors.greenMoney : GameColors.redHazard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          'WON BY ${winner.name.toUpperCase()} FOR \$$winningBid',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Valuation Summary Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMetric('LOT VALUE', '\$$totalValuation', GameColors.goldOrange),
                      const SizedBox(width: 20),
                      _buildMetric('HAMMER PRICE', '-\$$winningBid', Colors.blueGrey),
                      const SizedBox(width: 20),
                      _buildMetric(
                        'NET PROFIT',
                        netProfit >= 0 ? '+\$$netProfit' : '-\$${netProfit.abs()}',
                        netProfit >= 0 ? GameColors.greenMoney : GameColors.redHazard,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Cards Revealed inside crates
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: allWonCards.map((c) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: AuctionCardWidget(
                                card: c,
                                width: 145,
                                height: 195,
                                onTap: () => CardShowcaseModal.show(context, c),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Next Round Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TactileButton(
                    onTap: () {
                      SoundService.instance.playGavel();
                      Navigator.of(context).pop();
                      onNextRound();
                    },
                    baseColor: GameColors.greenMoney,
                    shadowColor: GameColors.greenDark,
                    height: 52,
                    borderRadius: 18,
                    width: double.infinity,
                    child: const Text(
                      'PROCEED TO NEXT LOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GameColors.inkBorder, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: GameColors.oakDark,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
