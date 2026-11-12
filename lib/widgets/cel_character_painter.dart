import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/game_theme.dart';

/// Cheerful Tuxedo Auctioneer raising a wooden gavel with celebratory sparkle stars
class TuxedoAuctioneerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool animateGavel;

  const TuxedoAuctioneerWidget({
    super.key,
    this.width = 170,
    this.height = 190,
    this.animateGavel = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _TuxedoAuctioneerPainter(),
      ),
    );
  }
}

class _TuxedoAuctioneerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Body / Tuxedo (Dark Navy)
    fillPaint.color = const Color(0xFF1E293B);
    final tuxPath = Path()
      ..moveTo(w * 0.25, h * 0.95)
      ..lineTo(w * 0.28, h * 0.58)
      ..lineTo(w * 0.45, h * 0.50)
      ..lineTo(w * 0.65, h * 0.58)
      ..lineTo(w * 0.80, h * 0.95)
      ..close();
    canvas.drawPath(tuxPath, fillPaint);
    canvas.drawPath(tuxPath, strokePaint);

    // White Shirt V & Red Bowtie
    fillPaint.color = Colors.white;
    final shirtPath = Path()
      ..moveTo(w * 0.42, h * 0.50)
      ..lineTo(w * 0.52, h * 0.50)
      ..lineTo(w * 0.47, h * 0.65)
      ..close();
    canvas.drawPath(shirtPath, fillPaint);
    canvas.drawPath(shirtPath, strokePaint);

    // Red Bowtie
    fillPaint.color = const Color(0xFFDC2626);
    final bowLeft = Path()
      ..moveTo(w * 0.47, h * 0.52)
      ..lineTo(w * 0.38, h * 0.48)
      ..lineTo(w * 0.38, h * 0.56)
      ..close();
    final bowRight = Path()
      ..moveTo(w * 0.47, h * 0.52)
      ..lineTo(w * 0.56, h * 0.48)
      ..lineTo(w * 0.56, h * 0.56)
      ..close();
    canvas.drawPath(bowLeft, fillPaint);
    canvas.drawPath(bowLeft, strokePaint);
    canvas.drawPath(bowRight, fillPaint);
    canvas.drawPath(bowRight, strokePaint);
    canvas.drawCircle(Offset(w * 0.47, h * 0.52), 4, fillPaint);
    canvas.drawCircle(Offset(w * 0.47, h * 0.52), 4, strokePaint);

    // Head (Peach skin)
    fillPaint.color = const Color(0xFFFFD1A4);
    final headCenter = Offset(w * 0.46, h * 0.36);
    canvas.drawOval(
      Rect.fromCenter(center: headCenter, width: w * 0.36, height: h * 0.34),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: headCenter, width: w * 0.36, height: h * 0.34),
      strokePaint,
    );

    // Ears
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.36), width: 14, height: 18),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.36), width: 14, height: 18),
      strokePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.64, h * 0.36), width: 14, height: 18),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.64, h * 0.36), width: 14, height: 18),
      strokePaint,
    );

    // Cheerful Big Smiling Eyes
    final eyePaint = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.40, h * 0.32), 6, eyePaint);
    canvas.drawCircle(Offset(w * 0.52, h * 0.32), 6, eyePaint);
    // Eye highlights
    canvas.drawCircle(Offset(w * 0.41, h * 0.30), 2.5, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.53, h * 0.30), 2.5, Paint()..color = Colors.white);

    // Smiling Rosy Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFCA5A5);
    canvas.drawCircle(Offset(w * 0.34, h * 0.38), 7, cheekPaint);
    canvas.drawCircle(Offset(w * 0.58, h * 0.38), 7, cheekPaint);

    // Big Smiling Mouth with Teeth
    fillPaint.color = const Color(0xFF991B1B);
    final mouthPath = Path()
      ..moveTo(w * 0.38, h * 0.41)
      ..quadraticBezierTo(w * 0.46, h * 0.48, w * 0.54, h * 0.41)
      ..close();
    canvas.drawPath(mouthPath, fillPaint);
    canvas.drawPath(mouthPath, strokePaint);
    // Teeth
    final teethPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.41, h * 0.41, w * 0.10, 4),
        const Radius.circular(2),
      ),
      teethPaint,
    );

    // Classic Curled Auctioneer Mustache
    fillPaint.color = const Color(0xFF451A03);
    final mustachePath = Path()
      ..moveTo(w * 0.46, h * 0.39)
      ..cubicTo(w * 0.43, h * 0.36, w * 0.32, h * 0.36, w * 0.30, h * 0.42)
      ..cubicTo(w * 0.35, h * 0.43, w * 0.43, h * 0.41, w * 0.46, h * 0.41)
      ..cubicTo(w * 0.49, h * 0.41, w * 0.57, h * 0.43, w * 0.62, h * 0.42)
      ..cubicTo(w * 0.60, h * 0.36, w * 0.49, h * 0.36, w * 0.46, h * 0.39)
      ..close();
    canvas.drawPath(mustachePath, fillPaint);
    canvas.drawPath(mustachePath, strokePaint);

    // Sleek Auctioneer Hair / Top
    fillPaint.color = const Color(0xFF291002);
    final hairPath = Path()
      ..moveTo(w * 0.28, h * 0.32)
      ..quadraticBezierTo(w * 0.46, h * 0.16, w * 0.64, h * 0.32)
      ..quadraticBezierTo(w * 0.46, h * 0.24, w * 0.28, h * 0.32)
      ..close();
    canvas.drawPath(hairPath, fillPaint);
    canvas.drawPath(hairPath, strokePaint);

    // Raised Arm Holding Wooden Gavel (Top Right)
    fillPaint.color = const Color(0xFF1E293B);
    final armPath = Path()
      ..moveTo(w * 0.65, h * 0.60)
      ..lineTo(w * 0.78, h * 0.42)
      ..lineTo(w * 0.86, h * 0.47)
      ..lineTo(w * 0.74, h * 0.68)
      ..close();
    canvas.drawPath(armPath, fillPaint);
    canvas.drawPath(armPath, strokePaint);

    // Hand
    fillPaint.color = const Color(0xFFFFD1A4);
    canvas.drawCircle(Offset(w * 0.82, h * 0.42), 9, fillPaint);
    canvas.drawCircle(Offset(w * 0.82, h * 0.42), 9, strokePaint);

    // Wooden Gavel (Handled & Head)
    final gavelHandle = Paint()
      ..color = const Color(0xFFB45309)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.80, h * 0.45),
      Offset(w * 0.88, h * 0.18),
      gavelHandle,
    );
    canvas.drawLine(
      Offset(w * 0.80, h * 0.45),
      Offset(w * 0.88, h * 0.18),
      strokePaint..strokeWidth = 2,
    );

    // Gavel Head
    fillPaint.color = const Color(0xFF92400E);
    final gavelHead = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.88, h * 0.17), width: 32, height: 16),
      const Radius.circular(5),
    );
    canvas.drawRRect(gavelHead, fillPaint);
    canvas.drawRRect(gavelHead, strokePaint..strokeWidth = 3);
    // Brass Ring on Gavel
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.88, h * 0.17), width: 8, height: 17),
        const Radius.circular(2),
      ),
      Paint()..color = GameColors.goldBright,
    );

    // Excitement Sparkle Star (Cartoon Gavel Flash)
    final sparkPaint = Paint()
      ..color = GameColors.goldBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.94, h * 0.08), Offset(w * 0.96, h * 0.03), sparkPaint);
    canvas.drawLine(Offset(w * 0.82, h * 0.08), Offset(w * 0.78, h * 0.04), sparkPaint);
    canvas.drawLine(Offset(w * 0.98, h * 0.17), Offset(w * 1.04, h * 0.17), sparkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cheerful cartoon bidders holding cash fans on the left
class CheerfulBiddersWidget extends StatelessWidget {
  final double width;
  final double height;

  const CheerfulBiddersWidget({
    super.key,
    this.width = 170,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CheerfulBiddersPainter(),
      ),
    );
  }
}

