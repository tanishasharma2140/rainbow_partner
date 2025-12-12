import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {

  // ---------------- SAVE TOKEN + ROLE ---------------- //
  Future<bool> saveUser(String userId, int role) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('token', userId);
    await sp.setInt('role', role);  // 1 = rainbow driver, 2 = serviceman, 3 = need a job

    notifyListeners();
    return true;
  }

  // ---------------- GET TOKEN ---------------- //
  Future<String?> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token');
  }

  // ---------------- GET ROLE ---------------- //
  Future<int?> getRole() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt('role');   // returns 1, 2, or 3
  }

  // ---------------- REMOVE TOKEN + ROLE ---------------- //
  Future<bool> remove() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.remove('token');
    await sp.remove('role');

    notifyListeners();
    return true;
  }
}
