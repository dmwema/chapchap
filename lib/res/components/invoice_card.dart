import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  DemandeModel demande;

  InvoiceCard({super.key, required this.demande});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withOpacity(.4), width: 1)
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(demande.datePaidBen.toString(), style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.6)
                ),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Image.asset("packages/country_icons/icons/flags/png/${demande.codePaysSrce}.png", width: 30,),
                const SizedBox(width: 10,),
                const Icon(Icons.arrow_forward, size: 30,),
                const SizedBox(width: 10,),
                Image.asset("packages/country_icons/icons/flags/png/${demande.codePaysDest}.png", width: 30,)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bénéficiaire", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                Text(demande.beneficiaire.toString(), style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),)
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Statut", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                const Text("Enrégistrée", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                ),)
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Montant", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                Text("${demande.montanceSrce} ${demande.codePaysSrce}", style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}