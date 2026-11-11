# Auction Wars (Flutter Edition)

A high-stakes, fast-flipping auction bidding game built in Flutter for Android Studio, strictly developed under the **Landscape Mode Specification Mandate** (16:9 aspect ratio, 1920x1080 native resolution, locked viewport 100vw × 100dvh, zero scrolling).

---

## 🎨 Visual Style & Theme
- **Cel-Shaded Cartoon Art**: Thick black ink outlines (3.5px), rich drop shadows, warm parchment canvas, and beveled dark oak picture framing with brass brackets and golden rivets.
- **Cheerful Cartoon Characters**: Completely devoid of generic emojis—featuring smiling cartoon auctioneers, expressive human bidders with cash fans, and crowned AI robots.
- **111 Unique Collectible Cards**: 50 High-Value Assets, 50 Junk & Hazards, and 11 Tactical Special Ops cards, with authentic cel-shaded vector illustrations from `e:\acomic\main cards`.

---

## 📂 Project Structure
```
auction_wars_flutter/
├── android/                   # Native Android project (configured for Android Studio)
│   └── app/src/main/
│       └── AndroidManifest.xml # Locked to sensorLandscape, full-screen immersive
├── assets/
│   └── cards/                 # 111 PNG card illustrations from e:\acomic\main cards
├── lib/
│   ├── main.dart              # Landscape 16:9 1920x1080 viewport wrapper
│   ├── models/
│   │   ├── card_data.dart     # Complete 111 card database with values, categories, pawn rates
│   │   ├── crate_lot.dart     # 2.5D Crate Lot generator (3 mystery crates per round)
│   │   └── player_model.dart  # Player & AI bot state (liquid cash, stash, debt, ops)
│   ├── screens/
│   │   ├── home_screen.dart   # Section 1.1 Home Menu Screen
│   │   └── game_screen.dart   # Section 1.2 Gameplay Screen
│   ├── services/
│   │   └── sound_service.dart # Pure-Dart audio & haptics service
│   ├── theme/
│   │   └── game_theme.dart    # Oak, felt, gold, ink palettes & styles
│   └── widgets/
│       ├── tactile_button.dart        # 3D embossed tactile cartoon buttons
│       ├── cartoon_frame.dart         # Beveled dark oak picture frame with brass rivets
│       ├── cel_character_painter.dart # Vector cartoon auctioneer, bidders, avatars
│       ├── decorative_corners.dart    # Fanned card decks, bidding tickets, characters
│       ├── header_bar.dart            # Animated gavel strike, 3D block logo, toggles
│       ├── mode_hero_card.dart        # 3 Hero Cards (Online, Local Party, VS Bots)
│       ├── bottom_vault_banner.dart   # Vault & Card Compendium banner
│       ├── card_view.dart             # Card Layout Blueprint (Section 1.3)
│       ├── modals/
│       │   └── setup_modals.dart      # Setup modals, Leaderboard, 111-card browser
│       └── game/
│           ├── top_nav_strip.dart     # Round tracker, Shark Loan bar, Market/Ops
│           ├── center_crates_view.dart# 3 Isometric crates, chains, padlocks, pot, bills
│           ├── opponent_seat_view.dart# Top arc opponent seats with speech bubbles
│           ├── bottom_player_dock.dart# YOU dock: avatar, bid/item money, ops tray, toast
│           ├── sidebar_panel.dart     # Retractable Pawn Shop & Quick-Turn controls
│           └── lot_reveal_dialog.dart # Crate opening ceremony
└── test/
    └── widget_test.dart       # Comprehensive smoke & integration tests
```

---

## 🚀 How to Open and Run in Android Studio
1. Open **Android Studio**.
2. Click **Open** and select:
   `C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter`
3. Wait for the Flutter & Dart plugins to index the project.
4. Select your target device (e.g. Android Phone/Tablet Emulator, Windows Desktop, or Chrome).
5. Press **Run** (`Shift + F10`) or click the green Play button.

### Command Line Execution
```bash
cd "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter"

# Run tests
flutter test

# Run application
flutter run -d windows    # For Windows Desktop
flutter run -d chrome     # For Web
flutter run -d android    # For Android Emulator or Device
```
