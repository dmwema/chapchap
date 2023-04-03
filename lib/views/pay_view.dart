import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class PayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "",
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("MONTANT À PAYER", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(.6)
                        ), textAlign: TextAlign.center,),
                        SizedBox(width: 5,),
                        const Text("(CAD)", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ), textAlign: TextAlign.center,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const Text("200.00", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.white
                    ),)
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text("Destination", style: TextStyle(
                color: Colors.black.withOpacity(.6),
              ),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 25,),
                  SizedBox(width: 10,),
                  Text("République Démocratique du Congo", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 10,),
              Text("Bénéficiaire", style: TextStyle(
                color: Colors.black.withOpacity(.6),
              ),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Daniel Mwema", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 10,),
              Text("Téléphone", style: TextStyle(
                color: Colors.black.withOpacity(.6),
              ),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("+243 123 456 678", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 10,),
              Text("Montant", style: TextStyle(
                color: Colors.black.withOpacity(.6),
              ),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("200 CAD", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Virement Interac", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                    SizedBox(width: 10,),
                    Text("(Toutes les banques)", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(.5),
                        fontSize: 11
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.darkRed
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Virement Interac - Dépot automatique", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                    SizedBox(height: 10,),
                    Text("(Toutes les banques sauf Desjardin)", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(.5),
                        fontSize: 11
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.darkRed2
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Virement Interac - Sans Dépot automatique", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                    SizedBox(height: 10,),
                    Text("(Dépot automatique)", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(.5),
                        fontSize: 11
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}