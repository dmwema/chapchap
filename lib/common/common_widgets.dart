import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Besoin d’aide ?", style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22
                              ),),
                              const SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () {
                                  _openUrl("tel://+15143701555");
                                },
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.phone_fill, color: AppColors.primaryColor, size: 30,),
                                    const SizedBox(width: 10,),
                                    const Text("Applez-nous", style: TextStyle(
                                      fontSize: 17
                                    ),)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () {
                                  _openUrl("mailto:support@chapchap.ca?subject=Contact&body=");
                                },
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.mail_solid, color: AppColors.primaryColor, size: 25,),
                                    const SizedBox(width: 10,),
                                    const Text("Envoyez nous un E-mail", style: TextStyle(
                                        fontSize: 17
                                    ),)
                                  ],
                                ),
                              ),
                            ],
                          )
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  );
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