class _CheerfulBiddersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;

    // Background Bidder (Female with glasses and #1 Paddle)
    fillPaint.color = const Color(0xFF0284C7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.55, w * 0.40, h * 0.42),
        const Radius.circular(16),
      ),
      fillPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.55, w * 0.40, h * 0.42),
        const Radius.circular(16),
      ),
      strokePaint,
    );

    // BG Head
    fillPaint.color = const Color(0xFFFFE0C2);
    canvas.drawCircle(Offset(w * 0.28, h * 0.42), w * 0.16, fillPaint);
    canvas.drawCircle(Offset(w * 0.28, h * 0.42), w * 0.16, strokePaint);

    // Hair
    fillPaint.color = const Color(0xFFB45309);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.32), width: w * 0.34, height: h * 0.16),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.32), width: w * 0.34, height: h * 0.16),
      strokePaint,
    );

    // Auction Paddle #1 Raised
    final paddlePaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawLine(
      Offset(w * 0.12, h * 0.55),
      Offset(w * 0.08, h * 0.15),
      strokePaint..strokeWidth = 7,
    );
    canvas.drawCircle(Offset(w * 0.08, h * 0.15), 18, paddlePaint);
    canvas.drawCircle(Offset(w * 0.08, h * 0.15), 18, strokePaint..strokeWidth = 3);
    // Number #1
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '#1',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(w * 0.08 - 9, h * 0.15 - 9));

    // Foreground Main Bidder (Wearing Green Vest with Cash Fan)
    fillPaint.color = const Color(0xFF10B981);
    final vestPath = Path()
      ..moveTo(w * 0.45, h * 0.95)
      ..lineTo(w * 0.48, h * 0.60)
      ..lineTo(w * 0.72, h * 0.54)
      ..lineTo(w * 0.92, h * 0.65)
      ..lineTo(w * 0.95, h * 0.95)
      ..close();
    canvas.drawPath(vestPath, fillPaint);
    canvas.drawPath(vestPath, strokePaint..strokeWidth = 3.5);

    // Main Bidder Head
    fillPaint.color = const Color(0xFFFFD1A4);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.68, h * 0.40), width: w * 0.36, height: h * 0.34),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.68, h * 0.40), width: w * 0.36, height: h * 0.34),
      strokePaint,
    );

    // Hair
    fillPaint.color = const Color(0xFF1E293B);
    final mainHair = Path()
      ..moveTo(w * 0.50, h * 0.36)
      ..quadraticBezierTo(w * 0.68, h * 0.20, w * 0.86, h * 0.36)
      ..close();
    canvas.drawPath(mainHair, fillPaint);
    canvas.drawPath(mainHair, strokePaint);

    // Smiling Eyes
    final eyePaint = Paint()..color = GameColors.inkBorder;
    canvas.drawCircle(Offset(w * 0.62, h * 0.36), 5, eyePaint);
    canvas.drawCircle(Offset(w * 0.74, h * 0.36), 5, eyePaint);
    canvas.drawCircle(Offset(w * 0.63, h * 0.34), 2, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.75, h * 0.34), 2, Paint()..color = Colors.white);

    // Big Grin
    fillPaint.color = const Color(0xFFDC2626);
    final smilePath = Path()
      ..moveTo(w * 0.59, h * 0.44)
      ..quadraticBezierTo(w * 0.68, h * 0.52, w * 0.77, h * 0.44)
      ..close();
    canvas.drawPath(smilePath, fillPaint);
    canvas.drawPath(smilePath, strokePaint);
    // Rosy Cheeks
    canvas.drawCircle(Offset(w * 0.55, h * 0.42), 6, Paint()..color = const Color(0xFFFCA5A5));
    canvas.drawCircle(Offset(w * 0.81, h * 0.42), 6, Paint()..color = const Color(0xFFFCA5A5));

    // Cash Fan in Hand ($100 Bills)
    _drawCashFan(canvas, Offset(w * 0.42, h * 0.52), strokePaint);
  }

  void _drawCashFan(Canvas canvas, Offset center, Paint stroke) {
    final angles = [-0.35, -0.15, 0.05, 0.25];
    final billFill = Paint()..color = const Color(0xFF86EFAC);

    for (final angle in angles) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final billRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-16, -34, 32, 22),
        const Radius.circular(3),
      );
      canvas.drawRRect(billRect, billFill);
      canvas.drawRRect(billRect, stroke..strokeWidth = 2);

      // $ symbol
      final textPainter = TextPainter(
        text: const TextSpan(
          text: '\$100',
          style: TextStyle(
            color: Color(0xFF14532D),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(-12, -28));

      canvas.restore();
    }

    // Bidder hand holding the bills
    final handPaint = Paint()..color = const Color(0xFFFFD1A4);
    canvas.drawCircle(center, 9, handPaint);
    canvas.drawCircle(center, 9, stroke..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cartoon Avatar circular portrait with high-contrast outlines and cheerful smiles
class CartoonAvatarWidget extends StatelessWidget {
  final String avatarKey;
  final double radius;
  final bool hasGavel;
  final bool isWinner;

  const CartoonAvatarWidget({
    super.key,
    required this.avatarKey,
    this.radius = 28,
    this.hasGavel = false,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgGradient1;
    Color bgGradient2;

    switch (avatarKey) {
      case 'sarah':
        bgGradient1 = const Color(0xFFF472B6);
        bgGradient2 = const Color(0xFFBE185D);
        break;
      case 'dave':
        bgGradient1 = const Color(0xFFFBBF24);
        bgGradient2 = const Color(0xFFB45309);
        break;
      case 'marcus':
        bgGradient1 = const Color(0xFF60A5FA);
        bgGradient2 = const Color(0xFF1D4ED8);
        break;
      case 'bot_kingpin':
        bgGradient1 = const Color(0xFFC084FC);
        bgGradient2 = const Color(0xFF6B21A8);
        break;
      case 'you':
      default:
        bgGradient1 = const Color(0xFF34D399);
        bgGradient2 = const Color(0xFF047857);
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgGradient1, bgGradient2],
            ),
            border: Border.all(
              color: isWinner ? GameColors.goldBright : GameColors.inkBorder,
              width: isWinner ? 4.0 : 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isWinner ? GameColors.goldBright.withValues(alpha: 0.6) : Colors.black38,
                blurRadius: isWinner ? 10 : 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: CustomPaint(
              painter: _AvatarFacePainter(avatarKey: avatarKey),
            ),
          ),
        ),
        if (hasGavel)
          Positioned(
            right: -6,
            bottom: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: GameColors.goldDeep,
                shape: BoxShape.circle,
                border: Border.all(color: GameColors.inkBorder, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(
                Icons.gavel_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        if (isWinner)
          Positioned(
            top: -12,
            left: radius - 12,
            child: const Icon(
              Icons.military_tech_rounded,
              color: GameColors.goldBright,
              size: 24,
            ),
          ),
      ],
    );
  }
}

class _AvatarFacePainter extends CustomPainter {
  final String avatarKey;

  _AvatarFacePainter({required this.avatarKey});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fill = Paint()..style = PaintingStyle.fill;

    if (avatarKey == 'bot_kingpin') {
      // Robot Kingpin Face
      fill.color = const Color(0xFF94A3B8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.65, height: h * 0.55),
          const Radius.circular(10),
        ),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.65, height: h * 0.55),
          const Radius.circular(10),
        ),
        stroke,
      );

      // Cyan Glowing Eyes
      fill.color = const Color(0xFF06B6D4);
      canvas.drawCircle(Offset(w * 0.38, h * 0.50), 5.5, fill);
      canvas.drawCircle(Offset(w * 0.62, h * 0.50), 5.5, fill);
      canvas.drawCircle(Offset(w * 0.38, h * 0.50), 5.5, stroke..strokeWidth = 1.5);
      canvas.drawCircle(Offset(w * 0.62, h * 0.50), 5.5, stroke..strokeWidth = 1.5);

      // Grinning Audio Grid Mouth
      stroke.strokeWidth = 2;
      canvas.drawLine(Offset(w * 0.35, h * 0.68), Offset(w * 0.65, h * 0.68), stroke);
      canvas.drawLine(Offset(w * 0.40, h * 0.64), Offset(w * 0.40, h * 0.72), stroke);
      canvas.drawLine(Offset(w * 0.50, h * 0.64), Offset(w * 0.50, h * 0.72), stroke);
      canvas.drawLine(Offset(w * 0.60, h * 0.64), Offset(w * 0.60, h * 0.72), stroke);

      // Golden Kingpin Crown
      fill.color = GameColors.goldBright;
      final crown = Path()
        ..moveTo(w * 0.30, h * 0.32)
        ..lineTo(w * 0.34, h * 0.16)
        ..lineTo(w * 0.44, h * 0.24)
        ..lineTo(w * 0.50, h * 0.12)
        ..lineTo(w * 0.56, h * 0.24)
        ..lineTo(w * 0.66, h * 0.16)
        ..lineTo(w * 0.70, h * 0.32)
        ..close();
      canvas.drawPath(crown, fill);
      canvas.drawPath(crown, stroke..strokeWidth = 2);
      return;
    }

    // Human Cheerful Faces
    fill.color = const Color(0xFFFFD1A4);
    // Face
    canvas.drawCircle(Offset(w * 0.5, h * 0.54), w * 0.34, fill);
    canvas.drawCircle(Offset(w * 0.5, h * 0.54), w * 0.34, stroke);

    if (avatarKey == 'sarah') {
      // Red Hair & Pearls
      fill.color = const Color(0xFFEA580C);
      final hair = Path()
        ..moveTo(w * 0.22, h * 0.62)
        ..quadraticBezierTo(w * 0.22, h * 0.22, w * 0.50, h * 0.22)
        ..quadraticBezierTo(w * 0.78, h * 0.22, w * 0.78, h * 0.62)
        ..quadraticBezierTo(w * 0.50, h * 0.36, w * 0.22, h * 0.62)
        ..close();
      canvas.drawPath(hair, fill);
      canvas.drawPath(hair, stroke);

      // Wink Eye + Open Eye
      stroke.strokeWidth = 2.5;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.38, h * 0.52), width: 10, height: 8),
        pi,
        pi,
        false,
        stroke,
      );
      canvas.drawCircle(Offset(w * 0.62, h * 0.50), 4.5, Paint()..color = GameColors.inkBorder);
      canvas.drawCircle(Offset(w * 0.63, h * 0.48), 1.8, Paint()..color = Colors.white);
    } else if (avatarKey == 'marcus') {
      // Sunglasses & Cool Grin
      fill.color = const Color(0xFF1E293B);
      final glasses = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.48), width: w * 0.56, height: 16),
        const Radius.circular(4),
      );
      canvas.drawRRect(glasses, fill);
      canvas.drawRRect(glasses, stroke..strokeWidth = 2);
    } else if (avatarKey == 'dave') {
      // Bowler Hat & Round Smiling Eyes
      fill.color = const Color(0xFF334155);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.32), width: w * 0.60, height: h * 0.30),
        pi,
        pi,
        true,
        fill,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.32), width: w * 0.60, height: h * 0.30),
        pi,
        pi,
        true,
        stroke,
      );
      canvas.drawLine(Offset(w * 0.16, h * 0.32), Offset(w * 0.84, h * 0.32), stroke..strokeWidth = 3);

      canvas.drawCircle(Offset(w * 0.38, h * 0.50), 4.5, Paint()..color = GameColors.inkBorder);
      canvas.drawCircle(Offset(w * 0.62, h * 0.50), 4.5, Paint()..color = GameColors.inkBorder);
    } else {
      // YOU - Cap & Sunglasses
      fill.color = const Color(0xFF047857);
      final cap = Path()
        ..moveTo(w * 0.18, h * 0.36)
        ..quadraticBezierTo(w * 0.50, h * 0.18, w * 0.82, h * 0.36)
        ..lineTo(w * 0.94, h * 0.36)
        ..close();
      canvas.drawPath(cap, fill);
      canvas.drawPath(cap, stroke);

      fill.color = const Color(0xFF0F172A);
      final glasses = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.48), width: w * 0.54, height: 14),
        const Radius.circular(3),
      );
      canvas.drawRRect(glasses, fill);
      canvas.drawRRect(glasses, stroke..strokeWidth = 2);
    }

    // Cheerful Grin for all
    final smile = Path()
      ..moveTo(w * 0.38, h * 0.66)
      ..quadraticBezierTo(w * 0.50, h * 0.76, w * 0.62, h * 0.66);
    canvas.drawPath(smile, stroke..strokeWidth = 2.8);
    // Rosy Cheeks
    final cheek = Paint()..color = const Color(0xFFFCA5A5);
    canvas.drawCircle(Offset(w * 0.30, h * 0.60), 4, cheek);
    canvas.drawCircle(Offset(w * 0.70, h * 0.60), 4, cheek);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
