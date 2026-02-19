import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/auth/splash.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/service/background_service.dart';
import 'package:rainbow_partner/service/socket_service.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/bank_update_request.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/edit_serviceman_profile.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_add_bank.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_due_wallet.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_help_support.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_privacy_policy.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_wallet_balance.dart';
import 'package:rainbow_partner/view/Service%20Man/partner_notification.dart';
import 'package:rainbow_partner/view/Service%20Man/service_terms_and_condition.dart';
import 'package:rainbow_partner/view_model/service_man/service_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServiceCustomDrawer extends StatefulWidget {
  const ServiceCustomDrawer({super.key});

  @override
  State<ServiceCustomDrawer> createState() => _ServiceCustomDrawerState();
}

class _ServiceCustomDrawerState extends State<ServiceCustomDrawer> {


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // WHITE BACKGROUND
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout,
                  color: Colors.black, // BLACK ICON
                  size: 32,
                ),

                const SizedBox(height: 14),

                TextConst(
                  title: "Sign Out?",
                  size: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),

                const SizedBox(height: 6),

                TextConst(
                  title: "Sign in again to continue",
                  textAlign: TextAlign.center,
                  size: 13,
                  color: Colors.grey,
                  fontFamily: AppFonts.poppinsReg,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    // CANCEL BUTTON
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Center(
                            child: TextConst(
                              title: "CANCEL",
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // SIGN OUT BUTTON
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context); // dialog close first
                          await _handleServicemanLogout();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: Center(
                            child: TextConst(
                              title: "SIGN OUT",
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleServicemanLogout() async {
    try {
      final serviceOnlineVm =
      Provider.of<ServiceOnlineStatusViewModel>(context, listen: false);

      final profileVm =
      Provider.of<ServicemanProfileViewModel>(context, listen: false);

      // 🔥 Get current location
      final position = await LocationUtils.getLocation();
      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      // 🔴 1️⃣ Make serviceman offline
      await serviceOnlineVm.serviceOnlineStatusApi(
        0,
        lat,
        lng,
        context,
      );

      // 🔄 2️⃣ Refresh profile (optional but good)
      await profileVm.servicemanProfileApi(lat, lng, context);

    } catch (e) {
      debugPrint("Logout Offline API Error: $e");
    }

    // 🔌 3️⃣ Disconnect socket (UI side)
    ServicemanSocketService().disconnect();

    // 📴 4️⃣ Stop background service
    await stopServicemanBackgroundService();

    // 🧹 5️⃣ Clear user data
    await UserViewModel().remove();

    // 🚪 6️⃣ Navigate to Splash
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Splash()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = Provider.of<ServicemanProfileViewModel>(context);

    return Drawer(
      backgroundColor: AppColor.white,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- PROFILE HEADER ----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => EditServicemanProfile()));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        profileVm.servicemanProfileModel?.data?.profilePhoto??"",
                      ),
                    ),

                    SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConst(
                          title:
                          "${profileVm.servicemanProfileModel!.data!.firstName} "
                              "${profileVm.servicemanProfileModel!.data!.lastName}",
                          size: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.royalBlue,
                        ),

                        TextConst(
                          title: profileVm.servicemanProfileModel!.data!.email,
                          size: 13,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Divider(),

            // ---------------- AVAILABLE STATUS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.event_available, size: 24, color: Colors.grey),

                  SizedBox(width: 18),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Available Status", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 3),

                      Text(
                        profileVm.servicemanProfileModel!.data!.onlineStatus == 1
                            ? "Online"
                            : "Offline",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: profileVm.servicemanProfileModel!.data!.onlineStatus == 1
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),
                ],
              ),
            ),

            // ---------------- OTHER DRAWER ITEMS ----------------
            _drawerItem(
              icon: Icons.wallet,
              title: "Withdraw",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceWalletBalance()));
              },
            ),

            _drawerItem(
              icon: Icons.account_balance_wallet_outlined,
              title: "Transaction History",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceDueWallet()));
              },
            ),

            _drawerItem(
              icon: Icons.account_balance,
              title: "Add Bank",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceAddBank()));
              },
            ),

            _drawerItem(
              icon: Icons.account_box_outlined,
              title: "Bank Update Request",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => BankUpdateRequest()));
              },
            ),

            _drawerItem(
              icon: Icons.notification_important,
              title: "Notification",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => PartnerNotification()));
              },
            ),

            _drawerItem(
              icon: Icons.support_agent,
              title: "Help & Support",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceHelpSupport()));
              },
            ),

            _drawerItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServicePrivacyPolicy()));
              },
            ),
            _drawerItem(
              icon: Icons.privacy_tip_outlined,
              title: "Term & Condition",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceTermsAndCondition()));
              },
            ),
            _drawerItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                _showLogoutDialog(context);
              },
            ),

            Spacer(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey),
            SizedBox(width: 18),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
