import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';

class SendBottomModal extends StatelessWidget {
  const SendBottomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20))
          ),
          width: double.infinity,
          child: const Center(
            child: Text("DETAILS DE L'ENVOI", style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),),
          )
        ),

        SizedBox(height: 5,),
        Divider(),
        SizedBox(height: 5,),
        Row(
          children: [
            Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 20, height: 20, fit: BoxFit.contain,),
            const SizedBox(width: 20,),
            const Text("République Démocratique du Congo", style: TextStyle(
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
    );
  }
}