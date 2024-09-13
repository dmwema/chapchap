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
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinConfirmController = TextEditingController();

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
                    CustomFormField(
                      label: "Nouveau code PIN",
                      hint: "Entrez le nouveau code PIN",
                      type: TextInputType
                          .number,
                      controller: _pinController,
                    ),
                    const SizedBox(
                      height: 20,),
                    CustomFormField(
                      label: "Confirmer le nouveau code PIN",
                      hint: "Confirmer le nouveau code PIN",
                      type: TextInputType
                          .number,
                      controller: _pinConfirmController,
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
                              if (_pinController
                                  .text ==
                                  "") {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez entrer le code PIN",
                                    context);
                              } else
                              if (_pinConfirmController
                                  .text ==
                                  "") {
                                Utils
                                    .flushBarErrorMessage(
                                    "Vous devez confirmer le code PIN",
                                    context);
                              } else
                              if (_pinController
                                  .text !=
                                  _pinConfirmController
                                      .text) {
                                Utils
                                    .flushBarErrorMessage(
                                    "Les deux pins ne correspondent pas",
                                    context);
                              } else {
                                Map data = {
                                  'code_pin': _pinController
                                      .text,
                                  'code_pin_cfrm': _pinConfirmController.text,
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