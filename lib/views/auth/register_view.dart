import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "CHAPCHAP",
        showBack: true,
        red: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("S’inscrire", style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                CustomFormField(
                  label: "Nom *",
                  hint: "Entrez votre nom",
                  password: false,
                ),
                SizedBox(height: 20,),
                CustomFormField(
                  label: "Prénom(s) *",
                  hint: "Entrez votre prénom",
                  password: false,
                ),
                SizedBox(height: 20,),
                CustomFormField(
                  label: "Email *",
                  hint: "Entrez votre l'adresse électronique",
                  password: false,
                ),
                SizedBox(height: 20,),
                CustomFormField(
                  label: "Mot de passe",
                  hint: "Créez un mot de passe",
                  password: true,
                  prefixIcon: Icon(Icons.lock_person_outlined),
                ),
                SizedBox(height: 20,),
                CustomFormField(
                  label: "Confirmer le Mot de passe",
                  hint: "Confirmer le mot de passe",
                  password: true,
                  prefixIcon: Icon(Icons.lock_person_outlined),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.2),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("packages/country_icons/icons/flags/png/ca.png", width: 30,),
                          SizedBox(width: 10,),
                          const Text("+1", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                    Flexible(child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Téléphone",
                        labelText: "Téléphone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30)),
                        ),
                        contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 16),
                      ),
                      onTap: () {

                      },
                    ))
                  ],
                ),
                SizedBox(height: 20,),
                CustomFormField(
                  label: "Adresse complete *",
                  hint: "Entrez votre adresse de domicile",
                  password: false,
                ),
                const SizedBox(height: 20,),
                CustomFormField(
                  label: "Code de parrainage",
                  hint: "Code de parrainage",
                  password: false,
                ),
                SizedBox(height: 20,),
                Text("Les champs avec astérisque(*) sont obligatoire", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 20,),
                RoundedButton(
                  title: "S'inscrire",
                  onPress: () {

                  },
                  loading: false,
                ),
                SizedBox(height: 20,),
                Text("Vous avez déjà un compte ?"),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.login);
                  }, child: Text("Connectez-vous", style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold
                ),),),
              ],
            ),
          )
        ),
      ),
    );
  }
}