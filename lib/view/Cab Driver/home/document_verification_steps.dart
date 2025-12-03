import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';

class DocumentVerificationSteps extends StatefulWidget {
  const DocumentVerificationSteps({super.key});

  @override
  State<DocumentVerificationSteps> createState() => _DocumentVerificationStepsState();
}

class _DocumentVerificationStepsState extends State<DocumentVerificationSteps> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.black, size: 30),
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// --------------------- IMAGE ---------------------
                Image.asset(
                  "assets/reject_document.png",
                  height: 260,
                ),

                const SizedBox(height: 25),

                /// --------------------- TITLE ---------------------
                const TextConst(
                  title: "Online check rejected",
                  textAlign: TextAlign.center,
                  size: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),

                const SizedBox(height: 12),

                const TextConst(
                  title: "Verify that your data is correct and send it again.",
                  textAlign: TextAlign.center,
                  size: 15,
                  color: Colors.black54,
                ),

                const SizedBox(height: 40),

                CustomButton(
                    bgColor: AppColor.royalBlue,
                    title: "Resubmit Document", onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>DriverHomePage()));
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
