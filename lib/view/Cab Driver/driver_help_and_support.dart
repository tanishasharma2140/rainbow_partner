import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/help_support_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverHelpAndSupport extends StatefulWidget {
  const DriverHelpAndSupport({super.key});

  @override
  State<DriverHelpAndSupport> createState() => _DriverHelpAndSupportState();
}

class _DriverHelpAndSupportState extends State<DriverHelpAndSupport> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HelpSupportViewModel>(context, listen: false)
          .helpSupportApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final helpSupportVm = Provider.of<HelpSupportViewModel>(context);

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

      body: helpSupportVm.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  "Our support team is always available.",
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

            _supportCard(
              phone: helpSupportVm.helpSupportModel?.data?.supportMobile,
              email: helpSupportVm.helpSupportModel?.data?.email,
            ),
          ],
        ),
      ),
    );
  }

  /// SUPPORT CARD
  Widget _supportCard({String? phone, String? email}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.royalBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [

          Row(
            children: const [
              Icon(Icons.support_agent,
                  size: 32, color: AppColor.royalBlue),
              SizedBox(width: 12),
              Expanded(
                child: TextConst(
                  title: "Need Quick Support?",
                  size: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (phone != null && phone.isNotEmpty)
            _contactRow(
              icon: Icons.call,
              title: phone,
              onIconTap: () {
                Launcher.launchCall(context, phone);
              },
            ),

          if (email != null && email.isNotEmpty)
            _contactRow(
              icon: Icons.mail_outline,
              title: email,
              onIconTap: () {
                Launcher.launchEmail(context, email);
              },
            ),
        ],
      ),
    );
  }

  /// CONTACT ROW WITH RIGHT SIDE CIRCLE ICON
  Widget _contactRow({
    required IconData icon,
    required String title,
    required VoidCallback onIconTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColor.royalBlue),
          const SizedBox(width: 12),

          Expanded(
            child: TextConst(
              title: title,
              size: 14,
            ),
          ),

          GestureDetector(
            onTap: onIconTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColor.royalBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= LAUNCHER HELPER =================
class Launcher {
  static Future<void> launchCall(BuildContext context, String number) async {
    final uri = Uri.parse("tel:$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> launchEmail(BuildContext context, String email) async {
    final uri = Uri.parse("mailto:$email");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
