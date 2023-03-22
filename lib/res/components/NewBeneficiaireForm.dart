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
  bool? redirect;

  NewBeneficiaireForm({super.key, required this.destinations, required BuildContext this.parentCotext, this.redirect});

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

  Destination? selectedDesinaion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Ajouter un bénéficiaire", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17
            ),),
            const SizedBox(height: 20,),
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
              },
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                    border: Border.all(color: Colors.black26, width: 1)
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
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Nom du bénéficiaire *",
              hint: "Entrez le nom du bénéficiaire *",
              controller: _nomController,
              password: false,
            ),
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Email du bénéficiaire ${emailRequired ? '*': ''}",
              hint: "Entrez l'adresse e-mail du bénéficiaire ${emailRequired ? '*': ''}",
              controller: _emailController,
              type: TextInputType.emailAddress,
              password: false,
            ),
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Téléphone *",
              hint: "Entrez le numéro de téléphone du bénéficiaire *",
              controller: _telController,
              type: TextInputType.phone,
              password: false,
            ),
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Confirmez le téléphone *",
              hint: "Confirmez le téléphone du bénéficiaire ",
              controller: _telConfirmController,
              type: TextInputType.phone,
              password: false,
            ),
            const SizedBox(height: 20,),
            CustomFormField(
              label: "Adresse du bénéficiaire *",
              hint: "Entrez l'adresse du bénéficiaire *",
              controller: _adresseController,
              password: false,
            ),
            const SizedBox(height: 20,),
            RoundedButton(
              title: "Enrégistrer",
              onPress: () {
                if (!demandesViewModel.loading) {
                  if (selectedDesinaion == null) {
                    Utils.flushBarErrorMessage("Vous devez choisir un pays", context);
                  } else if (_telController.text.isEmpty) {
                    Utils.flushBarErrorMessage("Le numéro de téléphone est obligatoire", context);
                  }  else if (_telConfirmController.text.isEmpty) {
                    Utils.flushBarErrorMessage("L'adresse est obligatoire", context);
                  } else if (_adresseController.text.isEmpty) {
                    Utils.flushBarErrorMessage("Saisissez le champs de confirmation du nuéro de téléphone", context);
                  }  else if (_telController.text != _telConfirmController.text) {
                    Utils.flushBarErrorMessage("Les deux numéros ne correspondent pas", context);
                  } else if (selectedDesinaion!.codePaysDest == "ca" && _emailController.text.isEmpty) {
                    Utils.flushBarErrorMessage("L'adresse email est obligatoire", context);
                  } else {
                    Map data = {
                      "id_pays": selectedDesinaion!.idPaysDest,
                      "emailBeneficiaire": _emailController.text,
                      "nomBeneficiaire": _nomController.text,
                      "telBeneficiaire": _telController.text,
                      "telConfirmBeneficiaire": _telConfirmController.text,
                      "adresseBeneficiaire":"",
                      "banque":"",
                      "swift":"",
                      "iban":"",
                      "id_institution_financiere":"",
                      "id_transit":"",
                      "id_compte":""
                    };
                    demandesViewModel.newBeneficiaire(data, context).then((value) {
                      if (widget.redirect != true) {
                        Navigator.pop(widget.parentCotext);
                      }
                      setState(() {
                        selectedDesinaion = null;
                        _nomController.text = "";
                        _emailController.text = "";
                        _telController.text = "";
                        _telConfirmController.text = "";
                        _adresseController.text = "";
                      });
                    });
                  }
                }
              },
              loading: demandesViewModel.loading,
            ),
            const SizedBox(height: 20,),
          ],
        ),),
    );
  }
}
