import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
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
      elevation: 2,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.bgColor,
      child:  Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
        ),
        height: 100,
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
              child: Container(
                decoration: BoxDecoration(
                    border: active == 0 ? Border(top: BorderSide(color: AppColors.accentColor, width: 4)) : null
                ),
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(active == 0 ? "assets/icons/home_color.png" : "assets/icons/home.png"),
                    const SizedBox(height: 5), // The dummy child
                    Text("Accueil", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: active == 0 ? AppColors.accentColor : AppColors.textGrey,),)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.send);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  height: 70.0,
                  width: 70.0,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Image.asset("assets/icons/send.png", width: 35,),
                  ))
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
              child: Container(
                decoration: BoxDecoration(
                    border: active == 1 ? Border(top: BorderSide(color: AppColors.accentColor, width: 4)) : null
                ),
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(active == 1 ? "assets/icons/recipient_color.png" : "assets/icons/recipient.png",),
                    const SizedBox(height: 5), // The dummy child
                    Text("Bénéficiaires", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: active == 1 ? AppColors.accentColor : AppColors.textGrey,),)
                  ],
                ),
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
  bool removePaddingH = false,
  bool removePaddingV = false,
  bool removePaddingAll = false,
  bool gradient = false,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      gradient: gradient ? LinearGradient(
        colors: [AppColors.primaryColor, const Color(0xFF6D2121)],
        stops: const [0, 1],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ) : null,
      boxShadow: [Utils.customShadow()],
    ),
    padding: removePaddingAll ? null : (removePaddingH ? const EdgeInsets.symmetric(vertical: 20) : (removePaddingV ? const EdgeInsets.symmetric(horizontal: 20) : const EdgeInsets.all(20))),
    child: child,
  );
}

Widget pageTitleStyle ({required String title, required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.75,
    child: Flexible(
      child: Text(title, style: TextStyle(
          fontSize: 23,
          color: AppColors.accentColor,
          fontWeight: FontWeight.w500
      ),),
    ),
  );
}

class CommonAppBar extends StatelessWidget implements PreferredSize {
  final BuildContext context;
  bool backArrow;
  bool empty;
  bool? navWhite;
  String? title;
  GestureTapCallback? backClick;

  CommonAppBar({
    super.key,
    required this.context,
    this.backArrow = false,
    this.empty = false,
    this.title,
    this.navWhite,
    this.backClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: empty ? AppColors.bgColor : AppColors.primaryColor,
      title: empty ? Image.asset("assets/logo.png", width: 120,) : (title == null ? null : AppTexts.titleText(title!, color: Colors.white, thin: true)),
      centerTitle: empty,
      leading: backArrow == true ? Padding(
        padding: const EdgeInsets.only(left: 20),
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back-icon.png")
        ),
      ): Container(),
      // actions: [
      //   if (showHelp)
      //     InkWell(
      //       onTap: () {
      //         showModalBottomSheet(
      //           context: context,
      //           builder: (context) {
      //             return Container(
      //                 padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      //                 color: AppColors.bgColor,
      //                 child: Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     AppTexts.titleText("Besoin d’aide ?"),
      //                     const SizedBox(height: 20,),
      //                     GestureDetector(
      //                       onTap: () {
      //                         _openUrl("tel://+15143701555");
      //                       },
      //                       child: Row(
      //                         children: [
      //                           Icon(CupertinoIcons.phone_fill, color: AppColors.primaryColor, size: 30,),
      //                           const SizedBox(width: 10,),
      //                           AppTexts.descriptionText("Appelez-nous")
      //                         ],
      //                       ),
      //                     ),
      //                     const SizedBox(height: 20,),
      //                     GestureDetector(
      //                       onTap: () {
      //                         _openUrl("mailto:support@chapchap.ca?subject=Contact&body=");
      //                       },
      //                       child: Row(
      //                         children: [
      //                           Icon(CupertinoIcons.mail_solid, color: AppColors.primaryColor, size: 25,),
      //                           const SizedBox(width: 10,),
      //                           AppTexts.descriptionText("Envoyez-nous un e-mail")
      //                         ],
      //                       ),
      //                     ),
      //                     const SizedBox(height: 20,),
      //                     GestureDetector(
      //                       onTap: () {
      //                         _openUrl("https://wa.me/+14384929679");
      //                       },
      //                       child: Row(
      //                         children: [
      //                           Image.asset("assets/wa.png", width: 30,),
      //                           const SizedBox(width: 10,),
      //                           AppTexts.descriptionText("Message whatsapp")
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 )
      //             );
      //           },
      //           shape: const RoundedRectangleBorder(
      //             borderRadius: BorderRadius.vertical(
      //               top: Radius.circular(20),
      //             ),
      //           ),
      //         );
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 20),
      //         child: AppTexts.smallText("Aide ?", color: color == true ? Colors.white : AppColors.textGrey),
      //       ),
      //     )
      // ],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        systemNavigationBarColor: AppColors.bgColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness:Brightness.dark, // For iOS (dark icons)
        systemNavigationBarDividerColor: AppColors.bgColor
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget get child => throw UnimplementedError();
}