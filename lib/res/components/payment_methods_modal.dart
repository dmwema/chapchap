import 'package:flutter/material.dart';

class PaymentMethodsModal extends StatelessWidget {
  const PaymentMethodsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Séléctionnez la méthode de reception", style: TextStyle(
                fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,),
            Text("Mpesa", style: TextStyle(
                fontSize: 14
            ),),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,),
            Text("Orange Money", style: TextStyle(
                fontSize: 14
            ),),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,),
            Text("Airtel Money", style: TextStyle(
                fontSize: 14
            ),),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,),
            Text("Afrimoney", style: TextStyle(
                fontSize: 14
            ),),
            SizedBox(height: 5,),
          ],
        )
    );
  }
}