import 'dart:math';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';
import 'tactile_button.dart';

enum ModeCardType {
  onlinePlay,
  localParty,
  vsBotsArena,
}

class ModeHeroCard extends StatefulWidget {
  final ModeCardType modeType;
  final VoidCallback onTap;

  const ModeHeroCard({
    super.key,
    required this.modeType,
    required this.onTap,
  });

  @override
  State<ModeHeroCard> createState() => _ModeHeroCardState();
}

class _ModeHeroCardState extends State<ModeHeroCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String subtext;
    String buttonText;
    String tagBadge;
    String imageAsset;
    List<Color> gradientColors;
    Color borderHighlight;

    switch (widget.modeType) {
      case ModeCardType.onlinePlay:
        title = 'ONLINE PLAY';
        subtext = 'Worldwide Rooms & Matchmaking';
        buttonText = 'PLAY ONLINE';
        tagBadge = '⚡ INSTANT QUEUE';
        imageAsset = 'assets/modes/art_online.jpg';
        gradientColors = const [
          Color(0xFF38BDF8),
          Color(0xFF0284C7),
          Color(0xFF0C4A6E),
          Color(0xFF082F49),
        ];
        borderHighlight = const Color(0xFF7DD3FC);
        break;

      case ModeCardType.localParty:
        title = 'LOCAL PARTY';
        subtext = 'Wi-Fi Hotspot & Nearby LAN';
        buttonText = 'HOST OR JOIN PARTY';
        tagBadge = '📶 NO INTERNET NEEDED';
        imageAsset = 'assets/modes/art_local.jpg';
        gradientColors = const [
          Color(0xFF4ADE80),
          Color(0xFF16A34A),
          Color(0xFF14532D),
          Color(0xFF052E16),
        ];
        borderHighlight = const Color(0xFF86EFAC);
        break;

      case ModeCardType.vsBotsArena:
        title = 'VS BOTS ARENA';
        subtext = 'Solo Match vs Smart AI Bidders';
        buttonText = 'CHOOSE BOTS & PLAY';
        tagBadge = '👑 KINGPIN ARENA';
        imageAsset = 'assets/modes/art_bots.jpg';
        gradientColors = const [
          Color(0xFFFB7185),
          Color(0xFFDC2626),
          Color(0xFF991B1B),
          Color(0xFF450A0A),
        ];
        borderHighlight = const Color(0xFFFECDD3);
        break;
    }

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            SoundService.instance.playClick();
            widget.onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: _isHovered ? 2 : 6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: _isHovered ? GameColors.goldBright : GameColors.inkBorder,
                width: 5.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isHovered ? GameColors.goldBright : Colors.black)
                      .withValues(alpha: _isHovered ? 0.45 : 0.60),
                  blurRadius: _isHovered ? 24 : 14,
                  offset: Offset(0, _isHovered ? 10 : 6),
                ),
                BoxShadow(
                  color: borderHighlight.withValues(alpha: 0.35),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Comic Sunburst Background Rays
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ComicRaysPainter(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),

                  // Top Glass Gloss Highlight Sweep
                  Positioned(
                    top: 8,
                    left: 16,
                    right: 16,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.35),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Upper Corner Feature Pill
                  Positioned(
                    top: 12,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: GameColors.inkBorder.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: GameColors.goldBright.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        tagBadge,
                        style: const TextStyle(
                          color: GameColors.goldBright,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),

                  // Main Content Column
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.3,
                            shadows: [
                              Shadow(color: GameColors.inkBorder, offset: Offset(2, 2)),
                              Shadow(color: GameColors.inkBorder, offset: Offset(-1, -1)),
                              Shadow(color: GameColors.inkBorder, offset: Offset(1, -1)),
                              Shadow(color: GameColors.inkBorder, offset: Offset(-1, 1)),
                              Shadow(color: Colors.black54, offset: Offset(0, 3), blurRadius: 4),
                            ],
                          ),
                        ),

                        const SizedBox(height: 2),

                        // Subtext
                        Text(
                          subtext,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // High-Impact Cel-Shaded Cartoon Artwork Window (Real Cartoon Art - No Stick Figures!)
                        Expanded(
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                final scale = _isHovered ? 1.03 : 1.0;
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 320,
                                  maxHeight: 250,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: GameColors.inkBorder,
                                    width: 4.5,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x88000000),
                                      blurRadius: 14,
                                      offset: Offset(0, 6),
                                    ),
                                    BoxShadow(
                                      color: Color(0x33FFFFFF),
                                      blurRadius: 2,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Real Cel-Shaded Cartoon Hero Illustration
                                      Image.asset(
                                        imageAsset,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Center(
                                          child: Icon(Icons.broken_image_rounded, size: 40),
                                        ),
                                      ),

                                      // Inner Corner Vignette / Shadow
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black.withValues(alpha: 0.25),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(13),
                                        ),
                                      ),

                                      // Top Glass Glare Triangle
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        height: 35,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white.withValues(alpha: 0.25),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Bottom Tag: Chunky Tactile Yellow Pill Button
                        TactileButton(
                          onTap: widget.onTap,
                          baseColor: GameColors.goldBright,
                          shadowColor: GameColors.brassShadow,
                          height: 50,
                          borderRadius: 22,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.modeType == ModeCardType.onlinePlay
                                        ? Icons.public_rounded
                                        : widget.modeType == ModeCardType.localParty
                                            ? Icons.wifi_tethering_rounded
                                            : Icons.sports_kabaddi_rounded,
                                    color: GameColors.inkBorder,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    buttonText,
                                    style: const TextStyle(
                                      color: GameColors.inkBorder,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),
                      ],
                    ),
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

/// Dynamic Comic Background Sunburst Rays
class _ComicRaysPainter extends CustomPainter {
  final Color color;

  _ComicRaysPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.45;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const numRays = 16;
    const angleStep = 2 * pi / numRays;
    final radius = max(size.width, size.height);

    for (int i = 0; i < numRays; i += 2) {
      final startAngle = i * angleStep;
      final path = Path()
        ..moveTo(cx, cy)
        ..lineTo(cx + cos(startAngle) * radius, cy + sin(startAngle) * radius)
        ..lineTo(cx + cos(startAngle + angleStep) * radius, cy + sin(startAngle + angleStep) * radius)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ComicRaysPainter oldDelegate) => false;
}
