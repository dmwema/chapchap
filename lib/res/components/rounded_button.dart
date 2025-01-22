import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final bool loading;
  final bool outlined;
  Color? color;
  final Color textColor;
  final void Function()? onPress;
  bool? wallet;
  bool? select;
  IconData? icon;

  RoundedButton({
    Key? key,
    required this.title,
    this.loading = false,
    this.wallet,
    this.outlined = false,
    this.select,
    this.icon,
    this.color,
    this.textColor = Colors.white,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPress,
      color: outlined ? null : color ?? AppColors.primaryColor,
      borderRadius: BorderRadius.circular(30),
      sizeStyle: CupertinoButtonSize.small,
      padding: EdgeInsets.all(0),
      pressedOpacity: .7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: outlined ? Border.all(width: 1, color: AppColors.accentColor) : null
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.5),
        child: Center(
          child: loading ? const SizedBox(
            width: 20,
            height: 20,
            child: CupertinoActivityIndicator(color: Colors.white)
         ) :Row(
            mainAxisAlignment: select == true ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
           children: [
             if (wallet == true)
             const Icon(Icons.wallet_outlined, size: 20,),
             if (wallet == true)
               const SizedBox(width: 5,),

             if (icon != null)
               Icon(icon, size: 20, color: textColor,),
             if (icon != null)
               const SizedBox(width: 5,),
             AppTexts.buttonText(title, color: outlined ? AppColors.accentColor : textColor),
             if (select == true)
               const Icon(Icons.arrow_drop_down)
           ],
         ),
        ),
      ),
    );
  }
}