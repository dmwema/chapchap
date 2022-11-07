import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.invoiceDetail);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withOpacity(.4), width: 1)
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Le 20 Juin 2022", style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.6)
                ),),
                const Text("F123-21", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),)
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Image.asset("packages/country_icons/icons/flags/png/ca.png", width: 30,),
                const SizedBox(width: 10,),
                Icon(Icons.arrow_forward, size: 30,),
                const SizedBox(width: 10,),
                Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 30,)
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bénéficiaire", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                const Text("Daniel Mwema", style: TextStyle(
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
                const Text("En cours", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                ),)
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Montant", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                const Text("200 CAD", style: TextStyle(
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