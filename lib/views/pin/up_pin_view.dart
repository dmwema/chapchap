import 'dart:async';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/model/pays_destination_model.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/pin_view_model.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isObscured = true;

  String? currentPin;
  String? newPin;
  String? confirmNewPin;

  String? currentPinMask;
  String? newPinMask;
  String? confirmNewPinMask;

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  StreamController<ErrorAnimationType> errorController2 = StreamController<ErrorAnimationType>();
  StreamController<ErrorAnimationType> errorController3 = StreamController<ErrorAnimationType>();

  bool loadEmail = false;
  bool loadSMS = false;

  @override
  void initState() {
    super.initState();

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ok");
    return HideKeyBordContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: CommonAppBar(context: context, backArrow: true, backClick: () {
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.accountView, (route) => false);
          },),
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTexts.titleText("Modifier le code PIN"),
                    const SizedBox(height: 20,),
                    AppTexts.smallText("Code PIN actuel"),
                    const SizedBox(height: 10,),
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
                          currentPin = value;
                        });
                      },
                      appContext: context,
                    ),
                    const SizedBox(height: 10,),
                    AppTexts.smallText("Nouveau code PIN"),
                    const SizedBox(height: 10,),
                    PinCodeTextField(
                      length: 5,
                      obscureText: true,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      errorAnimationController: errorController2,
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
                          newPin = value;
                        });
                      },
                      appContext: context,
                    ),
                    const SizedBox(height: 10,),
                    AppTexts.smallText("Confirmer le Nouveau code PIN"),
                    const SizedBox(height: 10,),
                    PinCodeTextField(
                      length: 5,
                      obscureText: true,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      errorAnimationController: errorController3,
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
                          confirmNewPin = value;
                        });
                      },
                      appContext: context,
                    ),
                    const SizedBox(
                      height: 10,),
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
                    ),
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