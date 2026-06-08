import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/conversion_rule.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/points/points_conversion_view.dart';
import 'package:chapchap/views/points/points_conversions_view.dart';
import 'package:chapchap/views/points/points_help_view.dart';
import 'package:chapchap/views/points/points_transactions_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../data/response/status.dart';
import '../../view_model/points_view_model.dart';

class PointsView extends StatefulWidget {
  const PointsView({Key? key}) : super(key: key);

  @override
  State<PointsView> createState() => _PointsViewSatet();
}

class _PointsViewSatet extends State<PointsView> {
  UserModel? user;
  PointsViewModel pointsViewModel = PointsViewModel();

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
    pointsViewModel.getBalance(context);
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          context: context,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTexts.descriptionText(AppLocalizations.of(context)!.translate('points_balance')),
                            ],
                          ),
                          ChangeNotifierProvider<PointsViewModel>(
                              create: (BuildContext context) => pointsViewModel,
                              child: Consumer<PointsViewModel>(
                                  builder: (context, value, _){
                                    switch (value.balance.status) {
                                      case Status.LOADING:
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          child: const CupertinoActivityIndicator(radius: 8,),
                                        );
                                      case Status.ERROR:
                                        return Center(
                                          child: Text(value.balance.message.toString()),
                                        );
                                      default:
                                        var pBalance = value.balance.data!;
                                        return AppTexts.bigTitleText(user != null && user!.pointsBalance != null ? user!.pointsBalance.toString(): "0");
                                    }
                                  })
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
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTexts.bodyText(AppLocalizations.of(context)!.translate('operations'), bold: true),
                        const SizedBox(height: 5,),
                        AppTexts.descriptionText(AppLocalizations.of(context)!.translate('manage_points'))
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
                        title: AppLocalizations.of(context)!.translate('conversion'),
                        icon: Icons.currency_exchange_rounded,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => PointsConversionView()));
                        }
                    ),
                    const SizedBox(height: 10,),
                    RoundedButton(
                        title: AppLocalizations.of(context)!.translate('my_transactions'),
                        icon: Icons.history,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (context) => PointsTransactionsView()
                          ));
                        }
                    ),
                    const SizedBox(height: 10,),
                    RoundedButton(
                        title: AppLocalizations.of(context)!.translate('my_conversions'),
                        icon: Icons.history,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (context) => const PointsConversionsView()
                          ));
                        }
                    ),
                    const SizedBox(height: 10,),
                    Divider(color: AppColors.formFieldColor,),
                    const SizedBox(height: 10,),
                    RoundedButton(
                        title: AppLocalizations.of(context)!.translate('how_it_works'),
                        icon: Icons.info_outline_rounded,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (context) => PointsHelpView()
                          ));
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