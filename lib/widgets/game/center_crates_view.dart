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
  final double openProgress;

  const CenterCratesView({
    super.key,
    required this.crates,
    required this.currentBid,
    required this.highestBidderName,
    required this.hammerCount,
    required this.turnDirection,
    this.onCrateTap,
    this.openProgress = 0.0,
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

        // 2.5D Wooden Crate with Iron Chains & Padlock (Animated crate opening)
        SizedBox(
          width: 140,
          height: 115,
          child: CustomPaint(
            painter: _IsometricCratePainter(
              label: crate.label,
              isRevealed: crate.isRevealed,
              isXRayed: crate.isXRayed,
              openProgress: crate.isRevealed ? 1.0 : openProgress,
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
  final double openProgress;

  _IsometricCratePainter({
    required this.label,
    required this.isRevealed,
    required this.isXRayed,
    this.openProgress = 0.0,
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

    final effectiveOpen = isRevealed ? max(openProgress, 1.0) : openProgress;

    // 1. If crate is opening, draw glowing golden god rays shooting out from inside
    if (effectiveOpen > 0.25) {
      final rayProgress = ((effectiveOpen - 0.25) / 0.75).clamp(0.0, 1.0);
      final rayPaint = Paint()
        ..color = Color.fromRGBO(254, 240, 138, 0.5 * rayProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5;

      for (int a = -4; a <= 4; a++) {
        final angle = (a * 15) * pi / 180;
        final rayLen = 50.0 * rayProgress;
        final startP = Offset(w * 0.50, h * 0.25);
        final endP = Offset(
          startP.dx + sin(angle) * rayLen,
          startP.dy - cos(angle) * rayLen,
        );
        canvas.drawLine(startP, endP, rayPaint);
      }
    }

    // 2. Interior Glow Cavity (visible when crate lid opens)
    if (effectiveOpen > 0.2) {
      final cavityProgress = ((effectiveOpen - 0.2) / 0.8).clamp(0.0, 1.0);
      final cavityPath = Path()
        ..moveTo(w * 0.14, h * 0.30)
        ..lineTo(w * 0.28, h * 0.12)
        ..lineTo(w * 0.98, h * 0.12)
        ..lineTo(w * 0.86, h * 0.30)
        ..close();

      final cavityGlow = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0),
          radius: 0.8,
          colors: [
            Color.fromRGBO(254, 240, 138, cavityProgress),
            Color.fromRGBO(245, 158, 11, cavityProgress),
            const Color(0xFF451A03),
          ],
        ).createShader(Rect.fromLTWH(w * 0.14, h * 0.12, w * 0.84, h * 0.20));
      canvas.drawPath(cavityPath, cavityGlow);
      canvas.drawPath(cavityPath, stroke);
    }

    // 3. Crate Front Face
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

    // 4. Crate Right Face
    fill.color = isXRayed ? const Color(0xFF0284C7) : const Color(0xFF78350F);
    final rightSide = Path()
      ..moveTo(w * 0.88, h * 0.32)
      ..lineTo(w * 1.00, h * 0.10)
      ..lineTo(w * 1.00, h * 0.73)
      ..lineTo(w * 0.88, h * 0.95)
      ..close();
    canvas.drawPath(rightSide, fill);
    canvas.drawPath(rightSide, stroke);

    // 5. Crate Top Lid (Animated opening in 2.5D!)
    if (effectiveOpen < 0.25) {
      // Flat Closed Top Lid
      fill.color = isXRayed ? const Color(0xFF7DD3FC) : const Color(0xFFD97706);
      final top = Path()
        ..moveTo(w * 0.12, h * 0.32)
        ..lineTo(w * 0.28, h * 0.10)
        ..lineTo(w * 1.00, h * 0.10)
        ..lineTo(w * 0.88, h * 0.32)
        ..close();
      canvas.drawPath(top, fill);
      canvas.drawPath(top, stroke);
    } else {
      // Hinging Opened Top Lid swinging upward!
      final lidLift = ((effectiveOpen - 0.25) / 0.75).clamp(0.0, 1.0) * (h * 0.35);
      final openLid = Path()
        ..moveTo(w * 0.28, h * 0.10)
        ..lineTo(w * 1.00, h * 0.10)
        ..lineTo(w * 0.95, h * 0.05 - lidLift)
        ..lineTo(w * 0.22, h * 0.05 - lidLift)
        ..close();

      fill.color = const Color(0xFF92400E);
      canvas.drawPath(openLid, fill);
      canvas.drawPath(openLid, stroke);

      // Underside slat line on open lid
      canvas.drawLine(
        Offset(w * 0.25, h * 0.075 - (lidLift * 0.5)),
        Offset(w * 0.97, h * 0.075 - (lidLift * 0.5)),
        slatStroke,
      );
    }

    // 6. Chains & Padlock or Floating Treasure Card
    if (effectiveOpen < 0.35) {
      final chainAlpha = (1.0 - (effectiveOpen / 0.35)).clamp(0.0, 1.0);
      final chainDrop = effectiveOpen * 30.0;

      // Heavy Iron Chains wrapped diagonally
      final chainPaint = Paint()
        ..color = Color.fromRGBO(148, 163, 184, chainAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(w * 0.12, h * 0.32 + chainDrop), Offset(w * 0.88, h * 0.95 + chainDrop), chainPaint);
      canvas.drawLine(Offset(w * 0.12, h * 0.95 + chainDrop), Offset(w * 0.88, h * 0.32 + chainDrop), chainPaint);

      // Steel Padlock in Center
      final lockCenter = Offset(w * 0.50, h * 0.63 + chainDrop);
      final lockRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: lockCenter, width: 24, height: 20),
        const Radius.circular(4),
      );
      canvas.drawRRect(lockRect, Paint()..color = Color.fromRGBO(226, 232, 240, chainAlpha));
      canvas.drawRRect(lockRect, stroke..strokeWidth = 2);

      // Padlock Shackle
      canvas.drawArc(
        Rect.fromCenter(center: Offset(lockCenter.dx, lockCenter.dy - 10), width: 14, height: 16),
        pi,
        pi,
        false,
        stroke..strokeWidth = 3,
      );

      // Keyhole
      canvas.drawCircle(lockCenter, 2.5, Paint()..color = GameColors.inkBorder);
    } else {
      // 7. Treasure Miniature Card Rising from the Crate!
      final riseProgress = ((effectiveOpen - 0.35) / 0.65).clamp(0.0, 1.0);
      final cardCenter = Offset(w * 0.50, h * 0.35 - (riseProgress * 28.0));

      // Rising Card Rect
      final cardRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: cardCenter, width: 34, height: 46),
        const Radius.circular(5),
      );
      canvas.drawRRect(cardRect, Paint()..color = GameColors.goldBright);
      canvas.drawRRect(cardRect, stroke..strokeWidth = 2);

      // Inner card illustration icon / star
      canvas.drawCircle(cardCenter, 8, Paint()..color = const Color(0xFFF59E0B));
      canvas.drawCircle(cardCenter, 8, stroke..strokeWidth = 1.2);

      // Sparkles around card
      final sparklePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cardCenter.dx - 18, cardCenter.dy - 12), 2.5, sparklePaint);
      canvas.drawCircle(Offset(cardCenter.dx + 18, cardCenter.dy + 10), 2.0, sparklePaint);
      canvas.drawCircle(Offset(cardCenter.dx + 14, cardCenter.dy - 16), 3.0, Paint()..color = GameColors.goldBright);
    }
  }

  @override
  bool shouldRepaint(covariant _IsometricCratePainter oldDelegate) =>
      oldDelegate.openProgress != openProgress ||
      oldDelegate.isRevealed != isRevealed ||
      oldDelegate.isXRayed != isXRayed;
}

