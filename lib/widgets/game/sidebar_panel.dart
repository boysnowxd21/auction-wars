import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../models/player_model.dart';
import '../../services/sound_service.dart';
import '../../theme/game_theme.dart';
import '../tactile_button.dart';

class SidebarPanel extends StatefulWidget {
  final PlayerModel player;
  final bool isUserTurn;
  final VoidCallback onRaise200;
  final VoidCallback onRaise500;
  final VoidCallback onPassFold;
  final Function(AuctionCard card) onPawnCard;

  const SidebarPanel({
    super.key,
    required this.player,
    required this.isUserTurn,
    required this.onRaise200,
    required this.onRaise500,
    required this.onPassFold,
    required this.onPawnCard,
  });

  @override
  State<SidebarPanel> createState() => _SidebarPanelState();
}

class _SidebarPanelState extends State<SidebarPanel> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _isOpen ? 280 : 44,
      decoration: BoxDecoration(
        color: GameColors.oakDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        border: Border.all(color: GameColors.oakBorder, width: 3.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x88000000),
            blurRadius: 16,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Open / Close Toggle Chevron Strip
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => _isOpen = !_isOpen);
                SoundService.instance.playClick();
              },
              child: Container(
                width: 36,
                height: double.infinity,
                color: GameColors.oakMedium,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isOpen ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                        color: GameColors.goldBright,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          _isOpen ? 'COLLAPSE' : 'PAWN & BID CONTROLS',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Sidebar Content (When Open)
          if (_isOpen)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // UPPER SECTION — PAWN SHOP: SELL FOR 50%
                    _buildPawnShopHeader(),

                    const SizedBox(height: 8),

                    Expanded(
                      flex: 6,
                      child: _buildStashPawnGrid(),
                    ),

                    const Divider(color: GameColors.oakBorder, thickness: 2.5),

                    // LOWER SECTION — QUICK-TURN CONTROLS
                    _buildQuickTurnControls(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPawnShopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1005),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GameColors.goldBright, width: 2),
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_exchange_rounded, color: GameColors.goldBright, size: 15),
            SizedBox(width: 4),
            Text(
              'PAWN SHOP: 50% CASH',
              style: TextStyle(
                color: GameColors.goldBright,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStashPawnGrid() {
    // Only positive assets can be liquidated for 50%
    final pawnable = widget.player.stash.where((c) => c.value > 0).toList();

    if (pawnable.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF140A04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: const Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.white30, size: 30),
                SizedBox(height: 6),
                Text(
                  'STASH EMPTY (\$0)',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Won positive assets appear here and can be pawned instantly for 50% cash.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white30, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: pawnable.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, i) {
        final card = pawnable[i];
        final payout = card.pawnValue;

        return GestureDetector(
          onTap: () {
            SoundService.instance.playCashRegister();
            widget.onPawnCard(card);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFBF6E9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: GameColors.inkBorder, width: 2),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.asset(card.imagePath, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    card.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: GameColors.inkBorder,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: const BoxDecoration(
                    color: GameColors.greenMoney,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Pawn: +\$$payout',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickTurnControls() {
    final enabled = widget.isUserTurn && !widget.player.isFolded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Center(
          child: Text(
            enabled ? 'YOUR TURN TO BID!' : 'WAITING FOR OPPONENTS...',
            style: TextStyle(
              color: enabled ? GameColors.goldBright : Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // [RAISE +$200]
        TactileButton(
          onTap: enabled ? widget.onRaise200 : null,
          baseColor: GameColors.greenMoney,
          shadowColor: GameColors.greenDark,
          height: 42,
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          enabled: enabled,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up_rounded, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'RAISE +\$200',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // [RAISE +$500]
        TactileButton(
          onTap: enabled ? widget.onRaise500 : null,
          baseColor: GameColors.greenMoney,
          shadowColor: GameColors.greenDark,
          height: 42,
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          enabled: enabled,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'RAISE +\$500',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // [PASS / FOLD]
        TactileButton(
          onTap: enabled ? widget.onPassFold : null,
          baseColor: GameColors.redHazard,
          shadowColor: GameColors.redDark,
          height: 42,
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          enabled: enabled,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.back_hand_rounded, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'PASS / FOLD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
