import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ResetPinView extends StatefulWidget {
  const ResetPinView({Key? key}) : super(key: key);

  @override
  State<ResetPinView> createState() => _ResetPinViewState();
}

class _ResetPinViewState extends State<ResetPinView> {
  PinViewModel pinViewModel = PinViewModel();
  bool loadingBio = false;
  UserModel? user;
  Destination? selectedTo;
  PaysDestinationModel? paysDestinationModel;
  List destinationsList = [];
  AuthViewModel authViewModel = AuthViewModel();
  bool changed = false;
  SharedPreferences? preferences;
  bool localAuthEnabled = false;

  bool loadEmail = false;
  bool loadSMS = false;

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      setState(() {
        loadEmail = false;
        loadSMS = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  final TextEditingController _codeController = TextEditingController();
  String? pin;
  String? pinConfirm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    return HideKeyBordContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
                child: commonAppBar(
                    context: context,
                    backArrow: true,
                    backClick: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.accountView,
                      );
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Récuperer le code PIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(
                      height: 20,),
                    const Text("Un code à 5 chiffres vous a été envoyé. Veuillez l'entrer pour changer le code PIN.", style: TextStyle(fontSize: 12, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(
                      height: 20,),
                    CustomFormField(
                      label: "Code",
                      hint: "Entrez le code réçu",
                      type: TextInputType
                          .number,
                      controller: _codeController,
                    ),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    PinCodeTextField(
                      length: 5,
                      obscureText: true,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
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
                      ),
                      onChanged: (value) {
                        setState(() {
                          pin = value;
                        });
                      },
                      appContext: context,
                    ),
                    const SizedBox(
                      height: 20,),
                    PinCodeTextField(
                      length: 5,
                      obscureText: true,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
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
                      ),
                      onChanged: (value) {
                        setState(() {
                          pinConfirm = value;
                        });
                      },
                      appContext: context,
                    ),
                    const SizedBox(
                      height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: [
                        RoundedButton(
                            title: "Enregistrer",
                            loading: pinViewModel.loading,
                            onPress: () async {
                              if (_codeController
                                  .text ==
                                  "") {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez entrer le code à 5 chiffres réçu",
                                    context);
                              } else
                              if (pin ==
                                  "") {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez entrer le code PIN",
                                    context);
                              } else
                              if (pinConfirm ==
                                  "") {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez confirmer le code PIN",
                                    context);
                              } else
                              if (pin != pinConfirm) {
                                Utils
                                    .flushBarErrorMessage(
                                    "Les deux pins ne correspondent pas",
                                    context);
                              } else {
                                Map data = {
                                  'code_pin': pin,
                                  'code_pin_cfrm': pinConfirm,
                                  'code': _codeController.text
                                };
                                await pinViewModel
                                    .changePin(data, context)
                                    .then((value) {
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RoutesName.home,
                                          (route) => false,
                                    );
                                  };
                                });
                              }
                            }
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}