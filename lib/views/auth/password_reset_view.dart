import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:flutter/material.dart';

class PasswordResetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
        child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Réinitialiser le mot de passe", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 20,),
              CustomFormField(
                label: "Adressse électronique",
                hint: "Entrez l'adresse électronique",
                password: false,
                prefixIcon: Icon(Icons.alternate_email_sharp),
              ),
              SizedBox(height: 20,),
              CustomFormField(
                label: "Confirmer Adresse électronique",
                hint: "Confirmer Adresse électronique",
                password: false,
                prefixIcon: Icon(Icons.alternate_email_sharp),
              ),
              SizedBox(height: 20,),
              InkWell(
                child: Text("Mot de passe oublié ?", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                ), textAlign: TextAlign.start,),
              ),
              SizedBox(height: 30,),
              RoundedButton(
                title: 'Envoyer',
                loading: false, onPress: () {  },
              ),
              const SizedBox(height: 20,),
              SizedBox(height: 20,),
              Text("Un mail sera envoyé à l’adresse renseigner avec un code de récupération. Rassurer-vous que l’adresse est bien saisie", style: TextStyle(
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