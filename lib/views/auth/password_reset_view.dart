import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
      child: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Réinitialiser le mot de passe", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 20,),
              CustomFormField(
                label: "Adressse électronique",
                controller: _usernameContoller,
                hint: "Entrez l'adresse électronique",
                password: false,
                prefixIcon: Icon(Icons.alternate_email_sharp),
              ),
              const SizedBox(height: 20,),
              CustomFormField(
                label: "Confirmer Adresse électronique",
                controller: _usernameConfirmContoller,
                hint: "Confirmer Adresse électronique",
                password: false,
                prefixIcon: const Icon(Icons.alternate_email_sharp),
              ),
              const SizedBox(height: 30,),
              RoundedButton(
                title: 'Envoyer',
                loading: authViewModel.loading,
                onPress: () {
                  if (_usernameConfirmContoller.text.isEmpty || _usernameContoller.text.isEmpty) {
                    Utils.flushBarErrorMessage("Vous devez saisir tous les champs", context);
                  } else if (_usernameConfirmContoller.text != _usernameContoller.text) {
                    Utils.flushBarErrorMessage("Les deux adresses ne correspondent pas", context);
                  } else {
                    Map data = {
                      'username': _usernameContoller.text
                    };
                    authViewModel.resetPassword(data, context);
                  }
              },
              ),
              const SizedBox(height: 20,),
              Text("Un message vous sera envoyé avec un code de récupération.", style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(.7)
              ), textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),

    );
  }
}