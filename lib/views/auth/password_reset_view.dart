import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  final TextEditingController _usernameContoller = TextEditingController();
  final TextEditingController _usernameConfirmContoller = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true, backClick: () {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
      },),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTexts.titleText("Réinitialiser le mot de passe"),
                      const SizedBox(height: 10,),
                      AppTexts.smallText("Veuillez saisir l’adresse e-mail associé à votre profil. Nous enverrons un message contenant un code de réinitialisation du mot de passe"),
                      const SizedBox(height: 20,),
                      CustomFormField(
                        label: "Adresse électronique",
                        hint: "Adresse électronique",
                        controller: _usernameContoller,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 20,),
                      RoundedButton(
                          title: "Valider",
                          loading: loading,
                          onPress: () async {
                            if (!loading) {
                              setState(() {
                                loading = true;
                              });
                              if (!authViewModel.loading) {
                                if (_usernameContoller.text.isEmpty) {
                                  Utils.flushBarErrorMessage("Vous devez saisir votre adresse E-mail", context);
                                } else {
                                  Map data = {
                                    'username': _usernameContoller.text
                                  };
                                  await authViewModel.passwordReset(data, context);
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              }
                            }
                          }
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}