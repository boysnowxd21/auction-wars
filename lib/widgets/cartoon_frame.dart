import 'package:flutter/material.dart';
import '../theme/game_theme.dart';

class CartoonPictureFrame extends StatelessWidget {
  final Widget child;

  const CartoonPictureFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF190C05), // Darkest outer oak
      ),
      child: CustomPaint(
        painter: _BeveledOakFramePainter(),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: GameColors.oakBorder,
                width: 4.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x77000000),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Color(0x40FFFFFF),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Warm Auction Showroom Gallery Architecture
                  Positioned.fill(
                    child: Image.asset(
                      'assets/ui/auction_showroom_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 2. Sunlit Cream-and-Parchment Overlay with rich cel-shaded warm vignette
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.35),
                          radius: 1.15,
                          colors: [
                            const Color(0xFFFFFBEB).withValues(alpha: 0.85),
                            const Color(0xFFFEF3C7).withValues(alpha: 0.89),
                            const Color(0xFFB45309).withValues(alpha: 0.78),
                          ],
                          stops: const [0.0, 0.60, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // 3. Inner Decorative Golden Board Rim Line
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: GameColors.goldDeep.withValues(alpha: 0.4),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  // 4. Main Foreground Canvas Content
                  Positioned.fill(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BeveledOakFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Dark Oak Frame Bevels
    final oakLightPaint = Paint()..color = const Color(0xFF5E2E14);
    final oakHighlight = Paint()..color = const Color(0xFF8B471F);
    final inkBorder = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Top Bevel Rim
    final topBevel = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w - 22, 22)
      ..lineTo(22, 22)
      ..close();
    canvas.drawPath(topBevel, oakHighlight);
    canvas.drawPath(topBevel, inkBorder);

    // Bottom Bevel Rim (Shadowed)
    final bottomBevel = Path()
      ..moveTo(0, h)
      ..lineTo(w, h)
      ..lineTo(w - 22, h - 22)
      ..lineTo(22, h - 22)
      ..close();
    canvas.drawPath(bottomBevel, Paint()..color = const Color(0xFF2E1307));
    canvas.drawPath(bottomBevel, inkBorder);

    // Left Bevel Rim
    final leftBevel = Path()
      ..moveTo(0, 0)
      ..lineTo(22, 22)
      ..lineTo(22, h - 22)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(leftBevel, oakLightPaint);
    canvas.drawPath(leftBevel, inkBorder);

    // Right Bevel Rim
    final rightBevel = Path()
      ..moveTo(w, 0)
      ..lineTo(w - 22, 22)
      ..lineTo(w - 22, h - 22)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(rightBevel, Paint()..color = const Color(0xFF3B1A0A));
    canvas.drawPath(rightBevel, inkBorder);

    // Corner Brass Brackets & Rivets
    _drawCornerBrassBracket(canvas, const Offset(0, 0), 0);
    _drawCornerBrassBracket(canvas, Offset(w, 0), 1);
    _drawCornerBrassBracket(canvas, Offset(w, h), 2);
    _drawCornerBrassBracket(canvas, Offset(0, h), 3);
  }

  void _drawCornerBrassBracket(Canvas canvas, Offset corner, int rotationQuarter) {
    canvas.save();
    canvas.translate(corner.dx, corner.dy);
    canvas.rotate(rotationQuarter * 3.14159 / 2);

    final brassPaint = Paint()..color = GameColors.goldDeep;
    final stroke = Paint()
      ..color = GameColors.inkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final bracket = Path()
      ..moveTo(0, 0)
      ..lineTo(48, 0)
      ..lineTo(48, 16)
      ..lineTo(16, 16)
      ..lineTo(16, 48)
      ..lineTo(0, 48)
      ..close();

    canvas.drawPath(bracket, brassPaint);
    canvas.drawPath(bracket, stroke);

    // Shiny Brass Rivets
    _drawRivet(canvas, const Offset(10, 10));
    _drawRivet(canvas, const Offset(32, 8));
    _drawRivet(canvas, const Offset(8, 32));

    canvas.restore();
  }

  void _drawRivet(Canvas canvas, Offset offset) {
    canvas.drawCircle(offset, 4, Paint()..color = GameColors.goldBright);
    canvas.drawCircle(
      offset,
      4,
      Paint()
        ..color = GameColors.inkBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(offset.dx - 1, offset.dy - 1), 1.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
