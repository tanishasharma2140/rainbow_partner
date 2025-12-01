import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rainbow_partner/res/sizing_const.dart';

import 'app_color.dart';



class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? icon;
  final Color? iconColor;
  final String? hintText;
  final bool? filled;
  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final void Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? hintSize;
  final double? fontSize;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? contentPadding;
  final double? cursorHeight;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BorderRadius? fieldRadius;
  final bool? enabled;
  final void Function()? onTap;
  final bool autofocus;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;
  final Color? hintColor;
  final String? errorText;
  final BorderSide? borderSide;
  final Color? textColor;
  final FontWeight? fontWeight;
  final FontWeight? hintWeight;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.icon,
    this.iconColor,
    this.hintText,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.onChanged,
    this.height,
    this.width,
    this.hintSize,
    this.fontSize,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.contentPadding,
    this.cursorHeight,
    this.cursorColor,
    this.prefixIcon,
    this.suffixIcon,
    this.fieldRadius,
    this.enabled,
    this.maxLines,
    this.onTap,
    this.autofocus = false,
    this.onSaved,
    this.validator,
    this.margin,
    this.hintColor,
    this.errorText,
    this.borderSide,
    this.textColor,
    this.fontWeight,
    this.hintWeight,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction, this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onFieldSubmitted,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height?? Sizes.screenHeight *0.1,
        width:  width ?? Sizes.screenWidth,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: TextFormField(
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textCapitalization: textCapitalization,
          textInputAction: textInputAction ?? TextInputAction.done,
          keyboardAppearance: Brightness.light,
          validator: validator,
          autovalidateMode: autovalidateMode,
          onSaved: onSaved,
          autofocus: autofocus,
          textAlignVertical: TextAlignVertical.center,
          enabled: enabled,
          controller: controller,
          cursorHeight: cursorHeight,
          onChanged: onChanged,
          cursorColor: cursorColor,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: style ?? TextStyle(color: Colors.black),
          onFieldSubmitted: onFieldSubmitted ?? (value) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            errorText: errorText,
            counter: const Offstage(),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor ?? Colors.white,
            hintText: hintText,
            hintStyle:
            TextStyle(
                color: AppColor.blackLight,
                fontSize: 15),
            contentPadding: contentPadding ??
                const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.blackLightI),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.blackLightI),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.blackLightI, width: 1.5),
            ),

          ),
        ),
      ),
    );
  }
}