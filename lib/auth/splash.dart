import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_loader.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/service/splash_service.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';

import '../res/app_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  SplashServices services = SplashServices();
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  bool _showTextImage = true;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    Timer(const Duration(milliseconds: 300), () {
      _controller.forward();
    });

    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        _showLogo = true;
      });
    });

    Timer(const Duration(seconds: 3), () {
      services.checkAuthentication(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.royalBlue,
        body: Column(
          children: [
            const Spacer(),

            if (_showLogo)
              FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/rainbow_logo.png',
                    width: 240,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (_showTextImage)
              FadeTransition(
                opacity: _textAnimation,
                child: Image.asset(
                  'assets/rainbow_part_text.png',
                  width: 190,
                ),
              ),
            const Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.circle, size: 15, color: AppColor.white),
                    SizedBox(width: 8),
                    TextConst(
                      title: "rainboW Partner",
                      size: 15,
                      color: AppColor.white,
                      fontFamily: AppFonts.poppinsReg,
                    ),
                  ],
                ),

                SizedBox(height: Sizes.screenHeight * 0.02),

                const CustomLoader(),
                SizedBox(height: Sizes.screenHeight * 0.04),
              ],
            ),
          ],
        ),
      ),
    );
  }
}