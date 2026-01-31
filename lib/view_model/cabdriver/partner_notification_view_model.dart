import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/partner_notification_model.dart';
import 'package:rainbow_partner/repo/cabdriver/partner_notification_repo.dart';

class PartnerNotificationViewModel with ChangeNotifier {
  final _partnerNotificationRepo = PartnerNotificationRepo();

  bool _loading = false;
  bool get loading => _loading;

  PartnerNotificationModel? _partnerNotificationModel;
  PartnerNotificationModel? get partnerNotificationModel => _partnerNotificationModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setPartnerNotifyModelData(PartnerNotificationModel value) {
    _partnerNotificationModel = value;
    notifyListeners();
  }

  Future<void> partnerNotificationApi(dynamic data,dynamic entityId) async {
    setLoading(true);

    try {
      final response = await _partnerNotificationRepo.partnerNotificationApi(data,entityId);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = PartnerNotificationModel.fromJson(body);
        setPartnerNotifyModelData(model);
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
