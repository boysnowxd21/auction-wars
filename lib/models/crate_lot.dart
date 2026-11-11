import 'dart:math';
import 'card_data.dart';

class CrateModel {
  final int index;
  final String label;
  final String hintTag;
  final List<AuctionCard> cards;
  bool isXRayed;
  bool isRevealed;

  CrateModel({
    required this.index,
    required this.label,
    required this.hintTag,
    required this.cards,
    this.isXRayed = false,
    this.isRevealed = false,
  });

  int get totalValue => cards.fold(0, (sum, c) => sum + c.value);
}

class CrateLot {
  final int round;
  final List<CrateModel> crates;
  final String venueName;

  CrateLot({
    required this.round,
    required this.crates,
    this.venueName = 'Port Harbor Docks',
  });

  int get totalLotValue => crates.fold(0, (sum, c) => sum + c.totalValue);

  static CrateLot generateRandomLot(int round, [Random? rng]) {
    final rand = rng ?? Random();
    final venues = ['Port Harbor Docks', 'Syndicate Underground', 'High-Roller Vault'];
    final venue = venues[(round - 1) % venues.length];

    final tags = [
      'TAG: HEAVY',
      'TAG: GEMS',
      'TAG: SUSPECT',
      'TAG: ANTIQUE',
      'TAG: TECH',
      'TAG: LUXURY',
      'TAG: WEAPON',
      'TAG: FRAGILE',
      'TAG: BULLION',
    ];

    final positivePool = CardDatabase.positiveAssets;
    final junkPool = CardDatabase.junkHazards;

    final List<CrateModel> generatedCrates = [];
    final labels = ['CRATE A', 'CRATE B', 'CRATE C'];

    for (int i = 0; i < 3; i++) {
      final List<AuctionCard> crateCards = [];
      // 60% chance positive, 40% chance junk
      final isPos = rand.nextDouble() < 0.65;
      if (isPos && positivePool.isNotEmpty) {
        crateCards.add(positivePool[rand.nextInt(positivePool.length)]);
      } else if (junkPool.isNotEmpty) {
        crateCards.add(junkPool[rand.nextInt(junkPool.length)]);
      }

      // 25% chance of 2nd card in crate
      if (rand.nextDouble() < 0.28) {
        if (rand.nextBool() && positivePool.isNotEmpty) {
          crateCards.add(positivePool[rand.nextInt(positivePool.length)]);
        } else if (junkPool.isNotEmpty) {
          crateCards.add(junkPool[rand.nextInt(junkPool.length)]);
        }
      }

      final tag = tags[rand.nextInt(tags.length)];
      generatedCrates.add(CrateModel(
        index: i,
        label: labels[i],
        hintTag: tag,
        cards: crateCards,
      ));
    }

    return CrateLot(
      round: round,
      crates: generatedCrates,
      venueName: venue,
    );
  }
}
