import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_data.dart';
import '../models/crate_lot.dart';
import '../models/player_model.dart';
import '../services/sound_service.dart';
import '../theme/game_theme.dart';
import '../widgets/game/bottom_player_dock.dart';
import '../widgets/game/center_crates_view.dart';
import '../widgets/game/lot_reveal_dialog.dart';
import '../widgets/game/opponent_seat_view.dart';
import '../widgets/game/table_bid_marker.dart';
import '../widgets/game/top_nav_strip.dart';
import '../widgets/modals/setup_modals.dart';
import '../widgets/tactile_button.dart';

class GameScreen extends StatefulWidget {
  final int playerCount;
  final AiDifficulty difficulty;
  final String gameMode;
  final VoidCallback onExitToMenu;

  const GameScreen({
    super.key,
    required this.playerCount,
    required this.difficulty,
    required this.gameMode,
    required this.onExitToMenu,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<PlayerModel> players;
  late PlayerModel userPlayer;
  late CrateLot currentLot;

  int currentRound = 1;
  static const int maxRounds = 10;

  int currentBid = 400;
  int highestBidderIndex = 0;
  int currentTurnIndex = 0;
  String turnDirection = 'Clockwise'; // 'Clockwise' or 'Counter-Clockwise'
  int hammerCount = 0; // 0=None, 1=Once, 2=Twice, 3=Fair Warning, 4=Sold
  bool isBiddingActive = true;
  String liveNarrative = 'AUCTION READY! OPENING BID: \$400';
  final Map<int, int> playerBids = {};

  Timer? _aiTimer;
  Timer? _hammerTimer;

  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _initializeGame();
  }

  void _initializeGame() {
    // 1. Create Human User Player (YOU)
    userPlayer = PlayerModel(
      id: 'p_user',
      name: 'Player',
      isUser: true,
      avatarKey: 'you',
      bidMoney: 2500,
      itemMoney: 0,
      debt: 0,
    );

    // Initial Special Ops cards matching reference tray (X-Ray Specs, Skip Next Bidder, Discount Voucher, Reverse Direction)
    final opsPool = CardDatabase.specialOps;
    for (int i = 0; i < 4; i++) {
      userPlayer.opsHand.add(opsPool[i % opsPool.length]);
    }

    // 2. Create AI Opponents
    final aiPool = [
      PlayerModel(id: 'ai_sarah', name: 'Sarah', isUser: false, avatarKey: 'sarah', bidMoney: 2800, aiDifficulty: widget.difficulty),
      PlayerModel(id: 'ai_dave', name: 'Dave', isUser: false, avatarKey: 'dave', bidMoney: 2400, aiDifficulty: widget.difficulty),
      PlayerModel(id: 'ai_marcus', name: 'Marcus', isUser: false, avatarKey: 'marcus', bidMoney: 3000, aiDifficulty: widget.difficulty),
      PlayerModel(id: 'ai_kingpin', name: 'Kingpin', isUser: false, avatarKey: 'bot_kingpin', bidMoney: 3500, aiDifficulty: AiDifficulty.kingpin),
    ];

    players = [userPlayer];
    final opponentsNeeded = widget.playerCount - 1;
    for (int i = 0; i < opponentsNeeded; i++) {
      players.add(aiPool[i % aiPool.length]);
    }

    _startNewRound();
  }

  void _startNewRound() {
    _aiTimer?.cancel();
    _hammerTimer?.cancel();

    currentLot = CrateLot.generateRandomLot(currentRound);
    currentBid = 300 + (currentRound * 50);
    highestBidderIndex = -1;
    hammerCount = 0;
    isBiddingActive = true;
    playerBids.clear();

    // Reset player statuses
    for (final p in players) {
      p.resetForNewLot();
    }

    // Opening bidder: player 0 (User) opens Round 1, then rotates
    currentTurnIndex = (currentRound - 1) % players.length;

    setState(() {
      liveNarrative = 'ROUND $currentRound: ${currentLot.venueName.toUpperCase()}! OPENING LOT.';
    });

    _processTurn();
  }

  void _processTurn() {
    _aiTimer?.cancel();
    if (!isBiddingActive) return;

    // Check how many players remain active (not folded)
    final activePlayers = players.where((p) => !p.isFolded).toList();

    if (activePlayers.isEmpty) {
      // Everyone folded - lot passed
      _finishLot(null);
      return;
    }

    if (activePlayers.length == 1 && highestBidderIndex >= 0) {
      // Only 1 player left and someone placed a bid -> begin hammer sequence!
      _startHammerSequence(players[highestBidderIndex]);
      return;
    }

    // Advance to next non-folded player if current is folded
    while (players[currentTurnIndex].isFolded) {
      _advanceTurnIndex();
    }

    final currentPlayer = players[currentTurnIndex];

    if (currentPlayer.isUser) {
      setState(() {
        liveNarrative = 'YOUR TURN TO BID! (LOT AT \$$currentBid)';
      });
      // Awaiting user action from Sidebar Controls
    } else {
      // AI Turn with smart deliberation delay
      setState(() {
        liveNarrative = '${currentPlayer.name.toUpperCase()} IS THINKING...';
      });

      _aiTimer = Timer(const Duration(milliseconds: 1400), () {
        if (!mounted || !isBiddingActive) return;
        _executeAiTurn(currentPlayer);
      });
    }
  }

  void _executeAiTurn(PlayerModel ai) {
    final rand = Random();

    // AI valuation calculation
    final estimatedLotValue = currentLot.totalLotValue;
    final maxWillingToPay = (estimatedLotValue * (ai.aiDifficulty == AiDifficulty.kingpin ? 1.2 : 0.85)).toInt();

    final canAfford200 = ai.bidMoney >= currentBid + 200;
    final canAfford500 = ai.bidMoney >= currentBid + 500;

    // Shark loan emergency if Kingpin or aggressive AI
    if (!canAfford200 && ai.aiDifficulty == AiDifficulty.kingpin && ai.debt < 3000 && rand.nextDouble() < 0.4) {
      ai.borrowSharkLoan(1000);
      setState(() {
        ai.speechBubble = 'TOOK A SHARK LOAN!';
      });
    }

    if (currentBid < maxWillingToPay && (canAfford200 || canAfford500)) {
      // Raise
      final raiseAmount = (canAfford500 && rand.nextBool()) ? 500 : 200;
      _applyBid(players.indexOf(ai), currentBid + raiseAmount);
    } else {
      // Fold / Pass
      _applyPass(players.indexOf(ai));
    }
  }

  void _applyBid(int playerIndex, int newBid) {
    final bidder = players[playerIndex];
    currentBid = newBid;
    highestBidderIndex = playerIndex;
    hammerCount = 0; // reset hammer
    playerBids[playerIndex] = newBid;

    for (final p in players) {
      p.hasHammer = false;
    }
    bidder.hasHammer = true;

    SoundService.instance.playClick();

    setState(() {
      bidder.speechBubble = '\$$currentBid!';
      liveNarrative = '${bidder.name.toUpperCase()} RAISED TO \$$currentBid!';
    });

    _advanceTurnIndex();
    _processTurn();
  }

  void _applyPass(int playerIndex) {
    final passer = players[playerIndex];
    passer.isFolded = true;

    setState(() {
      passer.speechBubble = 'PASS!';
      liveNarrative = '${passer.name.toUpperCase()} PASSED.';
    });

    _advanceTurnIndex();
    _processTurn();
  }

  void _advanceTurnIndex() {
    if (turnDirection == 'Clockwise') {
      currentTurnIndex = (currentTurnIndex + 1) % players.length;
    } else {
      currentTurnIndex = (currentTurnIndex - 1 + players.length) % players.length;
    }
  }

  void _startHammerSequence(PlayerModel winner) {
    _aiTimer?.cancel();
    _hammerTimer?.cancel();

    hammerCount = 1;
    SoundService.instance.playGavel();

    setState(() {
      liveNarrative = '🔨 GOING ONCE AT \$$currentBid TO ${winner.name.toUpperCase()}!';
    });

    _hammerTimer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      setState(() {
        hammerCount = 2;
        liveNarrative = '🔨 GOING TWICE AT \$$currentBid TO ${winner.name.toUpperCase()}!';
      });
      SoundService.instance.playGavel();

      _hammerTimer = Timer(const Duration(milliseconds: 1300), () {
        if (!mounted) return;
        setState(() {
          hammerCount = 3;
          liveNarrative = '🔨 FAIR WARNING AT \$$currentBid!';
        });
        SoundService.instance.playGavel();

        _hammerTimer = Timer(const Duration(milliseconds: 1400), () {
          if (!mounted) return;
          _finishLot(winner);
        });
      });
    });
  }

  void _finishLot(PlayerModel? winner) {
    isBiddingActive = false;
    hammerCount = 4;
    SoundService.instance.playGavel();

    if (winner != null) {
      // Deduct winning bid
      winner.bidMoney -= currentBid;
      if (winner.bidMoney < 0) winner.bidMoney = 0;

      // Add won cards to stash & update item money
      final allCards = currentLot.crates.expand((c) => c.cards).toList();
      for (final card in allCards) {
        winner.stash.add(card);
        if (card.value > 0) {
          winner.itemMoney += card.value;
        } else if (card.value < 0) {
          // Negative fee
          winner.bidMoney += card.value; // subtracts
          if (winner.bidMoney < 0) winner.bidMoney = 0;
        }
      }

      for (final c in currentLot.crates) {
        c.isRevealed = true;
      }

      setState(() {
        liveNarrative = '🎉 SOLD TO ${winner.name.toUpperCase()} FOR \$$currentBid!';
      });

      // Show celebratory Unpack Reveal Dialog
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => LotRevealDialog(
            lot: currentLot,
            winner: winner,
            winningBid: currentBid,
            onNextRound: () {
              if (currentRound < maxRounds) {
                currentRound++;
                _startNewRound();
              } else {
                _showGameOver();
              }
            },
          ),
        );
      });
    }
  }

  void _showGameOver() {
    players.sort((a, b) => b.netWorth.compareTo(a.netWorth));
    final winner = players.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WoodenPlaqueModal(
        title: 'AUCTION WARS CHAMPIONSHIP!',
        width: 720,
        height: 520,
        onClose: widget.onExitToMenu,
        content: Column(
          children: [
            const Icon(Icons.emoji_events_rounded, color: GameColors.goldBright, size: 54),
            const SizedBox(height: 6),
            Text(
              '${winner.name.toUpperCase()} IS THE AUCTION KINGPIN!',
              style: const TextStyle(
                color: GameColors.goldOrange,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: players.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final p = players[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: p.isUser ? const Color(0xFFFEF08A) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GameColors.inkBorder, width: 2),
                    ),
                    child: Row(
                      children: [
                        Text('#${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        const SizedBox(width: 12),
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        const Spacer(),
                        Text(
                          'NET WORTH: \$${p.netWorth}',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: GameColors.greenDark, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TactileButton(
              onTap: widget.onExitToMenu,
              baseColor: GameColors.goldBright,
              shadowColor: GameColors.brassShadow,
              height: 50,
              width: double.infinity,
              child: const Text('RETURN TO MAIN MENU', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  // Tactical Ops Card Trigger
  void _playOpsCard(AuctionCard card) {
    if (!userPlayer.opsHand.contains(card)) return;

    userPlayer.opsHand.remove(card);
    SoundService.instance.playClick();

    if (card.id == 'OPS_XRAY') {
      // X-Ray Specs: Reveals one unrevealed crate
      final unxrayed = currentLot.crates.where((c) => !c.isXRayed).toList();
      if (unxrayed.isNotEmpty) {
        unxrayed.first.isXRayed = true;
      }
      setState(() {
        liveNarrative = 'YOU USED X-RAY SPECS! REVEALED CRATE CONTENTS.';
      });
    } else if (card.id == 'OPS_SKIP') {
      // Skip next bidder
      _advanceTurnIndex();
      setState(() {
        liveNarrative = 'YOU PLAYED SKIP NEXT BIDDER!';
      });
      _processTurn();
    } else if (card.id == 'OPS_REVERSE') {
      // Reverse order
      setState(() {
        turnDirection = turnDirection == 'Clockwise' ? 'Counter-Clockwise' : 'Clockwise';
        liveNarrative = 'YOU REVERSED BIDDING TURN DIRECTION!';
      });
      _advanceTurnIndex();
      _processTurn();
    } else if (card.id == 'OPS_SHILL') {
      // Force raise +$500
      _applyBid(players.indexOf(userPlayer), currentBid + 500);
    } else {
      setState(() {
        liveNarrative = 'PLAYED ${card.name}!';
      });
    }
  }

  @override
  void dispose() {
    _aiTimer?.cancel();
    _hammerTimer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opponentPlayers = players.where((p) => !p.isUser).toList();
    // 2 on side, 1 on top:
    // Left: opponentPlayers[0]
    // Top: opponentPlayers[1] (if exists, else opponentPlayers[0])
    // Right: opponentPlayers[2] (if exists)
    final leftOpponent = opponentPlayers.isNotEmpty ? opponentPlayers[0] : null;
    final topOpponent = opponentPlayers.length > 1
        ? opponentPlayers[1]
        : (opponentPlayers.length == 1 ? opponentPlayers[0] : null);
    final rightOpponent = opponentPlayers.length > 2 ? opponentPlayers[2] : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Container(
          width: w,
          height: h,
          color: const Color(0xFF140A05),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Native Cel-Shaded Sage-Green Poker Felt Canvas (Zero raster images)
              Positioned.fill(
                child: CustomPaint(
                  painter: _PokerFeltTablePainter(
                    glowAnimation: _glowController,
                    turnDirection: turnDirection,
                  ),
                ),
              ),

              // 2. Top Navigation Strip (Wood Finish)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TopNavStrip(
                    currentRound: currentRound,
                    maxRounds: maxRounds,
                    venueName: currentLot.venueName,
                    debt: userPlayer.debt,
                    bidMoney: userPlayer.bidMoney,
                    onTakeSharkLoan: () {
                      setState(() {
                        userPlayer.borrowSharkLoan(1000);
                        liveNarrative = 'TOOK \$1,000 SHARK LOAN (+25% INTEREST)!';
                      });
                      SoundService.instance.playCashRegister();
                    },
                    onRepayDebt: () {
                      setState(() {
                        userPlayer.repayDebt(userPlayer.debt);
                        liveNarrative = 'REPAID SHARK LOAN DEBT IN FULL!';
                      });
                      SoundService.instance.playCashRegister();
                    },
                    onBlackMarketTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const CardCompendiumModal(),
                      );
                    },
                    onBuyOpsTap: () {
                      if (userPlayer.bidMoney >= 300 && userPlayer.opsHand.length < 6) {
                        final pool = CardDatabase.specialOps;
                        final drawn = pool[Random().nextInt(pool.length)];
                        setState(() {
                          userPlayer.bidMoney -= 300;
                          userPlayer.opsHand.add(drawn);
                          liveNarrative = 'BOUGHT ${drawn.name} FOR \$300!';
                        });
                        SoundService.instance.playClick();
                      }
                    },
                    onExitGame: widget.onExitToMenu,
                  ),
                ),
              ),

              // 3. Characters Layout: 1 on TOP, 2 on the SIDES
              // 3.1 TOP Opponent Seat & Table Bid Marker
              if (topOpponent != null && topOpponent != leftOpponent)
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OpponentSeatWidget(
                          player: topOpponent,
                          isCurrentTurn: players.indexOf(topOpponent) == currentTurnIndex && isBiddingActive,
                        ),
                        const SizedBox(height: 2),
                        TableBidMarker(
                          playerName: topOpponent.name,
                          bidAmount: playerBids[players.indexOf(topOpponent)],
                          isFolded: topOpponent.isFolded,
                          isHighestBidder: highestBidderIndex == players.indexOf(topOpponent),
                          isCurrentTurn: players.indexOf(topOpponent) == currentTurnIndex && isBiddingActive,
                        ),
                      ],
                    ),
                  ),
                ),

              // 3.2 LEFT Opponent Seat & Table Bid Marker
              if (leftOpponent != null)
                Positioned(
                  left: 14,
                  top: h * 0.22,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OpponentSeatWidget(
                        player: leftOpponent,
                        isCurrentTurn: players.indexOf(leftOpponent) == currentTurnIndex && isBiddingActive,
                      ),
                      const SizedBox(height: 4),
                      TableBidMarker(
                        playerName: leftOpponent.name,
                        bidAmount: playerBids[players.indexOf(leftOpponent)],
                        isFolded: leftOpponent.isFolded,
                        isHighestBidder: highestBidderIndex == players.indexOf(leftOpponent),
                        isCurrentTurn: players.indexOf(leftOpponent) == currentTurnIndex && isBiddingActive,
                      ),
                    ],
                  ),
                ),

              // 3.3 RIGHT Opponent Seat & Table Bid Marker
              if (rightOpponent != null)
                Positioned(
                  right: 14,
                  top: h * 0.22,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OpponentSeatWidget(
                        player: rightOpponent,
                        isCurrentTurn: players.indexOf(rightOpponent) == currentTurnIndex && isBiddingActive,
                      ),
                      const SizedBox(height: 4),
                      TableBidMarker(
                        playerName: rightOpponent.name,
                        bidAmount: playerBids[players.indexOf(rightOpponent)],
                        isFolded: rightOpponent.isFolded,
                        isHighestBidder: highestBidderIndex == players.indexOf(rightOpponent),
                        isCurrentTurn: players.indexOf(rightOpponent) == currentTurnIndex && isBiddingActive,
                      ),
                    ],
                  ),
                ),

              // 4. Center Stage: The 3 Mystery Crates & Active Pot Counter
              Positioned(
                top: h * 0.24,
                left: 190,
                right: 190,
                child: Center(
                  child: CenterCratesView(
                    crates: currentLot.crates,
                    currentBid: currentBid,
                    highestBidderName: highestBidderIndex >= 0 ? players[highestBidderIndex].name : 'Nobody',
                    hammerCount: hammerCount,
                    turnDirection: turnDirection,
                    onCrateTap: (i) {
                      final xray = userPlayer.opsHand.where((c) => c.id == 'OPS_XRAY').firstOrNull;
                      if (xray != null && !currentLot.crates[i].isXRayed) {
                        _playOpsCard(xray);
                      }
                    },
                  ),
                ),
              ),

              // 5. User Active Table Bid Marker (On the green felt right in front of YOU)
              Positioned(
                bottom: 206,
                left: 0,
                right: 0,
                child: Center(
                  child: TableBidMarker(
                    playerName: 'YOU',
                    bidAmount: playerBids[players.indexOf(userPlayer)],
                    isFolded: userPlayer.isFolded,
                    isHighestBidder: highestBidderIndex == players.indexOf(userPlayer),
                    isUser: true,
                    isCurrentTurn: players.indexOf(userPlayer) == currentTurnIndex && isBiddingActive,
                  ),
                ),
              ),

              // 6. Bottom Player Dock (YOU) with Cards Tray & Bidding Console
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomPlayerDock(
                  player: userPlayer,
                  liveNarrativeToast: liveNarrative,
                  isUserTurn: players[currentTurnIndex].isUser && isBiddingActive,
                  onRaise200: () {
                    _applyBid(players.indexOf(userPlayer), currentBid + 200);
                  },
                  onRaise500: () {
                    _applyBid(players.indexOf(userPlayer), currentBid + 500);
                  },
                  onPassFold: () {
                    _applyPass(players.indexOf(userPlayer));
                  },
                  onPawnCard: (card) {
                    setState(() {
                      userPlayer.pawnCard(card);
                      liveNarrative = 'PAWNED ${card.name} FOR +\$${card.pawnValue}!';
                    });
                    SoundService.instance.playCashRegister();
                  },
                  onPlayOpsCard: _playOpsCard,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Native Cel-Shaded Poker Felt Table Painter (Zero raster screenshot)
class _PokerFeltTablePainter extends CustomPainter {
  final Animation<double> glowAnimation;
  final String turnDirection;

  _PokerFeltTablePainter({
    required this.glowAnimation,
    required this.turnDirection,
  }) : super(repaint: glowAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark warm wooden room background
    final bgPaint = Paint()..color = const Color(0xFF140A05);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Subtle wooden plank seams
    final plankPaint = Paint()
      ..color = const Color(0xFF1E0E06)
      ..strokeWidth = 2;
    for (double y = 45; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), plankPaint);
    }

    // 2. The Poker Felt Table Ellipse (Centered on 16:9 canvas)
    final center = Offset(size.width * 0.50, size.height * 0.44);
    final tableWidth = size.width * 0.44;
    final tableHeight = size.height * 0.38;

    // Outer drop shadow under bumper
    final shadowPaint = Paint()
      ..color = const Color(0xAA000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawOval(
      Rect.fromCenter(
        center: center + const Offset(0, 12),
        width: tableWidth * 2,
        height: tableHeight * 2,
      ),
      shadowPaint,
    );

    // Mahogany Bumper Rim (Deep cel-shaded cartoon wood)
    final bumperRect = Rect.fromCenter(center: center, width: tableWidth * 2, height: tableHeight * 2);
    final bumperPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5A2A12), Color(0xFF38180A), Color(0xFF220D04)],
      ).createShader(bumperRect);
    canvas.drawOval(bumperRect, bumperPaint);

    // Mahogany Ink Border
    final inkBorderPaint = Paint()
      ..color = const Color(0xFF190902)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;
    canvas.drawOval(bumperRect, inkBorderPaint);

    // Inner Gold Inlay Rim
    final goldInlayRect = Rect.fromCenter(
      center: center,
      width: (tableWidth - 14) * 2,
      height: (tableHeight - 14) * 2,
    );
    final goldInlayPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawOval(goldInlayRect, goldInlayPaint);

    // 3. Sage-Green Poker Felt
    final feltRect = Rect.fromCenter(
      center: center,
      width: (tableWidth - 18) * 2,
      height: (tableHeight - 18) * 2,
    );
    final feltPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.15),
        radius: 0.85,
        colors: [
          const Color(0xFF2E7D52), // Sunlit center sage
          const Color(0xFF1B5336), // Deep felt body
          const Color(0xFF0F3520), // Dark rim shadow
        ],
      ).createShader(feltRect);
    canvas.drawOval(feltRect, feltPaint);

    // Inner rim stroke
    final feltInnerStroke = Paint()
      ..color = const Color(0x44000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawOval(feltRect, feltInnerStroke);

    // 4. Center Glowing Golden Turn Ring
    final ringW = tableWidth * 0.85;
    final ringH = tableHeight * 0.70;
    final ringRect = Rect.fromCenter(center: center + const Offset(0, 16), width: ringW, height: ringH);
    final glow = (0.3 + (glowAnimation.value * 0.35)).clamp(0.0, 1.0);
    final turnRingPaint = Paint()
      ..color = Color.fromRGBO(251, 191, 36, glow)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawOval(ringRect, turnRingPaint);
  }

  @override
  bool shouldRepaint(covariant _PokerFeltTablePainter oldDelegate) => true;
}
