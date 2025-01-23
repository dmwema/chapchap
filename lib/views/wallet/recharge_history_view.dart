import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RechargeHistoryView extends StatefulWidget {
  Map wallet;
  RechargeHistoryView({required this.wallet, Key? key}) : super(key: key);

  @override
  State<RechargeHistoryView> createState() => _RechargeHistoryViewState();
}

class _RechargeHistoryViewState extends State<RechargeHistoryView> {
  WalletViewModel walletViewModel = WalletViewModel();

  @override
  void initState() {
    super.initState();
    walletViewModel.getRechargesHistory(widget.wallet['currency'], context);
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppTexts.titleText("Recharges"),
            ),
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
                        const Icon(Icons.wallet, size: 23,),
                        const SizedBox(width: 5,),
                        AppTexts.cardTitle("${widget.wallet['balance']} ${widget.wallet['currency']}")
                      ],
                    ),
                  ],
                )
            ),
            const SizedBox(height: 20,),
            Expanded(child: ChangeNotifierProvider<WalletViewModel>(
                create: (BuildContext context) => walletViewModel,
                child: Consumer<WalletViewModel>(
                    builder: (context, value, _){
                      switch (value.rechargesList.status) {
                        case Status.LOADING:
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CupertinoActivityIndicator(color: Colors.black,),
                            ),
                          );
                        case Status.ERROR:
                          return Center(
                            child: Text(value.rechargesList.message.toString()),
                          );
                        default:
                          if (value.rechargesList.data!.length == 0) {
                            return Center(
                              child: AppTexts.descriptionText("Empty"),
                            );
                          }

                          List recharges = value.rechargesList.data!;
                          return ListView.builder(
                            itemCount: value.rechargesList.data!.length,
                            itemBuilder: (context, index) {
                              Map recharge = recharges[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Container(
                                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                                          color: AppColors.bgColor,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:  [
                                              const SizedBox(height: 20,),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: AppColors.formFieldColor
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                child: AppTexts.smallText(recharge['status_description'].toString(), color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange: (recharge['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green)),
                                              ),
                                              const SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Montant"),
                                                  AppTexts.bodyText("${recharge['amount']} ${recharge['currency']}", bold: true),
                                                ],
                                              ),
                                              Divider(color: AppColors.formFieldColor,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Date"),
                                                  AppTexts.bodyText(recharge['date'], bold: true),
                                                ],
                                              ),
                                              Divider(color: AppColors.formFieldColor,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Devise"),
                                                  AppTexts.bodyText(recharge['currency_label'], bold: true),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              if (recharge['lien_paiement'] != null)
                                              RoundedButton(
                                                  onPress: () async {
                                                    String url = recharge['lien_paiement'];
                                                    var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                                    if(urllaunchable){
                                                      await launch(url); //launch is from url_launcher package to launch URL
                                                      Navigator.pushNamed(context,RoutesName.walletHome);
                                                    }else{
                                                      Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
                                                    }
                                                  },
                                                  color: AppColors.buttonBlackColor,
                                                  title: "Recharger",
                                                  icon: CupertinoIcons.arrow_down_left
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                    );
                                  },
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
                                                const Icon(CupertinoIcons.arrow_down_left, color: Colors.green, size: 25,),
                                                const SizedBox(width: 10,),
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:  [
                                                    Row(
                                                      children: [
                                                        AppTexts.bodyText("${recharge['amount']} ${recharge['currency']}", color: AppColors.buttonBlackColor, bold: true),
                                                      ],
                                                    ),
                                                    AppTexts.smallText(recharge['date'], color: AppColors.buttonBlackColor.withOpacity(.5)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange.withOpacity(.1): (recharge['status_description'].toString().contains("Echoué") ? Colors.red.withOpacity(.1) : Colors.green.withOpacity(.1))
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                              child: AppTexts.smallText(recharge['status_description'], color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange: (recharge['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green)),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    })
            ))
          ],
        ),
      ),
    );
  }
}