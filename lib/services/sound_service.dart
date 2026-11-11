import 'package:flutter/services.dart';

class SoundService {
  static final SoundService instance = SoundService._();
  SoundService._();

  bool isMuted = false;

  void toggleSound() {
    isMuted = !isMuted;
    if (!isMuted) {
      playClick();
    }
  }

  void playClick() {
    if (isMuted) return;
    try {
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  void playGavel() {
    if (isMuted) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  void playCashRegister() {
    if (isMuted) return;
    try {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  void playCrateOpen() {
    if (isMuted) return;
    try {
      HapticFeedback.vibrate();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }
}
