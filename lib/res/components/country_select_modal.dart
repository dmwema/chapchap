import 'package:flutter/material.dart';

class CountrySelectModal extends StatelessWidget {
  const CountrySelectModal({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List countries = [
      {
        "code": "cd",
        "name": "République Démocratique du Congo",
        "phone": "+243",
        "device": "USD",
        "rate": 1.2
      },
      {
        "code": "ca",
        "name": "Canada",
        "phone": "+1",
        "device": "CAD",
        "rate": 1
      },
      {
        "code": "ci",
        "name": "République Démocratique du Congo",
        "phone": "+225",
        "device": "USD",
        "rate": 1.4
      },
      {
        "code": "bj",
        "name": "Bénin",
        "phone": "+229",
        "device": "USD",
        "rate": 1.7
      },
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Séléctionnez le pays de destination", style: TextStyle(
            fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          InkWell(
            child: Row(
              children: [
                Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 20, height: 20, fit: BoxFit.contain,),
                const SizedBox(width: 20,),
                Text("République Démocratique du Congo", style: TextStyle(
                    fontSize: 14
                ),)
              ],
            ),
          ),
        ],
      )
    );
  }
}