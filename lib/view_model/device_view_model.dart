import 'package:flutter/foundation.dart';
import '../repo/device_repo.dart';

class DeviceViewModel with ChangeNotifier {
  final _repo = DeviceRepo();

  String? _deviceId;
  String? get deviceId => _deviceId;

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  // MAIN FUNCTION
  Future<void> fetchDeviceId() async {
    _setLoading(true);

    String id = await _repo.getDeviceId();
    _deviceId = id;

    if (kDebugMode) {
      print("Fetched Device ID → $id");
    }

    _setLoading(false);
  }
}
