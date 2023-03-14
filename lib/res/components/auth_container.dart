import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;

  const AuthContainer({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 80, bottom: 50, right: 30, left: 30),
              width: double.infinity,
              color: AppColors.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.png"),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("CHAPCHAP", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("TRANSFERT D’ARGENT - MONEY TRANSFERT", style: TextStyle(
                    color: Colors.white.withOpacity(.7),
                    fontSize: 13,
                  ),
                    textAlign: TextAlign.center,),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            child
          ],
        ),
      ),

    );
  }
}