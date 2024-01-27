import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String hint;
  final int? maxLines;
  final TextInputType? type;
  final FocusNode? focusNode;
  final bool obscurePassword;
  final Widget? suffixIcon;
  final BorderRadius? radius;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  void Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final void Function()? onPressed;

  CustomFormField({
    super.key,
    required this.label,
    required this.hint,
    this.type,
    this.focusNode,
    this.radius,
    this.obscurePassword = false,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.controller, this.maxLines, this.onPressed, this.prefixIcon
  });

  static fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus
      ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override

  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscurePassword,
      focusNode: focusNode,
      maxLines: maxLines,
      decoration: BoxDecoration(
        color: AppColors.formFieldColor,
        border: Border.all(color: AppColors.formFieldBorderColor),
        borderRadius: BorderRadius.circular(6)
      ),
      onSubmitted: onFieldSubmitted,
      placeholder: hint,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      inputFormatters: inputFormatters,
      onTap: onPressed,
      suffix: suffixIcon,
    );
  }
}