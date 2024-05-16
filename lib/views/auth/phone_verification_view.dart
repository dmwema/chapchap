import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneVerification extends StatefulWidget {
  Map data;
  PhoneVerification({required this.data, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String otp = "";

  AuthViewModel authViewModel = AuthViewModel();

  Future<UserModel> getUserData () => UserViewModel().getUser();
  UserModel user = UserModel();
  bool resending = false;

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
          appBar: CustomAppBar(
            title: "Vérification",
            showBack: true,
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Entrez le code de vérification!", textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PinFieldAutoFill(
                        cursor: Cursor(color: Colors.black, width: 2, height: 16, enabled: true),
                        currentCode: otp,
                        codeLength: 5,
                        decoration: BoxLooseDecoration(
                            strokeColorBuilder: PinListenColorBuilder(Colors.black, Colors.black,),
                            strokeWidth: 0,
                            textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.black
                            ),
                            radius: const Radius.circular(5)
                        ),
                        onCodeChanged: (code) {
                          setState(() {
                            otp = code ?? '';
                          });
                        },
                      ),
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
                              resending = true;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            if (resending)
                              const CupertinoActivityIndicator(radius: 8,),
                            if (resending)
                              const SizedBox(width: 7,),
                            Text("Renvoyer le code ?", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primaryColor), textAlign: TextAlign.left,),
                          ],
                        )
                    ),
                    const SizedBox(height: 20,),
                    if (widget.data['message'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40,),
                      child: Text(
                        widget.data['message'],
                        style: const TextStyle(
                            color: Colors.black54,
                            height: 1.5,
                            fontSize: 14
                        ),
                        textAlign: TextAlign.center,
                      )
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
                loading: authViewModel.loading,
                onPress: (){
                  if (otp.length < 5) {
                    Utils.flushBarErrorMessage("Vous devez saisir tous les chiffres du code", context);
                    return;
                  }
                  Map data = {
                    "code": otp,
                    "username": widget.data['username']
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
      ),
    );
  }
}