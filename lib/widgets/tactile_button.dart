import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';

class TactileButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color baseColor;
  final Color shadowColor;
  final Color highlightColor;
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool enabled;

  const TactileButton({
    super.key,
    required this.child,
    this.onTap,
    this.baseColor = GameColors.goldDeep,
    this.shadowColor = GameColors.brassShadow,
    this.highlightColor = GameColors.goldBright,
    this.height = 48,
    this.width,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.enabled = true,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = widget.enabled && widget.onTap != null;
    final depth = _isPressed ? 2.0 : 5.0;

    return MouseRegion(
      cursor: effectiveEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: effectiveEnabled
            ? (_) {
                setState(() => _isPressed = true);
                SoundService.instance.playClick();
              }
            : null,
        onTapUp: effectiveEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: effectiveEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: effectiveEnabled
            ? () {
                setState(() => _isPressed = false);
                widget.onTap?.call();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          height: widget.height,
          width: widget.width,
          margin: EdgeInsets.only(top: _isPressed ? 3.0 : 0.0),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: effectiveEnabled ? widget.baseColor : Colors.grey.shade600,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: GameColors.inkBorder,
              width: GameTheme.inkStrokeWidth,
            ),
            boxShadow: effectiveEnabled
                ? [
                    BoxShadow(
                      color: widget.shadowColor,
                      offset: Offset(0, depth),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      offset: Offset(0, depth + 2),
                      blurRadius: 4,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      offset: const Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
