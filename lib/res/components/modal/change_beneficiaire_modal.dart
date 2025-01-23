import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/beneficiaire_model.dart';
import 'package:mardona/model/demande_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/recipient_card2.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeBeneficiaireModal extends StatefulWidget {
  final DemandeModel demande;
  const ChangeBeneficiaireModal({super.key, required this.demande});

  @override
  State<ChangeBeneficiaireModal> createState() => _ChangeBeneficiaireModalState();
}

class _ChangeBeneficiaireModalState extends State<ChangeBeneficiaireModal> {
  DemandesViewModel demandeViewModel = DemandesViewModel();
  BeneficiaireModel? selectedBeneficiaire;
  List? beneficiaires;

  @override
  Widget build(BuildContext context) {
    DemandeModel demande = widget.demande;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppTexts.smallText(demande.date.toString()),
                    const SizedBox(height: 5,),
                    AppTexts.smallText("#${demande.idDemande}"),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppTexts.bodyText("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", bold: true),
                    const SizedBox(height: 5,),
                    if (demande.progression != null)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.formFieldBorderColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                        child: AppTexts.smallText(demande.progression.toString(), color: AppColors.primaryColor)
                      )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Divider(color: AppColors.formFieldBorderColor,),
          const SizedBox(height: 5,),
          AppTexts.descriptionText(
            "Si vous ne trouvez pas le bénéficiaire, vous pouvez l'ajouter en faisant :"),
          const SizedBox(height: 20,),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppTexts.smallText("Accueil "),
              const Icon(Icons.chevron_right_rounded, color: Colors.green,),
              AppTexts.smallText(" Bénéficiaires "),
              const Icon(Icons.chevron_right_rounded, color: Colors.green,),
              AppTexts.smallText(" Ajouter un bénéficiaire "),
            ],
          ),
          const SizedBox(height: 15,),
          InkWell(
            onTap: () {
              if (beneficiaires == null) {
                DemandesViewModel demandesViewModel2 = DemandesViewModel();
                demandesViewModel2.beneficiaires([], context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.bgColor,
                  builder: (context) {
                    return ChangeNotifierProvider<DemandesViewModel>(
                        create: (BuildContext context) => demandesViewModel2,
                        child: Consumer<DemandesViewModel>(
                            builder: (context, value, _){
                              switch (value.beneficiairesList.status) {
                                case Status.LOADING:
                                  return Column(
                                    children: [Expanded(child: Center(
                                      child: CircularProgressIndicator(color: AppColors.primaryColor,),
                                    ))],
                                  );
                                case Status.ERROR:
                                  return Center(
                                    child: Text(value.beneficiairesList.message.toString()),
                                  );
                                default:
                                  beneficiaires = [];
                                  value.beneficiairesList.data!.forEach((element) {
                                    BeneficiaireModel beneficiaireD = BeneficiaireModel.fromJson(element);
                                    if (beneficiaireD.codePays == demande.codePaysDest) {
                                      beneficiaires!.add(element);
                                    }
                                  });
                                  if (beneficiaires!.isEmpty) {
                                    return Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: AppTexts.descriptionText("Aucune bénéficiaire trouvée"),
                                      ),
                                    );
                                  }
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      children: [
                                        AppTexts.titleText("Séléctionnez un bénéficiaire"),
                                        const SizedBox(height: 20,),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: beneficiaires!.length,
                                            itemBuilder: (context, index) {
                                              BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(beneficiaires![index]);
                                              bool last = index == beneficiaires!.length - 1;
                                              return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedBeneficiaire = beneficiaire;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: RecipientCard2(
                                                        name: "${beneficiaire.nomBeneficiaire}",
                                                        address: beneficiaire.codePays.toString(),
                                                        phone: beneficiaire.telBeneficiaire.toString(),
                                                      )
                                                    );
                                                  }
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                              }
                            })
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(0),
                    ),
                  ),
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.bgColor,
                  builder: (context) {
                    if (beneficiaires!.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppTexts.descriptionText("Aucune bénéficiaire trouvée"),
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          AppTexts.titleText("Séléctionnez un bénéficiaire"),
                          const SizedBox(height: 20,),
                          Expanded(
                            child: ListView.builder(
                              itemCount: beneficiaires!.length,
                              itemBuilder: (context, index) {
                                BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(beneficiaires![index]);
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedBeneficiaire = beneficiaire;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: RecipientCard2(
                                      name: "${beneficiaire.nomBeneficiaire}",
                                      address: beneficiaire.codePays.toString(),
                                      phone: beneficiaire.telBeneficiaire.toString(),
                                    )
                                );
                              },
                            ),
                          )
                        ],
                      ),
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
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.formFieldBorderColor, width: 1.5),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppTexts.smallText("Choisissez un bénéficiaire"),
                  const SizedBox(width: 10,),
                  const Expanded(child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down, size: 30,),
                  ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          if (selectedBeneficiaire != null)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTexts.smallText("Nom"),
                    Row(
                      children: [
                        Image.asset("packages/country_icons/icons/flags/png/${selectedBeneficiaire!.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                        const SizedBox(width: 10,),
                        AppTexts.bodyText(selectedBeneficiaire!.nomBeneficiaire.toString(), bold: true),
                      ],
                    )
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTexts.smallText("Téléphone"),
                    AppTexts.bodyText(selectedBeneficiaire!.telBeneficiaire.toString(), bold: true),
                  ],
                ),
              ],
            ),
          if (selectedBeneficiaire != null)
            const SizedBox(height: 20,),
          RoundedButton(
            title: "Enrégistrer",
            color: AppColors.buttonBlackColor,
            onPress: () {
              if (selectedBeneficiaire == null) {
                Utils.flushBarErrorMessage("Vous devez séléctionner un bénéficiaire.", context);
              } else {
                Map data = {
                  "idDemande": demande.idDemande,
                  "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire
                };
                DemandesViewModel changeBeneficiaireDemande = DemandesViewModel();
                demandeViewModel.changeBeneficiaire(data, context);
              }
            },
          )
        ],
      ),
    );
  }
}