import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_about_us.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_contact_us.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_help_and_support.dart' show DriverHelpAndSupport;
import 'package:rainbow_partner/view/Cab%20Driver/driver_notification.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_privacy_policy.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_refund_policy.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_terms_and_condition.dart';

class DriverSetting extends StatefulWidget {
  const DriverSetting({super.key});

  @override
  State<DriverSetting> createState() => _DriverSettingState();
}

class _DriverSettingState extends State<DriverSetting> {
  @override
  Widget build(BuildContext context) {
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
            title: 'Settings',
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
                title: 'Notifications',
                subtitle: 'Ride alerts & app notifications',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverNotification()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.support_agent,
                title: 'Help & Support',
                subtitle: 'For Help & Support',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverHelpAndSupport()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our terms of service',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>DriverTermsCondition()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we use your data',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverPrivacyPolicy()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.policy,
                title: 'Refund Policy',
                subtitle: 'Read our refund & Cancellation policy ',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverRefundPolicy()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.contact_page,
                title: 'Contact us',
                subtitle: 'Reach out for help and support',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverContactUs()));
                },
              ),
              const SizedBox(height: 12),
              _settingCard(
                icon: Icons.account_box_outlined,
                title: 'About us',
                subtitle: 'Know more about our services',
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
