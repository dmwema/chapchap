import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/pin_view_model.dart';
import 'package:mardona/views/pin/create_pin_view.dart';
import 'package:mardona/views/wallet/wallet_home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mardona/view_model/user_view_model.dart';

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
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Container(
                          width: 250, height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: const DecorationImage(
                              image: AssetImage('assets/wallet.gif'),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        AppTexts.cardTitle("Bienvenue dans votre"),
                        const SizedBox(height: 5,),
                        AppTexts.titleText("Portefeuille ChapChap"),
                        const SizedBox(height: 10,),
                        AppTexts.descriptionText("Une nouvelle expérience centrée sur la simplicité et le gain de temps."),
                        if (user!.pin != true)
                        const SizedBox(height: 20,),
                        if (user!.pin != true)
                        const Text("Pour commencer, veuillez créer un code PIN pour renforcer la sécurité de votre Wallet!",
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
                  title: user!.pin == true ? "Commencer" : "Définir un code PIN",
                  onPress: () async {
                    if (user!.pin != true) {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => CreatePinView())
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => WalletHomeView())
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