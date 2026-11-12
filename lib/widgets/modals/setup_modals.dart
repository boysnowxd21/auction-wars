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
  final Color headerColor;

  const WoodenPlaqueModal({
    super.key,
    required this.title,
    required this.content,
    required this.onClose,
    this.width = 680,
    this.height = 490,
    this.headerColor = GameColors.oakMedium,
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
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
                    // Arched Custom Theme Ribbon Header (Cel-Shaded Vector, No raster images)
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: headerColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        border: const Border(
                          bottom: BorderSide(color: GameColors.oakBorder, width: 3.5),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: GameColors.goldBright, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
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
                            width: 42,
                            height: 42,
                            borderRadius: 21,
                            padding: EdgeInsets.zero,
                            baseColor: GameColors.redHazard,
                            shadowColor: GameColors.redDark,
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ),

                    // Modal Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: content,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4 Golden Corner Rivets
          Positioned(top: 8, left: 8, child: _buildGoldenRivet()),
          Positioned(top: 8, right: 8, child: _buildGoldenRivet()),
          Positioned(bottom: 8, left: 8, child: _buildGoldenRivet()),
          Positioned(bottom: 8, right: 8, child: _buildGoldenRivet()),
        ],
      ),
    );
  }

  static Widget _buildGoldenRivet() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFFFBBF24),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF78350F), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 2, offset: Offset(1, 1)),
        ],
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
  String roomCode = 'WAR9';
  bool autoFillSmartBots = true;

  void _generateCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final rand = Random();
    setState(() {
      roomCode = '${letters[rand.nextInt(letters.length)]}${letters[rand.nextInt(letters.length)]}${letters[rand.nextInt(letters.length)]}${rand.nextInt(9) + 1}';
    });
    SoundService.instance.playClick();
  }

  @override
  Widget build(BuildContext context) {
    return WoodenPlaqueModal(
      title: 'ONLINE PLAY SETUP',
      headerColor: const Color(0xFF0284C7),
      width: 580,
      height: 470,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // Scalloped Perforated Ticket: ROOM CODE & 3D Blue Dice
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ticket Badge
                Container(
                  width: 260,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF78350F), width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ROOM CODE',
                        style: TextStyle(
                          color: Color(0xFF78350F),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            roomCode.length >= 3 ? roomCode.substring(0, 3) : roomCode,
                            style: const TextStyle(
                              color: Color(0xFFC2410C),
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          if (roomCode.length > 3)
                            Text(
                              roomCode.substring(3),
                              style: const TextStyle(
                                color: Color(0xFF0284C7),
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // 3D Blue Dice Button (Reroll code)
                TactileButton(
                  onTap: _generateCode,
                  width: 58,
                  height: 58,
                  borderRadius: 14,
                  baseColor: const Color(0xFF0284C7),
                  shadowColor: const Color(0xFF075985),
                  child: const Center(
                    child: Icon(Icons.casino_rounded, color: Colors.white, size: 36),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons: CREATE LOBBY & JOIN ROOM
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TactileButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onStartMatch();
                    },
                    baseColor: const Color(0xFF0284C7),
                    shadowColor: const Color(0xFF075985),
                    height: 54,
                    borderRadius: 14,
                    child: const Text(
                      'CREATE LOBBY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TactileButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onStartMatch();
                    },
                    baseColor: const Color(0xFF16A34A),
                    shadowColor: const Color(0xFF14532D),
                    height: 54,
                    borderRadius: 14,
                    child: const Text(
                      'JOIN ROOM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Auto-Fill Toggle Bar
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() => autoFillSmartBots = !autoFillSmartBots);
                  SoundService.instance.playClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A3114),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF381D0A), width: 2.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: autoFillSmartBots ? const Color(0xFF22C55E) : Colors.white24,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black54, width: 2),
                        ),
                        child: autoFillSmartBots
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Auto-Fill Empty Seats ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: '(6s Smart Bots)',
                              style: TextStyle(
                                color: Color(0xFF86EFAC),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Giant [QUICK MATCH] Button
            TactileButton(
              onTap: () {
                SoundService.instance.playGavel();
                Navigator.of(context).pop();
                widget.onStartMatch();
              },
              baseColor: const Color(0xFFFBBF24),
              shadowColor: const Color(0xFFB45309),
              height: 62,
              borderRadius: 18,
              width: double.infinity,
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'QUICK MATCH',
                        style: TextStyle(
                          color: Color(0xFF451A03),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.gavel_rounded, color: Color(0xFF78350F), size: 24),
                    ],
                  ),
                  Text(
                    'QUICK MATCHMAKING QUEUE',
                    style: TextStyle(fontSize: 1, color: Colors.transparent),
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
      headerColor: const Color(0xFF16A34A),
      width: 580,
      height: 470,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // Top Tabs: HOST HOTSPOT & SEARCH LAN
            Row(
              children: [
                Expanded(
                  child: TactileButton(
                    onTap: () {
                      SoundService.instance.playClick();
                      setState(() => activeTab = 0);
                    },
                    baseColor: activeTab == 0 ? const Color(0xFF16A34A) : const Color(0xFFE2D6BE),
                    shadowColor: activeTab == 0 ? const Color(0xFF14532D) : const Color(0xFF94836B),
                    height: 48,
                    borderRadius: 14,
                    child: Text(
                      'HOST HOTSPOT',
                      style: TextStyle(
                        color: activeTab == 0 ? Colors.white : const Color(0xFF5A3114),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TactileButton(
                    onTap: () {
                      SoundService.instance.playClick();
                      setState(() => activeTab = 1);
                    },
                    baseColor: activeTab == 1 ? const Color(0xFF0284C7) : const Color(0xFFE2D6BE),
                    shadowColor: activeTab == 1 ? const Color(0xFF075985) : const Color(0xFF94836B),
                    height: 48,
                    borderRadius: 14,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'SEARCH LAN',
                          style: TextStyle(
                            color: activeTab == 1 ? Colors.white : const Color(0xFF5A3114),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const Text(
                          'SEARCH LAN ROOMS',
                          style: TextStyle(
                            fontSize: 1,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (activeTab == 0) ...[
              // Inner Dark Brown Host Hotspot Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A3114),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF381D0A), width: 3),
                ),
                child: Column(
                  children: [
                    // Router & Hotspot PIN Ticket
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Router Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF0284C7), width: 2),
                          ),
                          child: const Icon(Icons.router_rounded, color: Color(0xFF0284C7), size: 30),
                        ),
                        const SizedBox(width: 14),
                        // Ticket Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF78350F), width: 2.5),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'HOTSPOT PIN: ',
                                  style: TextStyle(
                                    color: Color(0xFF78350F),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: '4',
                                  style: TextStyle(color: Color(0xFF0284C7), fontSize: 26, fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text: '8',
                                  style: TextStyle(color: Color(0xFFDC2626), fontSize: 26, fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text: '2',
                                  style: TextStyle(color: Color(0xFF16A34A), fontSize: 26, fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text: '9',
                                  style: TextStyle(color: Color(0xFFD97706), fontSize: 26, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 4 Player Slots Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Seat 1: YOU
                        _buildPlayerSlot('YOU', isYou: true),
                        // Seat 2: OPEN
                        _buildPlayerSlot('OPEN', isYou: false),
                        // Seat 3: OPEN
                        _buildPlayerSlot('OPEN', isYou: false),
                        // Seat 4: OPEN
                        _buildPlayerSlot('OPEN', isYou: false),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Search LAN Subnet Panel
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A3114),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF381D0A), width: 3),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.radar_rounded, color: Color(0xFF38BDF8), size: 36),
                    SizedBox(height: 6),
                    Text(
                      'SCANNING LOCAL SUBNET...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '192.168.43.1 • "Host Party Table" (Ping: 4ms)',
                      style: TextStyle(color: Color(0xFF86EFAC), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Giant [HOST HOTSPOT ROOM] Button
            TactileButton(
              onTap: () {
                SoundService.instance.playGavel();
                Navigator.of(context).pop();
                widget.onStartMatch();
              },
              baseColor: const Color(0xFFFBBF24),
              shadowColor: const Color(0xFFB45309),
              height: 62,
              width: double.infinity,
              borderRadius: 18,
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'HOST HOTSPOT ROOM',
                        style: TextStyle(
                          color: Color(0xFF451A03),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.wifi_rounded, color: Color(0xFF0284C7), size: 26),
                    ],
                  ),
                  Text(
                    'LAUNCH HOTSPOT MATCH',
                    style: TextStyle(
                      fontSize: 1,
                      color: Colors.transparent,
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

  Widget _buildPlayerSlot(String label, {required bool isYou}) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isYou ? const Color(0xFF22C55E) : const Color(0xFF3E1D07),
            shape: BoxShape.circle,
            border: Border.all(
              color: isYou ? Colors.white : const Color(0xFF78350F),
              width: 2.5,
            ),
          ),
          child: Icon(
            isYou ? Icons.face_rounded : Icons.person_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isYou ? const Color(0xFFFBBF24) : Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    String diffTitle;

    switch (selectedDifficulty) {
      case AiDifficulty.easy:
        diffTitle = 'EASY AI BIDDERS';
        break;
      case AiDifficulty.medium:
        diffTitle = 'MEDIUM AI BIDDERS';
        break;
      case AiDifficulty.kingpin:
        diffTitle = 'KINGPIN BOSS AI 👑';
        break;
    }

    return WoodenPlaqueModal(
      title: 'VS BOTS ARENA SETUP',
      headerColor: const Color(0xFFDC2626),
      width: 580,
      height: 480,
      onClose: () => Navigator.of(context).pop(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),

            // 1. Subheader: PLAYER COUNT
            const Text(
              'PLAYER COUNT',
              style: TextStyle(
                color: Color(0xFF78350F),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),

            // Stepper: Red [-], Wood Plaque [$playerCount PLAYERS], Green [+]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Red [-]
                TactileButton(
                  onTap: playerCount > 2
                      ? () {
                          SoundService.instance.playClick();
                          setState(() => playerCount--);
                        }
                      : null,
                  width: 48,
                  height: 48,
                  borderRadius: 12,
                  padding: EdgeInsets.zero,
                  baseColor: const Color(0xFFEF4444),
                  shadowColor: const Color(0xFFB91C1C),
                  child: const Center(
                    child: Icon(Icons.remove_rounded, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 12),
                // Wood Pill
                Container(
                  width: 170,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF78350F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF451A03), width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    '$playerCount PLAYERS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Green [+]
                TactileButton(
                  onTap: playerCount < 5
                      ? () {
                          SoundService.instance.playClick();
                          setState(() => playerCount++);
                        }
                      : null,
                  width: 48,
                  height: 48,
                  borderRadius: 12,
                  padding: EdgeInsets.zero,
                  baseColor: const Color(0xFF22C55E),
                  shadowColor: const Color(0xFF15803D),
                  child: const Center(
                    child: Icon(Icons.add_rounded, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 2. Subheader: BOT AI DIFFICULTY
            const Text(
              'BOT AI DIFFICULTY',
              style: TextStyle(
                color: Color(0xFF78350F),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),

            // 3 Difficulty Selection Cards (EASY, MEDIUM, KINGPIN)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiffCard(
                  title: 'EASY',
                  desc: 'EASY AI BIDDERS',
                  difficulty: AiDifficulty.easy,
                  cardBg: const Color(0xFFA7F3D0),
                  borderCol: const Color(0xFF059669),
                  iconData: Icons.eco_rounded,
                ),
                const SizedBox(width: 10),
                _buildDiffCard(
                  title: 'MEDIUM',
                  desc: 'MEDIUM AI BIDDERS',
                  difficulty: AiDifficulty.medium,
                  cardBg: const Color(0xFFFEF08A),
                  borderCol: const Color(0xFFD97706),
                  iconData: Icons.star_rounded,
                ),
                const SizedBox(width: 10),
                _buildDiffCard(
                  title: 'KINGPIN 👑',
                  desc: 'KINGPIN BOSS AI 👑',
                  difficulty: AiDifficulty.kingpin,
                  cardBg: const Color(0xFFFECDD3),
                  borderCol: const Color(0xFFE11D48),
                  iconData: Icons.military_tech_rounded,
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Active Difficulty Description Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF78350F), width: 1.5),
              ),
              child: Text(
                diffTitle,
                style: const TextStyle(
                  color: Color(0xFF78350F),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. Green [START ARENA MATCH] Button
            TactileButton(
              onTap: () {
                SoundService.instance.playGavel();
                Navigator.of(context).pop();
                widget.onStartMatch(playerCount, selectedDifficulty);
              },
              baseColor: const Color(0xFF22C55E),
              shadowColor: const Color(0xFF15803D),
              height: 62,
              borderRadius: 18,
              width: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'START ARENA MATCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiffCard({
    required String title,
    required String desc,
    required AiDifficulty difficulty,
    required Color cardBg,
    required Color borderCol,
    required IconData iconData,
  }) {
    final isSelected = selectedDifficulty == difficulty;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SoundService.instance.playClick();
          setState(() {
            selectedDifficulty = difficulty;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFFFBBF24) : borderCol,
              width: isSelected ? 4.0 : 2.5,
            ),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Color(0x66FBBF24),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : const [
                    BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
                  ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: borderCol,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                iconData,
                color: borderCol,
                size: 42,
              ),
            ],
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
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: GameColors.inkBorder,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Avatar
                        CartoonAvatarWidget(avatarKey: item['avatar'], radius: 24),

                        const SizedBox(width: 12),

                        // Name & Tag
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isUser ? GameColors.redDark : GameColors.inkBorder,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isUser ? GameColors.redHazard : const Color(0xFF0284C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['badge'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: GameTheme.greenMoneyPillDeco,
                              child: Text(
                                'NET WORTH: ${item['worth']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '🔥 ${item['streak']}',
                              style: const TextStyle(
                                fontSize: 15,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
                Spacer(),
                Text(
                  'NEXT REWARD AT RANK #3 (+500 GEMS)',
                  style: TextStyle(
                    color: GameColors.goldBright,
                    fontSize: 14,
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
                size: 20,
                color: isSelected ? GameColors.inkBorder : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? GameColors.inkBorder : Colors.white70,
                  fontSize: 15,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '1280x720 Native • Cel-Shaded AAA Graphics • Zero Scroll',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
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
              height: 54,
              width: double.infinity,
              borderRadius: 16,
              child: const Text(
                'SAVE & CLOSE SETTINGS',
                style: TextStyle(
                  color: GameColors.inkBorder,
                  fontSize: 18,
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
        Icon(icon, color: GameColors.goldBright, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: GameColors.oakDark,
            fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
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
                                fit: BoxFit.fill,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: GameColors.oakDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TactileButton(
                          onTap: () => CardShowcaseModal.show(context, inspectedCard!),
                          baseColor: GameColors.goldBright,
                          shadowColor: GameColors.brassShadow,
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fullscreen_rounded, color: GameColors.inkBorder, size: 22),
                              SizedBox(width: 6),
                              Text(
                                'FULL SCREEN SHOWCASE',
                                style: TextStyle(
                                  color: GameColors.inkBorder,
                                  fontSize: 15,
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
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
