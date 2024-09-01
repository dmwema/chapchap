import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
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
    return CupertinoButton(
      onPressed: onPress,
      color: AppColors.primaryColor,
      pressedOpacity: .7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: const Offset(0, 3), // changes position of shadow
          //   ),
          // ],
        ),
        child: Center(
          child: loading ? const SizedBox(
            width: 20,
            height: 20,
            child: CupertinoActivityIndicator(color: Colors.white)
         ) :Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),),
        ),
      ),
    );
  }
}