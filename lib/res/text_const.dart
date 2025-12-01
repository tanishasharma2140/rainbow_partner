import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';

class TextConst extends StatelessWidget {
  final String title;
  final double? size;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;

  const TextConst({
    super.key,
    required this.title,
    this.size,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.fontStyle,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontFamily: fontFamily ?? AppFonts.kanitReg,
        color: color ?? AppColor.black,
        fontSize: size ?? kDefaultFontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontStyle: fontStyle ?? FontStyle.normal,
        shadows: shadows,
      ),
    );
  }
}
