import 'dart:io';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_filex/open_filex.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
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
  int currentPage = 0;
  int maxRegistrationSteps = 5;
  PageController scrollController = PageController();

  List stepTitles = [
    "Informations personnelles", "Informations du compte", "Adresse & Profeseion", "Promotions & Politiques", "Vérifier et terminer"
  ];

  Map data = {};

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscurePasswordConfirm = ValueNotifier<bool>(true);

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
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
        backClick: () {
          if (currentPage == 0) {
            Navigator.pop(context);
          } else {
            setState(() {
              scrollController.previousPage(duration: const Duration(microseconds: 500), curve: const ElasticInOutCurve());
              currentPage--;
            });
          }
        },
      ),
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTexts.smallText("Inscription", color: AppColors.primaryColor),
                  AppTexts.titleText(stepTitles[currentPage]),
                  const SizedBox(height: 10,),
                  Row(
                    children: List.generate(5, (index) {
                      return AnimatedContainer(
                        duration: const Duration(microseconds: 500),
                        width: index == currentPage ? (MediaQuery.of(context).size.width - 40 - 40 - (20*4)) : 20,
                        height: 5,
                        decoration: BoxDecoration(
                            color: index == currentPage ? AppColors.primaryColor : (index < currentPage ? AppColors.primaryColor.withOpacity(.5) : AppColors.formFieldBorderColor),
                            borderRadius: BorderRadius.circular(4)
                        ),
                        margin: EdgeInsets.only(right: index < 4 ? 10: 0),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: scrollController,
                onPageChanged: (index) {
                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    );
                  }

                  if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          CustomFormField(
                            label: "Adresse Email *",
                            controller: _emailController,
                            hint: "Adresse Email *",
                          ),
                          const SizedBox(height: 10,),
                          ChangeNotifierProvider<DemandesViewModel>(
                            create: (BuildContext context) => demandesViewModel,
                            child: Consumer<DemandesViewModel>(
                              builder: (context, value, _) {
                                switch (value.paysActifList.status) {
                                  case Status.LOADING:
                                    return SizedBox(
                                      height: MediaQuery.of(context).size.height - 100,
                                      child: const CupertinoActivityIndicator(color: Colors.black,),
                                    );
                                  case Status.ERROR:
                                    return Text(value.paysActifList.message.toString());
                                  default:
                                    paysList = value.paysActifList.data!;
                                    selectedPays ??= PaysModel.fromJson(paysList[0]);
                                    return Row(
                                      children: [
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
                                            height: 50, width: 80,
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                                            decoration: BoxDecoration(
                                                color: AppColors.formFieldColor,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                if (selectedPays != null)
                                                  Image.asset("packages/country_icons/icons/flags/png/${selectedPays!.codePays}.png", width: 30, height: 20,),
                                                if (selectedPays == null)
                                                  AppTexts.bodyText("_"),
                                                const SizedBox(width: 5,),
                                                const Icon(Icons.arrow_drop_down)
                                              ],
                                            )
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 80 - 40 - 10,
                                          child: CustomFormField(
                                            label: "Numéro de téléphone",
                                            hint: "Numéro de téléphone",
                                            controller: _phoneController,
                                            type: TextInputType.phone,
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(left: selectedPays == null ? 0: 20),
                                              child: AppTexts.cardTitle(selectedPays == null ? "" : selectedPays!.paysIndictel.toString()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                }
                              }
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
                        ],
                      ),
                    );
                  }

                  if (index == 2) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          CustomFormField(
                            label: "Adresse complete *",
                            controller: _addressController,
                            hint: "Adresse complete *",
                          ),
                          const SizedBox(height: 10,),
                          CustomFormField(
                            label: "Profession actuelle",
                            controller: _professionController,
                            hint: "Profession actuelle",
                          ),
                        ],
                      ),
                    );
                  }

                  if (index == 3) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
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
                                Flexible(
                                    child: AppTexts.smallText("J'accepte les politiques de chapchap. *")
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
                                Flexible(
                                    child: AppTexts.smallText("Je m'abonne à la newsletter pour recevoir des e-mails de notification.")
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          RoundedButton(
                            title: "Politique de confidentialité",
                            onPress: () async {
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
                            color: AppColors.buttonBlackColor,
                            loading: loadingPdf1,
                          ),
                          const SizedBox(height: 10,),
                          RoundedButton(
                            title: "Conditions d'utilisation",
                            onPress: () async {
                              if (!loadingPdf2) {
                                setState(() {
                                  loadingPdf2 = true;
                                });

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
                            color: AppColors.buttonBlackColor,
                            loading: loadingPdf2,
                          ),
                          const SizedBox(height: 20,)
                        ],
                      ),
                    );
                  }

                  if (index == 4) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                      child: commonRoundedContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTexts.smallText("Nom complet", color: Colors.black54),
                                  AppTexts.bodyText("${data["prenom"]} ${data["nom"]}", bold: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            commonDivider(),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTexts.smallText("Adresse E-mail", color: Colors.black54),
                                  AppTexts.bodyText("${data["email"]}", bold: true),
                                  const SizedBox(height: 10),
                                  AppTexts.smallText("Numéro de téléphone", color: Colors.black54),
                                  AppTexts.bodyText("${data["telephone"]}", bold: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            commonDivider(),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTexts.smallText("Adresse de résidence", color: Colors.black54),
                                  AppTexts.bodyText("${data["adresse"]}", bold: true),
                                  const SizedBox(height: 10),
                                  AppTexts.smallText("Profession", color: Colors.black54),
                                  AppTexts.bodyText("${data["profession"] == '' ? '_': data["profession"]}", bold: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            commonDivider(),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTexts.smallText("Code de parrainage", color: Colors.black54),
                                  AppTexts.bodyText("${data["code_parrainage"] == '' ? '_' : data["code_parrainage"]}", bold: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        removePaddingH: true
                      ),
                    );
                  }

                  return Container();
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
              child: RoundedButton(
                title: currentPage == maxRegistrationSteps - 1 ? "S'inscrire" : "Suivant",
                loading: authViewModel.loading,
                onPress: () {
                  if (!authViewModel.loading) {
                    if (currentPage == 0) {
                      if (_nomController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre nom", context);
                      } else if (_prenomController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre prénom", context);
                      } else {
                        setState(() {
                          data["prenom"] = _prenomController.text;
                          data["nom"] = _nomController.text;
                          currentPage++;
                        });
                        scrollController.nextPage(duration: const Duration(microseconds: 500), curve: const ElasticInOutCurve());
                      }
                    } else if (currentPage == 1) {
                      if (_emailController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre adresse E-mail", context);
                      } else if (_phoneController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre numéro de téléphone", context);
                      } else if (_passwordController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer le mot de passe", context);
                      } else if (_passwordController.text.length < 6) {
                        Utils.flushBarErrorMessage("Le mot de passe ne doit pas avoir moins de 6 carractères", context);
                      }  else if (_passwordController.text != _confirmPasswordController.text) {
                        Utils.flushBarErrorMessage("Les deux mot de passes ne correspondent pas", context);
                      } else {
                        setState(() {
                          data["username"] = _emailController.text;
                          data["email"] = _emailController.text;
                          data["idPays"] = selectedPays!.idPays.toString();
                          data["telephone"] = selectedPays!.paysIndictel.toString() + _phoneController.text;
                          data["email"] = _emailController.text;
                          currentPage++;
                        });
                        scrollController.nextPage(duration: const Duration(microseconds: 500), curve: const ElasticInOutCurve());
                      }
                    } else if (currentPage == 2) {
                      if (_addressController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Vous devez entrer votre adresse de résidence", context);
                      } else {
                        setState(() {
                          data["adresse"] = _addressController.text;
                          data["profession"] = _professionController.text;
                          currentPage++;
                        });
                        scrollController.nextPage(duration: const Duration(microseconds: 500), curve: const ElasticInOutCurve());
                      }
                    } else if (currentPage == 3) {
                      if (!confirmPolicy) {
                        Utils.flushBarErrorMessage("Vous devez accepter nos politiques avant de continuer", context);
                      }
                      setState(() {
                        data["code_parrainage"] = _codeController.text;
                        currentPage++;
                      });
                      scrollController.nextPage(duration: const Duration(microseconds: 500), curve: const ElasticInOutCurve());
                    } else {
                      authViewModel.registerApi(data, context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}