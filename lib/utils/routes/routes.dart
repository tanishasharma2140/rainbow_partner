import 'package:flutter/material.dart';
import 'package:rainbow_partner/auth/login.dart';
import 'package:rainbow_partner/auth/onboarding_screen.dart';
import 'package:rainbow_partner/auth/otp_screen.dart';
import 'package:rainbow_partner/auth/splash.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/ride%20history/cab_ride_history.dart';
import 'package:rainbow_partner/view/Cab%20Driver/ride_waiting_screen.dart';
import 'package:rainbow_partner/view/Service%20Man/home/accepted_booking.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splashScreen:
        return (context) => const Splash();
      case RoutesName.login:
        return (context) => const Login();
      case RoutesName.rideWaiting:
        return (context) => const RideWaitingScreen();
      case RoutesName.acceptedBooking:
        return (context) => const AcceptedBooking();
      case RoutesName.cabRideHistory:
        return (context) => const CabRideHistory();

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