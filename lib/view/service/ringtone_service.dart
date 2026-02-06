import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum SoundType { ringtone, notification }

class RingtoneService {
  static final RingtoneService _instance = RingtoneService._internal();
  factory RingtoneService() => _instance;
  RingtoneService._internal();

  final AudioPlayer _ringtonePlayer = AudioPlayer();
  final AudioPlayer _notificationPlayer = AudioPlayer();

  bool _isRingtonePlaying = false;

  /// 🔔 LOOP RINGTONE (Incoming booking etc.)
  Future<void> playRingtone() async {
    debugPrint("🔔 playRingtone() called");

    if (_isRingtonePlaying) {
      debugPrint("⚠️ Ringtone already playing");
      return;
    }

    try {
      _isRingtonePlaying = true;
      await _ringtonePlayer.setReleaseMode(ReleaseMode.loop);
      await _ringtonePlayer.play(
        AssetSource('rainbow_driver.mp3'),
      );
      debugPrint("🎵 Ringtone started");
    } catch (e) {
      _isRingtonePlaying = false;
      debugPrint("❌ Ringtone error: $e");
    }
  }

  /// 🔕 STOP RINGTONE
  Future<void> stopRingtone() async {
    debugPrint("🔕 stopRingtone() called");

    if (!_isRingtonePlaying) {
      debugPrint("⚠️ Ringtone not playing");
      return;
    }

    try {
      await _ringtonePlayer.stop();
      _isRingtonePlaying = false;
      debugPrint("🛑 Ringtone stopped");
    } catch (e) {
      debugPrint("❌ Stop ringtone error: $e");
    }
  }

  /// 🔊 ONE-TIME NOTIFICATION SOUND
  Future<void> playNotification() async {
    debugPrint("🔊 playNotification() called");

    try {
      await _notificationPlayer.setReleaseMode(ReleaseMode.stop);
      await _notificationPlayer.play(
        AssetSource('spinning-coin-on-table-352448.mp3'),
      );
      debugPrint("🔔 Notification sound played");
    } catch (e) {
      debugPrint("❌ Notification sound error: $e");
    }
  }

  /// 🧹 CLEANUP
  void dispose() {
    debugPrint("🧹 RingtoneService disposed");
    _ringtonePlayer.dispose();
    _notificationPlayer.dispose();
  }
}
