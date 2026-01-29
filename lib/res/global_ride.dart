import 'package:audioplayers/audioplayers.dart';

class GlobalRideRinger {
  static final GlobalRideRinger _instance = GlobalRideRinger._internal();
  factory GlobalRideRinger() => _instance;
  GlobalRideRinger._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentOrderId;

  Future<void> play({required String orderId}) async {
    if (_isPlaying && _currentOrderId == orderId) return;

    _currentOrderId = orderId;
    _isPlaying = true;

    await _player.stop(); // 🔒 safety
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('driver_ring.mp3'));
  }


  Future<void> stop() async {
    if (!_isPlaying) return;
    await _player.stop();
    _isPlaying = false;
    _currentOrderId = null;
  }
}
