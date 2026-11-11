import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../models/player_model.dart';
import '../../services/sound_service.dart';
import '../../theme/game_theme.dart';
import '../card_view.dart';
import '../cel_character_painter.dart';
import '../tactile_button.dart';
import 'card_showcase_modal.dart';

/// Modal base wrapper with thick dark oak plaque, gold rivets, and cartoon border
class WoodenPlaqueModal extends StatelessWidget {
  final String title;
  final Widget content;
  final double width;
  final double height;
  final VoidCallback onClose;

  const WoodenPlaqueModal({
    super.key,
    required this.title,
    required this.content,
    required this.onClose,
    this.width = 680,
    this.height = 490,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogW = min(width, screenSize.width * 0.94);
    final dialogH = min(height, screenSize.height * 0.90);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: dialogW,
        height: dialogH,
        decoration: BoxDecoration(
          color: GameColors.oakDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: GameColors.oakBorder, width: 6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 1.0,
                colors: [
                  Color(0xFFFFFDF7),
                  Color(0xFFF7EED4),
                  Color(0xFFE4D2A9),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GameColors.oakBorder, width: 3.5),
            ),
            child: Column(
              children: [
                // Modal Header
                Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: GameColors.oakMedium,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    border: Border(
                      bottom: BorderSide(color: GameColors.oakBorder, width: 3.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: GameColors.goldBright, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(color: GameColors.inkBorder, offset: Offset(2, 2)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TactileButton(
                        onTap: onClose,
                        width: 38,
                        height: 38,
                        borderRadius: 19,
                        padding: EdgeInsets.zero,
                        baseColor: GameColors.redHazard,
                        shadowColor: GameColors.redDark,
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),

                // Modal Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 1. Online Play Modal
class OnlinePlayModal extends StatefulWidget {
  final VoidCallback onStartMatch;

  const OnlinePlayModal({super.key, required this.onStartMatch});

  @override
  State<OnlinePlayModal> createState() => _OnlinePlayModalState();
}

class _OnlinePlayModalState extends State<OnlinePlayModal> {
  String roomCode = 'ROCK';
  bool autoFillSmartBots = true;

  void _generateCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final rand = Random();
    setState(() {
      roomCode = List.generate(4, (_) => letters[rand.nextInt(letters.length)]).join();
    });
    SoundService.instance.playClick();
  }

  @override
  Widget build(BuildContext context) {
    return WoodenPlaqueModal(
      title: 'ONLINE PLAY SETUP',
      width: 620,
      height: 440,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            const Text(
              'HOST OR JOIN WORLDWIDE AUCTION ROOM',
              style: TextStyle(
                color: GameColors.oakDark,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

          // 4-Letter Room Code Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GameColors.inkBorder, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ROOM CODE: ',
                  style: TextStyle(
                    color: GameColors.oakLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  roomCode,
                  style: const TextStyle(
                    color: GameColors.blueOps,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(width: 16),
                TactileButton(
                  onTap: _generateCode,
                  height: 38,
                  baseColor: GameColors.goldBright,
                  shadowColor: GameColors.brassShadow,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded, size: 16, color: GameColors.inkBorder),
                      SizedBox(width: 4),
                      Text(
                        'RE-ROLL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: GameColors.inkBorder,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons: CREATE LOBBY & JOIN ROOM
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TactileButton(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onStartMatch();
                },
                baseColor: GameColors.greenMoney,
                shadowColor: GameColors.greenDark,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'CREATE LOBBY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TactileButton(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onStartMatch();
                },
                baseColor: GameColors.blueOps,
                shadowColor: GameColors.blueDark,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'JOIN ROOM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Auto-Fill Toggle
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => autoFillSmartBots = !autoFillSmartBots);
                SoundService.instance.playClick();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: GameColors.goldOrange, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      autoFillSmartBots ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: GameColors.greenDark,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Auto-Fill Empty Seats After 6s (Disguised Smart Bots)',
                      style: TextStyle(
                        color: GameColors.oakDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Large Quick Matchmaking Queue Button
          TactileButton(
            onTap: () {
              Navigator.of(context).pop();
              widget.onStartMatch();
            },
            baseColor: GameColors.goldBright,
            shadowColor: GameColors.brassShadow,
            height: 56,
            borderRadius: 20,
            width: double.infinity,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flash_on_rounded, color: GameColors.inkBorder, size: 24),
                SizedBox(width: 8),
                Text(
                  'QUICK MATCHMAKING QUEUE (FIND TABLE)',
                  style: TextStyle(
                    color: GameColors.inkBorder,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

/// 2. Local Party Modal
class LocalPartyModal extends StatefulWidget {
  final VoidCallback onStartMatch;

  const LocalPartyModal({super.key, required this.onStartMatch});

  @override
  State<LocalPartyModal> createState() => _LocalPartyModalState();
}

class _LocalPartyModalState extends State<LocalPartyModal> {
  int activeTab = 0; // 0 = Host Hotspot, 1 = Search LAN

  @override
  Widget build(BuildContext context) {
    return WoodenPlaqueModal(
      title: 'LOCAL PARTY (WI-FI & LAN)',
      width: 620,
      height: 440,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs
          Row(
            children: [
              Expanded(
                child: TactileButton(
                  onTap: () => setState(() => activeTab = 0),
                  baseColor: activeTab == 0 ? GameColors.greenMoney : Colors.grey.shade400,
                  shadowColor: activeTab == 0 ? GameColors.greenDark : Colors.grey.shade700,
                  child: const Text(
                    'HOST HOTSPOT ROOM',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TactileButton(
                  onTap: () => setState(() => activeTab = 1),
                  baseColor: activeTab == 1 ? GameColors.blueOps : Colors.grey.shade400,
                  shadowColor: activeTab == 1 ? GameColors.blueDark : Colors.grey.shade700,
                  child: const Text(
                    'SEARCH LAN ROOMS',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (activeTab == 0) ...[
            // Host Hotspot Panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GameColors.inkBorder, width: 3),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_tethering_rounded, color: GameColors.greenMoney, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'BROADCAST IP: 192.168.43.1:8080',
                        style: TextStyle(
                          color: GameColors.oakDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ROOM PIN: 8421  •  SLOTS: 1/4 READY',
                    style: TextStyle(
                      color: GameColors.goldOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Friends can connect directly to your mobile Wi-Fi Hotspot without internet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Search LAN Panel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GameColors.inkBorder, width: 3),
              ),
              child: const Column(
                children: [
                  Icon(Icons.radar_rounded, color: GameColors.blueOps, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'SCANNING LOCAL SUBNET...',
                    style: TextStyle(
                      color: GameColors.blueDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Found: "Dave\'s High Stakes Vault" (Ping: 4ms)',
                    style: TextStyle(color: GameColors.greenDark, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          TactileButton(
            onTap: () {
              Navigator.of(context).pop();
              widget.onStartMatch();
            },
            baseColor: GameColors.greenMoney,
            shadowColor: GameColors.greenDark,
            height: 54,
            width: double.infinity,
            borderRadius: 20,
            child: const Text(
              'LAUNCH HOTSPOT MATCH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

/// 3. VS Bots Arena Modal with Compact Difficulty Slider
class VsBotsArenaModal extends StatefulWidget {
  final Function(int playerCount, AiDifficulty difficulty) onStartMatch;

  const VsBotsArenaModal({super.key, required this.onStartMatch});

  @override
  State<VsBotsArenaModal> createState() => _VsBotsArenaModalState();
}

class _VsBotsArenaModalState extends State<VsBotsArenaModal> {
  int playerCount = 4;
  AiDifficulty selectedDifficulty = AiDifficulty.medium;
  double _sliderValue = 1.0; // 0.0 = Easy, 1.0 = Medium, 2.0 = Kingpin

  @override
  Widget build(BuildContext context) {
    Color activeColor;
    String diffTitle;
    String diffDesc;
    IconData diffIcon;

    switch (selectedDifficulty) {
      case AiDifficulty.easy:
        activeColor = const Color(0xFF10B981);
        diffTitle = 'EASY AI BIDDERS';
        diffDesc = 'Predictable bidding patterns & early folds.';
        diffIcon = Icons.thumb_up_rounded;
        break;
      case AiDifficulty.medium:
        activeColor = const Color(0xFF0284C7);
        diffTitle = 'MEDIUM AI BIDDERS';
        diffDesc = 'Calculates crate valuation & bluffs smartly.';
        diffIcon = Icons.military_tech_rounded;
        break;
      case AiDifficulty.kingpin:
        activeColor = const Color(0xFFDC2626);
        diffTitle = 'KINGPIN BOSS AI 👑';
        diffDesc = 'Cutthroat shark loans, ruthless counter-bids & ops!';
        diffIcon = Icons.workspace_premium_rounded;
        break;
    }

    return WoodenPlaqueModal(
      title: 'VS BOTS ARENA SETUP',
      width: 620,
      height: 430,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Table Capacity Stepper
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: GameColors.inkBorder, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'TABLE CAPACITY: ',
                    style: TextStyle(
                      color: GameColors.oakDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TactileButton(
                    onTap: playerCount > 2
                        ? () => setState(() => playerCount--)
                        : null,
                    width: 34,
                    height: 34,
                    borderRadius: 17,
                    padding: EdgeInsets.zero,
                    baseColor: GameColors.goldBright,
                    shadowColor: GameColors.brassShadow,
                    child: const Icon(Icons.remove_rounded, color: GameColors.inkBorder, size: 20),
                  ),
                  Container(
                    width: 110,
                    alignment: Alignment.center,
                    child: Text(
                      '$playerCount PLAYERS',
                      style: const TextStyle(
                        color: GameColors.redDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TactileButton(
                    onTap: playerCount < 5
                        ? () => setState(() => playerCount++)
                        : null,
                    width: 34,
                    height: 34,
                    borderRadius: 17,
                    padding: EdgeInsets.zero,
                    baseColor: GameColors.goldBright,
                    shadowColor: GameColors.brassShadow,
                    child: const Icon(Icons.add_rounded, color: GameColors.inkBorder, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. Compact Difficulty Slider Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GameColors.inkBorder, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  // Active Difficulty Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GameColors.inkBorder, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(diffIcon, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          diffTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    diffDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Tactile 3-Step Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: activeColor,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: GameColors.goldBright,
                      overlayColor: GameColors.goldBright.withValues(alpha: 0.25),
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: 2.0,
                      divisions: 2,
                      onChanged: (val) {
                        setState(() {
                          _sliderValue = val;
                          if (val <= 0.3) {
                            selectedDifficulty = AiDifficulty.easy;
                          } else if (val <= 1.3) {
                            selectedDifficulty = AiDifficulty.medium;
                          } else {
                            selectedDifficulty = AiDifficulty.kingpin;
                          }
                        });
                        SoundService.instance.playClick();
                      },
                    ),
                  ),

                  // Clickable Division Ticks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSliderTick('EASY', 0.0, const Color(0xFF10B981)),
                      _buildSliderTick('MEDIUM', 1.0, const Color(0xFF0284C7)),
                      _buildSliderTick('KINGPIN 👑', 2.0, const Color(0xFFDC2626)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 3. Green [START ARENA MATCH] Button
            TactileButton(
              onTap: () {
                Navigator.of(context).pop();
                widget.onStartMatch(playerCount, selectedDifficulty);
              },
              baseColor: GameColors.greenMoney,
              shadowColor: GameColors.greenDark,
              height: 48,
              borderRadius: 18,
              width: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'START ARENA MATCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderTick(String label, double val, Color col) {
    final isSelected = (_sliderValue - val).abs() < 0.3;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _sliderValue = val;
          if (val == 0.0) selectedDifficulty = AiDifficulty.easy;
          if (val == 1.0) selectedDifficulty = AiDifficulty.medium;
          if (val == 2.0) selectedDifficulty = AiDifficulty.kingpin;
        });
        SoundService.instance.playClick();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: isSelected ? col : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? GameColors.inkBorder : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

/// 4. Top 100 Leaderboard Modal (AAA Mobile Game Style)
class LeaderboardModal extends StatefulWidget {
  const LeaderboardModal({super.key});

  @override
  State<LeaderboardModal> createState() => _LeaderboardModalState();
}

class _LeaderboardModalState extends State<LeaderboardModal> {
  int _activeTab = 0; // 0=Global, 1=Weekly, 2=Friends

  final List<Map<String, dynamic>> ranks = [
    {'rank': 1, 'name': 'Kingpin Victor', 'worth': '\$184,500', 'streak': '28 Wins', 'avatar': 'bot_kingpin', 'badge': 'VIP KINGPIN'},
    {'rank': 2, 'name': 'Sarah Spark', 'worth': '\$142,000', 'streak': '19 Wins', 'avatar': 'sarah', 'badge': 'ELITE BIDDER'},
    {'rank': 3, 'name': 'Marcus Vance', 'worth': '\$129,500', 'streak': '14 Wins', 'avatar': 'marcus', 'badge': 'HIGH ROLLER'},
    {'rank': 4, 'name': 'Diamond Dave', 'worth': '\$115,000', 'streak': '11 Wins', 'avatar': 'dave', 'badge': 'SHARK LOANER'},
    {'rank': 5, 'name': 'YOU (Champion)', 'worth': '\$98,500', 'streak': '8 Wins', 'avatar': 'you', 'badge': 'RISING STAR'},
    {'rank': 6, 'name': 'Elena Rust', 'worth': '\$85,000', 'streak': '6 Wins', 'avatar': 'sarah', 'badge': 'PRO FLIPPER'},
    {'rank': 7, 'name': 'Baron Von Flip', 'worth': '\$72,500', 'streak': '5 Wins', 'avatar': 'dave', 'badge': 'COLLECTOR'},
    {'rank': 8, 'name': 'Speedy Sam', 'worth': '\$61,000', 'streak': '4 Wins', 'avatar': 'marcus', 'badge': 'SNIPER'},
  ];

  @override
  Widget build(BuildContext context) {
    return WoodenPlaqueModal(
      title: 'TOP 100 AUCTION LEADERBOARD',
      width: 740,
      height: 530,
      onClose: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          // Filter Tabs (Global All-Time, Weekly Tournament, Friends League)
          Row(
            children: [
              _buildTab(0, 'GLOBAL ALL-TIME', Icons.public_rounded),
              const SizedBox(width: 8),
              _buildTab(1, 'WEEKLY CUP', Icons.emoji_events_rounded),
              const SizedBox(width: 8),
              _buildTab(2, 'FRIENDS LEAGUE', Icons.groups_rounded),
            ],
          ),

          const SizedBox(height: 10),

          // Scrollable Rankings List
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12, width: 2),
              ),
              child: ListView.separated(
                itemCount: ranks.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final item = ranks[i];
                  final isUser = item['avatar'] == 'you';
                  final rankNum = item['rank'] as int;

                  Color rankBadgeColor = Colors.grey.shade400;
                  Color rankBorderColor = Colors.grey.shade600;
                  if (rankNum == 1) {
                    rankBadgeColor = GameColors.goldBright;
                    rankBorderColor = GameColors.goldOrange;
                  } else if (rankNum == 2) {
                    rankBadgeColor = const Color(0xFFE2E8F0);
                    rankBorderColor = const Color(0xFF94A3B8);
                  } else if (rankNum == 3) {
                    rankBadgeColor = const Color(0xFFF97316);
                    rankBorderColor = const Color(0xFFC2410C);
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(colors: [Color(0xFFFEF9C3), Color(0xFFFEF08A)])
                          : const LinearGradient(colors: [Colors.white, Color(0xFFF8FAFC)]),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isUser ? GameColors.goldBright : GameColors.inkBorder,
                        width: isUser ? 3.5 : 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isUser ? GameColors.goldBright.withValues(alpha: 0.45) : Colors.black12,
                          blurRadius: isUser ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Rank Badge with Trophy / Crown Icon for top 3
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: rankBadgeColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: rankBorderColor, width: 2),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
                          ),
                          child: Text(
                            '#$rankNum',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: GameColors.inkBorder,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Avatar
                        CartoonAvatarWidget(avatarKey: item['avatar'], radius: 20),

                        const SizedBox(width: 12),

                        // Name & Tag
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                color: isUser ? GameColors.redDark : GameColors.inkBorder,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: isUser ? GameColors.redHazard : const Color(0xFF0284C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['badge'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Net Worth & Streak
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: GameTheme.greenMoneyPillDeco,
                              child: Text(
                                'NET WORTH: ${item['worth']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '🔥 ${item['streak']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: GameColors.oakDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Pinned Bottom Bar for Player's Position
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1408),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: GameColors.goldBright, width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: GameColors.goldBright, size: 22),
                SizedBox(width: 8),
                Text(
                  'YOUR STANDING: #5 • TOP 5% ELITE AUCTIONEER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
                Spacer(),
                Text(
                  'NEXT REWARD AT RANK #3 (+500 GEMS)',
                  style: TextStyle(
                    color: GameColors.goldBright,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int tabIndex, String label, IconData icon) {
    final isSelected = _activeTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _activeTab = tabIndex);
          SoundService.instance.playClick();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? GameColors.goldBright : const Color(0xFF26140B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? GameColors.inkBorder : Colors.white24,
              width: isSelected ? 2.5 : 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? GameColors.inkBorder : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? GameColors.inkBorder : Colors.white70,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4b. Dedicated Game Settings Modal
class GameSettingsModal extends StatefulWidget {
  const GameSettingsModal({super.key});

  @override
  State<GameSettingsModal> createState() => _GameSettingsModalState();
}

class _GameSettingsModalState extends State<GameSettingsModal> {
  bool _fastAiTurns = false;
  bool _vibration = true;
  bool _screenShake = true;

  @override
  Widget build(BuildContext context) {
    return WoodenPlaqueModal(
      title: 'GAME & AUDIO SETTINGS',
      width: 620,
      height: 480,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Section 1: Audio Controls
            _buildSectionHeader('AUDIO & HAPTICS', Icons.volume_up_rounded),
            const SizedBox(height: 6),
            _buildSettingRow(
              'Master Sound & SFX',
              'Auction gavels, cash register & bid clicks',
              !SoundService.instance.isMuted,
              (val) {
                setState(() => SoundService.instance.toggleSound());
              },
            ),
            const SizedBox(height: 6),
            _buildSettingRow(
              'Haptic Touch Vibration',
              'Tactile button click feedback on mobile',
              _vibration,
              (val) => setState(() => _vibration = val),
            ),

            const SizedBox(height: 12),

            // Section 2: Gameplay Speed
            _buildSectionHeader('GAMEPLAY SPEED & VISUALS', Icons.speed_rounded),
            const SizedBox(height: 6),
            _buildSettingRow(
              'Fast AI Turns',
              'Skip bot thinking deliberation for high-speed matches',
              _fastAiTurns,
              (val) => setState(() => _fastAiTurns = val),
            ),
            const SizedBox(height: 6),
            _buildSettingRow(
              'Screen Shake & Confetti',
              'Dynamic celebrations upon winning crates',
              _screenShake,
              (val) => setState(() => _screenShake = val),
            ),

            const SizedBox(height: 14),

            // Display Info Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1005),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GameColors.goldOrange, width: 2),
              ),
              child: const Row(
                children: [
                  Icon(Icons.stay_current_landscape_rounded, color: GameColors.goldBright, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LANDSCAPE HD MOBILE EDITION',
                          style: TextStyle(
                            color: GameColors.goldBright,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '1280x720 Native • Cel-Shaded AAA Graphics • Zero Scroll',
                          style: TextStyle(color: Colors.white70, fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Close Button
            TactileButton(
              onTap: () => Navigator.of(context).pop(),
              baseColor: GameColors.goldBright,
              shadowColor: GameColors.brassShadow,
              height: 48,
              width: double.infinity,
              borderRadius: 16,
              child: const Text(
                'SAVE & CLOSE SETTINGS',
                style: TextStyle(
                  color: GameColors.inkBorder,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: GameColors.goldBright, size: 18),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: GameColors.oakDark,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GameColors.inkBorder, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: GameColors.inkBorder,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: GameColors.greenMoney,
            activeThumbColor: Colors.white,
            onChanged: (val) {
              onChanged(val);
              SoundService.instance.playClick();
            },
          ),
        ],
      ),
    );
  }
}

/// 5. Card Compendium Modal (111 Cards Browser)
class CardCompendiumModal extends StatefulWidget {
  const CardCompendiumModal({super.key});

  @override
  State<CardCompendiumModal> createState() => _CardCompendiumModalState();
}

class _CardCompendiumModalState extends State<CardCompendiumModal> {
  int filterTab = 0; // 0=All, 1=Assets, 2=Junk, 3=Ops
  AuctionCard? inspectedCard;

  @override
  Widget build(BuildContext context) {
    List<AuctionCard> cards;
    if (filterTab == 1) {
      cards = CardDatabase.positiveAssets;
    } else if (filterTab == 2) {
      cards = CardDatabase.junkHazards;
    } else if (filterTab == 3) {
      cards = CardDatabase.specialOps;
    } else {
      cards = CardDatabase.allCards;
    }

    return WoodenPlaqueModal(
      title: 'VAULT & CARD COMPENDIUM (111 CARDS)',
      width: 900,
      height: 580,
      onClose: () => Navigator.of(context).pop(),
      content: Row(
        children: [
          // Left side: Card Grid with Filters
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Filter Tabs
                Row(
                  children: [
                    _buildTab(0, 'ALL (111)'),
                    const SizedBox(width: 6),
                    _buildTab(1, 'ASSETS (50)'),
                    const SizedBox(width: 6),
                    _buildTab(2, 'JUNK (50)'),
                    const SizedBox(width: 6),
                    _buildTab(3, 'OPS (11)'),
                  ],
                ),
                const SizedBox(height: 10),

                // Grid of Card Thumbnails
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: GameColors.inkBorder, width: 2),
                    ),
                    child: GridView.builder(
                      itemCount: cards.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, i) {
                        final c = cards[i];
                        final isSelected = inspectedCard?.id == c.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() => inspectedCard = c);
                            CardShowcaseModal.show(context, c);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? GameColors.goldBright : GameColors.inkBorder,
                                width: isSelected ? 3.0 : 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                c.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Right side: Inspected Card Preview
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF5E6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: GameColors.oakBorder, width: 3),
              ),
              child: inspectedCard != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AuctionCardWidget(
                          card: inspectedCard!,
                          width: 200,
                          height: 270,
                          isSelected: true,
                          onTap: () => CardShowcaseModal.show(context, inspectedCard!),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${inspectedCard!.id}  •  ${inspectedCard!.tag}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: GameColors.oakDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TactileButton(
                          onTap: () => CardShowcaseModal.show(context, inspectedCard!),
                          baseColor: GameColors.goldBright,
                          shadowColor: GameColors.brassShadow,
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fullscreen_rounded, color: GameColors.inkBorder, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'FULL SCREEN SHOWCASE',
                                style: TextStyle(
                                  color: GameColors.inkBorder,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'Tap any card in the grid to inspect full cel-shaded vector art & stats.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int tabIndex, String label) {
    final isSelected = filterTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => filterTab = tabIndex);
          SoundService.instance.playClick();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? GameColors.oakDark : Colors.amber.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GameColors.inkBorder, width: 2),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : GameColors.inkBorder,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
