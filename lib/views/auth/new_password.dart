import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  String email;
  NewPassword({required this.email, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _passCnfController = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();
  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscurePasswordConfirm = ValueNotifier<bool>(true);

  bool resending = false;

  @override
  Widget build(BuildContext context) {
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
                      backArrow: true,
                    backClick: () {
                        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Réinitialiser le mot de passe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                        const SizedBox(height: 10,),
                        const Text("Veuillez saisir le code réçu et créez un nouveau mot de passe", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black45), textAlign: TextAlign.left,),
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: () async {
                            if (!resending) {
                              setState(() {
                                resending = true;
                              });

                              Map data = {
                                "username": widget.email
                              };
                              await authViewModel.resendCode(data, context);

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
                        CustomFormField(
                          label: "Code",
                          hint: "Code",
                          controller: _codeController,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10,),
                        CustomFormField(
                          label: "Mot de passe",
                          hint: "Mot de passe",
                          controller: _passController,
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
                        const SizedBox(height: 10,),
                        CustomFormField(
                          label: "Confirmer le mot de passe",
                          hint: "Confirmer le mot de passe",
                          controller: _passCnfController,
                          maxLines: 1,
                          obscurePassword: obscurePasswordConfirm.value,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscurePasswordConfirm.value = !obscurePasswordConfirm.value;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: obscurePasswordConfirm.value ? const Icon(Icons.visibility_off, size: 20,) : const Icon(Icons.visibility, size: 20,),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        RoundedButton(
                            title: "Valider",
                            loading: authViewModel.loading,
                            onPress: () async {
                              if (!authViewModel.loading) {
                                if (_passCnfController.text.isEmpty || _passController.text.isEmpty || _codeController.text.isEmpty) {
                                  Utils.flushBarErrorMessage("Tous les champs sont réquis", context);
                                } else {
                                  Map data = {
                                    "password": _passController.text,
                                    "password_cfrm": _passCnfController.text,
                                    "code": _codeController.text,
                                    "username": widget.email
                                  };
                                  authViewModel.changePassword(data, context);
                                }
                              }
                            }
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}