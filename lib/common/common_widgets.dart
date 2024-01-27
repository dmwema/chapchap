import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget commonAppBar({
  BuildContext? context,
  bool? backArrow = false,
  bool showHelp = true,
  bool? theme = false,
  Color? appBarColor,
  GestureTapCallback? editClick,
  GestureTapCallback? themeClick,
}) {
  return Container(
    height: MediaQuery.of(context!).viewInsets.top + MediaQuery.of(context!).padding.top,
    width: double.infinity,
    padding: const EdgeInsets.only(
      bottom: 20,
      left: 20,
      top: 20,
      right: 20,
    ),
    alignment: Alignment.bottomCenter,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: backArrow!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
       Visibility(
          visible: showHelp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {

                },
                child: Container(
                  height: 25,
                  width: 25,
                  padding: const EdgeInsets.all(2),
                  child: const Icon(CupertinoIcons.question_circle, size: 20,),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}