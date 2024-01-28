import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  String? deviceToken;

  @override
  void initState() {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonAppBar(
                  context: context,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Connectez-vous", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                      const SizedBox(height: 10,),
                      const Text("Connectez-vous avec votre adress électronique et votre mot de passe", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black45), textAlign: TextAlign.left,),
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
                      }, child: const Text("Mot de passe oublié ?", style: TextStyle(
                        color: Colors.black
                      ),)),
                      const SizedBox(height: 20,),
                      RoundedButton(
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
                                  print(e.toString());
                                }
                              }

                              Map data = {
                                'username': _emailController.text.toString(),
                                'password': _passwordController.text.toString(),
                                'phoneId': token
                              };

                              authViewModel.loginApi(data, context);
                            }
                          }
                        }
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.register);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Vous êtes nouveau ?", style: TextStyle(color: Colors.black),),
                      const SizedBox(height: 3,),
                      Text("Inscrivez-vous", style: TextStyle(color: AppColors.primaryColor),),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  _LoginViewState createState() => _LoginViewState();
}