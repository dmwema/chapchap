import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  NotificationsService? notificationsService;

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool loadingBio = false;
  UserModel? user;

  String? deviceToken;
  bool localAuthEnabled = false;

  @override
  void initState() {
    AuthViewModel().getLocalAuth().then((value) {
      setState(() {
        localAuthEnabled = value;
      });
    });
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
        print(value.toJson());
      });
    });
    setState(() {
      try {
        notificationsService = NotificationsService();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true,),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  AppTexts.titleText("Identifiez-vous"),
                  // AppTexts.descriptionText("Connectez-vous avec votre adresse électronique et votre mot de passe"),
                  const SizedBox(height: 20,),
                  CustomFormField(
                    label: "Adresse électronique",
                    hint: "Adresse électronique",
                    controller: _emailController,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10,),
                  CustomFormField(
                    label: "Mot de passe",
                    hint: "Mot de passe",
                    controller: _passwordController,
                    maxLines: 1,
                    obscurePassword: obscurePassword.value,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscurePassword.value = !obscurePassword.value;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: obscurePassword.value ? const Icon(Icons.visibility_off, size: 20,) : const Icon(Icons.visibility, size: 20,),
                      ),
                    ),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushNamed(context, RoutesName.passwordReset);
                  }, child: AppTexts.buttonText("Mot de passe oublié ?")
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          title: "Se connecter",
                          loading: authViewModel.loading,
                          onPress: () async {
                            if (!authViewModel.loading) {
                              if (_emailController.text.isEmpty) {
                                Utils.flushBarErrorMessage("Vous devez entrer l'adresse mail", context);
                              } else if (_passwordController.text.isEmpty) {
                                Utils.flushBarErrorMessage("Vous devez entrer le mot de passe", context);
                              } else if (_passwordController.text.length < 6) {
                                Utils.flushBarErrorMessage("Le mot de passe ne doit pas avoir moins de 6 carractères", context);
                              } else {
                                String? token;
                                if (notificationsService != null) {
                                  try {
                                    notificationsService!.isTokenRefresh();
                                    await notificationsService!.getDeviceToken().then((value) {
                                      token = value;
                                    });
                                  } catch (e) {
                                    print("-------------Error----------------");
                                    print(e.toString());
                                  }
                                }

                                Map data = {
                                  'username': _emailController.text.toString(),
                                  'password': _passwordController.text.toString(),
                                  'phoneId': token
                                };
                                authViewModel.loginApi(data, context, false);
                              }
                            }
                          }
                        ),
                      ),
                      if (user != null && user!.emailClient != null && user!.emailClient != "null" && user!.emailClient != "" && user!.password != null && user!.password != "null" && user!.password != "" && localAuthEnabled)
                      InkWell(
                        onTap: () async {
                          await LocalAuthService.canAuthenticate().then((value2) async {
                            if (value2) {
                              if (!loadingBio) {
                                setState(() {
                                  loadingBio = true;
                                });
                                await LocalAuthService.authenticate().then((value3) async {
                                  if (value3) {
                                    String? token;
                                    if (notificationsService != null) {
                                      try {
                                        notificationsService!.isTokenRefresh();
                                        await notificationsService!.getDeviceToken().then((value) {
                                          token = value;
                                        });
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    }
                                    Map dataAuth = {
                                      'username': user!.emailClient.toString(),
                                      'password': user!.password.toString(),
                                      'phoneId': token
                                    };

                                    await authViewModel.loginApi(dataAuth, context, true);
                                    setState(() {
                                      loadingBio = false;
                                    });
                                  }
                                });
                              }
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryColor
                          ),
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Platform.isAndroid ?
                            const Icon(Icons.fingerprint_rounded, size: 30, color: Colors.white,) :
                            Image.asset('assets/fid.png', width: 30,)
                          ,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _LoginViewState createState() => _LoginViewState();
}