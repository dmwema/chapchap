import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

class UpPinView extends StatefulWidget {
  const UpPinView({Key? key}) : super(key: key);

  @override
  State<UpPinView> createState() => _UpPinViewState();
}

class _UpPinViewState extends State<UpPinView> {
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

  String? currentPin;
  String? newPin;
  String? confirmNewPin;

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
                    const Text("Modifier le code PIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(height: 20,),
                    const Text("Code PIN actuel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(height: 10,),
                    PinFieldAutoFill(
                      cursor: Cursor(color: Colors.black, width: 2, height: 16, enabled: true),
                      currentCode: currentPin,
                      codeLength: 5,
                      decoration: BoxLooseDecoration(
                          strokeColorBuilder: PinListenColorBuilder(Colors.black, Colors.black,),
                          bgColorBuilder: const FixedColorBuilder(Colors.white),
                          strokeWidth: 1,
                          textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ),
                          radius: const Radius.circular(15)
                      ),
                      onCodeChanged: (code) {
                          currentPin = code ?? '';
                      },
                    ),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    const Text("Nouveau code PIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(height: 10,),
                    PinFieldAutoFill(
                      cursor: Cursor(color: Colors.black, width: 2, height: 16, enabled: true),
                      currentCode: newPin,
                      codeLength: 5,
                      decoration: BoxLooseDecoration(
                          strokeColorBuilder: PinListenColorBuilder(Colors.black, Colors.black,),
                          bgColorBuilder: const FixedColorBuilder(Colors.white),
                          strokeWidth: 1,
                          textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ),
                          radius: const Radius.circular(15)
                      ),
                      onCodeChanged: (code) {
                          newPin = code ?? '';
                      },
                    ),
                    const SizedBox(height: 20,),
                    const Text("Confirmer le Nouveau code PIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(height: 10,),
                    PinFieldAutoFill(
                      cursor: Cursor(color: Colors.black, width: 2, height: 16, enabled: true),
                      currentCode: currentPin,
                      codeLength: 5,
                      decoration: BoxLooseDecoration(
                          strokeColorBuilder: PinListenColorBuilder(Colors.black, Colors.black,),
                          bgColorBuilder: const FixedColorBuilder(Colors.white),
                          strokeWidth: 1,
                          textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ),
                          radius: const Radius.circular(15)
                      ),
                      onCodeChanged: (code) {
                          confirmNewPin = code ?? '';
                      },
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
                              if (currentPin == null || currentPin!.length < 5) {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez entrer le code PIN actuel",
                                    context);
                              } else
                              if (newPin == null || newPin!.length < 5) {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez entrer le nouveau code PIN",
                                    context);
                              } else
                              if (confirmNewPin == null || confirmNewPin!.length < 5) {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez confirmer le code PIN",
                                    context);
                              } else
                              if (newPin != confirmNewPin) {
                                Utils
                                    .flushBarErrorMessage(
                                    "Les deux pins ne correspondent pas",
                                    context);
                              } else {
                                Map data = {
                                  'code_pin': newPin,
                                  'code_pin_old': currentPin
                                };

                                await pinViewModel.updatePin(data, context);
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