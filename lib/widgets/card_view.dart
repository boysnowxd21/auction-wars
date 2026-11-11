import 'package:flutter/material.dart';
import '../models/card_data.dart';
import '../theme/game_theme.dart';

class AuctionCardWidget extends StatelessWidget {
  final AuctionCard card;
  final double width;
  final double height;
  final bool isSelected;
  final VoidCallback? onTap;

  const AuctionCardWidget({
    super.key,
    required this.card,
    this.width = 175,
    this.height = 250,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBg;
    Color headerBg;
    Color badgeColor;
    String badgeText;
    IconData categoryIcon;

    switch (card.cardType) {
      case CardType.positive:
        cardBg = const Color(0xFFFEFCE8);
        headerBg = const Color(0xFF15803D);
        badgeColor = GameColors.greenMoney;
        badgeText = '+\$${card.value} • Pawn: +\$${card.pawnValue}';
        categoryIcon = _getCategoryIcon(card.category);
        break;

      case CardType.junk:
        cardBg = const Color(0xFFF3F4F6);
        headerBg = card.value < 0 ? const Color(0xFFB91C1C) : const Color(0xFF4B5563);
        badgeColor = card.value < 0 ? GameColors.redHazard : const Color(0xFF6B7280);
        badgeText = card.value < 0
            ? 'Fee: -\$${card.value.abs()}'
            : '\$0 Hoarder Scrap';
        categoryIcon = _getCategoryIcon(card.category);
        break;

      case CardType.specialOps:
        cardBg = const Color(0xFFF0F9FF);
        headerBg = const Color(0xFF0369A1);
        badgeColor = GameColors.blueOps;
        badgeText = card.actionWindow;
        categoryIcon = Icons.bolt_rounded;
        break;
    }

    final isMini = height < 145;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? GameColors.goldBright : GameColors.inkBorder,
            width: isSelected ? 4.5 : 3.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? GameColors.goldBright.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.35),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Header Banner: Item Name with Category Icon
              Container(
                height: isMini ? 24 : 34,
                padding: EdgeInsets.symmetric(horizontal: isMini ? 4 : 8),
                decoration: BoxDecoration(
                  color: headerBg,
                  border: Border(
                    bottom: BorderSide(
                      color: GameColors.inkBorder,
                      width: isMini ? 1.5 : 2.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(categoryIcon, color: Colors.white, size: isMini ? 12 : 16),
                    SizedBox(width: isMini ? 4 : 6),
                    Expanded(
                      child: Text(
                        card.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMini ? 9.5 : 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Illustration Window: Cel-shaded Cartoon Vector Drawing from PNG
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(isMini ? 3 : 6),
                  child: Center(
                    child: Image.asset(
                      card.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.amber.shade100,
                          child: Center(
                            child: Icon(categoryIcon, size: isMini ? 24 : 36, color: headerBg),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 3. Value / Action Badge
              Container(
                margin: EdgeInsets.symmetric(horizontal: isMini ? 4 : 8, vertical: isMini ? 1.5 : 3),
                padding: EdgeInsets.symmetric(vertical: isMini ? 1.5 : 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(isMini ? 6 : 10),
                  border: Border.all(color: GameColors.inkBorder, width: isMini ? 1.5 : 2),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMini ? 8.5 : 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                      shadows: const [
                        Shadow(color: GameColors.inkBorder, offset: Offset(1, 1)),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Bottom Text Box: Clean Description of Special Rules
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: isMini ? 4 : 8, vertical: isMini ? 2 : 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF5E6),
                    border: Border(
                      top: BorderSide(color: GameColors.inkBorder, width: isMini ? 1.5 : 2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      card.description,
                      maxLines: isMini ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GameColors.inkBorder,
                        fontSize: isMini ? 8.0 : 9.5,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'gems':
        return Icons.diamond_rounded;
      case 'bullion':
        return Icons.monetization_on_rounded;
      case 'fragile':
        return Icons.broken_image_rounded;
      case 'heavy':
        return Icons.fitness_center_rounded;
      case 'luxury':
        return Icons.watch_rounded;
      case 'tech':
        return Icons.memory_rounded;
      case 'antique':
        return Icons.history_edu_rounded;
      case 'weapon':
        return Icons.shield_rounded;
      case 'suspect':
        return Icons.warning_amber_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
