import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
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
    final t = AppLocalizations.of(context)!;
    DemandeModel demande = widget.demande;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top + 60, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 60),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.withOpacity(.2)
                    ),
                    width: 40, height: 40,
                    child: const Icon(Icons.close, color: Colors.black,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                  width: MediaQuery.of(context).size.width * 0.5 - 20,
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
            AppTexts.descriptionText(t.translate("no_beneficiary_tip")),
            const SizedBox(height: 20,),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppTexts.smallText(t.translate("home")),
                const Icon(Icons.chevron_right_rounded, color: Colors.green,),
                AppTexts.smallText(t.translate("beneficiaries")),
                const Icon(Icons.chevron_right_rounded, color: Colors.green,),
                AppTexts.smallText(t.translate("add_beneficiary")),
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
                                          child: AppTexts.descriptionText(t.translate("no_beneficiary_found")),
                                        ),
                                      );
                                    }
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        children: [
                                          AppTexts.titleText(t.translate("select_beneficiary")),
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
                                                      initials: beneficiaire.initials(),
                                                    )
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
                            child: AppTexts.descriptionText(t.translate("no_beneficiary_found")),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            AppTexts.titleText(t.translate("select_beneficiary")),
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
                                        initials: beneficiaire.initials(),
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
                    AppTexts.smallText(t.translate("choose_beneficiary")),
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
                      AppTexts.smallText(t.translate("name")),
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
                      AppTexts.smallText(t.translate("phone")),
                      AppTexts.bodyText(selectedBeneficiaire!.telBeneficiaire.toString(), bold: true),
                    ],
                  ),
                ],
              ),
            if (selectedBeneficiaire != null)
              const SizedBox(height: 20,),
            RoundedButton(
              title: t.translate("save"),
              color: AppColors.buttonBlackColor,
              onPress: () {
                if (selectedBeneficiaire == null) {
                  Utils.flushBarErrorMessage(t.translate("must_choose_beneficiary"), context);
                } else {
                  Map data = {
                    "idDemande": demande.idDemande,
                    "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire
                  };
                  DemandesViewModel changeBeneficiaireDemande = DemandesViewModel();
                  changeBeneficiaireDemande.changeBeneficiaire(data, context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}