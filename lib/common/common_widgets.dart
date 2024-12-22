import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Widget commonBottomAppBar({
  required BuildContext context,
  required int active
}) {
  return BottomAppBar(
    elevation: 0,
    shape: const CircularNotchedRectangle(),
    child:  SizedBox(
      height: 66,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (active != 0) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.home,
                      (route) => false,
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(active == 0 ? CupertinoIcons.square_grid_2x2_fill : CupertinoIcons.square_grid_2x2, color: active == 0 ? AppColors.primaryColor : null,),
                const SizedBox(height: 5), // The dummy child
                AppTexts.menuText("Accueil", color: active == 0 ? AppColors.primaryColor : Colors.black),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (active != 1) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.recipeints,
                      (route) => false,
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(active == 1 ? CupertinoIcons.person_2_fill : CupertinoIcons.person_2, color: active == 1 ? AppColors.primaryColor : null,),
                const SizedBox(height: 5), // The dummy child
                AppTexts.menuText("Bénéficiaires", color: active == 1 ? AppColors.primaryColor : Colors.black),
              ],
            ),
          ),
          const SizedBox(width: 40),
          GestureDetector(
            onTap: () {
              if (active != 2) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.exchange,
                      (route) => false,
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(active == 2 ? CupertinoIcons.arrow_right_arrow_left_circle_fill : CupertinoIcons.arrow_right_arrow_left_circle, color: active == 2 ? AppColors.primaryColor : null,),
                const SizedBox(height: 5), // The dummy child
                AppTexts.menuText("Change", color: active == 2 ? AppColors.primaryColor : Colors.black),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (active != 3) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.accountView,
                      (route) => false,
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(active == 3 ? CupertinoIcons.person_fill : CupertinoIcons.person, color: active == 3 ? AppColors.primaryColor : null,),
                const SizedBox(height: 5),
                AppTexts.menuText("Mon compte", color: active == 3 ? AppColors.primaryColor : Colors.black),
              ],
            ),
          ),
        ],
      ),
    )
  );
}

Widget commonDivider() {
  return Divider(
    color: AppColors.bgColor,
    height: 4,
    thickness: 4,
  );
}

Widget commonRoundedContainer({
  required Widget child,
  bool removePaddingH = false
}) {
  return Container(
    decoration: BoxDecoration(
        boxShadow: [Utils.customShadow()],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
    ),
    padding: removePaddingH ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.all(20),
    child: child,
  );
}

class CommonAppBar extends StatelessWidget implements PreferredSize {
  final BuildContext context;
  bool backArrow;
  bool showHelp;
  bool? color;
  GestureTapCallback? backClick;

  CommonAppBar({
    super.key,
    required this.context,
    this.backArrow = false,
    this.showHelp = true,
    this.color,
    this.backClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: color == true ? AppColors.primaryColor : AppColors.bgColor,
      leading: backArrow == true ? InkWell(
          onTap: backClick ?? () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: AppColors.textGrey, size: 25,)
      ): Container(),
      actions: [
        if (showHelp)
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
                          AppTexts.titleText("Besoin d’aide ?"),
                          const SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () {
                              _openUrl("tel://+15143701555");
                            },
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.phone_fill, color: AppColors.primaryColor, size: 30,),
                                const SizedBox(width: 10,),
                                AppTexts.descriptionText("Appelez-nous")
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
                                AppTexts.descriptionText("Envoyez-nous un e-mail")
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () {
                              _openUrl("https://wa.me/+14384929679");
                            },
                            child: Row(
                              children: [
                                Image.asset("assets/wa.png", width: 30,),
                                const SizedBox(width: 10,),
                                AppTexts.descriptionText("Message whatsapp")
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
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AppTexts.smallText("Aide ?"),
            ),
          )
      ],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: color == true ? AppColors.primaryColor : AppColors.bgColor,
        systemNavigationBarColor: color == true ? AppColors.primaryColor : AppColors.bgColor,
        systemNavigationBarIconBrightness: color == true ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: color == true ? Brightness.light : Brightness.dark, // For Android (dark icons)
        statusBarBrightness: color == true ? Brightness.light : Brightness.dark, // For iOS (dark icons)
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget get child => throw UnimplementedError();
}