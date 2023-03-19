import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _passCnfController = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
        child: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Column(
            children: [
              const Text("Créez un nouveau mot de passe", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 20,),
              CustomFormField(
                label: "Code réçu *",
                hint: "Entrez le code réçu dans le message",
                type: TextInputType.number,
                controller: _codeController,
                password: false,
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 10,),
              CustomFormField(
                label: "Nouveau mot de passe *",
                hint: "Nouveau mot de passe *",
                controller: _passController,
                password: false,
                prefixIcon: const Icon(Icons.lock_person_outlined),
                suffixIcon: const Icon(Icons.visibility_off_outlined),
              ),
              SizedBox(height: 20,),
              CustomFormField(
                label: "Confirmer le mot de passe *",
                controller: _passCnfController,
                hint: "Confirmer le mot de passe *",
                password: false,
                prefixIcon: Icon(Icons.lock_person_outlined),
                suffixIcon: Icon(Icons.visibility_off_outlined),
              ),
              SizedBox(height: 30,),
              RoundedButton(
                title: 'Enrégistrer',
                loading: authViewModel.loading, onPress: () {
                  if (!authViewModel.loading) {
                    if (_passCnfController.text.isEmpty || _passController.text.isEmpty || _codeController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Tous les champs sont réquis", context);
                    } else {
                      Map data = {
                        "password": _passController.text,
                        "password_cfrm": _passCnfController.text,
                        "code": _codeController.text
                      };
                      authViewModel.changePassword(data, context);
                    }
                  }
              },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),

    );
  }
}