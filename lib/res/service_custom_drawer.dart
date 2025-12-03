import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/edit_serviceman_profile.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/help_desk.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_due_wallet.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_help_support.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_privacy_policy.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_wallet_balance.dart';

class ServiceCustomDrawer extends StatefulWidget {
  const ServiceCustomDrawer({super.key});

  @override
  State<ServiceCustomDrawer> createState() => _ServiceCustomDrawerState();
}

class _ServiceCustomDrawerState extends State<ServiceCustomDrawer> {

  bool isOnline = false;

  // -------------------------------------------------------
  //                 AVAILABLE STATUS POPUP
  // -------------------------------------------------------
  void showAvailableStatusPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE
                  Text(
                    "Available Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // MAIN STATUS BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xffe9f6ee),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [

                        /// LEFT SIDE TEXT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Available Status",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isOnline ? "You are Online" : "You are Offline",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isOnline ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        /// SWITCH BUTTON
                        Transform.scale(
                          scale: 1.1,
                          child: CupertinoSwitch(
                            value: isOnline,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setSheet(() => isOnline = value);
                              setState(() {}); // 🔥 UPDATE DRAWER TOO
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------
  //                   LOGOUT POPUP
  // -------------------------------------------------------
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, color: Colors.black, size: 32),
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
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: TextConst(
                              title: "CANCEL",
                              color: Colors.grey,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Center(
                            child: TextConst(
                              title: "SIGN OUT",
                              color: Colors.red,
                              size: 14,
                              fontWeight: FontWeight.w600,
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

  // -------------------------------------------------------
  //                       UI
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.white,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------------------------------------------
            //                PROFILE HEADER
            // ---------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> EditServicemanProfile()));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(Icons.person, size: 40),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConst(
                          title: "John Doe",
                          size: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.royalBlue,
                        ),
                        TextConst(
                          title: "demo@handyman.com",
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

            // ---------------------------------------------------
            //           AVAILABLE STATUS ITEM (LIVE)
            // ---------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: InkWell(
                onTap: () => showAvailableStatusPopup(context),
                child: Row(
                  children: [
                    Icon(Icons.event_available, size: 24, color: Colors.grey),

                    SizedBox(width: 18),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Available Status",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 3),
                        Text(
                          isOnline ? "Online" : "Offline",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isOnline ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),

            // ---------------------------------------------------
            //                   OTHER ITEMS
            // ---------------------------------------------------
            _drawerItem(
              icon: Icons.wallet,
              title: "Wallet Balance",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ServiceWalletBalance()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.account_balance_wallet_outlined,
              title: "Due Wallet",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ServiceDueWallet()),
                );
              },
            ),

            _drawerItem(
              icon: Icons.support_agent,
              title: "Help Desk",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => HelpDesk()),
                );
              },
            ),

            _drawerItem(
              icon: Icons.help,
              title: "Help & Support",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ServiceHelpSupport()),
                );
              },
            ),

            _drawerItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ServicePrivacyPolicy()),
                );
              },
            ),

            _drawerItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () => _showLogoutDialog(context),
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
