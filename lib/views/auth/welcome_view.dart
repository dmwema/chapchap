import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:chapchap/views/auth/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo_black.png", width: 70,),
                    const SizedBox(height: 20,),
                    const Text("Bienvenue !", style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),),
                    const SizedBox(height: 20,),
                    const SizedBox(
                      width: 250,
                      child: Text("Envoyez de l’argent en toute sécurité et rapidité avec ChapChap !", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black45
                      ), textAlign: TextAlign.center,),
                    ),
                    const SizedBox(height: 20,),
                    Image.asset("assets/welcome.png", width: 300,),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                          title: "Se connecter à son compte",
                          onPress: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LoginView(),
                              ),
                            );
                          }
                      ),
                      const SizedBox(height: 10,),
                      RoundedButton(
                        title: "Créer un compte ChapChap",
                        onPress: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RegisterView(),
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
  _WelcomeViewState createState() => _WelcomeViewState();
}