class _DollarBillsFanPainter extends CustomPainter {
  final int currentBid;

  _DollarBillsFanPainter({required this.currentBid});

  static const List<Map<String, dynamic>> _billTypes = [
    {'color': Color(0xFF86EFAC), 'label': '\$100', 'inner': Color(0xFF4ADE80)},
    {'color': Color(0xFFFDE047), 'label': '\$250', 'inner': Color(0xFFEAB308)},
    {'color': Color(0xFFC084FC), 'label': '\$500', 'inner': Color(0xFFA855F7)},
    {'color': Color(0xFFF87171), 'label': '\$1,000', 'inner': Color(0xFFEF4444)},
    {'color': Color(0xFF38BDF8), 'label': '\$2,500', 'inner': Color(0xFF0284C7)},
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final stroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Number of visual bills based on bid amount
    final billCount = (currentBid / 300).clamp(3, 9).toInt();

    for (int i = 0; i < billCount; i++) {
      final billData = _billTypes[i % _billTypes.length];
      final billFill = Paint()..color = billData['color'] as Color;
      final innerColor = billData['inner'] as Color;
      final label = billData['label'] as String;

      final angle = -0.55 + (i * 1.1 / (billCount - 1));
      canvas.save();
      canvas.translate(cx + (i - billCount / 2) * 28, cy + 10);
      canvas.rotate(angle);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 66, height: 34),
        const Radius.circular(5),
      );
      canvas.drawRRect(rrect, billFill);
      canvas.drawRRect(rrect, stroke);

      // Inner medallion
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 22, height: 18),
        Paint()..color = innerColor,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 22, height: 18),
        stroke..strokeWidth = 1.2,
      );

      // Denomination text
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: GameColors.inkBorder,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }

    // Casino Chips Stack on the Left & Right
    _drawChipStack(canvas, Offset(cx - 150, cy + 18), const Color(0xFF0284C7), const Color(0xFF38BDF8), 4);
    _drawChipStack(canvas, Offset(cx + 150, cy + 18), const Color(0xFFDC2626), const Color(0xFFF87171), 5);
  }

  void _drawChipStack(Canvas canvas, Offset center, Color baseColor, Color rimColor, int count) {
    final stroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int j = 0; j < count; j++) {
      final chipRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - (j * 4.5)),
        width: 26,
        height: 12,
      );
      canvas.drawOval(chipRect, Paint()..color = baseColor);
      canvas.drawOval(chipRect, stroke);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - (j * 4.5)),
          width: 14,
          height: 6,
        ),
        Paint()..color = rimColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DollarBillsFanPainter oldDelegate) =>
      oldDelegate.currentBid != currentBid;
}
