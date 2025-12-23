import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/custom_text_field.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';
import '../main.dart' show bottomPadding;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.white,

          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          SystemNavigator.pop();

                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                    TextConst(
                      textAlign: TextAlign.center,
                      title: "Join us via phone number",
                      size: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.01),
                    // SUBTITLE
                    TextConst(
                      title: "We’ll text a code to verify your phone",
                      size: 16,
                      color: AppColor.blackLightI,
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.05),
                    CustomTextField(
                      cursorColor: AppColor.black,
                      cursorHeight: Sizes.screenHeight*0.02,
                      width: Sizes.screenWidth * 0.85,
                      controller: auth.phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,   // ⭐ Only numbers allowed
                      ],
                      height: Sizes.screenHeight * 0.09,
                      fillColor: AppColor.whiteDark,
                      borderRadius: BorderRadius.circular(14),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 13, bottom: 1,right: 7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/india.png", width: 30),
                            const SizedBox(width: 7),
                            const TextConst(
                              title: "+91",
                              size: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.screenWidth * 0.06,
                      ),
                      child: CustomButton(
                        title: "Next",
                        textColor: AppColor.white,
                        bgColor: AppColor.royalBlue,
                        onTap: () {
                          String phone = auth.phoneController.text.trim();

                          if (phone.isEmpty || phone.length != 10) {
                            Utils.showErrorMessage(context, "Please enter a valid 10-digit mobile number");
                            return;
                          }
                          auth.otpSentApi(phone, context);
                        },
                      ),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.03),
                    // SizedBox(height: bottomPadding),
                  ],
                ),
              ),
              if (auth.loading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      height: Sizes.screenHeight * 0.13,
                      width: Sizes.screenWidth * 0.28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: GradientCirPro(
                          strokeWidth: 6,
                          size: 70,
                          gradient: AppColor.circularIndicator,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
