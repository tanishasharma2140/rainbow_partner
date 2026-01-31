import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/policy_model.dart';
import 'package:rainbow_partner/repo/policy_repo.dart';

class PolicyViewModel with ChangeNotifier {
  final _policyRepo = PolicyRepo();

  bool _loading = false;
  bool get loading => _loading;

  PolicyModel? _policyModel;
  PolicyModel? get policyModel => _policyModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setPolicyModelData(PolicyModel value) {
    _policyModel = value;
    notifyListeners();
  }

  Future<void> policyApi(dynamic data) async {
    setLoading(true);

    try {
      final response = await _policyRepo.policyApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = PolicyModel.fromJson(body);
        setPolicyModelData(model);
      } else {
        if (kDebugMode) print("❌ Error Status: $statusCode → $body");
      }

    } catch (e) {
      if (kDebugMode) print("ViewModel Error → $e");
    } finally {
      setLoading(false);
    }
  }
}
