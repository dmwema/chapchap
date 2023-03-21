import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/res/components/screen_argument.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  DemandeModel demande;

  HistoryCard({super.key, required this.demande});

  @override
  Widget build(BuildContext context) {
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
                  const Text("Informations de l'opération", style: TextStyle(
                      fontWeight: FontWeight.w600
                  ),),
                  const SizedBox(height: 10,),
                  Text(demande.progression.toString(),
                      style: TextStyle(
                      fontSize: 13,
                      color: demande.facture != null ? Colors.green: (demande.lienPaiement != null ? Colors.orange: Colors.red),
                  ),),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Date", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text(demande.date.toString()),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant envoyé", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}"),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant à recevoir", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.montanceDest} ${demande.paysCodeMonnaieDest}"),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Sens du transfert", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("${demande.paysSrce} vers ${demande.paysDest}"),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bénéficiaire", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text(demande.beneficiaire.toString()),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Téléphone", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text(demande.telBeneficiaire.toString()),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                  const SizedBox(height: 10,),
                  if (demande.lienPaiement != null && demande.facture == null)
                  RoundedButton(
                    title: "Payer",
                    onPress: (){
                      Navigator.pushNamed(context, RoutesName.webViewPage, arguments: ScreenArguments(demande.lienPaiement.toString(), demande.lienPaiement.toString()));

                    },
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
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(demande.date.toString(), style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),),
                const SizedBox(height: 7,),
                Text("Envoi argent à ${demande.beneficiaire}", style: TextStyle(
                    color: Colors.black.withOpacity(.5),
                    fontSize: 12
                ),)
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 - 30,
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
                Text(demande.progression.toString(), style: TextStyle(
                    color: demande.facture != null ? Colors.green: (demande.lienPaiement != null ? Colors.orange: Colors.red),
                    fontWeight: FontWeight.w500,
                    fontSize: 11
                ),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}