import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthContainer(
        child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Se connecter", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              Text("Connectez-vous avec votre adress électronique et votre mot de passe", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black.withOpacity(.7)
              ), textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              CustomFormField(
                label: "Adressse électronique",
                hint: "Entrez l'adresse électronique",
                password: false,
                prefixIcon: Icon(Icons.alternate_email_sharp),
              ),
              SizedBox(height: 20,),
              CustomFormField(
                label: "Mot de passe",
                hint: "Entrez le mot de passe",
                password: true,
                prefixIcon: Icon(Icons.lock_person_outlined),
                suffixIcon: Icon(Icons.visibility_off_outlined),
              ),
              SizedBox(height: 20,),
              InkWell(
                child: const Text("Mot de passe oublié ?", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                ), textAlign: TextAlign.start,),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.passwordReset);
                },
              ),
              SizedBox(height: 30,),
              RoundedButton(
                title: 'Se connecter',
                loading: false, onPress: () {  },
              ),
              const SizedBox(height: 20,),
              Text("Vous n'avez pas encore de compte ?"),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.register);
                }, child: Text("Inscrivez-vous", style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold
              ),),),
            ],
          ),
        ),
      ),

    );
  }
}