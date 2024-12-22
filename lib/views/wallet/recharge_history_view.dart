import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
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
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChangeNotifierProvider<WalletViewModel>(
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
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: commonRoundedContainer(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        AppTexts.smallText(recharge['date']),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppTexts.smallText("Devise"),
                                            AppTexts.bodyText(recharge['currency_label'], bold: true),
                                          ],
                                        ),
                                        Divider(color: AppColors.bgColor,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppTexts.smallText("Montant"),
                                            AppTexts.bodyText("${recharge['amount']} ${recharge['currency']}", bold: true),
                                          ],
                                        ),
                                        Divider(color: AppColors.bgColor,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.history, color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange: (recharge['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green), size: 20,),
                                                const SizedBox(width: 5,),
                                                AppTexts.smallText(recharge['status_description'], color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange: (recharge['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green))
                                              ],
                                            ),
                                            // if (recharge['lien_paiement'] != null)
                                              InkWell(
                                                onTap: () async {
                                                  String url = recharge['lien_paiement'];
                                                  var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                                  if(urllaunchable){
                                                    await launch(url); //launch is from url_launcher package to launch URL
                                                    Navigator.pushNamed(context,RoutesName.walletHome);
                                                  }else{
                                                    Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primaryColor,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  child: AppTexts.buttonText("Recharger", color: Colors.white),
                                                ),
                                              )
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                );
                              },
                            );
                        }
                      })
              ),
            ))
          ],
        ),
      ),
    );
  }
}