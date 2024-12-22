import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChangeNotifierProvider<WalletViewModel>(
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
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: commonRoundedContainer(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:  [
                                          AppTexts.smallText(transfer['date']),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppTexts.smallText("Devise"),
                                              AppTexts.bodyText(transfer['currency_label'], bold: true),
                                            ],
                                          ),
                                          Divider(color: AppColors.bgColor,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppTexts.smallText("Montant"),
                                              AppTexts.bodyText("${transfer['amount']} ${transfer['currency']}", bold: true),
                                            ],
                                          ),
                                          if (transfer['status_description'] != null)
                                          Divider(color: AppColors.bgColor,),
                                          if (transfer['status_description'] != null)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.history, color: transfer['status_description'].toString().contains("En cours") || transfer['status_description'].toString().contains("En attente") ? Colors.orange: (transfer['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green), size: 20,),
                                                  const SizedBox(width: 5,),
                                                  AppTexts.smallText(transfer['status_description'], color: transfer['status_description'].toString().contains("En cours") || transfer['status_description'].toString().contains("En attente") ? Colors.orange: (transfer['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green))
                                                ],
                                              ),
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