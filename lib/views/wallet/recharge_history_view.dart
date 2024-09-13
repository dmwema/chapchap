import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_colors.dart';
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
              child: Text("Recharges", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
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
                              child: Text(
                                "Empty",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.2),
                                ),
                              ),
                            );
                          }

                          List recharges = value.rechargesList.data!;
                          return ListView.builder(
                            itemCount: value.rechargesList.data!.length,
                            itemBuilder: (context, index) {
                              Map recharge = recharges[index];
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
                                          Text(recharge['currency_label'], style: const TextStyle(
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
                                          Text(recharge['date'], style: const TextStyle(
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
                                          Text("${recharge['amount']} ${recharge['currency']}", style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor
                                          ),),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.history, color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange: (recharge['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green), size: 15,),
                                              const SizedBox(width: 5,),
                                              Text(recharge['status_description'], style: TextStyle(
                                                fontSize: 12,
                                                color: recharge['status_description'].toString().contains("En cours") || recharge['status_description'].toString().contains("En attente") ? Colors.orange: (recharge['status_description'].toString().contains("Echoué") ? Colors.red : Colors.green),
                                                fontWeight: FontWeight.bold,
                                              ),),
                                            ],
                                          ),
                                          if (recharge['lien_paiement'] != null)
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
                                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                                child: const Text("Payer", style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                                ),),
                                              ),
                                            )
                                        ],
                                      ),
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