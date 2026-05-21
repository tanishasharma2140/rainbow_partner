import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rainbow_partner/controller/language_controller.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';

import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/custom_text_field.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermissions(); // only once
    });
  }

  // ✅ PERMISSION CHECK (NO LOOP)
  Future<void> checkPermissions() async {

    // 🔔 Notification
    var notificationStatus = await Permission.notification.status;

    if (!notificationStatus.isGranted) {
      notificationStatus = await Permission.notification.request();
    }

    // 📍 Location
    var locationStatus = await Permission.location.status;

    if (!locationStatus.isGranted) {
      locationStatus = await Permission.location.request();
    }

    // ❗ अगर permanently denied → settings
    if (notificationStatus.isPermanentlyDenied ||
        locationStatus.isPermanentlyDenied) {

      Utils.showErrorMessage(context, "Please allow permission from settings");
      openAppSettings();
      return;
    }

    // 📍 Location service check
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Utils.showErrorMessage(context, "Turn on location");
      await Geolocator.openLocationSettings();
      return;
    }

    // ✅ FINAL
    if (notificationStatus.isGranted && locationStatus.isGranted) {
      setState(() {
        isPermissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final loc = AppLocalizations.of(context)!;

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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// Back Button
                        IconButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 26,
                            color: Colors.black,
                          ),
                        ),

                        /// Language Dropdown
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Consumer<LanguageController>(
                            builder: (context, languageProvider, child) {

                              final loc = AppLocalizations.of(context)!;

                              return PopupMenuButton<String>(
                                color: AppColor.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                onSelected: (value) {
                                  if (value == 'en') {
                                    languageProvider.changeLanguage(
                                      const Locale('en'),
                                    );
                                  } else if (value == 'hi') {
                                    languageProvider.changeLanguage(
                                      const Locale('hi'),
                                    );
                                  }
                                },

                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 'en',
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        TextConst(title: loc.english),
                                      ],
                                    ),
                                  ),

                                  PopupMenuItem(
                                    value: 'hi',
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(loc.hindi),
                                      ],
                                    ),
                                  ),
                                ],

                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      const Icon(
                                        Icons.language,
                                        size: 18,
                                        color: Colors.black87,
                                      ),

                                      const SizedBox(width: 6),

                                      Text(
                                        languageProvider.currentLanguageCode == 'en'
                                            ? loc.english
                                            : loc.hindi,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(width: 4),

                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: Sizes.screenHeight * 0.02),

                    TextConst(
                      textAlign: TextAlign.center,
                      title: loc.join_us_via,
                      size: 25,
                      fontWeight: FontWeight.w700,
                    ),

                    SizedBox(height: Sizes.screenHeight * 0.01),

                    TextConst(
                      title: loc.we_will_text,
                      size: 16,
                      color: AppColor.blackLightI,
                    ),

                    SizedBox(height: Sizes.screenHeight * 0.05),

                    CustomTextField(
                      cursorColor: AppColor.black,
                      cursorHeight: Sizes.screenHeight * 0.02,
                      width: Sizes.screenWidth * 0.85,
                      controller: auth.phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      height: Sizes.screenHeight * 0.09,
                      fillColor: AppColor.whiteDark,
                      borderRadius: BorderRadius.circular(14),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 13, bottom: 1, right: 7),
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
                          title: loc.next,
                        textColor: AppColor.white,
                        bgColor: isPermissionGranted
                            ? AppColor.royalBlue
                            : Colors.grey, // disabled look
                          onTap: () async {

                            await checkPermissions();

                            if (!isPermissionGranted) return;

                            String phone = auth.phoneController.text.trim();

                            if (phone.isEmpty || phone.length != 10) {
                              Utils.showErrorMessage(context, loc.please_enter_valid);
                              return;
                            }

                            auth.otpSentApi(phone, context);
                          }
                      ),
                    ),

                    SizedBox(height: Sizes.screenHeight * 0.03),
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
                        boxShadow: const [
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