import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {
  final String? label;
  final String hint;
  final int? maxLines;
  final TextInputType? type;
  final FocusNode? focusNode;
  final bool obscurePassword;
  final bool required;
  final Widget? suffixIcon;
  final BorderRadius? radius;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  void Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final void Function()? onPressed;
  final void Function(String)? onChanged;
  bool disabled = false;


  CustomFormField({
    super.key,
    this.label,
    required this.hint,
    this.type,
    this.focusNode,
    this.disabled = false,
    this.radius,
    this.obscurePassword = false,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.onChanged,
    this.required = true,
    this.inputFormatters,
    this.controller, this.maxLines, this.onPressed, this.prefixIcon
  });

  static void fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus
      ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override

  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label != null)
        Row(
          children: [
            AppTexts.smallText(label!),
            if (required)
              ...[
                const SizedBox(width: 5,),
                AppTexts.bodyText("*", bold: true, color: Colors.red),
              ]
          ],
        ),
        if (label != null)
        const SizedBox(height: 5,),
        CupertinoTextField(
          controller: controller,
          keyboardType: type,
          cursorColor: Colors.black,
          obscureText: obscurePassword,
          prefix: prefixIcon,
          readOnly: disabled,
          focusNode: focusNode,
          maxLines: maxLines,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
            borderRadius: BorderRadius.circular(6)
          ),
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black
          ),
          onSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          placeholder: hint,
          placeholderStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey.withOpacity(.9)
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          inputFormatters: inputFormatters,
          onTap: onPressed,
          suffix: suffixIcon,
        ),
      ],
    );
  }
}