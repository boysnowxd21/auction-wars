import 'package:flutter/material.dart';
import '../../theme/game_theme.dart';
import '../tactile_button.dart';

class TopNavStrip extends StatelessWidget {
  final int currentRound;
  final int maxRounds;
  final String venueName;
  final int debt;
  final int bidMoney;
  final VoidCallback onTakeSharkLoan;
  final VoidCallback onRepayDebt;
  final VoidCallback onBlackMarketTap;
  final VoidCallback onBuyOpsTap;
  final VoidCallback onExitGame;

  const TopNavStrip({
    super.key,
    required this.currentRound,
    required this.maxRounds,
    required this.venueName,
    required this.debt,
    required this.bidMoney,
    required this.onTakeSharkLoan,
    required this.onRepayDebt,
    required this.onBlackMarketTap,
    required this.onBuyOpsTap,
    required this.onExitGame,
  });

  @override
  Widget build(BuildContext context) {
    final canRepay = debt > 0 && bidMoney >= 500;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [GameColors.oakLight, GameColors.oakMedium, GameColors.oakDark],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.oakBorder, width: 3.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: SizedBox(
            width: 1350,
            child: Row(
              children: [
                // Left: Compact Game Badge (Round Progress & Venue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF26140B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GameColors.goldOrange, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.gavel_rounded, color: GameColors.goldBright, size: 20),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROUND: $currentRound / $maxRounds',
                      style: const TextStyle(
                        color: GameColors.goldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      venueName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Center: The Shark Loan Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E130C),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: GameColors.inkBorder, width: 2.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red Debt Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: debt > 0 ? GameColors.redHazard : const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: GameColors.inkBorder, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.water_drop_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        debt > 0 ? 'DEBT: -\$$debt' : 'DEBT: \$0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Quick [+SHARK LOAN ($1,000)]
                TactileButton(
                  onTap: onTakeSharkLoan,
                  baseColor: const Color(0xFFEF4444),
                  shadowColor: const Color(0xFF991B1B),
                  height: 38,
                  borderRadius: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Text(
                    '+SHARK LOAN (\$1,000)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Green [REPAY NOW]
                TactileButton(
                  onTap: canRepay ? onRepayDebt : null,
                  baseColor: GameColors.greenMoney,
                  shadowColor: GameColors.greenDark,
                  height: 38,
                  borderRadius: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  enabled: canRepay,
                  child: const Text(
                    'REPAY NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Right: [BLACK MARKET] & [BUY OPS (-$300)]
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TactileButton(
                onTap: onBlackMarketTap,
                baseColor: const Color(0xFF8B5CF6),
                shadowColor: const Color(0xFF5B21B6),
                height: 42,
                borderRadius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Row(
                  children: [
                    Icon(Icons.storefront_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'BLACK MARKET',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TactileButton(
                onTap: bidMoney >= 300 ? onBuyOpsTap : null,
                baseColor: GameColors.blueOps,
                shadowColor: GameColors.blueDark,
                height: 42,
                borderRadius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                enabled: bidMoney >= 300,
                child: const Row(
                  children: [
                    Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'BUY OPS (-\$300)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TactileButton(
                onTap: onExitGame,
                baseColor: const Color(0xFF475569),
                shadowColor: const Color(0xFF1E293B),
                width: 42,
                height: 42,
                borderRadius: 21,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
      ),
      ),
      ),
    );
  }
}
