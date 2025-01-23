import 'package:mardona/model/beneficiaire_model.dart';
import 'package:mardona/model/demande_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/confirm_cancel.dart';
import 'package:mardona/res/components/modal/change_beneficiaire_modal.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:mardona/views/confirm_cancel_view.dart';
import 'package:mardona/views/send_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryCard extends StatefulWidget {
  DemandeModel demande;
  bool? hasProblem;

  HistoryCard({super.key, required this.demande, this.hasProblem});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {

  String truncateWithEllipsis(String text, {int maxLength = 22}) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength - 3)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    DemandeModel demande = widget.demande;
    bool? hasProblem = widget.hasProblem;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              color: AppColors.bgColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const SizedBox(height: 20,),
                  if (demande.probleme != null && demande.probleme != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.formFieldBorderColor
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: AppTexts.descriptionText(demande.probleme.toString()),
                          ),
                        ),
                      ],
                    ),
                  if (demande.probleme != null && demande.probleme != "")
                  const SizedBox(height: 10,),
                  if (demande.progression != null)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.formFieldColor
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: AppTexts.smallText(demande.progression.toString(), color: demande.facture != null ? Colors.green: (demande.lienPaiement != null || demande.progression.toString().contains("En cours") ? Colors.orange: Colors.red)),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("ID Transaction"),
                      AppTexts.bodyText("#${demande.idDemande}", bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Date"),
                      AppTexts.bodyText(demande.date.toString(), bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Montant envoyé"),
                      AppTexts.bodyText("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Montant à recevoir"),
                      AppTexts.bodyText("${demande.montanceDest} ${demande.paysCodeMonnaieDest}", bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Mode de retrait"),
                      AppTexts.bodyText("${demande.modeRetrait}", bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Sens"),
                      AppTexts.bodyText("${demande.paysSrce} vers ${demande.paysDest}", bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Bénéficiaire"),
                      AppTexts.bodyText(demande.beneficiaire.toString(), bold: true),
                    ],
                  ),
                  Divider(color: AppColors.formFieldColor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTexts.smallText("Téléphone"),
                      AppTexts.bodyText(demande.telBeneficiaire.toString(), bold: true),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      if (demande.lienPaiement != null && demande.facture == null && hasProblem != true)
                        RoundedButton(
                            onPress: () async {
                              if (demande.codePaysSrce == "cd") {
                                Navigator.pushNamed(context, RoutesName.drcPayment, arguments: {
                                  'idDemande': demande.idDemande,
                                  'nomBeneficiaire': demande.beneficiaire,
                                  'montant': "${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}",
                                });
                              } else {
                                String url = demande.lienPaiement.toString();
                                var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                if(urllaunchable){
                                  await launch(url); //launch is from url_launcher package to launch URL
                                  Navigator.pushNamed(context,RoutesName.home);
                                }else{
                                  Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
                                }
                              }
                            },
                            color: AppColors.buttonBlackColor,
                            title: "Payer",
                            icon: CupertinoIcons.creditcard
                        ),
                      if (demande.lienPaiement != null && demande.facture == null && hasProblem != true)
                        const SizedBox(height: 5,),
                      if (hasProblem != true)
                        RoundedButton(
                          onPress: () async {
                            BeneficiaireModel beneficiaire = BeneficiaireModel(
                              codePays: demande.codePaysDest,
                              idBeneficiaire: demande.idBeneficiaire,
                              telBeneficiaire: demande.telBeneficiaire,
                              paysMonnaie: demande.paysCodeMonnaieDest,
                              nomBeneficiaire: demande.beneficiaire,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SendView(
                                beneficiaire: beneficiaire,
                                destination: demande.codePaysDest,
                                modeRetrait: demande.idModeRetrait,
                                amount: double.parse(demande.montanceSrce.toString().replaceAll(',', '.').replaceAll(' ', '')),
                              )),
                            );
                          },
                          color: AppColors.buttonBlackColor,
                          title: "Nouveau Transfert",
                          icon: CupertinoIcons.arrow_up_right
                        ),
                      if (
                        demande.facture == null
                        && hasProblem != true
                      )
                        const SizedBox(height: 5,),
                      if (
                        demande.facture == null
                        && hasProblem != true
                        && (demande.lienPaiement != null || demande.progression.toString().contains("En cours"))
                      )
                        RoundedButton(
                            onPress: () {
                              DemandesViewModel demandeViewModel = DemandesViewModel();
                              if (demande.isPaid == true) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmCancelView(demandeId: demande.idDemande!.toInt(), demandesViewModel: demandeViewModel)));
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: AppColors.bgColor,
                                  builder: (context) {
                                    return ConfirmCancel(demandeId: demande.idDemande!.toInt(), demandesViewModel: demandeViewModel);
                                  },
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0),
                                    ),
                                  ),
                                );
                              }
                            },
                            color: AppColors.buttonBlackColor,
                            title: "Annuler la demande",
                            icon: CupertinoIcons.xmark_circle
                        ),
                      if (hasProblem == true)
                        RoundedButton(
                            onPress: () {
                              DemandesViewModel demandeViewModel = DemandesViewModel();
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: AppColors.bgColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0),
                                    ),
                                  ),
                                  builder: (context) {
                                    return ChangeBeneficiaireModal(demande: demande,);
                                  }
                              );
                            },
                            color: AppColors.buttonBlackColor,
                            title: "Changer de beneficiaire",
                            icon: CupertinoIcons.pencil
                        ),
                    ],
                  )
                ],
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ]
            ),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        width: 35, height: 35,
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Center(
                          child: Icon(
                            demande.facture != null ? CupertinoIcons.checkmark_alt : (demande.lienPaiement != null || demande.progression.toString().contains("En cours")? (CupertinoIcons.refresh_thick): CupertinoIcons.nosign), size: 20,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppTexts.cardTitle(demande.beneficiaire.toString()),
                          const SizedBox(height: 2,),
                          AppTexts.cardDescription(demande.date.toString(), color: AppColors.textGrey),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.formFieldColor
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: AppTexts.cardDescription("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", bold: true),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}