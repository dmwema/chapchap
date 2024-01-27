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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                      ),
                      const SizedBox(height: 10,),
                      CustomFormField(
                        label: "Mot de passe",
                        hint: "Mot de passe",
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(Icons.visibility_off, size: 20,),
                        ),
                      ),
                      TextButton(onPressed: () {

                      }, child: const Text("Mot de passe oublié ?", style: TextStyle(
                        color: Colors.black
                      ),)),
                      const SizedBox(height: 20,),
                      RoundedButton(title: "Se connecter", onPress: () {

                      })
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 10,
              child: TextButton(
                onPressed: () {
                  
                },
                child: Container(
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