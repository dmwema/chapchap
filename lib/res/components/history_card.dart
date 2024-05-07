import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/confirm_cancel.dart';
import 'package:chapchap/res/components/modal/change_beneficiaire_modal.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryCard extends StatefulWidget {
  DemandeModel demande;
  bool? hasProblem;

  HistoryCard({super.key, required this.demande, this.hasProblem});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const SizedBox(height: 5,),
                  if (demande.progression != null)
                  Text(demande.progression.toString(),
                      style: TextStyle(
                      fontSize: 13,
                      color: demande.facture != null ? Colors.green: (demande.lienPaiement != null ? Colors.orange: Colors.red),
                  ),),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ID Transaction", style: TextStyle(
                          fontWeight: FontWeight.bold,
                      ),),
                      Text("#${demande.idDemande}"),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Date", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text(demande.date.toString()),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant envoyé", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}"),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant à recevoir", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.montanceDest} ${demande.paysCodeMonnaieDest}"),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mode de retrait", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.modeRetrait}"),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Sens du transfert", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.paysSrce} vers ${demande.paysDest}"),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bénéficiaire", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text(demande.beneficiaire.toString()),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Téléphone", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text(demande.telBeneficiaire.toString()),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(),
                  const SizedBox(height: 5,),
                  Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      if (demande.lienPaiement != null && demande.facture == null && hasProblem != true)
                        InkWell(
                          onTap: () async {
                            String url = demande.lienPaiement.toString();
                            var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                            if(urllaunchable){
                              await launch(url); //launch is from url_launcher package to launch URL
                              Navigator.pushNamed(context,RoutesName.home);
                            }else{
                              Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.activeGreen,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.creditcard, color: Colors.white, size: 25,),
                                  SizedBox(width: 10,),
                                  Text("Payer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                ],
                              )
                          ),
                        ),
                      if (demande.lienPaiement != null && demande.facture == null && hasProblem != true)
                        const SizedBox(height: 10,),
                      if (hasProblem != true)
                        InkWell(
                          onTap: () {
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
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.arrow_up_right, color: Colors.white, size: 15,),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Nouveau Transfert",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      if (
                      demande.facture == null
                          && hasProblem != true
                      )
                        const SizedBox(height: 10,),
                      if (
                      demande.facture == null
                          && hasProblem != true
                      )
                        InkWell(
                          onTap: () {
                            DemandesViewModel demandeViewModel = DemandesViewModel();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return ConfirmCancel(demandeId: demande.idDemande!.toInt(), demandesViewModel: demandeViewModel);
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.xmark_circle, color: Colors.white, size: 15,),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Annuler la demande",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      if (hasProblem == true)
                        InkWell(
                          onTap: () {
                            DemandesViewModel demandeViewModel = DemandesViewModel();
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return ChangeBeneficiaireModal(demande: demande,);
                                }
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.pencil, color: Colors.white, size: 15,),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Changer de beneficiaire",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                    ),
                                  ),
                                ],
                              )
                          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: demande.facture != null ? Colors.green.withOpacity(.3): (demande.lienPaiement != null ? (Colors.orange.withOpacity(.3)): Colors.red.withOpacity(.3)),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: Icon(
                      demande.facture != null ? CupertinoIcons.checkmark : (demande.lienPaiement != null ? (CupertinoIcons.refresh): CupertinoIcons.xmark), size: 20,
                      color: demande.facture != null ? Colors.green: (demande.lienPaiement != null ? (Colors.orange): Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6 - 20 - 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(demande.beneficiaire.toString(), style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),),
                      const SizedBox(height: 2,),
                      Text(demande.date.toString(), style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4 - 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16
                      ),),
                      const SizedBox(height: 5,),
                      if (demande.progression != null)
                      Text(demande.progression.toString(), style: TextStyle(
                          color: demande.facture != null ? Colors.green: (demande.lienPaiement != null ? (Colors.orange): Colors.red),
                          fontWeight: FontWeight.w500,
                          fontSize: 9
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
              )
            ),
          )
        ],
      ),
    );
  }
}