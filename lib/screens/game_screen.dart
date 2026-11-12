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
import '../widgets/game/sidebar_panel.dart';
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

    return Container(
      color: const Color(0xFF140A05),
      child: Stack(
        children: [
          // 1. Exact 1:1 Cel-Shaded Game Screen Artwork from Reference Image
          Positioned.fill(
            child: Image.asset(
              'assets/reference/ref_game.jpg',
              fit: BoxFit.fill,
            ),
          ),

          // 2. Main Game Screen Layout
          Column(
            children: [
              // 2.1 Top Navigation Strip (Wood Finish)
              Padding(
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

              // 2.2 Upper Arc: Opponent Seats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: opponentPlayers.map((opp) {
                    final isTurn = players.indexOf(opp) == currentTurnIndex && isBiddingActive;
                    return OpponentSeatWidget(
                      player: opp,
                      isCurrentTurn: isTurn,
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),

              // 2.3 Center Stage: The 3 Mystery Crates & Pot Counter
              CenterCratesView(
                crates: currentLot.crates,
                currentBid: currentBid,
                highestBidderName: highestBidderIndex >= 0 ? players[highestBidderIndex].name : 'Nobody',
                hammerCount: hammerCount,
                turnDirection: turnDirection,
                onCrateTap: (i) {
                  // If player has X-Ray card, prompt use
                  final xray = userPlayer.opsHand.where((c) => c.id == 'OPS_XRAY').firstOrNull;
                  if (xray != null && !currentLot.crates[i].isXRayed) {
                    _playOpsCard(xray);
                  }
                },
              ),

              const Spacer(),

              // 2.4 Bottom Player Dock (YOU)
              BottomPlayerDock(
                player: userPlayer,
                liveNarrativeToast: liveNarrative,
                onPlayOpsCard: _playOpsCard,
              ),
            ],
          ),

          // 3. Right-Hand Retractable Sidebar (Pawn Shop & Quick-Turn Controls)
          Positioned(
            right: 0,
            top: 74,
            bottom: 40,
            child: SidebarPanel(
              player: userPlayer,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
