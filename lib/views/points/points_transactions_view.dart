import 'package:chapchap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/view_model/points_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';

class PointsTransactionsView extends StatefulWidget {
  PointsTransactionsView({Key? key}) : super(key: key);

  @override
  State<PointsTransactionsView> createState() => _PointsTransactionsViewState();
}

class _PointsTransactionsViewState extends State<PointsTransactionsView> {
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
    pointsViewModel.getTransactionsHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

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
                      AppTexts.titleText(AppLocalizations.of(context).translate('transactions')),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.formFieldColor, width: 1),
                            top: BorderSide(color: AppColors.formFieldColor, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/icons/coins.png", width: 20),
                                const SizedBox(width: 5),
                                ChangeNotifierProvider<PointsViewModel>(
                                  create: (BuildContext context) => pointsViewModel,
                                  child: Consumer<PointsViewModel>(
                                    builder: (context, value, _) {
                                      switch (value.balance.status) {
                                        case Status.LOADING:
                                          return CupertinoActivityIndicator(radius: 8);
                                        case Status.ERROR:
                                          return Center(child: Text(value.balance.message.toString()));
                                        default:
                                          return AppTexts.cardTitle(user?.pointsBalance?.toString() ?? "0");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                    switch (value.transactions.status) {
                      case Status.LOADING:
                        return const Center(child: CupertinoActivityIndicator(color: Colors.black));
                      case Status.ERROR:
                        return AppTexts.descriptionText(value.transactions.message.toString());
                      default:
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.transactions.data.length,
                          itemBuilder: (context, index) {
                            var current = value.transactions.data[index];
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
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.orange.withOpacity(.2),
                                            ),
                                            padding: const EdgeInsets.all(5),
                                            child: Image.asset("assets/icons/coins.png", width: 20),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    current['idDemande'] == null ? CupertinoIcons.arrow_down_left : CupertinoIcons.arrow_up_right,
                                                    size: 15,
                                                    color: current['idDemande'] == null ? Colors.red : Colors.green,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  AppTexts.bodyText("${current['points']} Points", color: AppColors.buttonBlackColor, bold: true),
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
                                          AppTexts.smallText(
                                            current['idDemande'] == null ? locale.conversion : AppLocalizations.of(context).translate('transfer'),
                                          ),
                                          if (current['idDemande'] != null)
                                            AppTexts.bodyText("#${current['idDemande']}", bold: true),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
