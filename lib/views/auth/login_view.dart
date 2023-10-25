import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
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
  NotificationsService notificationsService = NotificationsService();

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  String? deviceToken;

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
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: AuthContainer(
        child: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Column(
            children: [
              const Text("Se connecter", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              Text("Connectez-vous avec votre adresse électronique et votre mot de passe", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black.withOpacity(.7)
              ), textAlign: TextAlign.center,),
              const SizedBox(height: 20,),
              CustomFormField(
                label: "Adresse électronique",
                hint: "Entrez l'adresse électronique",
                controller: _emailController,
                type: TextInputType.emailAddress,
                focusNode: emailFocusNode,
                onFieldSubmitted:
                    (value) {
                  CustomFormField.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
                },
                password: false,
                prefixIcon: Icon(Icons.alternate_email_sharp),
              ),
              const SizedBox(height: 20,),
              ValueListenableBuilder(
                valueListenable: obscurePassword, builder: (context, value, child) {
                return
                  CustomFormField(
                    label: "Mot de passe",
                    hint: "Entrez le mot de passe",
                    controller: _passwordController,
                    password: true,
                    maxLines: 1,
                    obscurePassword: obscurePassword.value,
                    type: TextInputType.visiblePassword,
                    focusNode: passwordFocusNode,
                    prefixIcon: Icon(Icons.lock_person_outlined),
                    suffixIcon: InkWell(
                      onTap: ( ) {
                        obscurePassword.value = !obscurePassword.value;
                      },
                      child: Icon(
                          obscurePassword.value ? Icons.visibility_off_outlined: Icons.visibility
                      ),
                    ),
                  );
              }),
              const SizedBox(height: 20,),
              InkWell(
                child: const Text("Mot de passe oublié ?", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                ), textAlign: TextAlign.start,),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.passwordReset);
                },
              ),
              const SizedBox(height: 30,),
              RoundedButton(
                title: 'Se connecter',
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
                      notificationsService.isTokenRefresh();
                      await notificationsService.getDeviceToken().then((value) {
                        token = value;
                      });
                      print("******************************");
                      print("******************************");
                      print("******************************");
                      print(token);
                      print("******************************");
                      print("******************************");
                      print("******************************");
                      Map data = {
                        'username': _emailController.text.toString(),
                        'password': _passwordController.text.toString(),
                        'phoneId': token
                      };

                      authViewModel.loginApi(data, context);
                    }
                  }
                },
              ),
              const SizedBox(height: 20,),
              const Text("Vous n'avez pas encore de compte ?"),
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
  _LoginViewState createState() => _LoginViewState();
}