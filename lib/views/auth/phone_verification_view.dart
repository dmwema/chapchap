import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class PhoneVerification extends StatelessWidget {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();

  AuthViewModel authViewModel = AuthViewModel();

  PhoneVerification({Key? key}) : super(key: key);

  Future<UserModel> getUserData () => UserViewModel().getUser();
  UserModel user = UserModel();

  @override
  Widget build(BuildContext context) {
    getUserData ().then((value) {
      user = value;
    });
    return HideKeyBordContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Vérification ",
          showBack: true,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height - 110,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Code de vérification envoyé !", textAlign: TextAlign.center, style: TextStyle(
                      color: AppColors.primaryColor, fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: TextFormField(
                            controller: _controller1,
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
                            controller: _controller2,
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
                            controller: _controller3,
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
                            controller: _controller4,
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
                            controller: _controller5,
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
                  const SizedBox(height: 30,),
                  if (user.nomClient != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40,),
                    child: Text(
                      user.nomClient.toString(),
                      style: const TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),

                  const Text("Saisissez le code réçu par sms pour vérifier votre numéro de téléphone!", textAlign: TextAlign.center,),
                  const SizedBox(height: 30,),
                  /*InkWell(
                    child: const Center(
                      child: Text("Renvoyer le code", style: TextStyle(color: Colors.blue),),
                    ),
                    onTap: () {
                      if (user != null) {
                        authViewModel.registerApi({}, context, user.id, redirect: false);
                      }
                    },
                  ),*/

                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              child: RoundedButton(
              title: 'Valider',
              loading: authViewModel.loading,
              onPress: (){
                var code = _controller1.text + _controller2.text + _controller3.text + _controller4.text + _controller5.text;
                if (code.length < 5) {
                  Utils.flushBarErrorMessage("Vous devez saisir tous les chiffres du code", context);
                  return;
                }
                Map data = {
                  "code": code
                };
                if (user.nomClient != null) {
                  authViewModel.phoneVerificationConfirm(data, context);
                }
              },
            ),
            )
          ],
        ),
      ),
    );
  }
}