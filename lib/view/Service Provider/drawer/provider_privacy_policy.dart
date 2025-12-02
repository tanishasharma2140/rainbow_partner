import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ProviderPrivacyPolicy extends StatefulWidget {
  const ProviderPrivacyPolicy({super.key});

  @override
  State<ProviderPrivacyPolicy> createState() => _ProviderPrivacyPolicyState();
}

class _ProviderPrivacyPolicyState extends State<ProviderPrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            TextConst(
              title: "Privacy Policy",
              color: Colors.white,
              size: 20,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const TextConst(
              title: "Your Privacy Matters to Us",
              size: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),

            SizedBox(height: 15),

            const TextConst(
              title:
              "We are committed to protecting your personal information and "
                  "ensuring a safe and secure experience on our platform. "
                  "This Privacy Policy explains how we collect, use, and protect your data.\n\n"

                  "When you use our app, we may collect basic details such as your "
                  "name, phone number, email address, service details, and location "
                  "information. This data is only used to improve your experience, "
                  "manage your bookings, process payouts, and provide better service.\n\n"

                  "We never share your personal information with any third-party "
                  "advertisers or agencies. Your data is stored securely and only "
                  "used for operational and support purposes.\n\n"

                  "You have full control over your account information. You can update, "
                  "modify, or request deletion of your data at any time. If you have "
                  "any concerns about your privacy or data security, you can contact "
                  "our support team and we will be happy to assist you.",
              size: 15,
              color: Colors.black87,
            ),

            SizedBox(height: 25),

            const TextConst(
              title: "Data Protection",
              size: 18,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 10),

            const TextConst(
              title:
              "We implement strict security measures to keep your information safe. "
                  "This includes encrypted communication, secure servers, and controlled "
                  "access to personal data. Your privacy and trust are our top priorities.",
              size: 14,
              color: Colors.black87,
            ),

            SizedBox(height: 25),

            const TextConst(
              title: "Contact Us",
              size: 18,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 10),

            const TextConst(
              title:
              "If you have questions regarding this Privacy Policy or how your data "
                  "is handled, please feel free to reach out to our support team anytime.",
              size: 14,
              color: Colors.black87,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
