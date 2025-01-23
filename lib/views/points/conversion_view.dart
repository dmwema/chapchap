
import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:mardona/view_model/wallet_view_model.dart';
import 'package:mardona/views/wallet/create_wallet_view.dart';
import 'package:mardona/views/wallet/recharge_history_view.dart';
import 'package:mardona/views/wallet/recharge_view.dart';
import 'package:mardona/views/wallet/transfers_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PointsView extends StatefulWidget {
  const PointsView({Key? key}) : super(key: key);

  @override
  State<PointsView> createState() => _PointsViewSatet();
}

class _PointsViewSatet extends State<PointsView> {
  UserModel? user;

  DemandesViewModel  demandesViewModel = DemandesViewModel();

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          context: context,
          navWhite: true,
          backArrow: true,
          backClick: () {
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
          },
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: commonRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTexts.descriptionText("Vous avez"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTexts.titleText("500 POINTS", color: Colors.orange)
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColors.formFieldColor
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: AppTexts.smallText("1 Point = 5 CAD"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(top: -10, left: (MediaQuery.of(context).size.width - 80)/2, child: Image.asset("assets/icons/coins.png", width: 70,))
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTexts.bodyText("Operations", bold: true),
                        const SizedBox(height: 5,),
                        AppTexts.descriptionText("Gérez vos points de manière efficace")
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    RoundedButton(
                      title: "Conversion",
                      icon: Icons.currency_exchange_rounded,
                      color: AppColors.buttonBlackColor,
                      textColor: Colors.white,
                      onPress: () {
                        if (true) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String? pin;
                              return Dialog(
                                backgroundColor: AppColors.bgColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(
                                        20)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      vertical: 30,
                                      horizontal: 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min,
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.buttonBlackColor,
                                        size: 60,
                                      ),
                                      AppTexts.titleText("Vous devez avoir au moins 1000 points pour faire une conversion."),
                                      const SizedBox(height: 5,),
                                      AppTexts.descriptionText("Faites plus de transferts pour gagner encore plus de points 😊"),
                                      const SizedBox(height: 10,),
                                      RoundedButton(
                                        title: "Compris", onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {

                        }
                      }
                    ),
                    const SizedBox(height: 10,),
                    RoundedButton(
                      title: "Historique",
                      icon: Icons.history,
                      color: AppColors.buttonBlackColor,
                      textColor: Colors.white,
                      onPress: () {
                        // Navigator.pushNamed(context, RoutesName.send);
                      }
                    ),
                    const SizedBox(height: 10,),
                    RoundedButton(
                      title: "Comment ça marche",
                      icon: Icons.info_outline_rounded,
                      color: AppColors.buttonBlackColor,
                      textColor: Colors.white,
                      onPress: () {
                        // Navigator.pushNamed(context, RoutesName.interac);
                      }
                    ),
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