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

class TransfersHistoryView extends StatefulWidget {
  Map wallet;
  TransfersHistoryView({required this.wallet, Key? key}) : super(key: key);

  @override
  State<TransfersHistoryView> createState() => _TransfersHistoryViewState();
}

class _TransfersHistoryViewState extends State<TransfersHistoryView> {
  WalletViewModel walletViewModel = WalletViewModel();

  @override
  void initState() {
    super.initState();
    walletViewModel.getTransfersHistory(widget.wallet['currency'], context);
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
              child: AppTexts.titleText("Transferts"),
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
                      switch (value.transfersList.status) {
                        case Status.LOADING:
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CupertinoActivityIndicator(color: Colors.black,),
                            ),
                          );
                        case Status.ERROR:
                          return Center(
                            child: Text(value.transfersList.message.toString()),
                          );
                        default:
                          if (value.transfersList.data!.length == 0) {
                            return Center(
                              child: Text(
                                "Empty",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.2),
                                ),
                              ),
                            );
                          }

                          List transfers = value.transfersList.data!;
                          return ListView.builder(
                            itemCount: value.transfersList.data!.length,
                            itemBuilder: (context, index) {
                              Map transfer = transfers[index];
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Montant"),
                                                  AppTexts.bodyText("${transfer['amount']} ${transfer['currency']}", bold: true),
                                                ],
                                              ),
                                              Divider(color: AppColors.formFieldColor,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Date"),
                                                  AppTexts.bodyText(transfer['date'], bold: true),
                                                ],
                                              ),
                                              Divider(color: AppColors.formFieldColor,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Devise"),
                                                  AppTexts.bodyText(transfer['currency_label'], bold: true),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              if (transfer['lien_paiement'] != null)
                                                RoundedButton(
                                                    onPress: () async {
                                                      String url = transfer['lien_paiement'];
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
                                                const Icon(CupertinoIcons.arrow_up_right, color: Colors.red, size: 25,),
                                                const SizedBox(width: 10,),
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:  [
                                                    Row(
                                                      children: [
                                                        AppTexts.bodyText("${transfer['amount']} ${transfer['currency']}", color: AppColors.buttonBlackColor, bold: true),
                                                      ],
                                                    ),
                                                    AppTexts.smallText(transfer['date'], color: AppColors.buttonBlackColor.withOpacity(.5)),
                                                  ],
                                                ),
                                              ],
                                            ),
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