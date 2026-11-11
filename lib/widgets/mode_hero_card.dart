import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';
import 'tactile_button.dart';

enum ModeCardType {
  onlinePlay,
  localParty,
  vsBotsArena,
}

/// Mode Hero Card with Full-Bleed Edge-to-Edge 3D Cartoon Cover Art
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
    Color themeColor;
    Color themeDark;

    switch (widget.modeType) {
      case ModeCardType.onlinePlay:
        title = 'ONLINE PLAY';
        subtext = 'Worldwide Rooms & Matchmaking';
        buttonText = 'PLAY ONLINE';
        tagBadge = '⚡ INSTANT QUEUE';
        imageAsset = 'assets/modes/art_online.jpg';
        themeColor = const Color(0xFF0284C7);
        themeDark = const Color(0xFF082F49);
        break;

      case ModeCardType.localParty:
        title = 'LOCAL PARTY';
        subtext = 'Wi-Fi Hotspot & Nearby LAN';
        buttonText = 'HOST OR JOIN PARTY';
        tagBadge = '📶 NO INTERNET NEEDED';
        imageAsset = 'assets/modes/art_local.jpg';
        themeColor = const Color(0xFF16A34A);
        themeDark = const Color(0xFF052E16);
        break;

      case ModeCardType.vsBotsArena:
        title = 'VS BOTS ARENA';
        subtext = 'Solo Match vs Smart AI Bidders';
        buttonText = 'CHOOSE BOTS & PLAY';
        tagBadge = '👑 KINGPIN ARENA';
        imageAsset = 'assets/modes/art_bots.jpg';
        themeColor = const Color(0xFFDC2626);
        themeDark = const Color(0xFF450A0A);
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
              color: themeDark,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: _isHovered ? GameColors.goldBright : GameColors.inkBorder,
                width: 5.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isHovered ? GameColors.goldBright : Colors.black)
                      .withValues(alpha: _isHovered ? 0.60 : 0.65),
                  blurRadius: _isHovered ? 26 : 14,
                  offset: Offset(0, _isHovered ? 10 : 6),
                ),
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.45),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. FULL-BLEED 3D CARTOON COVER ARTWORK
                  AnimatedScale(
                    scale: _isHovered ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: themeDark,
                        child: const Center(
                          child: Icon(Icons.broken_image_rounded, size: 40, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),

                  // 2. GRADIENT SCRIM OVERLAYS (Ensures 100% crystal-clear readability for headers & buttons)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            themeDark.withValues(alpha: 0.92),
                            themeDark.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                            themeDark.withValues(alpha: 0.95),
                          ],
                          stops: const [0.0, 0.22, 0.45, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // 3. DIAGONAL GLASS GLARE SHEEN
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GlassGlarePainter(),
                    ),
                  ),

                  // 4. UPPER CORNER FEATURE PILL
                  Positioned(
                    top: 12,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.70),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: GameColors.goldBright,
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        tagBadge,
                        style: const TextStyle(
                          color: GameColors.goldBright,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  // 5. MAIN CONTENT COLUMN (Overlaid stylishly on top of full-bleed art)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 6),

                        // Big 3D Bold Mode Title
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Color(0xFFFFFBEB),
                                Color(0xFFFDE047),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                                shadows: [
                                  Shadow(color: GameColors.inkBorder, offset: Offset(2, 2)),
                                  Shadow(color: GameColors.inkBorder, offset: Offset(-1, -1)),
                                  Shadow(color: GameColors.inkBorder, offset: Offset(1, -1)),
                                  Shadow(color: GameColors.inkBorder, offset: Offset(-1, 1)),
                                  Shadow(color: Colors.black87, offset: Offset(0, 4), blurRadius: 6),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 3),

                        // Subtext pill
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.60),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: Text(
                              subtext,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),

                        // Expanded area keeps the beautiful 3D artwork visible
                        const Spacer(),

                        // 6. BOTTOM TAG: CHUNKY TACTILE YELLOW PILL BUTTON
                        TactileButton(
                          onTap: widget.onTap,
                          baseColor: GameColors.goldBright,
                          shadowColor: GameColors.brassShadow,
                          height: 48,
                          borderRadius: 20,
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
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    buttonText,
                                    style: const TextStyle(
                                      color: GameColors.inkBorder,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),
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

/// Diagonal Glass Sheen Glare Effect
class _GlassGlarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-0.8, -1.0),
        end: const Alignment(0.8, 1.0),
        colors: [
          Colors.white.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.45, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.70, 0)
      ..lineTo(size.width * 0.15, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
