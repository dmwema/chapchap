import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/view_model/points_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chapchap/l10n/app_localizations.dart';

class PointsConversionsView extends StatefulWidget {
  const PointsConversionsView({Key? key}) : super(key: key);

  @override
  State<PointsConversionsView> createState() => _PointsConversionsViewState();
}

class _PointsConversionsViewState extends State<PointsConversionsView> {
  WalletViewModel walletViewModel = WalletViewModel();
  UserModel? user;
  PointsViewModel pointsViewModel = PointsViewModel();

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    pointsViewModel.getBalance(context);
    pointsViewModel.getConversionsHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTexts.titleText(AppLocalizations.of(context).translate('conversions')),
                      const SizedBox(height: 10,),
                      Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.formFieldColor, width: 1),
                                top: BorderSide(color: AppColors.formFieldColor, width: 1),
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/icons/coins.png", width: 20,),
                                  const SizedBox(width: 5,),
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
                                                return AppTexts.cardTitle(user != null && user!.pointsBalance != null ? user!.pointsBalance.toString() : "0");
                                            }
                                          })
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider<PointsViewModel>(
                create: (BuildContext context) => pointsViewModel,
                child: Consumer<PointsViewModel>(
                    builder: (context, value, _) {
                      switch (value.conversions.status) {
                        case Status.LOADING:
                          return const Center(
                            child: CupertinoActivityIndicator(color: Colors.black,),
                          );
                        case Status.ERROR:
                          return AppTexts.descriptionText(value.conversions.message.toString());
                        default:
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.conversions.data.length,
                            itemBuilder: (context, index) {
                              var current = value.conversions.data[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
                                child: commonRoundedContainer(
                                    removePaddingAll: true,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 50, height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Colors.orange.withOpacity(.2),
                                                ),
                                                padding: const EdgeInsets.all(5),
                                                child: Image.asset("assets/icons/coins.png", width: 20,),
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:  [
                                                  Row(
                                                    children: [
                                                      const Icon(CupertinoIcons.arrow_down_left, size: 18, color: Colors.red,), const SizedBox(width: 5,),
                                                      AppTexts.bodyText("${current['points_used']} " + AppLocalizations.of(context).translate('points'), color: AppColors.buttonBlackColor, bold: true),
                                                    ],
                                                  ),
                                                  AppTexts.smallText(current['date'], color: AppColors.buttonBlackColor.withOpacity(.5)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(CupertinoIcons.arrow_up_right, size: 18, color: Colors.green,), const SizedBox(width: 5,),
                                                  AppTexts.bodyText("${current['cash_received']} CAD", bold: true),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              );
                            },
                          );
                      }
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
