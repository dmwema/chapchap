import 'dart:async';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';  // Importez AppLocalizations
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
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
    return HideKeyBordContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: CommonAppBar(
            context: context,
            backArrow: true,
            backClick: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.accountView, (route) => false);
            },
          ),
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
                    // Utilisation de AppLocalizations pour la traduction
                    AppTexts.titleText(AppLocalizations.of(context)!.translate('modify_pin_title')),

                    const SizedBox(height: 20,),

                    AppTexts.smallText(AppLocalizations.of(context)!.translate('current_pin_label')),

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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pinViewModel.resetPin(context);
                          },
                          child: AppTexts.bodyText("Code PIN oublié ?", bold: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),

                    AppTexts.smallText(AppLocalizations.of(context)!.translate('new_pin_label')),

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

                    AppTexts.smallText(AppLocalizations.of(context)!.translate('confirm_new_pin_label')),

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
                    const SizedBox(height: 10,),

                    RoundedButton(
                        title: AppLocalizations.of(context)!.translate('save_button'),
                        loading: pinViewModel.loading,
                        onPress: () async {
                          if (currentPin == null || currentPin!.length < 5) {
                            Utils.flushBarErrorMessage(
                                AppLocalizations.of(context)!.translate('error_current_pin_required'), context);
                          } else if (newPin == null || newPin!.length < 5) {
                            Utils.flushBarErrorMessage(
                                AppLocalizations.of(context)!.translate('error_new_pin_required'), context);
                          } else if (confirmNewPin == null || confirmNewPin!.length < 5) {
                            Utils.flushBarErrorMessage(
                                AppLocalizations.of(context)!.translate('error_confirm_new_pin_required'), context);
                          } else if (newPin != confirmNewPin) {
                            Utils.flushBarErrorMessage(
                                AppLocalizations.of(context)!.translate('error_pins_do_not_match'), context);
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
