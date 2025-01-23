import 'dart:async';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/custom_appbar.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneVerification extends StatefulWidget {
  Map data;
  PhoneVerification({required this.data, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String otp = "";
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  AuthViewModel authViewModel = AuthViewModel();

  Future<UserModel> getUserData () => UserViewModel().getUser();
  UserModel user = UserModel();
  bool resending = false;

  bool loading = false;

  @override
  void initState() {
    listenOtp();
    super.initState();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUserData ().then((value) {
      user = value;
    });
    return HideKeyBordContainer(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.bgColor,
          appBar: CommonAppBar(context: context, backArrow: true, backClick: () {
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
          },),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    AppTexts.titleText("Entrez le code de vérification!"),
                    const SizedBox(height: 20,),
                    PinCodeTextField(
                      length: 5,
                      obscureText: true,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      errorAnimationController: errorController,
                      keyboardType: TextInputType.number,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      cursorColor: Colors.black,
                      showCursor: true,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          errorBorderColor: Colors.black45,
                          inactiveColor: AppColors.formFieldBorderColor,
                          activeColor: AppColors.textGrey,
                          selectedColor: AppColors.textGrey
                      ),
                      onChanged: (value) {
                        setState(() {
                          otp = value ?? '';
                        });
                      },
                      appContext: context,
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                        onTap: () async {
                          if (!resending) {
                            setState(() {
                              resending = true;
                            });

                            Map data = {
                              "username": widget.data['username']
                            };
                            await authViewModel.resendCode(data, context, widget.data['token']);

                            setState(() {
                              resending = false;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            if (resending)
                              const CupertinoActivityIndicator(radius: 8,),
                            if (resending)
                              const SizedBox(width: 7,),
                            AppTexts.bodyText("Renvoyer le code ?", bold: true),
                          ],
                        )
                    ),
                    const SizedBox(height: 20,),
                    if (widget.data['message'] != null)
                    AppTexts.descriptionText(
                      widget.data['message'],
                    ),
                    /* const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),

                    const Text("Saisissez le code réçu pour vérifier votre numéro de téléphone!", textAlign: TextAlign.center,),

                    InkWell(
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
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundedButton(
                title: 'Valider',
                loading: loading,
                onPress: () async {
                  if (!loading) {
                    if (otp.length < 5) {
                      Utils.flushBarErrorMessage("Vous devez saisir tous les chiffres du code", context);
                      return;
                    }
                    setState(() {
                      loading = true;
                    });
                    Map data = {
                      "code": otp,
                      "username": widget.data['username']
                    };
                    if (user.nomClient != null) {
                      if (widget.data['update'] != null && widget.data['update'] == true) {
                        await authViewModel.confirmPhoneVerification(data, context, widget.data['token']);
                      } else {
                        await authViewModel.confirmContact(data, context, widget.data['token']);
                      }
                    }
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}