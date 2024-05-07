import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetCodeView extends StatelessWidget {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.all(10)
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      )
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.all(10)
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      )
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.all(10)
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      )
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.all(10)
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      )
                  ),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.all(10)
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: Text("Un mail a été envoyé à votre adresse albakrsanogo@quickdep.ca pour terminer le processus .", style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(.7)
                ), textAlign: TextAlign.center,),
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 10,),
              const Text("Veuillez consulter votre boîte de messagerie et saisir le code que vous avez reçu.", style: TextStyle(
                  fontSize: 13,
                fontWeight: FontWeight.w500
                ), textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              RoundedButton(
                title: 'Vérifier',
                loading: false, onPress: () {
                  Navigator.pushNamed(context, RoutesName.newPassword);
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}