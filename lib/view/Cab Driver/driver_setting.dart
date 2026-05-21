import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_about_us.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_contact_us.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_help_and_support.dart' show DriverHelpAndSupport;
import 'package:rainbow_partner/view/Cab%20Driver/driver_notification.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_privacy_policy.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_refund_policy.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_service_description.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_terms_and_condition.dart';

class DriverSetting extends StatefulWidget {
  const DriverSetting({super.key});

  @override
  State<DriverSetting> createState() => _DriverSettingState();
}

class _DriverSettingState extends State<DriverSetting> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          centerTitle: true,
          title: TextConst(
            title: loc.settings,
            size: 18,
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _settingCard(
                icon: Icons.notifications_active_outlined,
                title: loc.notifications,
                subtitle: loc.ride_alerts_app_notifications,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverNotification()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.support_agent,
                title: loc.help_support,
                subtitle: loc.for_help_support,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverHelpAndSupport()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.description_outlined,
                title: loc.terms_conditions,
                subtitle: loc.read_terms_service,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>DriverTermsCondition()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.privacy_tip_outlined,
                title: loc.privacy_policy,
                subtitle: loc.how_we_use_data,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverPrivacyPolicy()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.policy,
                title: loc.refund_policy,
                subtitle: loc.read_refund_cancellation_policy,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverRefundPolicy()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.design_services,
                title: loc.service_description,
                subtitle: loc.read_service_description,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverServiceDescription()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.contact_page,
                title: loc.contact_us,
                subtitle: loc.reach_out_help_support,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverContactUs()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.account_box_outlined,
                title: loc.about_us,
                subtitle: loc.know_more_services,
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverAboutUs()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColor.royalBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.royalBlue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextConst(
                    title: title,
                    size: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
