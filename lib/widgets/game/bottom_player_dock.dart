import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../models/player_model.dart';
import '../../theme/game_theme.dart';
import '../card_view.dart';
import '../cel_character_painter.dart';
import '../modals/card_showcase_modal.dart';
import '../tactile_button.dart';

class BottomPlayerDock extends StatelessWidget {
  final PlayerModel player;
  final String liveNarrativeToast;
  final bool isUserTurn;
  final VoidCallback onRaise200;
  final VoidCallback onRaise500;
  final VoidCallback onPassFold;
  final Function(AuctionCard card)? onPawnCard;
  final Function(AuctionCard card)? onPlayOpsCard;
  final VoidCallback? onOpenStashVault;

  const BottomPlayerDock({
    super.key,
    required this.player,
    required this.liveNarrativeToast,
    required this.isUserTurn,
    required this.onRaise200,
    required this.onRaise500,
    required this.onPassFold,
    this.onPawnCard,
    this.onPlayOpsCard,
    this.onOpenStashVault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
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
          // 1. Left: Player Profile & Quick Pawn Shop Section
          _buildPlayerProfile(),

          const SizedBox(width: 12),

          // 2. Center: Huge, High-Visibility Special Ops Cards Tray
          Expanded(
            child: _buildOpsCardTray(context),
          ),

          const SizedBox(width: 12),

          // 3. Right: Quick-Turn Bidding Controls (Replaces old auction desk box)
          _buildQuickTurnConsole(),
        ],
      ),
    );
  }

  Widget _buildPlayerProfile() {
    return Container(
      width: 255,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1005),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.goldBright, width: 2.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Row 1: Avatar + Name + YOU Badge
          Row(
            children: [
              const CartoonAvatarWidget(
                avatarKey: 'you',
                radius: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                          fontSize: 15,
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
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Row 2: Dual Metric Badges (Bid Money & Item Money)
          Row(
            children: [
              // Metric Pill 1: BID MONEY: $X,XXX
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: GameTheme.greenMoneyPillDeco,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'BID MONEY: \$${player.bidMoney}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Metric Pill 2: ITEM MONEY: +$X,XXX (Tappable to view Stash Vault)
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onOpenStashVault,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: GameTheme.goldMoneyPillDeco,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'ITEM MONEY: +\$${player.itemMoney}',
                          style: const TextStyle(
                            color: GameColors.inkBorder,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Row 3: Pawn Shop Section & Stash Vault Trigger
          _buildPawnShopSection(),
        ],
      ),
    );
  }

  Widget _buildPawnShopSection() {
    final pawnable = player.stash.where((c) => c.value > 0).toList();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onOpenStashVault,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2E1508),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD97706), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2_rounded, size: 18, color: GameColors.goldBright),
                      SizedBox(width: 4),
                      Text(
                        'PAWN SHOP: 50% CASH',
                        style: TextStyle(
                          color: GameColors.goldBright,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (pawnable.isEmpty)
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'STASH EMPTY (\$0)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: GameColors.greenMoney,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PAWN +\$${pawnable.first.pawnValue}',
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpsCardTray(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF190C05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5E2E14), width: 2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.style_rounded, color: GameColors.blueOps, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        'SPECIAL OPS CARD TRAY (${player.opsHand.length} / 6)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'TAP CARD TO INSPECT & ACTIVATE',
                        style: TextStyle(
                          color: GameColors.goldBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Cards Row (Large, visible, high-impact cards with full art)
          Expanded(
            child: player.opsHand.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: player.opsHand.map((c) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AuctionCardWidget(
                            card: c,
                            width: 132,
                            height: 170,
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
                      style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTurnConsole() {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1005),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUserTurn ? GameColors.goldBright : const Color(0xFF5E2E14),
          width: isUserTurn ? 2.5 : 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Live Narrative / Turn Status Pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isUserTurn ? const Color(0xFF15803D) : const Color(0xFF334155),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isUserTurn ? const Color(0xFF86EFAC) : Colors.white24,
                width: 1.5,
              ),
            ),
            child: Text(
              liveNarrativeToast,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Raise Buttons: [RAISE +$200] & [RAISE +$500]
          Row(
            children: [
              Expanded(
                child: TactileButton(
                  onTap: isUserTurn ? onRaise200 : null,
                  baseColor: GameColors.greenMoney,
                  shadowColor: GameColors.greenDark,
                  height: 44,
                  borderRadius: 12,
                  enabled: isUserTurn,
                  padding: EdgeInsets.zero,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.trending_up_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'RAISE +\$200',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TactileButton(
                  onTap: isUserTurn ? onRaise500 : null,
                  baseColor: GameColors.greenMoney,
                  shadowColor: GameColors.greenDark,
                  height: 44,
                  borderRadius: 12,
                  enabled: isUserTurn,
                  padding: EdgeInsets.zero,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'RAISE +\$500',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Pass / Fold Button
          TactileButton(
            onTap: isUserTurn ? onPassFold : null,
            baseColor: GameColors.redHazard,
            shadowColor: GameColors.redDark,
            height: 42,
            width: double.infinity,
            borderRadius: 12,
            enabled: isUserTurn,
            padding: EdgeInsets.zero,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag_rounded, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'PASS / FOLD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
