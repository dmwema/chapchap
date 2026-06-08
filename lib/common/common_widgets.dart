import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:restart_app/restart_app.dart';
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
      elevation: 1,
      color: Colors.white,
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
                  const SizedBox(height: 5),
                  AppTexts.menuText(AppLocalizations.of(context)!.translate("home"), color: active == 0 ? AppColors.primaryColor : Colors.black),
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
                  Icon(active == 1 ? Icons.contacts : Icons.contacts_outlined, color: active == 1 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5),
                  AppTexts.menuText(AppLocalizations.of(context)!.translate("recipients"), color: active == 1 ? AppColors.primaryColor : Colors.black),
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
                  Icon(active == 2 ? Icons.currency_exchange_rounded : Icons.currency_exchange_rounded, color: active == 2 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5),
                  AppTexts.menuText(AppLocalizations.of(context)!.translate("exchange"), color: active == 2 ? AppColors.primaryColor : Colors.black),
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
                  Icon(active == 3 ? CupertinoIcons.person_alt_circle_fill : CupertinoIcons.person_alt_circle, color: active == 3 ? AppColors.primaryColor : null,),
                  const SizedBox(height: 5),
                  AppTexts.menuText(AppLocalizations.of(context)!.translate("account"), color: active == 3 ? AppColors.primaryColor : Colors.black),
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
  bool removePaddingH = false,
  bool removePaddingV = false,
  bool removePaddingAll = false,
  bool shadow = false,
  bool gradient = false,
  Color bgColor = Colors.white,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: bgColor,
      gradient: gradient ? LinearGradient(
        colors: [AppColors.primaryColor, const Color(0xFF6D2121)],
        stops: const [0, 1],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ) : null,
      boxShadow: shadow ? [Utils.customShadow()] : null,
    ),
    padding: removePaddingAll ? null : (removePaddingH ? const EdgeInsets.symmetric(vertical: 20) : (removePaddingV ? const EdgeInsets.symmetric(horizontal: 20) : const EdgeInsets.all(20))),
    child: child,
  );
}

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  final bool backArrow;
  final bool showHelp;
  final bool? color;
  final bool? navWhite;
  final List<Widget>? actions;
  final GestureTapCallback? backClick;

  const CommonAppBar({
    super.key,
    required this.context,
    this.backArrow = false,
    this.showHelp = true,
    this.color,
    this.actions,
    this.navWhite,
    this.backClick,
  });

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  String local = "Fr";

  @override
  void initState() {
    super.initState();
    UserViewModel().getUserLanguage().then((value) {
      if (mounted) {
        setState(() {
          local = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: widget.color == true ? AppColors.primaryColor : AppColors.bgColor,
      leading: widget.backArrow
          ? InkWell(
        onTap: widget.backClick ?? () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: widget.color == true ? Colors.white : AppColors.textGrey, size: 25),
      )
          : Container(),
      actions: widget.actions ?? [
        if (widget.showHelp)
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
                        color: AppColors.bgColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTexts.titleText(AppLocalizations.of(context)!.translate("need_help")),
                            const SizedBox(height: 20,),
                            GestureDetector(
                              onTap: () {
                                _openUrl("tel://+15143701555");
                              },
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.phone_fill, color: AppColors.primaryColor, size: 30,),
                                  const SizedBox(width: 10,),
                                  AppTexts.descriptionText(AppLocalizations.of(context)!.translate("call_us"))
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
                                  AppTexts.descriptionText(AppLocalizations.of(context)!.translate("email_us"))
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
                                  AppTexts.descriptionText(AppLocalizations.of(context)!.translate("whatsapp_message"))
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
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
              child: AppTexts.smallText(AppLocalizations.of(context)!.translate("help"), color: widget.color == true ? Colors.white : AppColors.textGrey),
            ),
          ),
        if (widget.showHelp)
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: AppColors.bgColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTexts.titleText(AppLocalizations.of(context)!.translate("choose_language")),
                          const SizedBox(height: 10),
                          ...Utils.languages.map((element) {
                            return ProfileMenu(
                              title: AppLocalizations.of(context)!.translate("lang.${element['code']!.toLowerCase()}"),
                              icon: Icons.language,
                              color: local == element['code'] ? AppColors.primaryColor : Colors.grey[200],
                              onTap: () async {
                                await UserViewModel().setUserLanguage(element['code']!);
                                Restart.restartApp(
                                  notificationTitle: AppLocalizations.of(context)!.translate("restart_app"),
                                  notificationBody: AppLocalizations.of(context)!.translate("please_tap_here_to_open_the_app_again"),
                                );
                              },
                              noIcon: true,
                            );
                          })
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                image: DecorationImage(
                  image: AssetImage("packages/country_icons/icons/flags/png/${local.toLowerCase() == "en" ? "gb" : local.toLowerCase()}.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: widget.color == true ? AppColors.primaryColor : AppColors.bgColor,
        systemNavigationBarColor: widget.navWhite == true || widget.color != true ? AppColors.bgColor : AppColors.primaryColor,
        systemNavigationBarIconBrightness: widget.navWhite == true || widget.color != true ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: widget.color == true ? Brightness.light : Brightness.dark,
        statusBarBrightness: widget.color == true ? Brightness.dark : Brightness.light,
        systemNavigationBarDividerColor: widget.navWhite == true || widget.color != true ? AppColors.bgColor : AppColors.primaryColor,
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey(); // Redéfinit la clé pour forcer un rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class ChampsRequisParModeRetrait {
  static Map<String, Map<String, String>> FIELDS = {
    "DEPOSIT_ACCOUNT_BANK": {
      "banque": "Banque",
      "intitule_compte_bancaire": "Intitulé du compte",
      "numero_compte_bancaire": "Numéro du compte",
    },
    "INTERAC_BANK": {
      "id_institution_financiere": "ID Institution financière",
      "id_transit": "ID Transit",
      "id_compte": "ID compte",
    },
    "INTERAC": {
      "emailBeneficiaire": "Adresse E-mail du bénéficiaire"
    },
    "MOBILE_MONEY": {
      "telBeneficiaire": "Numéro de téléphone du bénéficiaire"
    },
  };
}
