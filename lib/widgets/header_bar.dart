import 'dart:math';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';
import 'tactile_button.dart';

class HomeHeaderBar extends StatefulWidget {
  final VoidCallback onLeaderboardTap;
  final VoidCallback onSettingsTap;

  const HomeHeaderBar({
    super.key,
    required this.onLeaderboardTap,
    required this.onSettingsTap,
  });

  @override
  State<HomeHeaderBar> createState() => _HomeHeaderBarState();
}

class _HomeHeaderBarState extends State<HomeHeaderBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _gavelController;
  late Animation<double> _gavelAngleAnimation;
  late Animation<double> _sparkScaleAnimation;

  @override
  void initState() {
    super.initState();
    _gavelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);

    _gavelAngleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.35), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -0.35, end: 0.08), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 45),
    ]).animate(CurvedAnimation(parent: _gavelController, curve: Curves.easeInOut));

    _sparkScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 25),
    ]).animate(_gavelController);
  }

  @override
  void dispose() {
    _gavelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 1200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Tactile Golden Button [TOP 100 LEADERBOARD]
                TactileButton(
                  onTap: widget.onLeaderboardTap,
                  baseColor: GameColors.goldBright,
                  shadowColor: GameColors.brassShadow,
                  height: 52,
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: GameColors.brassShadow,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white70, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: GameColors.goldBright,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'TOP 100 LEADERBOARD',
                        style: TextStyle(
                          color: GameColors.inkBorder,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Center: Large 3D Carved Wooden Block Logo "AUCTION WARS" with Animated Gavel Strike
                _buildCenterLogo(),

                const Spacer(),

                // Right: Polished Wooden Toggles for Sound/SFX and Settings
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildWoodCircleButton(
                      icon: SoundService.instance.isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      tooltip: 'Sound FX',
                      onTap: () {
                        setState(() {
                          SoundService.instance.toggleSound();
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildWoodCircleButton(
                      icon: Icons.settings_rounded,
                      tooltip: 'Settings',
                      onTap: widget.onSettingsTap,
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

  Widget _buildCenterLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Auction Gavel Striking Sound Block
            AnimatedBuilder(
              animation: _gavelController,
              builder: (context, child) {
                return SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Impact Spark Lines
                      Transform.scale(
                        scale: _sparkScaleAnimation.value,
                        child: CustomPaint(
                          size: const Size(44, 44),
                          painter: _ImpactSparksPainter(),
                        ),
                      ),
                      // Sound Block at bottom
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 32,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF451A03),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: GameColors.inkBorder, width: 2),
                          ),
                        ),
                      ),
                      // Gavel
                      Positioned(
                        top: 2,
                        child: Transform.rotate(
                          angle: _gavelAngleAnimation.value,
                          alignment: const Alignment(-0.5, 0.8),
                          child: const Icon(
                            Icons.gavel_rounded,
                            color: GameColors.goldBright,
                            size: 34,
                            shadows: [
                              Shadow(color: GameColors.inkBorder, offset: Offset(2, 2)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(width: 8),

            // "AUCTION WARS" 3D Block Text
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFBEB),
                    Color(0xFFFDE047),
                    Color(0xFFF59E0B),
                    Color(0xFFD97706),
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                'AUCTION WARS',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'sans-serif-black',
                  letterSpacing: 2.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Color(0xFF1E1005), offset: Offset(3, 3), blurRadius: 0),
                    Shadow(color: Color(0xFF1E1005), offset: Offset(-1, -1), blurRadius: 0),
                    Shadow(color: Color(0xFFB45309), offset: Offset(0, 4), blurRadius: 2),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Subtext: HIGH BIDS • SEALED CRATES • QUICK FLIPS
        Container(
          margin: const EdgeInsets.only(top: 1),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF26140B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GameColors.goldOrange, width: 1.5),
            boxShadow: const [
              BoxShadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 4),
            ],
          ),
          child: const Text(
            'HIGH BIDS • SEALED CRATES • QUICK FLIPS',
            style: TextStyle(
              color: GameColors.goldBright,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWoodCircleButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return TactileButton(
      onTap: onTap,
      width: 48,
      height: 48,
      borderRadius: 24,
      padding: EdgeInsets.zero,
      baseColor: GameColors.oakLight,
      shadowColor: GameColors.oakBorder,
      highlightColor: GameColors.oakHighlight,
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

class _ImpactSparksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GameColors.goldBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2 + 6);
    const count = 6;
    for (int i = 0; i < count; i++) {
      final angle = -pi + (i * pi / (count - 1));
      final p1 = Offset(center.dx + cos(angle) * 10, center.dy + sin(angle) * 8);
      final p2 = Offset(center.dx + cos(angle) * 20, center.dy + sin(angle) * 16);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
