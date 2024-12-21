import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final bool loading;
  Color? color;
  final Color textColor;
  final VoidCallback onPress;
  bool? wallet;
  IconData? icon;

  RoundedButton({
    Key? key,
    required this.title,
    this.loading = false,
    this.wallet,
    this.icon,
    this.color,
    this.textColor = Colors.white,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPress,
      color: color ?? AppColors.primaryColor,
      pressedOpacity: .7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading ? const SizedBox(
            width: 20,
            height: 20,
            child: CupertinoActivityIndicator(color: Colors.white)
         ) :Row(
            mainAxisAlignment: MainAxisAlignment.center,
           children: [
             if (wallet == true)
             const Icon(Icons.wallet_outlined, size: 20,),
             if (wallet == true)
               const SizedBox(width: 5,),

             if (icon != null)
               Icon(icon, size: 20, color: textColor,),
             if (icon != null)
               const SizedBox(width: 5,),
             AppTexts.buttonText(title, color: textColor)
           ],
         ),
        ),
      ),
    );
  }
}