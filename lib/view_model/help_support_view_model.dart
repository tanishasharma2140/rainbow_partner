import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/help_support_model.dart';
import 'package:rainbow_partner/repo/help_support_repo.dart';

class HelpSupportViewModel with ChangeNotifier {
  final _helpSupportRepo = HelpSupportRepo();

  bool _loading = false;
  bool get loading => _loading;

  HelpSupportModel? _helpSupportModel;
  HelpSupportModel? get helpSupportModel => _helpSupportModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setHelpSupportModelData(HelpSupportModel value) {
    _helpSupportModel = value;
    notifyListeners();
  }

  // ---------------- API CALL ----------------
  Future<void> helpSupportApi(dynamic data) async {
    setLoading(true);

    try {
      final response = await _helpSupportRepo.helpSupportApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = HelpSupportModel.fromJson(body);
        setHelpSupportModelData(model);
      } else {
        if (kDebugMode) {
          print("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ ViewModel Error → $e");
      }
    } finally {
      setLoading(false);
    }
  }
}
