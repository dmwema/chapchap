import 'dart:io';

import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalAuthView extends StatefulWidget {
  const LocalAuthView({super.key});

  @override
  State<StatefulWidget> createState() => _LocalAuthViewState();
}

class _LocalAuthViewState extends State<LocalAuthView> {
  bool authenticated = false;
  bool loadingBio = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Platform.isAndroid ? "assets/fingerprint.png" : "assets/faceid.png", width: 60),
                const SizedBox(height: 20,),
                AppTexts.titleText(loc!.authVerification(Platform.isAndroid ? loc.fingerprint : loc.faceID)),
                const SizedBox(height: 10,),
                AppTexts.descriptionText(loc.authDescription(Platform.isAndroid ? loc.fingerprint : loc.faceID)),
                const SizedBox(height: 20,),
                RoundedButton(
                    title: loc.authButton(Platform.isAndroid ? loc.fingerprint : loc.faceID),
                    color: AppColors.buttonBlackColor,
                    textColor: Colors.white,
                    onPress: () async {
                      if (!loadingBio) {
                        setState(() {
                          loadingBio = true;
                        });
                        await LocalAuthService.authenticate().then((value) {
                          if (value) {
                            Navigator.pushNamed(context, RoutesName.home);
                          }
                          setState(() {
                            loadingBio = false;
                          });
                        });
                      }
                    }
                )
              ],
            )
        ),
      ),
    );
  }
}
