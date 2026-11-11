import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';

class BottomVaultBanner extends StatefulWidget {
  final VoidCallback onTap;

  const BottomVaultBanner({
    super.key,
    required this.onTap,
  });

  @override
  State<BottomVaultBanner> createState() => _BottomVaultBannerState();
}

class _BottomVaultBannerState extends State<BottomVaultBanner> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
          duration: const Duration(milliseconds: 150),
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF381502),
                Color(0xFF78350F),
                Color(0xFF381502),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered ? GameColors.goldBright : GameColors.goldOrange,
              width: 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? GameColors.goldBright.withValues(alpha: 0.55)
                    : Colors.black.withValues(alpha: 0.45),
                blurRadius: _isHovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left: Illustrated Treasure Chest / Velvet Bag of Gold Coins
              Container(
                width: 52,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GameColors.goldBright, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/cards/Velvet Bag of Gold Coins.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Center: Banner Text (FittedBox scales down cleanly)
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.auto_stories_rounded,
                            color: GameColors.goldBright,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFFFFBEB), GameColors.goldBright],
                            ).createShader(bounds),
                            child: const Text(
                              'VAULT & CARD COMPENDIUM (111 CARDS)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                                shadows: [
                                  Shadow(
                                    color: GameColors.inkBorder,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'TAP TO INSPECT HIGH-VALUE ASSETS • TOXIC HAZARDS • SPECIAL OPS',
                        style: TextStyle(
                          color: Colors.amber.shade200,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Right: Real Illustrated Cherry-Red Muscle Car
              Container(
                width: 52,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GameColors.goldBright, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/cards/Vintage Muscle Car.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

