import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auction_wars_flutter/main.dart';

void main() {
  testWidgets('Auction Wars App boots and loads Home Screen successfully',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Main Logo and Header Elements
    expect(find.text('AUCTION WARS'), findsOneWidget);
    expect(find.text('TOP 100 LEADERBOARD'), findsOneWidget);

    // Verify 3 Hero Mode Cards
    expect(find.text('ONLINE PLAY'), findsOneWidget);
    expect(find.text('LOCAL PARTY'), findsOneWidget);
    expect(find.text('VS BOTS ARENA'), findsOneWidget);

    // Verify Bottom Banner
    expect(find.text('VAULT & CARD COMPENDIUM (111 CARDS)'), findsOneWidget);
  });

  testWidgets('Tapping VS BOTS ARENA opens modal and starts Arena match',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap on VS BOTS ARENA button
    await tester.tap(find.text('CHOOSE BOTS & PLAY'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Modal is visible
    expect(find.text('VS BOTS ARENA SETUP'), findsOneWidget);
    expect(find.text('START ARENA MATCH'), findsOneWidget);

    // Tap START ARENA MATCH
    await tester.tap(find.text('START ARENA MATCH'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Game Screen loaded
    expect(find.textContaining('ROUND: 1'), findsOneWidget);
    expect(find.textContaining('BID MONEY:'), findsOneWidget);
    expect(find.textContaining('ITEM MONEY:'), findsOneWidget);
    expect(find.text('PASS / FOLD'), findsOneWidget);
  });

  testWidgets('Tapping ONLINE PLAY opens Online Modal and can start match',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap on PLAY ONLINE
    await tester.tap(find.text('PLAY ONLINE'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Online Play Modal
    expect(find.text('ONLINE PLAY SETUP'), findsOneWidget);
    expect(find.textContaining('QUICK MATCHMAKING QUEUE'), findsOneWidget);

    // Tap Quick Matchmaking
    await tester.tap(find.textContaining('QUICK MATCHMAKING QUEUE'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Game Screen loaded
    expect(find.textContaining('ROUND: 1'), findsOneWidget);
  });

  testWidgets('Tapping LOCAL PARTY opens Local Party Modal and tabs work',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap on HOST OR JOIN PARTY
    await tester.tap(find.text('HOST OR JOIN PARTY'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Local Party Modal
    expect(find.text('LOCAL PARTY (WI-FI & LAN)'), findsOneWidget);
    expect(find.text('HOST HOTSPOT ROOM'), findsOneWidget);
    expect(find.text('SEARCH LAN ROOMS'), findsOneWidget);

    // Switch Tab to SEARCH LAN ROOMS
    await tester.tap(find.text('SEARCH LAN ROOMS'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('SCANNING LOCAL SUBNET...'), findsOneWidget);

    // Launch Match
    await tester.tap(find.text('LAUNCH HOTSPOT MATCH'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Game Screen loaded
    expect(find.textContaining('ROUND: 1'), findsOneWidget);
  });

  testWidgets('Tapping Compendium banner opens 111-card compendium modal',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Vault Banner
    await tester.tap(find.text('VAULT & CARD COMPENDIUM (111 CARDS)'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Modal
    expect(find.text('ALL (111)'), findsOneWidget);
    expect(find.text('ASSETS (50)'), findsOneWidget);
    expect(find.text('JUNK (50)'), findsOneWidget);
    expect(find.text('OPS (11)'), findsOneWidget);
  });

  testWidgets('Tapping TOP 100 LEADERBOARD opens leaderboard modal',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Leaderboard Button
    await tester.tap(find.text('TOP 100 LEADERBOARD'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Modal
    expect(find.text('TOP 100 AUCTION LEADERBOARD'), findsOneWidget);
    expect(find.text('Kingpin Victor'), findsOneWidget);
  });

  testWidgets('VS BOTS ARENA difficulty slider ticks switch modes and launch cleanly on compact landscape',
      (WidgetTester tester) async {
    // Test on a compact tablet/phone landscape resolution (e.g. 960x540)
    tester.view.physicalSize = const Size(960, 540);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap on VS BOTS ARENA button
    await tester.tap(find.text('CHOOSE BOTS & PLAY'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify initial slider state is Medium
    expect(find.text('MEDIUM AI BIDDERS'), findsOneWidget);

    // Tap Kingpin tick
    await tester.tap(find.text('KINGPIN 👑'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('KINGPIN BOSS AI 👑'), findsOneWidget);

    // Tap Easy tick
    await tester.tap(find.text('EASY'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('EASY AI BIDDERS'), findsOneWidget);

    // Tap START ARENA MATCH and confirm it opens the game screen
    await tester.tap(find.text('START ARENA MATCH'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('ROUND: 1'), findsOneWidget);
  });

  testWidgets('Multi-device landscape resolutions test: 1280x720, 2400x1080, 1024x768, 800x480',
      (WidgetTester tester) async {
    final testSizes = [
      const Size(1280, 720),
      const Size(2400, 1080),
      const Size(1024, 768),
      const Size(800, 480),
    ];

    for (final size in testSizes) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const AuctionWarsApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('AUCTION WARS'), findsOneWidget);
      expect(find.text('ONLINE PLAY'), findsOneWidget);
      expect(find.text('LOCAL PARTY'), findsOneWidget);
      expect(find.text('VS BOTS ARENA'), findsOneWidget);
      expect(find.text('VAULT & CARD COMPENDIUM (111 CARDS)'), findsOneWidget);
    }
    tester.view.resetPhysicalSize();
  });

  testWidgets('Tapping card thumbnail opens Full-Screen Card Showcase Modal with complete stats',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const AuctionWarsApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Vault Banner
    await tester.tap(find.text('VAULT & CARD COMPENDIUM (111 CARDS)'));
    await tester.pump(const Duration(milliseconds: 300));

    // Tap first card inside GridView
    final firstCard = find.descendant(
      of: find.byType(GridView),
      matching: find.byType(GestureDetector),
    ).first;
    await tester.tap(firstCard);
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Full Screen Card Showcase Opened
    expect(find.text('SPECIAL RULES & APPRAISAL'), findsOneWidget);
    expect(find.text('AUCTION WAR TACTICS'), findsOneWidget);
    expect(find.text('CLOSE SHOWCASE'), findsOneWidget);

    // Tap CLOSE SHOWCASE
    await tester.tap(find.text('CLOSE SHOWCASE'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify back to compendium
    expect(find.text('ALL (111)'), findsOneWidget);
  });
}
