import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/review_model.dart';
import 'package:rainbow_partner/repo/serviceman/review_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ReviewViewModel with ChangeNotifier {
  final ReviewRepo _reviewRepo = ReviewRepo();

  bool _loading = false;
  bool get loading => _loading;

  ReviewModel? _reviewModel;
  ReviewModel? get reviewModel => _reviewModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setReviewModelData(ReviewModel value) {
    _reviewModel = value;
    notifyListeners();
  }

  Future<void> reviewApi(context) async {
    _setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      final Map<String, dynamic> data = {
        "serviceman_id": userId,
      };

      if (kDebugMode) {
        debugPrint("🚀 WALLET HISTORY API DATA → $data");
      }

      final response = await _reviewRepo.reviewApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        _setReviewModelData(ReviewModel.fromJson(body));
      } else {
        if (kDebugMode) {
          debugPrint("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ WalletHistoryViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      _setLoading(false); // ✅ MOST IMPORTANT
    }
  }
}
