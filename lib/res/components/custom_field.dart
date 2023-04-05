import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String hint;
  final int? maxLines;
  final bool password;
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
    required this.label,
    required this.hint,
    required this.password,
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
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscurePassword,
      focusNode: focusNode,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: radius ?? const BorderRadius.all(Radius.circular(35)),
          ),
          contentPadding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon
      ),
      inputFormatters: inputFormatters,
      onTap: onPressed,
    );
  }
}