import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final bool loading;
  Color? color;
  final Color textColor;
  final VoidCallback onPress;

  RoundedButton({
    Key? key,
    required this.title,
    this.loading = false,
    this.color,
    this.textColor = Colors.white,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    color ??= const Color(0xFF29216B);
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Center(
          child: loading ? const CircularProgressIndicator(color: Colors.white) :Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}