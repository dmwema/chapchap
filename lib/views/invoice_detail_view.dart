import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class InvoiceDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Facture F123-21",
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Text("Date", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black.withOpacity(.6)
              ),),
              const SizedBox(height: 7,),
              const Text("Lundi, 20 Septembre 2022", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),),
              SizedBox(height: 10,),
              const Divider(),
              SizedBox(height: 10,),
              Text("Bénéficiaire", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black.withOpacity(.6)
              ),),
              const SizedBox(height: 7,),
              const Text("Daniel Mwema", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 20,),
                  const SizedBox(width: 10,),
                  const Text("République Démocratique du Congo", style: TextStyle(
                    fontSize: 12,
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              const Divider(),
              SizedBox(height: 10,),
              Text("Statut", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black.withOpacity(.6)
              ),),
              const SizedBox(height: 7,),
              const Text("En cours", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.orange
              ),),
              SizedBox(height: 10,),
              const Divider(),
              SizedBox(height: 10,),
              Text("Montant", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black.withOpacity(.6)
              ),),
              const SizedBox(height: 7,),
              const Text("200 CAD", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
              ),),
              const SizedBox(height: 50,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: const [
                            Icon(Icons.delete_outline_rounded, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text("Supprimer", style: TextStyle(
                              color: Colors.white
                            ),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.pay);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: const [
                            Icon(Icons.money, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text("Payer", style: TextStyle(
                                color: Colors.white
                            ),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}