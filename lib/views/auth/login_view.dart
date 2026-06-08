import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _handleBiometricLogin(AuthViewModel authViewModel) async {
    setState(() {
      loadingBio = true;
    });

    await LocalAuthService.canAuthenticate().then((value2) async {
      if (value2) {
        await LocalAuthService.authenticate().then((value3) async {
          if (value3) {
            final prefs = await SharedPreferences.getInstance();
            final emailClient = prefs.getString('emailClient');
            final password = prefs.getString('password');

            if (emailClient != null && password != null) {
              String? token;
              if (notificationsService != null) {
                try {
                  await notificationsService!.getDeviceToken().then((value) {
                    notificationsService!.isTokenRefresh();
                    token = value;
                  });
                } catch (e) {
                  print(e.toString());
                }
              }

              Map data = {
                'username': emailClient,
                'password': password,
                'phoneId': token
              };

              authViewModel.loginApi(data, context, false);
            } else {
              Utils.flushBarErrorMessage(
                  AppLocalizations.of(context)!.translate("generic_error"),
                  context
              );
            }

            setState(() {
              loadingBio = false;
            });
          } else {
            setState(() {
              loadingBio = false;
            });
          }
        });
      } else {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.translate("phone_not_supported"),
            context
        );
        setState(() {
          loadingBio = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true, backClick: () {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.welcomeView, (route) => false);
      },),
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
                  AppTexts.titleText(loc!.loginTitle),
                  const SizedBox(height: 20,),
                  CustomFormField(
                    label: loc.email,
                    hint: loc.email,
                    controller: _emailController,
                    maxLines: 1,
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10,),
                  CustomFormField(
                    label: loc.password,
                    hint: loc.password,
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
                  }, child: AppTexts.buttonText(loc.forgotPassword)),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                            title: loc.login,
                            loading: authViewModel.loading,
                            onPress: () async {
                              if (!authViewModel.loading) {
                                if (_emailController.text.isEmpty) {
                                  Utils.flushBarErrorMessage(loc.enterEmail, context);
                                } else if (_passwordController.text.isEmpty) {
                                  Utils.flushBarErrorMessage(loc.enterPassword, context);
                                } else if (_passwordController.text.length < 6) {
                                  Utils.flushBarErrorMessage(loc.passwordLength, context);
                                } else {
                                  String? token;
                                  if (notificationsService != null) {
                                    try {
                                      await notificationsService!.getDeviceToken().then((value) {
                                        notificationsService!.isTokenRefresh();
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
                                  authViewModel.loginApi(data, context, false);
                                }
                              }
                            }
                        ),
                      ),
                      if (localAuthEnabled) ...[
                        const SizedBox(height: 15,),
                        GestureDetector(
                          onTap: loadingBio ? null : () => _handleBiometricLogin(authViewModel),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.buttonBlackColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            margin: EdgeInsets.only(left: 10),
                            child: loadingBio
                                ? const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                                : Icon(
                              Platform.isIOS ? Icons.face : Icons.fingerprint,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
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
