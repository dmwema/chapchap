import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
        child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Créez un nouveau mot de passe", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 20,),
              CustomFormField(
                label: "Nouveau mot de passe *",
                hint: "Nouveau mot de passe *",
                password: false,
                prefixIcon: Icon(Icons.lock_person_outlined),
                suffixIcon: Icon(Icons.visibility_off_outlined),
              ),
              SizedBox(height: 20,),
              CustomFormField(
                label: "Confirmer le mot de passe *",
                hint: "Confirmer le mot de passe *",
                password: false,
                prefixIcon: Icon(Icons.lock_person_outlined),
                suffixIcon: Icon(Icons.visibility_off_outlined),
              ),
              SizedBox(height: 30,),
              RoundedButton(
                title: 'Enrégistrer',
                loading: false, onPress: () {
                Navigator.pushNamed(context, RoutesName.login);
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