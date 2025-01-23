import 'dart:ui';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/view_model/user_view_model.dart';
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
                child: AppTexts.bigTitleText("Informations interac"),
              ),
              const SizedBox(height: 20,),
              if (user != null && user!.codeInterac != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTexts.descriptionText("Pour approvisionner votre Wallet : "),
                        const SizedBox(height: 20,),
                        AppTexts.smallText("Nom "),
                        AppTexts.titleText("Chapchap"),
                        Divider(color: AppColors.formFieldColor,),
                        AppTexts.smallText("Adresse courriel "),
                        AppTexts.titleText("paiement@chapchap.ca"),
                        Divider(color: AppColors.formFieldColor,),
                        AppTexts.smallText("Question "),
                        AppTexts.titleText(user!.questionInterac.toString()),
                        Divider(color: AppColors.formFieldColor,),
                        AppTexts.smallText("Reponse "),
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
                                    Icon(showResponse ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: Colors.white, size: 15,),
                                    const SizedBox(width: 5,),
                                    Text(showResponse ? "afficher" : "Cacher", style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Divider(color: AppColors.formFieldColor,),
                        AppTexts.smallText("Code à écrire dans le champ message/raison (obligatoire)"),
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
                                    Icon(showCode ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: Colors.white, size: 15,),
                                    const SizedBox(width: 5,),
                                    Text(showCode ? "afficher" : "Cacher", style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),),
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
        )



    );
  }
}