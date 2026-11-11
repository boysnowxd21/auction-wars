import 'package:flutter/material.dart';

class GameColors {
  // Oak Wood Frame & Panels
  static const Color oakDark = Color(0xFF26140B);
  static const Color oakBorder = Color(0xFF150A05);
  static const Color oakMedium = Color(0xFF4A2511);
  static const Color oakLight = Color(0xFF7A401E);
  static const Color oakHighlight = Color(0xFFB56530);

  // Parchment Canvas
  static const Color parchmentLight = Color(0xFFFBF6E9);
  static const Color parchmentBase = Color(0xFFF4ECCF);
  static const Color parchmentShadow = Color(0xFFDECEA1);

  // Sage Green Poker Felt
  static const Color feltDark = Color(0xFF143823);
  static const Color feltBase = Color(0xFF1F5234);
  static const Color feltLight = Color(0xFF2D734B);
  static const Color feltHighlight = Color(0xFF3EA369);

  // Gold & Brass Accents
  static const Color goldBright = Color(0xFFFFD700);
  static const Color goldDeep = Color(0xFFF59E0B);
  static const Color goldOrange = Color(0xFFD97706);
  static const Color brassShadow = Color(0xFF78350F);

  // Vibrant Gameplay Action Colors
  static const Color greenMoney = Color(0xFF10B981);
  static const Color greenDark = Color(0xFF047857);
  static const Color redHazard = Color(0xFFEF4444);
  static const Color redDark = Color(0xFF991B1B);
  static const Color blueOps = Color(0xFF0EA5E9);
  static const Color blueDark = Color(0xFF0369A1);
  static const Color yellowPill = Color(0xFFFACC15);
  static const Color yellowPillDark = Color(0xFFCA8A04);

  // Ink Outline & Shadows
  static const Color inkBorder = Color(0xFF110C08);
  static const Color deepShadow = Color(0x66000000);
}

class GameTheme {
  static const double inkStrokeWidth = 3.5;
  static const double cardInkStroke = 3.0;

  static BoxDecoration cartoonFrameDeco = BoxDecoration(
    color: GameColors.oakMedium,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: GameColors.oakBorder, width: 6),
    boxShadow: const [
      BoxShadow(
        color: Color(0x88000000),
        blurRadius: 18,
        offset: Offset(0, 10),
      ),
      BoxShadow(
        color: GameColors.oakHighlight,
        blurRadius: 2,
        offset: Offset(0, -2),
      ),
    ],
  );

  static BoxDecoration woodPanelDeco = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [GameColors.oakLight, GameColors.oakMedium, GameColors.oakDark],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: GameColors.oakBorder, width: 3.5),
    boxShadow: const [
      BoxShadow(
        color: Color(0x4D000000),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration parchmentDeco = BoxDecoration(
    gradient: const RadialGradient(
      center: Alignment(0.0, -0.2),
      radius: 0.9,
      colors: [
        GameColors.parchmentLight,
        GameColors.parchmentBase,
        GameColors.parchmentShadow,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: GameColors.oakBorder, width: 3.5),
  );

  static BoxDecoration greenMoneyPillDeco = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF34D399), GameColors.greenMoney, GameColors.greenDark],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: GameColors.inkBorder, width: 2.5),
    boxShadow: const [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration goldMoneyPillDeco = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFDE047), GameColors.goldDeep, GameColors.goldOrange],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: GameColors.inkBorder, width: 2.5),
    boxShadow: const [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration redPillDeco = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF87171), GameColors.redHazard, GameColors.redDark],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: GameColors.inkBorder, width: 2.5),
    boxShadow: const [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration bluePillDeco = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF38BDF8), GameColors.blueOps, GameColors.blueDark],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: GameColors.inkBorder, width: 2.5),
    boxShadow: const [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static TextStyle headerTitleStyle = const TextStyle(
    color: Color(0xFFFFFBEB),
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    shadows: [
      Shadow(color: GameColors.inkBorder, offset: Offset(2, 2), blurRadius: 0),
      Shadow(color: GameColors.inkBorder, offset: Offset(-1, -1), blurRadius: 0),
    ],
  );

  static TextStyle badgeTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.8,
    shadows: [
      Shadow(color: GameColors.inkBorder, offset: Offset(1.5, 1.5), blurRadius: 0),
    ],
  );
}
