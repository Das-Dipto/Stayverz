import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputText extends StatelessWidget {
  final TextEditingController? controller;
  final String? helperText;
  final bool obscureText;
  final bool enable;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? borderWidth;
  final double? borerRadius;
  final double? evaluation;
  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final Color? textColor;
  final Color? borderColor;
  final Color? fillColor;
  final int? maxLines, maxLength;
  final bool autofocus;
  final Function(String)? onChange;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters; // <-- Added this line
  final VoidCallback? onTap;

  const CustomInputText({
    super.key,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.controller,
    this.enable = true,
    this.suffixIcon,
    this.prefixIcon,
    this.borderColor,
    this.borderWidth,
    this.borerRadius,
    this.evaluation,
    this.fillColor,
    this.helperText,
    this.obscureText = false,
    this.padding,
    this.keyboardType,
    this.onChange,
    this.textColor,
    this.maxLines = 1,
    this.inputFormatters, // <-- And this line
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: borderWidth ?? 1,
        color: borderColor ?? Colors.grey.withOpacity(0.5),
      ),
    );

    TextStyle textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    var child = Material(
      elevation: evaluation ?? 0,
      borderRadius: BorderRadius.circular(borerRadius ?? 0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        maxLines: maxLines,
        autofocus: autofocus,
        maxLength: maxLength,
        inputFormatters: inputFormatters, // <-- And this line
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabled: enable,
          isDense: true,
          hintText: helperText,
          hintStyle: textStyle.copyWith(color: const Color(0xff667085)),
          border: inputBorder,
          enabledBorder: inputBorder,
          errorBorder: inputBorder,
          focusedBorder: inputBorder,
          filled: true,
          fillColor: fillColor ?? const Color(0xffF9FAFB),
          contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
        ),
        onChanged: onChange,
        onTap: onTap,
        keyboardType: keyboardType,
        style: textStyle.copyWith(color: textColor ?? const Color(0xff1f2427)),
        cursorColor: const Color(0xff1f2427),
        cursorWidth: 4,
      ),
    );

    return padding != null ? Padding(
      padding: padding!,
      child: child,
    ) : child;
  }
}

// Hello I am Tamim