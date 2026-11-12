import 'package:flutter/material.dart';
import '../../theme/game_theme.dart';

/// Cel-shaded tactile Bid Marker placed directly on the felt table in front of each player
class TableBidMarker extends StatelessWidget {
  final String playerName;
  final int? bidAmount;
  final bool isFolded;
  final bool isHighestBidder;
  final bool isUser;
  final bool isCurrentTurn;

  const TableBidMarker({
    super.key,
    required this.playerName,
    required this.bidAmount,
    this.isFolded = false,
    this.isHighestBidder = false,
    this.isUser = false,
    this.isCurrentTurn = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFolded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xDD374151),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Text(
          '$playerName: FOLDED',
          style: const TextStyle(
            color: Color(0xFFFCA5A5),
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (bidAmount == null || bidAmount! <= 0) {
      if (isCurrentTurn) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xDD0284C7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
            boxShadow: const [
              BoxShadow(color: Color(0x5538BDF8), blurRadius: 8, spreadRadius: 1),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                isUser ? 'YOUR TURN TO BID' : '$playerName BIDDING...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isHighestBidder ? const Color(0xFF15803D) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighestBidder ? GameColors.goldBright : Colors.white38,
          width: isHighestBidder ? 2.5 : 1.5,
        ),
        boxShadow: [
          if (isHighestBidder)
            const BoxShadow(
              color: Color(0x88FACC15),
              blurRadius: 10,
              spreadRadius: 2,
            )
          else
            const BoxShadow(
              color: Colors.black45,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Money / Chip Graphic
          Icon(
            isHighestBidder ? Icons.stars_rounded : Icons.monetization_on_rounded,
            color: isHighestBidder ? GameColors.goldBright : const Color(0xFF38BDF8),
            size: 19,
          ),
          const SizedBox(width: 6),
          Text(
            isHighestBidder
                ? (isUser ? 'YOUR HIGH BID: \$$bidAmount' : '$playerName HIGH: \$$bidAmount')
                : (isUser ? 'YOUR BID: \$$bidAmount' : '$playerName: \$$bidAmount'),
            style: TextStyle(
              color: isHighestBidder ? Colors.white : const Color(0xFFF1F5F9),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              shadows: const [
                Shadow(color: Colors.black, offset: Offset(1, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
