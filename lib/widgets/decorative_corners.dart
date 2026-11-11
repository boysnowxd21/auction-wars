import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import 'cel_character_painter.dart';

class DecorativeCorners extends StatelessWidget {
  const DecorativeCorners({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Top-Left: Fanned Decks of Collectible Cards & Golden Tickets
          Positioned(
            left: 14,
            top: 10,
            child: _buildTopLeftFannedCards(),
          ),

          // Top-Right: Golden Bidding Tickets & Cards
          Positioned(
            right: 14,
            top: 10,
            child: _buildTopRightTickets(),
          ),

          // Bottom-Left: Cheerful Cartoon Bidders with Cash Fans (Compact corner placement - never covers cards!)
          const Positioned(
            left: 10,
            bottom: 4,
            child: CheerfulBiddersWidget(width: 95, height: 95),
          ),

          // Bottom-Right: Smiling Tuxedo Auctioneer with Gavel (Compact corner placement - never covers cards!)
          const Positioned(
            right: 10,
            bottom: 4,
            child: TuxedoAuctioneerWidget(width: 95, height: 95),
          ),
        ],
      ),
    );
  }

  Widget _buildTopLeftFannedCards() {
    return SizedBox(
      width: 190,
      height: 140,
      child: Stack(
        children: [
          // Card 1: 1999 Trading Card Box
          Positioned(
            left: 8,
            top: 24,
            child: Transform.rotate(
              angle: -0.34,
              child: _buildRealMiniCard('assets/cards/1999 Trading Card Box.png', 'RARE'),
            ),
          ),
          // Card 2: Golden Age Comic #1
          Positioned(
            left: 45,
            top: 14,
            child: Transform.rotate(
              angle: -0.16,
              child: _buildRealMiniCard('assets/cards/Golden Age Comic #1.png', 'MINT'),
            ),
          ),
          // Card 3: Gold Bullion Bar
          Positioned(
            left: 85,
            top: 22,
            child: Transform.rotate(
              angle: 0.14,
              child: _buildRealMiniCard('assets/cards/Gold Bullion Bar.png', 'GOLD'),
            ),
          ),
          // Golden Bidding Ticket #01
          Positioned(
            left: 36,
            top: 55,
            child: Transform.rotate(
              angle: 0.22,
              child: _buildGoldenTicket('#01'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRightTickets() {
    return SizedBox(
      width: 190,
      height: 140,
      child: Stack(
        children: [
          // Card 1: Vintage Muscle Car
          Positioned(
            right: 8,
            top: 24,
            child: Transform.rotate(
              angle: 0.34,
              child: _buildRealMiniCard('assets/cards/Vintage Muscle Car.png', 'VAULT'),
            ),
          ),
          // Card 2: Signed Legendary Guitar
          Positioned(
            right: 45,
            top: 14,
            child: Transform.rotate(
              angle: 0.16,
              child: _buildRealMiniCard('assets/cards/Signed Legendary Guitar.png', 'EPIC'),
            ),
          ),
          // Card 3: Rare Blue Diamond Ring
          Positioned(
            right: 85,
            top: 22,
            child: Transform.rotate(
              angle: -0.14,
              child: _buildRealMiniCard('assets/cards/Rare Blue Diamond Ring.png', 'GEMS'),
            ),
          ),
          // Golden Bidding Ticket #77
          Positioned(
            right: 36,
            top: 55,
            child: Transform.rotate(
              angle: -0.22,
              child: _buildGoldenTicket('#77'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealMiniCard(String assetPath, String tag) {
    return Container(
      width: 52,
      height: 74,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GameColors.inkBorder, width: 2.5),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.star_rounded, size: 20, color: GameColors.goldBright),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            color: GameColors.goldDeep,
            child: Text(
              tag,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenTicket(String ticketNo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [GameColors.goldBright, GameColors.goldOrange],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GameColors.inkBorder, width: 2.2),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.confirmation_number_rounded, color: GameColors.inkBorder, size: 14),
          const SizedBox(width: 4),
          Text(
            ticketNo,
            style: const TextStyle(
              color: GameColors.inkBorder,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
