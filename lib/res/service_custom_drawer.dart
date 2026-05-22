import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/auth/splash.dart';
import 'package:rainbow_partner/controller/language_controller.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/bank_update_request.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/edit_serviceman_profile.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_add_bank.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_due_wallet.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_help_support.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_privacy_policy.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_wallet_balance.dart';
import 'package:rainbow_partner/view/Service%20Man/partner_notification.dart';
import 'package:rainbow_partner/view/Service%20Man/service_about_us.dart';
import 'package:rainbow_partner/view/Service%20Man/service_contact_us.dart';
import 'package:rainbow_partner/view/Service%20Man/service_refund_policy.dart';
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
    final loc = AppLocalizations.of(context)!;
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
                  title: loc.are_you_sure_logout,
                  size: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),

                const SizedBox(height: 6),

                TextConst(
                  title: loc.we_will_text, // Or a generic message if "Sign in again to continue" isn't in arb
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
                              title: loc.cancel.toUpperCase(),
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
                              title: loc.exit.toUpperCase(),
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

      // 🔴 1️⃣ Make serviceman offline (API call)
      await serviceOnlineVm.serviceOnlineStatusApi(
        0,
        lat,
        lng,
        context,
      );

      // ✅ Sync with Native side (Offline)
      const MethodChannel('rapido_background_button').invokeMethod('setServicemanOnline', {'online': false});

      // 🔄 2️⃣ Refresh profile
      await profileVm.servicemanProfileApi(lat, lng, context);

    } catch (e) {
      debugPrint("Logout Offline API Error: $e");
    }

    // 🔌 3️⃣ Disconnect socket
    // ServicemanSocketService().disconnect();

    // 🧹 4️⃣ Clear user data
    await UserViewModel().remove();

    // 🚪 5️⃣ Navigate to Splash
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
    final loc = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColor.white,
      width: 280,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
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
                          "${profileVm.servicemanProfileModel?.data?.firstName ?? ''} "
                              "${profileVm.servicemanProfileModel?.data?.lastName ?? ''}",
                          size: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.royalBlue,
                        ),

                        TextConst(
                          title: profileVm.servicemanProfileModel?.data?.email ?? '',
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
                      Text(loc.overlay_permission, style: TextStyle(fontSize: 16)), // "Available Status" doesn't seem to be in arb, using nearest
                      SizedBox(height: 3),

                      Text(
                        profileVm.servicemanProfileModel?.data?.onlineStatus == 1
                            ? loc.online
                            : loc.offline,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: profileVm.servicemanProfileModel?.data?.onlineStatus == 1
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

            Consumer<LanguageController>(
              builder: (context, languageProvider, child) {
                final loc = AppLocalizations.of(context)!;
                return PopupMenuButton<String>(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: const Offset(60, 0),
                  onSelected: (value) {
                    if (value == 'en') {
                      languageProvider.changeLanguage(const Locale('en'));
                    } else if (value == 'hi') {
                      languageProvider.changeLanguage(const Locale('hi'));
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'en',
                      child: Row(
                        children: [
                          Text("🇬🇧", style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          TextConst(title: loc.english),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'hi',
                      child: Row(
                        children: [
                          Text("🇮🇳", style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          TextConst(title: loc.hindi),
                        ],
                      ),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: AppColor.royalBlue),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextConst(
                                title:
                                loc.change_language,
                                size: 16,
                              ),
                              Text(
                                languageProvider.currentLanguageCode == 'en'
                                    ? "🇬🇧  ${loc.english}"
                                    : "🇮🇳  ${loc.hindi}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black45),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ---------------- OTHER DRAWER ITEMS ----------------
            _drawerItem(
              icon: Icons.wallet,
              title: loc.withdraw,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceWalletBalance()));
              },
            ),

            _drawerItem(
              icon: Icons.account_balance_wallet_outlined,
              title: loc.transaction_history,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceDueWallet()));
              },
            ),

            _drawerItem(
              icon: Icons.account_balance,
              title: loc.add_bank,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceAddBank()));
              },
            ),

            _drawerItem(
              icon: Icons.account_box_outlined,
              title: loc.bank_update_request,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => BankUpdateRequest()));
              },
            ),

            _drawerItem(
              icon: Icons.notification_important,
              title: loc.notifications,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => PartnerNotification()));
              },
            ),

            _drawerItem(
              icon: Icons.support_agent,
              title: loc.help_support,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceHelpSupport()));
              },
            ),

            _drawerItem(
              icon: Icons.privacy_tip_outlined,
              title: loc.privacy_policy,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServicePrivacyPolicy()));
              },
            ),

            _drawerItem(
              icon: Icons.description_outlined,
              title: loc.terms_conditions,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceTermsAndCondition()));
              },
            ),

            _drawerItem(
              icon: Icons.info_outline,
              title: loc.about_us,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceAboutUs()));
              },
            ),

            _drawerItem(
              icon: Icons.contact_support_outlined,
              title: loc.contact_us,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceContactUs()));
              },
            ),

            _drawerItem(
              icon: Icons.refresh_outlined,
              title: loc.refund_policy,
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => ServiceRefundPolicy()));
              },
            ),

            Divider(),

            _drawerItem(
              icon: Icons.logout,
              title: loc.exit,
              titleColor: Colors.red,
              iconColor: Colors.red,
              onTap: () => _showLogoutDialog(context),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade600),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: titleColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
