import 'package:flutter/material.dart';

class AppColor{

  static const  white = Color(0xFFFFFFFF);
  static const  whiteDark = Color(0xFFF4F4F4);
  static const  whiteDarkII = Color(0xFFF5F5F5);
  static const  black = Color(0xff020202);
  static const  blackLight = Color(0x55000000);
  static const  blackLightI = Color(0xff414141);
  static const  royalBlue = Color(0xff4169E1);
  static const  lightBlue = Color(0xff435178);
  static const  grey = Color(0xFFababab);
  static const  greyLight = Color(0xFF9e9e9e);
  static const Color progressIndicator = Color(0xff2A4066);
  static const Color indicatorBlue = Color(0xff007AFF);

  static const LinearGradient circularIndicator = LinearGradient(
      colors: [white, indicatorBlue, progressIndicator],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);




// static   Color scaffoldBgGrey = Colors.grey.shade50;
//
// static const LinearGradient subBtn = LinearGradient(
//   colors: [
//     Color(0xFFFFD700), // golden yellow
//     Color(0xFFfeca1f),
//   ],
// );

}