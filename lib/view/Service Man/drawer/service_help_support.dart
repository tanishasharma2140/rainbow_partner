import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ServiceHelpSupport extends StatefulWidget {
  const ServiceHelpSupport({super.key});

  @override
  State<ServiceHelpSupport> createState() => _ServiceHelpSupportState();
}

class _ServiceHelpSupportState extends State<ServiceHelpSupport> {
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
              title: "Help & Support",
              color: Colors.white,
              size: 20,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const TextConst(
              title: "Need help with services?",
              size: 18,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 15),

            const TextConst(
              title:
              "If you are facing issues related to adding, updating, or managing "
                  "your services, we are here to help.\n\n"

                  "You can explore the guidelines below or contact our support team "
                  "for quick assistance.\n\n"

                  "• Trouble adding new services?\n"
                  "• Not able to update service details?\n"
                  "• Issues with service pricing or duration?\n"
                  "• Want help managing bookings?\n\n"

                  "Our support team is always available to keep your service workflow "
                  "smooth and error-free.",
              size: 14,
              color: Colors.black87,
              fontFamily: AppFonts.poppinsReg,
            ),

            const SizedBox(height: 25),

            const TextConst(
              title: "Contact Support",
              size: 16,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.royalBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  const Icon(Icons.support_agent,
                      size: 32, color: AppColor.royalBlue),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TextConst(
                          title: "Need Quick Support?",
                          size: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 4),
                        TextConst(
                          title:
                          "Contact our support team for immediate assistance.",
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const TextConst(
                      title: "Call",
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
