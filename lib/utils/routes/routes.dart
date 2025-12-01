import 'package:flutter/material.dart';
import 'package:rainbow_partner/auth/login.dart';
import 'package:rainbow_partner/auth/onboarding_screen.dart';
import 'package:rainbow_partner/auth/splash.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splashScreen:
        return (context) => const Splash();
      case RoutesName.login:
        return (context) => const Login();
      case RoutesName.onboardingScreen:
        return (context) => const OnboardingScreen();

      default:
        return (context) => const Scaffold(
          body: Center(
            child: Text(
              'No Route Found!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        );
    }
  }
}