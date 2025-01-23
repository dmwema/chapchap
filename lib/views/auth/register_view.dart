import 'dart:io';
import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/pays_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/custom_field.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscurePasswordConfirm = ValueNotifier<bool>(true);

  bool loading = false;
  PaysModel? selectedPays;
  List paysList = [];
  DemandesViewModel demandesViewModel = DemandesViewModel();
  AuthViewModel authViewModel = AuthViewModel();

  bool confirmPolicy = false;
  bool confirmNewsletter = false;

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysActifs([], context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
        title: "Inscription",
      ),
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    pageTitleStyle(
                        title: "Créez votre compte Mardona Transfert", context: context),
                    const SizedBox(height: 20,),
                    CustomFormField(
                      label: "Nom *",
                      controller: _nomController,
                      hint: "Nom *",
                    ),
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Prénom(s) *",
                      controller: _prenomController,
                      hint: "Prénom(s) *",
                    ),
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Adresse Email *",
                      controller: _emailController,
                      hint: "Adresse Email *",
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.lightGrey,
                          builder: (context) {
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppTexts.titleText("Séléctionnez votre pays"),
                                    const SizedBox(height: 20,),
                                    Expanded(child: ListView.builder(
                                      itemCount: paysList.length,
                                      itemBuilder: (context, index) {
                                        PaysModel current = PaysModel
                                            .fromJson(paysList[index]);
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedPays = current;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "packages/country_icons/icons/flags/png/${current
                                                        .codePays}.png",
                                                    width: 30,
                                                    height: 20,
                                                    fit: BoxFit.contain,),
                                                  const SizedBox(
                                                    width: 20,),
                                                  Flexible(
                                                    child: AppTexts.bodyText("${current
                                                        .paysNom} (${current
                                                        .paysIndictel})",),
                                                  )
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    ))
                                  ],
                                )
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(0),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (selectedPays != null)
                                    Image.asset(
                                      "packages/country_icons/icons/flags/png/${selectedPays!.codePays}.png",
                                      width: 30,
                                      height: 20,
                                      fit: BoxFit.contain,),
                                  if (selectedPays != null)
                                    const SizedBox(width: 10),
                                  Text(selectedPays == null ? "Veuillez séléctionner votre pays" : selectedPays!.paysNom.toString()),
                                ],
                              ),
                              Icon(CupertinoIcons.chevron_down, size: 18,
                                color: AppColors.textGrey,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Téléphone",
                      hint: "Téléphone",
                      maxLines: 1,
                      controller: _phoneController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: AppTexts.bodyText(selectedPays == null ? "-" : selectedPays!.paysIndictel.toString()),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Mot de passe *",
                      hint: "Mot de passe *",
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
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Confirmer le Mot de passe *",
                      controller: _confirmPasswordController,
                      hint: "Confirmer le mot de passe *",
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
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Adresse complete *",
                      controller: _addressController,
                      hint: "Adresse complete *",
                    ),
                    const SizedBox(height: 10,),
                    CustomFormField(
                      label: "Code de parrainage",
                      controller: _codeController,
                      hint: "Code de parrainage",
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                child: RoundedButton(
                  title: "S'inscrire",
                  loading: authViewModel.loading,
                  onPress: () {
                    if (!authViewModel.loading) {
                      if (_nomController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre nom", context);
                      } else if (_prenomController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre prénom", context);
                      } else if (_emailController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre adresse E-mail", context);
                      } else if (_phoneController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre numéro de téléphone", context);
                      } else if (_passwordController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer le mot de passe", context);
                      } else if (_passwordController.text.length < 6) {
                        Utils.flushBarErrorMessage("Le mot de passe ne doit pas avoir moins de 6 carractères", context);
                      }  else if (_passwordController.text != _confirmPasswordController.text) {
                        Utils.flushBarErrorMessage("Les deux mot de passes ne correspondent pas", context);
                      } else if (_addressController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre adresse de résidence", context);
                      } else {
                        Map data = {
                          "prenom": _prenomController.text,
                          "nom": _nomController.text,
                          "username": _emailController.text,
                          "username": _emailController.text,
                          "idPays": selectedPays!.idPays.toString(),
                          "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                          "email": _emailController.text,
                          "adresse": _addressController.text,
                          "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                          "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                          "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                          "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                        };
                        authViewModel.registerApi(data, context);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}