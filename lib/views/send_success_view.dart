import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class SendSuccessView extends StatelessWidget {
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                const Icon(Icons.check_circle_outlined, color: Colors.green, size: 80,),
                SizedBox(height: 20,),
                Text("Transaction effectuée avec succès", style: TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
                )),
                const SizedBox(height: 20,),
                Text("Votre transaction a été éffectuée avec succès. veuillez payer l’argent de transfert Merci d’avoir choisi ChapChap!", style: TextStyle(
                  color: Colors.black.withOpacity(.7)
                ), textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: const [
                      Text("Montant à payer", style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 10,),
                      Text("200.00 CAD", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 40
                      ),)
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                RoundedButton(title: "Voir l'historique", onPress: () {
                  Navigator.pushNamed(context, RoutesName.history);
                }),
              ],
            ),
          )
        ),
      ),
    );
  }
}