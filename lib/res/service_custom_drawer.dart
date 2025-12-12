import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/edit_serviceman_profile.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/help_desk.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_add_bank.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_due_wallet.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_help_support.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_privacy_policy.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_wallet_balance.dart';
import 'package:rainbow_partner/view_model/service_man/service_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';

class ServiceCustomDrawer extends StatefulWidget {
  const ServiceCustomDrawer({super.key});

  @override
  State<ServiceCustomDrawer> createState() => _ServiceCustomDrawerState();
}

class _ServiceCustomDrawerState extends State<ServiceCustomDrawer> {

  bool isOnline = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<ServicemanProfileViewModel>(context, listen: false);

      vm.servicemanProfileApi(context).then((_) {
        setState(() {
          isOnline = vm.servicemanProfileModel!.data!.onlineStatus == 1;
        });
      });
    });
  }


  void showAvailableStatusPopup(BuildContext context) {
    final serviceOnlineVm = Provider.of<ServiceOnlineStatusViewModel>(context, listen: false);
    final profileVm = Provider.of<ServicemanProfileViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
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

                  Text("Available Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xffe9f6ee),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Available Status",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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

                        Transform.scale(
                          scale: 1.1,
                          child: CupertinoSwitch(
                            value: isOnline,
                            activeColor: Colors.green,
                            onChanged: (value) async {
                              setSheet(() => isOnline = value);
                              setState(() {});

                              int statusVal = value ? 1 : 0;

                              await serviceOnlineVm.serviceOnlineStatusApi(
                                statusVal,
                                "86768768.09",
                                "55465789.09",
                                context,
                              );

                              // REFRESH PROFILE AFTER STATUS UPDATE
                              await profileVm.servicemanProfileApi(context);

                              setState(() {
                                isOnline = profileVm.servicemanProfileModel!.data!.onlineStatus == 1;
                              });

                              setSheet(() {
                                isOnline = profileVm.servicemanProfileModel!.data!.onlineStatus == 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
                        profileVm.servicemanProfileModel!.data!.profilePhoto,
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
              child: InkWell(
                onTap: () => showAvailableStatusPopup(context),
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

                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),

            // ---------------- OTHER DRAWER ITEMS ----------------
            _drawerItem(
              icon: Icons.wallet,
              title: "Wallet Balance",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceWalletBalance()));
              },
            ),

            _drawerItem(
              icon: Icons.account_balance_wallet_outlined,
              title: "Due Wallet",
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
              icon: Icons.support_agent,
              title: "Help Desk",
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => HelpDesk()));
              },
            ),

            _drawerItem(
              icon: Icons.help,
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
