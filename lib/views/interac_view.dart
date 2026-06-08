import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InteracView extends StatefulWidget {
  const InteracView({Key? key}) : super(key: key);

  @override
  State<InteracView> createState() => _InteracViewState();
}

class _InteracViewState extends State<InteracView> {
  UserModel? user;

  bool showCode = true;
  bool showResponse = true;

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppTexts.bigTitleText(AppLocalizations.of(context)!.translate('interacInformation')),
            ),
            const SizedBox(height: 20),
            if (user != null && user!.codeInterac != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTexts.descriptionText(AppLocalizations.of(context)!.translate('fundYourWallet')),
                        const SizedBox(height: 20),
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('name')),
                        AppTexts.titleText("Chapchap"),
                        Divider(color: AppColors.formFieldColor),
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('emailAddress')),
                        AppTexts.titleText("paiement@transfertchapchap.com"),
                        Divider(color: AppColors.formFieldColor),
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('question')),
                        AppTexts.titleText(user!.questionInterac.toString()),
                        Divider(color: AppColors.formFieldColor),
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('answer')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: showResponse ? 5 : 0, sigmaY: showResponse ? 5 : 0),
                                child: AppTexts.titleText(user!.reponseInterac.toString())
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showResponse = !showResponse;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.primaryColor
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(showResponse ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: Colors.white, size: 15),
                                    const SizedBox(width: 5),
                                    Text(showResponse ? AppLocalizations.of(context)!.translate('show') : AppLocalizations.of(context)!.translate('hide'), style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: AppColors.formFieldColor),
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('codeMessageField')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: showCode ? 5 : 0, sigmaY: showCode ? 5 : 0),
                                child: AppTexts.titleText(user!.codeInterac.toString())
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showCode = !showCode;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.primaryColor
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(showCode ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: Colors.white, size: 15),
                                    const SizedBox(width: 5),
                                    Text(showCode ? AppLocalizations.of(context)!.translate('show') : AppLocalizations.of(context)!.translate('hide'), style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
