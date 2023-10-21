import 'dart:io';

import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalAuthView extends StatefulWidget {
  const LocalAuthView({super.key});

  @override
  State<StatefulWidget> createState() => _LocalAuthViewState();
}

class _LocalAuthViewState extends State<LocalAuthView> {
  bool authenticated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Platform.isAndroid ? "assets/fingerprint.png" : "assets/faceid.png", width: 60),
              const SizedBox(height: 20,),
              Text("Verification ${Platform.isAndroid ? 'de l\'empreinte digitale' : 'du FaceID'}", style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700
              ),),
              const SizedBox(height: 10,),
              Text("Vous devez vérifier votre ${Platform.isAndroid ? 'empreinte digitale' : 'FaceID'} pour déverouiller l'application", style: const TextStyle(
                  fontSize: 12,
              ), textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  LocalAuthService.authenticate().then((value) {
                    if (value) {
                      Navigator.pushNamed(context, RoutesName.home);
                    }
                  });
                },
                child: Text('Vérifier ${Platform.isAndroid ? 'l\'empreinte digitale' : 'le FaceID'}')
              ),
            ],
          )
        ),
      ),
    );
  }
}