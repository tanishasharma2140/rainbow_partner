import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class SplashServices {

  Future<void> checkAuthentication(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final userVm = UserViewModel();

      final String? userId = await userVm.getUser();
      final int? role = await userVm.getRole();

      if (kDebugMode) {
        print("User ID: $userId");
        print("Role: $role");
      }

      /// 🔴 NOT LOGGED IN
      if (userId == null || userId.isEmpty) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
        return;
      }

      /// 🟢 LOGGED IN → ROLE BASED NAVIGATION
      switch (role) {
        case 1:
        // 🚕 Cab Driver
        //   Navigator.pushReplacementNamed(
        //     context,
        //     RoutesName.cabDriverDashboard,
        //   );
          break;

        case 2:
        // 🧑‍🔧 Service Provider
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> HandymanDashboard()));
          break;

        case 3:
        // 💼 Need a Job (Service Man)
        //   Navigator.pushReplacementNamed(
        //     context,
        //     RoutesName.serviceManDashboard,
        //   );
          break;

        default:
        // ❓ Role missing → Login
          Navigator.pushReplacementNamed(context, RoutesName.login);
      }

    } catch (e) {
      if (kDebugMode) {
        print("Splash Error: $e");
      }
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }
}
