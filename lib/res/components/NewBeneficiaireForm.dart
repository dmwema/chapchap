import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
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
  bool? redirect;
  bool? hideTitle;

  NewBeneficiaireForm({super.key, required this.destinations, this.initialDestination, this.hideTitle,  required BuildContext this.parentCotext, this.redirect});

  @override
  State<NewBeneficiaireForm> createState() => _NewBeneficiaireFormState();
}

class _NewBeneficiaireFormState extends State<NewBeneficiaireForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _telConfirmController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();

  bool emailRequired = false;
  bool loadDest = false;
  bool loading = false;
  bool confirmNumber = false;

  Destination? selectedDesinaion;

  @override
  Widget build(BuildContext context) {
    if(widget.initialDestination != null && !loadDest) {
      setState(() {
        selectedDesinaion = widget.initialDestination!;
      });
    }
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
              const Text("Ajouter un bénéficiaire", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
              ),),
            if(widget.hideTitle != true)
              const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                if (widget.initialDestination == null) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Séléctionnez le pays du bénéficiaire", style: TextStyle(
                                  fontWeight: FontWeight.w600
                              ),),
                              const SizedBox(height: 20,),
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
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset("packages/country_icons/icons/flags/png/${widget.destinations[index].codePaysDest}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                            const SizedBox(width: 20,),
                                            Text(widget.destinations[index].paysDest.toString(), style: const TextStyle(
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
                    selectedDesinaion == null ? const Text("Pays du bénéficiaire *", style: TextStyle(color: Colors.black54),): Row(
                      children: [
                        Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 30, height: 15, fit: BoxFit.contain),
                        const SizedBox(width: 10,),
                        Text(selectedDesinaion!.paysDest.toString())
                      ],
                    ),
                    const Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: "Nom du bénéficiaire *",
              hint: "Entrez le nom du bénéficiaire *",
              controller: _nomController,
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: "Email du bénéficiaire ${emailRequired ? '*': ''}",
              hint: "Entrez l'adresse e-mail du bénéficiaire ${emailRequired ? '*': ''}",
              controller: _emailController,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: AppColors.formFieldColor,
                  border: Border.all(color: AppColors.formFieldBorderColor, width: 1)
              ),
              child: Row(
                children: [
                  SizedBox(child: Padding(padding: const EdgeInsets.only(bottom: 3), child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        selectedDesinaion == null ? '-' : selectedDesinaion!.paysIndictelDest.toString(),
                        style: const TextStyle(
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),),),
                  Expanded(child: TextFormField(
                    controller: _telController,
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
                  ),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: AppColors.formFieldColor,
                  border: Border.all(color: AppColors.formFieldBorderColor, width: 1)
              ),
              child: Row(
                children: [
                  SizedBox(child: Padding(padding: const EdgeInsets.only(bottom: 3), child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        selectedDesinaion == null ? '-' : selectedDesinaion!.paysIndictelDest.toString(),
                        style: const TextStyle(
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),),),
                  Expanded(child: TextFormField(
                    controller: _telConfirmController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.formFieldColor,
                      hintText: "Confirmer le téléphone *",
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
                  ),)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                setState(() {
                  confirmNumber = !confirmNumber;
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    activeColor: AppColors.primaryColor,
                    checkColor: Colors.white,
                    value: confirmNumber,
                    onChanged: (bool? value) {
                      setState(() {
                        confirmNumber = !confirmNumber;
                      });
                    },
                  ),
                  const Flexible(
                    child: Text("Je confirme que le numéro entré est correct. En cas d'erreur, ChapChap n'est pas responsable et aucun remboursement ne pourra être généré.."),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Adresse du bénéficiaire *",
              hint: "Entrez l'adresse du bénéficiaire *",
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
                    } else if (_telController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Le numéro de téléphone est obligatoire", context);
                    }  else if (_telConfirmController.text.isEmpty) {
                      Utils.flushBarErrorMessage("L'adresse est obligatoire", context);
                    } else if (_adresseController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Saisissez le champs de confirmation du numéro de téléphone", context);
                    }  else if (_telController.text != _telConfirmController.text) {
                      Utils.flushBarErrorMessage("Les deux numéros ne correspondent pas", context);
                    } else if (selectedDesinaion!.codePaysDest == "ca" && _emailController.text.isEmpty) {
                      Utils.flushBarErrorMessage("L'adresse email est obligatoire", context);
                    } else if (!confirmNumber) {
                      Utils.flushBarErrorMessage("Vous devez cocher la case de la confirmation du numéro de téléphone", context);
                    } else {
                      setState(() {
                        loading = true;
                      });
                      Map data = {
                        "id_pays": selectedDesinaion!.idPaysDest.toString(),
                        "emailBeneficiaire": _emailController.text,
                        "nomBeneficiaire": _nomController.text,
                        "telBeneficiaire": selectedDesinaion!.paysIndictelDest.toString() + _telController.text,
                        "telConfirmBeneficiaire": selectedDesinaion!.paysIndictelDest.toString() + _telConfirmController.text,
                        "adresseBeneficiaire": _adresseController.text,
                        "banque":"",
                        "swift":"",
                        "iban":"",
                        "id_institution_financiere":"",
                        "id_transit":"",
                        "id_compte":""
                      };
                      demandesViewModel.newBeneficiaire(data, context, redirect: widget.redirect == true).then((value) {
                        if (widget.redirect != true) {
                          Navigator.pop(widget.parentCotext);
                        } else {
                          Navigator.pushNamed(context, RoutesName.recipeints);
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
