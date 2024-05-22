import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonAppBar(
                  context: context,
                  backArrow: true
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Réinitialiser le mot de passe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                      const SizedBox(height: 10,),
                      const Text("Veuillez saisir l’adresse e-mail associé à votre profil. Nous enverrons un message contenant un code de réinitialisation du mot de passe", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black45), textAlign: TextAlign.left,),
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