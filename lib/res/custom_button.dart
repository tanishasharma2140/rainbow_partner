import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/text_const.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double? size;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.bgColor = Colors.black,
    this.textColor = Colors.white,

    this.borderRadius = 12,
    this.height = 48,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: TextConst(
          title: title,
          fontWeight: fontWeight,
          color: textColor,
          size: size ?? fontSize, // 🔥 default size support
        ),
      ),
    );
  }
}
