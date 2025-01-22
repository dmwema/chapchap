import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewBeneficiaireForm extends StatefulWidget {
  List destinations;
  BuildContext parentCotext;
  Destination? initialDestination;
  DemandesViewModel? demandesViewModel;
  bool? redirect;
  bool? hideTitle;

  NewBeneficiaireForm({super.key, this.demandesViewModel, required this.destinations, this.initialDestination, this.hideTitle,  required BuildContext this.parentCotext, this.redirect});

  @override
  State<NewBeneficiaireForm> createState() => _NewBeneficiaireFormState();
}

class _NewBeneficiaireFormState extends State<NewBeneficiaireForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();

  bool emailRequired = false;
  bool loadDest = false;
  bool loading = false;
  bool canEditDestination = true;

  Destination? selectedDesinaion;

  @override
  void initState() {
    if (widget.initialDestination != null) {
      setState(() {
        canEditDestination = false;
        selectedDesinaion = widget.initialDestination;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 20
        ),
        child: Column(
          children: [
            if(widget.hideTitle != true)
              AppTexts.titleText("Ajouter un bénéficiaire"),
            if(widget.hideTitle != true)
              const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                if (canEditDestination) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.bgColor,
                    builder: (context) {
                      return Container(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTexts.titleText("Séléctionnez le pays du bénéficiaire"),
                              const SizedBox(height: 10,),
                              Expanded(child: ListView.builder(
                                itemCount: widget.destinations.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedDesinaion = widget.destinations[index];
                                        });
                                        if (selectedDesinaion!.codePaysDest == "ca") {
                                          setState(() {
                                            emailRequired = true;
                                          });
                                        } else {
                                          setState(() {
                                            emailRequired = false;
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset("packages/country_icons/icons/flags/png/${widget.destinations[index].codePaysDest}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                            const SizedBox(width: 20,),
                                            AppTexts.smallText(widget.destinations[index].paysDest.toString())
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
                }

              },
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: AppColors.formFieldColor,
                  border: Border.all(color: AppColors.formFieldBorderColor, width: 1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectedDesinaion == null ? AppTexts.cardTitle("Pays du bénéficiaire *"): Row(
                      children: [
                        Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 30, height: 15, fit: BoxFit.contain),
                        const SizedBox(width: 10,),
                        AppTexts.smallText(selectedDesinaion!.paysDest.toString())
                      ],
                    ),
                    if (canEditDestination)
                    const Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: "Nom du bénéficiaire *",
              hint: "Nom *",
              controller: _nomController,
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: "Email ${emailRequired ? '*': ''}",
              hint: "Adresse E-mail ${emailRequired ? '*': ''}",
              controller: _emailController,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: "Téléphone *",
              hint: "Téléphone *",
              controller: _telController,
              type: TextInputType.phone,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: AppTexts.smallText(selectedDesinaion == null ? '-' : selectedDesinaion!.paysIndictelDest.toString()),
              ),
            ),
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Adresse *",
              hint: "Adresse *",
              controller: _adresseController,
            ),
            const SizedBox(height: 20,),
            RoundedButton(
              loading: loading,
              title: "Enrégistrer",
              onPress: () {
                if (!loading) {
                  if (!demandesViewModel.loading) {
                    if (selectedDesinaion == null) {
                      Utils.flushBarErrorMessage("Vous devez choisir un pays", context);
                    } else if (_nomController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Le nom du bénéficiaire est obligatoire est obligatoire", context);
                    }  else if (_telController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Le numéro de téléphone est obligatoire", context);
                    } else if (selectedDesinaion!.codePaysDest == "ca" && _emailController.text.isEmpty) {
                      Utils.flushBarErrorMessage("L'adresse email est obligatoire", context);
                    } else {
                      setState(() {
                        loading = true;
                      });
                      Map data = {
                        "id_pays": selectedDesinaion!.idPaysDest.toString(),
                        "emailBeneficiaire": _emailController.text,
                        "nomBeneficiaire": _nomController.text,
                        "telBeneficiaire": selectedDesinaion!.paysIndictelDest.toString() + _telController.text,
                        "telConfirmBeneficiaire": selectedDesinaion!.paysIndictelDest.toString() + _telController.text,
                        "adresseBeneficiaire": _adresseController.text,
                        "banque":"",
                        "swift":"",
                        "iban":"",
                        "id_institution_financiere":"",
                        "id_transit":"",
                        "id_compte":""
                      };
                      demandesViewModel.newBeneficiaire(data, widget.parentCotext, redirect: canEditDestination).then((value) async {
                        if (value != null){
                          if (value['error'] != true) {
                            Utils.toastMessage("Bénéficiaire enrégistré avec succès");
                            if (widget.redirect != true || !canEditDestination) {
                              // Navigator.pushNamed(context, RoutesName.recipeints);
                              Future.delayed(const Duration(milliseconds: 500), () async {
                                if (widget.demandesViewModel != null) {
                                  await widget.demandesViewModel!.beneficiaires([], context);
                                }
                                Navigator.pop(widget.parentCotext);
                              });
                            } else {
                              Navigator.pushReplacementNamed(context, RoutesName.recipeints);
                            }
                          } else {
                            Utils.flushBarErrorMessage(value['message'], context);
                          }
                        } else {
                          Utils.flushBarErrorMessage("Une erreur est suvenue, veuillez ressayer plutard", context);
                        }
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  }
                }
              },
            )
          ],
        ),
      )
    );
  }
}
