import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

var maskFormatterPhoneNumber = MaskTextInputFormatter(
    mask: '##########',
    filter: { "#": RegExp(r'\d') },
    type: MaskAutoCompletionType.lazy
);

Widget commonAppBar({
  BuildContext? context,
  bool? backArrow = false,
  bool showHelp = true,
  bool? theme = false,
  Color? appBarColor,
  GestureTapCallback? editClick,
  GestureTapCallback? backClick,
  GestureTapCallback? themeClick,
}) {
  return Container(
    height: MediaQuery.of(context!).viewInsets.top + MediaQuery.of(context!).padding.top + 10,
    width: double.infinity,
    color: appBarColor ?? AppColors.formFieldColor,
    padding: const EdgeInsets.only(
      bottom: 10,
      left: 20,
      top: 10,
      right: 20,
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: backArrow!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: backClick ?? () {
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
                InkWell(
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
    ),
  );
}

Widget commonBottomAppBar({
  required BuildContext context,
  required int active
}) {
  return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 66,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (active != 0) {
                  Navigator.pushNamed(context, RoutesName.home);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(active == 0 ? CupertinoIcons.square_grid_2x2_fill : CupertinoIcons.square_grid_2x2, color: active == 0 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5), // The dummy child
                  Text("Accueil", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: active == 0 ? AppColors.primaryColor : null,),)
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (active != 1) {
                  Navigator.pushNamed(context, RoutesName.recipeints);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(active == 1 ? CupertinoIcons.person_2_fill : CupertinoIcons.person_2, color: active == 1 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5), // The dummy child
                  Text("Bénéficiaires", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: active == 1 ? AppColors.primaryColor : null,),)
                ],
              ),
            ),
            const SizedBox(width: 40),
            GestureDetector(
              onTap: () {
                if (active != 2) {
                  Navigator.pushNamed(context, RoutesName.exchange);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(active == 2 ? CupertinoIcons.arrow_right_arrow_left_circle_fill : CupertinoIcons.arrow_right_arrow_left_circle, color: active == 2 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5), // The dummy child
                  Text("Change", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: active == 2 ? AppColors.primaryColor : null,),)
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (active != 3) {
                  Navigator.pushNamed(context, RoutesName.accountView);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(active == 3 ? CupertinoIcons.person_fill : CupertinoIcons.person, color: active == 3 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5),
                  Text("Mon compte", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: active == 3 ? AppColors.primaryColor : null,),)
                ],
              ),
            ),
          ],
        ),
      )
  );
}