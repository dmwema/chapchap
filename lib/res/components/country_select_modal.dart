import 'package:flutter/material.dart';

class CountrySelectModal extends StatelessWidget {
  const CountrySelectModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("République Démocratique du Congo", style: TextStyle(
                fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/bj.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Bénin", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/bf.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Burkina Faso", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/cn.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Chine", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/ci.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Côte d'Ivoire", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/gn.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Guinée", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/ml.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Mali", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/sn.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Sénégal", style: TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset("packages/country_icons/icons/flags/png/tg.png", width: 20, height: 20, fit: BoxFit.contain,),
              const SizedBox(width: 20,),
              Text("Togo", style: const TextStyle(
                  fontSize: 14
              ),)
            ],
          ),
          SizedBox(height: 5,),
        ],
      )
    );
  }
}