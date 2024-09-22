import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateWalletView extends StatefulWidget {
  CreateWalletView({Key? key}) : super(key: key);

  @override
  State<CreateWalletView> createState() => _CreateWalletViewState();
}

class _CreateWalletViewState extends State<CreateWalletView> {
  WalletViewModel walletViewModel = WalletViewModel();
  final TextEditingController _amountController = TextEditingController();
  Map selectedCurrency = {};

  @override
  void initState() {
    super.initState();
    walletViewModel.getCurrencies(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formFieldColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: HideKeyBordContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                context: context,
                backArrow: true
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Créer un wallet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text("Pour quelle devise voulez-vous créer le wallet ?", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black45), textAlign: TextAlign.left,),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Séléctionnez la devise", style: TextStyle(
                                        fontWeight: FontWeight.w600
                                    ),),
                                    const SizedBox(height: 20,),
                                    if (walletViewModel.currencies.data == null)
                                      const Row(
                                        children: [
                                          Text("Loading"),
                                        ],
                                      ),
                                    if (walletViewModel.currencies.data != null)
                                      Expanded(child: ListView.builder(
                                      itemCount: walletViewModel.currencies.data!.length,
                                      itemBuilder: (context, index) {
                                        Map currency = walletViewModel.currencies.data![index];
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedCurrency = currency;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                              ),
                                              child: Row(
                                                children: [
                                                  Text("${currency["currency_label"]} (${currency["currency"]})", style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold
                                                  ),)
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    ))
                                  ],
                                )
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedCurrency.isEmpty ? "Choisir la dévise" : "${selectedCurrency['currency_label']} (${selectedCurrency['currency']})", style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),),
                            const Icon(Icons.wallet, size: 20,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    RoundedButton(
                      title: "Valider",
                      loading: walletViewModel.loading,
                      onPress: () async {
                        if (selectedCurrency.isEmpty) {
                          Utils.flushBarErrorMessage("Vous devez séléctionner une dévise", context);
                        } else {
                          await walletViewModel.createWallet({
                            "currency": selectedCurrency["currency"]
                          }, context);
                        }
                      }
                    )
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