import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';

class DocumentVerified extends StatefulWidget {
  const DocumentVerified({super.key});

  @override
  State<DocumentVerified> createState() => _DocumentVerifiedState();
}

class _DocumentVerifiedState extends State<DocumentVerified> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

               TextConst(
                 title:
                "Set up access to ride\nrequests",
                 size: 25,
                 fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 35),

              // -------------------------
              // TIMELINE
              // -------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ICONS + LINES
                  Column(
                    children: [
                      // Green Tick
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.check, color: Colors.white),
                      ),

                      // Green Line
                      Container(
                        height: 70,
                        width: 3,
                        color: Colors.green,
                      ),

                      // Black Icon
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                        child: const Icon(Icons.credit_card,
                            color: Colors.white, size: 20),
                      ),

                      Container(
                        height: 70,
                        width: 3,
                        color: Colors.grey.shade300,
                      ),

                      // Grey Icon
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.directions_car,
                            color: Colors.grey, size: 22),
                      ),
                    ],
                  ),

                  const SizedBox(width: 18),

                  // TEXT BLOCK
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // STEP 1
                         TextConst(
                           title:
                          "Documents submitted",
                             size: 18, fontWeight: FontWeight.w600
                        ),
                        const SizedBox(height: 4),
                        TextConst(
                          title:
                          "We have all the info we need to verify you",
                          size: 15,
                          fontFamily: AppFonts.poppinsReg,
                          color: Colors.grey.shade700,
                        ),

                        const SizedBox(height: 30),

                         TextConst(
                           title:
                          "Set up access to ride requests",
                             size: 18, fontWeight: FontWeight.w600
                        ),
                        const SizedBox(height: 4),
                        TextConst(
                          title:
                          "You'll be ready to accept ride requests right after verification",
                          size: 15,
                          fontFamily: AppFonts.poppinsReg,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(height: 30),
                         TextConst(
                           title:
                          "Wait for verification result",
                             size: 18, fontWeight: FontWeight.w600),
                        const SizedBox(height: 4),
                        TextConst(
                          title:
                          "We'll notify you within 24 hours",
                          size: 15,
                          fontFamily: AppFonts.poppinsReg,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 35),

              // -------------------------
              // OTHER DOCUMENT SECTION
              // -------------------------
              //  TextConst(
              //    title:
              //   "Other documents you can upload:",
              //    size: 18, fontWeight: FontWeight.w600,
              // ),

              // const SizedBox(height: 10),
              //
              // Row(
              //   children: [
              //     const Icon(Icons.description_outlined, size: 28),
              //     const SizedBox(width: 12),
              //     const Expanded(
              //       child: Text(
              //         "Police clearance certificate (optional)",
              //         style: TextStyle(fontSize: 17),
              //       ),
              //     ),
              //     const Icon(Icons.chevron_right, size: 28),
              //   ],
              // ),

              const Spacer(),

              // -------------------------
              // BOTTOM BUTTON
              // -------------------------
              CustomButton(
                  bgColor: AppColor.royalBlue,
                  title: "Go to setup", onTap: (){}),
              SizedBox(height: Sizes.screenHeight*0.025,)
            ],
          ),
        ),
      ),
    );
  }
}
