  import 'package:chapchap/res/app_colors.dart';
  import 'package:chapchap/res/app_texts.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  class RoundedButton extends StatelessWidget {
    final String title;
    final bool loading;
    Color? color;
    final Color textColor;
    final void Function()? onPress;
    bool? wallet;
    bool? small;
    bool? select;
    IconData? icon;

    RoundedButton({
      Key? key,
      required this.title,
      this.loading = false,
      this.wallet,
      this.small = false,
      this.select,
      this.icon,
      this.color,
      this.textColor = Colors.white,
      required this.onPress
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      final double buttonHeight = small == true ? 35 : 50;
      final double fontSize = small == true ? 12 : 16;
      final double iconSize = small == true ? 16 : 20;
      final double paddingHorizontal = small == true ? 8 : 16;

      return CupertinoButton(
        onPressed: onPress,
        color: color ?? AppColors.primaryColor,
        pressedOpacity: .7,
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 0),
        child: Container(
          height: buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: loading
                ? SizedBox(
              width: iconSize,
              height: iconSize,
              child: CupertinoActivityIndicator(color: Colors.white),
            )
                : Row(
              mainAxisAlignment: select == true ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                if (wallet == true) ...[
                  Icon(Icons.wallet_outlined, size: iconSize),
                  SizedBox(width: 5),
                ],
                if (icon != null) ...[
                  Icon(icon, size: iconSize, color: textColor),
                  SizedBox(width: 5),
                ],
                if (small == true)
                  AppTexts.menuText(title, color: textColor),
                if (small != true)
                AppTexts.buttonText(title, color: textColor),
                if (select == true)
                  Icon(Icons.arrow_drop_down, size: iconSize),
              ],
            ),
          ),
        ),
      );
    }
  }
