import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/crate_lot.dart';
import '../../theme/game_theme.dart';

class CenterCratesView extends StatelessWidget {
  final List<CrateModel> crates;
  final int currentBid;
  final String highestBidderName;
  final int hammerCount; // 0=None, 1=Once, 2=Twice, 3=Fair Warning, 4=Sold
  final String turnDirection; // 'Clockwise' or 'Counter-Clockwise'
  final Function(int crateIndex)? onCrateTap;

  const CenterCratesView({
    super.key,
    required this.crates,
    required this.currentBid,
    required this.highestBidderName,
    required this.hammerCount,
    required this.turnDirection,
    this.onCrateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Directional Turn Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xCC0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GameColors.goldBright, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                turnDirection == 'Clockwise' ? '↻ Clockwise Bidding' : '↺ Counter-Clockwise Bidding',
                style: const TextStyle(
                  color: GameColors.goldBright,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Three 2.5D Isometric Wooden Crates
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(crates.length, (i) {
            final crate = crates[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: onCrateTap != null ? () => onCrateTap!(i) : null,
                child: _buildIsometricCrate(crate),
              ),
            );
          }),
        ),

        const SizedBox(height: 10),

        // Active Pot Counter & Dollar Bill Stacks
        _buildPotCounterAndBills(),
      ],
    );
  }

  Widget _buildIsometricCrate(CrateModel crate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hanging Manila Stencil Hint Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE68A),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: GameColors.inkBorder, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2),
            ],
          ),
          child: Text(
            crate.isXRayed
                ? 'X-RAY: ${crate.cards.map((c) => c.name).join(", ")}'
                : crate.hintTag,
            style: TextStyle(
              color: crate.isXRayed ? GameColors.blueDark : const Color(0xFF78350F),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: 3),

        // 2.5D Wooden Crate with Iron Chains & Padlock
        SizedBox(
          width: 140,
          height: 115,
          child: CustomPaint(
            painter: _IsometricCratePainter(
              label: crate.label,
              isRevealed: crate.isRevealed,
              isXRayed: crate.isXRayed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPotCounterAndBills() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dynamic Cartoon Dollar Bill Stacks Fanning Out
        CustomPaint(
          size: const Size(420, 80),
          painter: _DollarBillsFanPainter(currentBid: currentBid),
        ),

        // Active Pot Counter Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF26140B), Color(0xFF150A05)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GameColors.goldBright, width: 3.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CURRENT BID: \$$currentBid',
                style: const TextStyle(
                  color: GameColors.goldBright,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(2, 2)),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'HIGH BIDDER: ${highestBidderName.toUpperCase()}',
                style: TextStyle(
                  color: highestBidderName == 'You' ? GameColors.greenMoney : Colors.amber.shade200,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),

              // Hammer Call Alert Banner
              if (hammerCount > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getHammerColor(hammerCount),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    _getHammerText(hammerCount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _getHammerColor(int count) {
    switch (count) {
      case 1:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFFEA580C);
      case 3:
        return const Color(0xFFDC2626);
      case 4:
      default:
        return const Color(0xFF15803D);
    }
  }

  String _getHammerText(int count) {
    switch (count) {
      case 1:
        return '🔨 GOING ONCE!';
      case 2:
        return '🔨 GOING TWICE!';
      case 3:
        return '🔨 FAIR WARNING!';
      case 4:
      default:
        return '🎉 SOLD!';
    }
  }
}

class _IsometricCratePainter extends CustomPainter {
  final String label;
  final bool isRevealed;
  final bool isXRayed;

  _IsometricCratePainter({
    required this.label,
    required this.isRevealed,
    required this.isXRayed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // Crate Front Face
    fill.color = isXRayed ? const Color(0xFF38BDF8) : const Color(0xFFB45309);
    final front = Path()
      ..moveTo(w * 0.12, h * 0.32)
      ..lineTo(w * 0.88, h * 0.32)
      ..lineTo(w * 0.88, h * 0.95)
      ..lineTo(w * 0.12, h * 0.95)
      ..close();
    canvas.drawPath(front, fill);
    canvas.drawPath(front, stroke);

    // Crate Slats Lines
    final slatStroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(w * 0.12, h * 0.53), Offset(w * 0.88, h * 0.53), slatStroke);
    canvas.drawLine(Offset(w * 0.12, h * 0.74), Offset(w * 0.88, h * 0.74), slatStroke);

    // Cross Braces (X brace on front)
    canvas.drawLine(Offset(w * 0.12, h * 0.32), Offset(w * 0.88, h * 0.95), slatStroke);
    canvas.drawLine(Offset(w * 0.12, h * 0.95), Offset(w * 0.88, h * 0.32), slatStroke);

    // Crate Top Face (Isometric 2.5D angle)
    fill.color = isXRayed ? const Color(0xFF7DD3FC) : const Color(0xFFD97706);
    final top = Path()
      ..moveTo(w * 0.12, h * 0.32)
      ..lineTo(w * 0.28, h * 0.10)
      ..lineTo(w * 1.00, h * 0.10)
      ..lineTo(w * 0.88, h * 0.32)
      ..close();
    canvas.drawPath(top, fill);
    canvas.drawPath(top, stroke);

    // Crate Right Face
    fill.color = isXRayed ? const Color(0xFF0284C7) : const Color(0xFF78350F);
    final rightSide = Path()
      ..moveTo(w * 0.88, h * 0.32)
      ..lineTo(w * 1.00, h * 0.10)
      ..lineTo(w * 1.00, h * 0.73)
      ..lineTo(w * 0.88, h * 0.95)
      ..close();
    canvas.drawPath(rightSide, fill);
    canvas.drawPath(rightSide, stroke);

    if (!isRevealed) {
      // Heavy Iron Chains wrapped diagonally
      final chainPaint = Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(w * 0.12, h * 0.32), Offset(w * 0.88, h * 0.95), chainPaint);
      canvas.drawLine(Offset(w * 0.12, h * 0.95), Offset(w * 0.88, h * 0.32), chainPaint);

      // Steel Padlock in Center
      final lockRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.50, h * 0.63), width: 24, height: 20),
        const Radius.circular(4),
      );
      canvas.drawRRect(lockRect, Paint()..color = const Color(0xFFE2E8F0));
      canvas.drawRRect(lockRect, stroke..strokeWidth = 2);

      // Padlock Shackle
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.50, h * 0.53), width: 14, height: 16),
        pi,
        pi,
        false,
        stroke..strokeWidth = 3,
      );

      // Keyhole
      canvas.drawCircle(Offset(w * 0.50, h * 0.63), 2.5, Paint()..color = GameColors.inkBorder);
    } else {
      // Golden Sparkle of Revealed Treasure!
      final goldPaint = Paint()..color = GameColors.goldBright;
      canvas.drawCircle(Offset(w * 0.50, h * 0.63), 16, goldPaint);
      canvas.drawCircle(Offset(w * 0.50, h * 0.63), 16, stroke..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DollarBillsFanPainter extends CustomPainter {
  final int currentBid;

  _DollarBillsFanPainter({required this.currentBid});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final stroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Number of visual bills based on bid amount
    final billCount = (currentBid / 400).clamp(3, 10).toInt();
    final billFill = Paint()..color = const Color(0xFF86EFAC);

    for (int i = 0; i < billCount; i++) {
      final angle = -0.6 + (i * 1.2 / (billCount - 1));
      canvas.save();
      canvas.translate(cx + (i - billCount / 2) * 24, cy + 12);
      canvas.rotate(angle);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 62, height: 32),
        const Radius.circular(4),
      );
      canvas.drawRRect(rrect, billFill);
      canvas.drawRRect(rrect, stroke);

      // Border and $ symbol
      canvas.drawCircle(Offset.zero, 8, Paint()..color = const Color(0xFF4ADE80));
      canvas.drawCircle(Offset.zero, 8, stroke..strokeWidth = 1.2);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DollarBillsFanPainter oldDelegate) =>
      oldDelegate.currentBid != currentBid;
}
