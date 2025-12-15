import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class JobRequestSuccessPage extends StatelessWidget {
  const JobRequestSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // back disable
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ✅ SUCCESS ICON
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 25),

                // ✅ TITLE
                const TextConst(
                  title: "Request Submitted!",
                  size: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // ✅ MESSAGE
                const TextConst(
                  title:
                  "Tumhara job request successfully submit ho gaya hai.\nAb job assign hone ka wait karo.",
                  size: 15,
                  color: Colors.black54,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                // ✅ BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.royalBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // ya Home page pe bhejo
                    },
                    child: const TextConst(
                      title: "Go to Home",
                      size: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
