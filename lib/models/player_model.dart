import 'card_data.dart';

enum AiDifficulty {
  easy,
  medium,
  kingpin,
}

class PlayerModel {
  final String id;
  final String name;
  final bool isUser;
  final String avatarKey;
  int bidMoney;
  int itemMoney;
  int debt;
  final List<AuctionCard> stash;
  final List<AuctionCard> opsHand;
  bool isFolded;
  bool hasHammer;
  String? speechBubble;
  final AiDifficulty aiDifficulty;
  final String title;

  PlayerModel({
    required this.id,
    required this.name,
    required this.isUser,
    required this.avatarKey,
    this.bidMoney = 2500,
    this.itemMoney = 0,
    this.debt = 0,
    List<AuctionCard>? stash,
    List<AuctionCard>? opsHand,
    this.isFolded = false,
    this.hasHammer = false,
    this.speechBubble,
    this.aiDifficulty = AiDifficulty.medium,
    this.title = 'Challenger',
  })  : stash = stash ?? [],
        opsHand = opsHand ?? [];

  int get netWorth => bidMoney + itemMoney - debt;

  bool pawnCard(AuctionCard card) {
    if (!stash.contains(card)) return false;
    if (card.value <= 0) return false;
    final payout = card.pawnValue;
    stash.remove(card);
    bidMoney += payout;
    itemMoney -= card.value;
    if (itemMoney < 0) itemMoney = 0;
    return true;
  }

  void borrowSharkLoan(int amount) {
    bidMoney += amount;
    // 25% shark fee
    debt += (amount * 1.25).toInt();
  }

  bool repayDebt(int amount) {
    if (bidMoney < amount || debt <= 0) return false;
    final actualRepay = amount > debt ? debt : amount;
    bidMoney -= actualRepay;
    debt -= actualRepay;
    return true;
  }

  void resetForNewLot() {
    isFolded = false;
    speechBubble = null;
    hasHammer = false;
  }
}
