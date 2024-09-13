import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_colors.dart';
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
      backgroundColor: AppColors.formFieldColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
                context: context,
                backArrow: true
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Transferts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1),
                      top: BorderSide(color: AppColors.formFieldBorderColor, width: 1),
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.wallet, size: 15,),
                        const SizedBox(width: 10,),
                        Text(widget.wallet['balance'] + " " + widget.wallet['currency'], style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500
                        ),)
                      ],
                    ),
                    // Text("(3)", style: TextStyle(
                    //     fontWeight: FontWeight.bold
                    // ),)
                  ],
                )
            ),
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
                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.black, width: 1)
                                    )
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Devise", style: TextStyle(
                                              fontSize: 11
                                          ),),
                                          Text(transfer['currency_label'], style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Date", style: TextStyle(
                                              fontSize: 11
                                          ),),
                                          Text(transfer['date'], style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Montant", style: TextStyle(
                                              fontSize: 11
                                          ),),
                                          Text("${transfer['amount']} ${transfer['currency']}", style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor
                                          ),),
                                        ],
                                      ),
                                      // const SizedBox(height: 5,),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(transfer['status_description'], style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),),
                                      //   ],
                                      // ),
                                    ],
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