import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/bank_detail.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/due_wallet.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/edit_profile.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/handyman_list.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/provider_help.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/provider_privacy_policy.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/wallet_history.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
                        onTap: () {
                          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.white,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => EditProfile()),
                  );
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
                          title:
                          "Felix Harris",
                          size: 18,
                          color: AppColor.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        TextConst(
                          title:
                          "demo@provider.com",
                          size: 13,
                          color: AppColor.grey,
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),

            Divider(),
            _drawerItem(
              icon: Icons.wallet,
              title: "Wallet Balance",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => WalletHistory()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.account_balance_wallet_outlined,
              title: "Due Wallet",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => DueWallet()),
                );
              },
            ),

            _drawerItem(
              icon: Icons.people_alt_outlined,
              title: "Handyman List",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => HandymanList()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.account_balance,
              title: "Bank Details ",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => BankDetail()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ProviderHelp()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy & Policy",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ProviderPrivacyPolicy()),
                );
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

            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Container(
            //     height: 50,
            //     decoration: BoxDecoration(
            //       color: Colors.lime,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "Driver mode",
            //         style: TextStyle(
            //             fontSize: 18, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
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
