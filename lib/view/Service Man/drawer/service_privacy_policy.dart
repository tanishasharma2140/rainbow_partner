import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ServicePrivacyPolicy extends StatefulWidget {
  const ServicePrivacyPolicy({super.key});

  @override
  State<ServicePrivacyPolicy> createState() => _ServicePrivacyPolicyState();
}

class _ServicePrivacyPolicyState extends State<ServicePrivacyPolicy> {
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
            const TextConst(
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
              title: "Your Privacy Matters",
              size: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),

            SizedBox(height: 15),

            const TextConst(
              title:
              "We value your trust and are committed to protecting your service-related "
                  "information. This Privacy Policy explains how we collect, manage, and "
                  "use provider service data in our platform.\n\n"

                  "When you add or update your services in our app, we may collect details "
                  "such as service images, descriptions, pricing, duration, and location. "
                  "This information helps in displaying your services correctly to customers "
                  "and improving overall service visibility.\n\n"

                  "Your service data is only used within the platform to help customers "
                  "understand your offerings better. We do not share your service-related "
                  "information with third-party advertisers or unauthorized platforms.\n\n"

                  "You can update or modify your service details anytime. If you want to "
                  "remove a service or have any privacy concerns, you can contact our "
                  "support team for assistance.",
              size: 15,
              color: Colors.black87,
            ),

            SizedBox(height: 25),

            const TextConst(
              title: "Service Data Security",
              size: 18,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 10),

            const TextConst(
              title:
              "We use secure servers and encrypted systems to protect your service "
                  "information from unauthorized access. Only verified users and admins "
                  "can view or manage your service-related data. Your security and trust "
                  "are our top priorities.",
              size: 14,
              color: Colors.black87,
            ),

            SizedBox(height: 25),

            const TextConst(
              title: "Need Help?",
              size: 18,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 10),

            const TextConst(
              title:
              "If you have any questions regarding your service privacy or want to "
                  "know how your data is handled, feel free to contact our support team "
                  "anytime. We are always here to help.",
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
