import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class WalletPresentationView extends StatefulWidget {
  const WalletPresentationView({Key? key}) : super(key: key);

  @override
  State<WalletPresentationView> createState() => _ContactViewState();
}

class _ContactViewState extends State<WalletPresentationView> {
  UserModel? user;
  PinViewModel pinViewModel = PinViewModel();

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
                context: context,
                backArrow: true,
                backClick: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.home,
                        (route) => false,
                  );
                }
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30,),
                        Image.asset('assets/wallet.gif', width: MediaQuery.of(context).size.width * 0.6,),
                        const SizedBox(height: 20,),
                        const Text("Bienvenue a votre", style: TextStyle(
                          fontSize: 25,
                          color: Colors.black87,
                        ), textAlign: TextAlign.center,),
                        const SizedBox(height: 5,),
                        Text("portefeuille ChapChap", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor
                        ), textAlign: TextAlign.center,),
                        const SizedBox(height: 10,),
                        const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15
                          ), textAlign: TextAlign.center,),
                        if (user!.pin != true)
                        const SizedBox(height: 20,),
                        if (user!.pin != true)
                        const Text("Pour commencer, veuillez creer un code PIN pour renforcer la securite de votre compte",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15
                          ), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (user != null)
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: RoundedButton(
                  title: user!.pin == true ? "Commencer" : "Definir un code PIN",
                  onPress: () async {
                    if (user!.pin != true) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.createPin,
                            (route) => false,
                      );
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.walletHome,
                            (route) => false,
                      );
                    }
                  }
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}