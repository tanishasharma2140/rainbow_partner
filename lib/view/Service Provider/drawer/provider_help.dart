import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ProviderHelp extends StatefulWidget {
  const ProviderHelp({super.key});

  @override
  State<ProviderHelp> createState() => _ProviderHelpState();
}

class _ProviderHelpState extends State<ProviderHelp> {
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
                title:
                "Help Support",
                color: Colors.white, size: 20, fontWeight: FontWeight.w600
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const TextConst(
              title:
              "How can we help you?",
              size: 18,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 15),

            const TextConst(
              title:
              "If you need any assistance regarding your account, "
                  "services, bookings, payouts, or app-related issues, "
                  "you can reach out to our support team anytime. "
                  "We are always ready to help you with quick and reliable solutions.\n\n"

                  "For basic queries, please make sure your app is updated "
                  "to the latest version. If the problem still continues, "
                  "contact our support team using the details below.\n\n"

                  "• Need help adding or updating services?\n"
                  "• Want to change your profile details?\n"
                  "• Having issues with bookings or payments?\n"
                  "• Any technical errors in the app?\n\n"

                  "No matter what the issue is, we are here to support you "
                  "and ensure your experience on our platform remains smooth.",

              size: 14,
              fontFamily: AppFonts.poppinsReg,
              color: Colors.black87,
            ),

            const SizedBox(height: 25),

             TextConst(
               title:
              "Contact Support",
               size: 16,
               fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.royalBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  const Icon(Icons.support_agent, size: 32, color: AppColor.royalBlue),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TextConst(
                          title:
                          "Need Immediate Help?",
                          size: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 4),
                        TextConst(
                          title:
                          "Chat with our support team for quick assistance.",
                          size: 13,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.royalBlue,
                    ),
                    child: const TextConst(title: "call",color: AppColor.white,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
