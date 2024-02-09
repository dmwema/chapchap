import 'dart:io';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_filex/open_filex.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:email_validator/email_validator.dart';
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
  final TextEditingController _professionController = TextEditingController();

  bool loading = false;
  var _openResult = 'Unknown';

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

  Future<void> openFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
      loading = false;
    });
  }

  bool loadingPdf1 = false;
  bool loadingPdf2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider<DemandesViewModel>(
            create: (BuildContext context) => demandesViewModel,
            child: Consumer<DemandesViewModel>(
              builder: (context, value, _){
                switch (value.paysActifList.status) {
                  case Status.LOADING:
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: const Center(
                        child: CupertinoActivityIndicator(color: Colors.black,),
                      ),
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.paysActifList.message.toString()),
                    );
                  default:
                    paysList = value.paysActifList.data!;
                    selectedPays ??= PaysModel.fromJson(paysList[0]);
                    return Stack(
                      children: [
                        commonAppBar(
                          context: context,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50,),
                              const Text("Inscrivez-vous", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
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
                                label: "Email *",
                                controller: _emailController,
                                hint: "Email *",
                              ),
                              const SizedBox(height: 10,),
                              CustomFormField(
                                label: "Mot de passe *",
                                controller: _passwordController,
                                hint: "Mot de passe *",
                                prefixIcon: const Icon(Icons.lock_person_outlined),
                              ),
                              const SizedBox(height: 10,),
                              CustomFormField(
                                label: "Confirmer le Mot de passe *",
                                controller: _confirmPasswordController,
                                hint: "Confirmer le mot de passe *",
                                prefixIcon: const Icon(Icons.lock_person_outlined),
                              ),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("Séléctionnez votre pays", style: TextStyle(
                                                  fontWeight: FontWeight.w600
                                              ),),
                                              const SizedBox(height: 20,),
                                              Expanded(child: ListView.builder(
                                                itemCount: paysList.length,
                                                itemBuilder: (context, index) {
                                                  PaysModel current = PaysModel.fromJson(paysList[index]);
                                                  return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedPays = current;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                            const SizedBox(width: 20,),
                                                            Text("${current.paysNom} (${current.paysIndictel})", style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold
                                                            ),)
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
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.formFieldColor,
                                      border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 10),
                                        decoration: BoxDecoration(
                                            color: AppColors.formFieldBorderColor,
                                            // border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(6), topLeft: Radius.circular(6))
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset("packages/country_icons/icons/flags/png/${selectedPays!.codePays}.png", width: 20,),
                                            const SizedBox(width: 5,),
                                            const Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 10, bottom: 3),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(selectedPays!.paysIndictel.toString(), style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Flexible(child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.formFieldColor,
                                          hintText: "Téléphone *",
                                          hintStyle: TextStyle(
                                            color: Colors.black.withOpacity(.25)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.formFieldColor),// Changer la couleur de la bordure
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.formFieldColor),
                                          ),
                                          contentPadding: const EdgeInsets.only(left: 6),
                                        ),
                                        onTap: () {

                                        },
                                      ))
                                    ],
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
                                label: "Profession actuelle *",
                                controller: _professionController,
                                hint: "Profession actuelle *",
                              ),
                              const SizedBox(height: 10,),
                              CustomFormField(
                                label: "Code de parrainage",
                                controller: _codeController,
                                hint: "Code de parrainage",
                              ),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    confirmPolicy = !confirmPolicy;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3), // Changer le BorderRadius
                                      ),
                                      checkColor: Colors.white,
                                      value: confirmPolicy,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          confirmPolicy = !confirmPolicy;
                                        });
                                      },
                                    ),
                                    const Flexible(
                                      child: Text("J'accepte les politiques de chapchap. *"),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    confirmNewsletter = !confirmNewsletter;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      visualDensity: const VisualDensity(vertical: -4,),
                                      activeColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3), // Changer le BorderRadius
                                      ),
                                      checkColor: Colors.white,
                                      value: confirmNewsletter,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          confirmNewsletter = !confirmNewsletter;
                                        });
                                      },
                                    ),
                                    const Flexible(
                                      child: Text("Je m'abonne à la news letter pour recevoir des emails de notification."),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              RoundedButton(
                                title: "S'inscrire",
                                loading: authViewModel.loading,
                                onPress: () {
                                  if (!authViewModel.loading) {
                                    if (_nomController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer votre nom", context);
                                    } else if (_prenomController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer votre préom", context);
                                    } else if (_addressController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer votre adresse de résidence", context);
                                    } else if (_professionController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer votre profession actuelle", context);
                                    } else if (_phoneController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer votre numéro de téléphone", context);
                                    }  else if (_emailController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer l'adresse mail", context);
                                    } else if (!EmailValidator.validate(_emailController.text)) {
                                      Utils.flushBarErrorMessage("Adresse e-mail invalide", context);
                                    } else if (_passwordController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer le mot de passe", context);
                                    } else if (_passwordController.text.length < 6) {
                                      Utils.flushBarErrorMessage("Le mot de passe ne doit pas avoir moins de 6 carractères", context);
                                    }  else if (_passwordController.text != _confirmPasswordController.text) {
                                      Utils.flushBarErrorMessage("Les deux mot de passes ne correspondent pas", context);
                                    }  else if (!confirmPolicy) {
                                      Utils.flushBarErrorMessage("Vous devez accepter nos politiques avant de continuer", context);
                                    } else {
                                      Map data = {
                                        "username": _emailController.text,
                                        "nom": _nomController.text,
                                        "prenom": _prenomController.text,
                                        "email": _emailController.text,
                                        "idPays": selectedPays!.idPays,
                                        "adresse": _addressController.text,
                                        "profession": _professionController.text,
                                        "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                                        "code_parrainage": _codeController.text,
                                        "password": _passwordController.text
                                      };

                                      authViewModel.registerApi(data, context);
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Déjà inscit ?", style: TextStyle(fontWeight: FontWeight.w600),),
                                  const SizedBox(width: 5,),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, RoutesName.login);
                                    }, child: Text("Connectez-vous", style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold
                                  ),),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Divider(),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: () async {
                                  if (!loadingPdf1) {
                                    setState(() {
                                      loadingPdf1 = true;
                                    });

                                    var urllaunchable = await canLaunch("https://chapchap.ca/privacy_policy"); //canLaunch is from url_launcher package
                                    if(urllaunchable){
                                      await launch("https://chapchap.ca/privacy_policy"); //launch is from url_launcher package to launch URL
                                    }else{
                                      Utils.toastMessage("Impossible d'ouvrir l'url des politiques");
                                    }

                                    setState(() {
                                      loadingPdf1 = false;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (loadingPdf1)
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CupertinoActivityIndicator(color: Colors.black, radius: 7,),
                                      ),
                                    if (loadingPdf1)
                                    const SizedBox(width: 5,),
                                    const Text("Politique de confidentialité", style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    ), textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: () async {
                                  if (!loadingPdf2) {
                                    setState(() {
                                      loadingPdf2 = true;
                                    });
                                    // DemandesViewModel demandeVM = DemandesViewModel();
                                    // File file = await demandeVM.getFileContent("https://chapchap.ca/terms_of_condition", context: context);
                                    // try {
                                    //   openFile(file.path);
                                    // } catch (error) {
                                    //   Utils.flushBarErrorMessage("Une erreur est survenue, veuillez ressayer.", context);
                                    // }

                                    var urllaunchable = await canLaunch("https://chapchap.ca/terms_of_condition"); //canLaunch is from url_launcher package
                                    if(urllaunchable){
                                      await launch("https://chapchap.ca/terms_of_condition"); //launch is from url_launcher package to launch URL
                                    }else{
                                      Utils.toastMessage("Impossible d'ouvrir l'url des politiques");
                                    }
                                    setState(() {
                                      loadingPdf2 = false;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (loadingPdf2)
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CupertinoActivityIndicator(color: Colors.black, radius: 7,),
                                      ),
                                    if (loadingPdf2)
                                    const SizedBox(width: 5,),
                                    const Text("Conditions d'utilisation", style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14
                                    ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ],
                    );
                }
              })
    )
        ),
      ),
    );
  }
}