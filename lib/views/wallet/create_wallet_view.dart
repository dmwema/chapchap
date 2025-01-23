import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/custom_field.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/wallet_view_model.dart';
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
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: HideKeyBordContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText("Créer un wallet"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    AppTexts.descriptionText("Pour quelle devise voulez-vous créer le wallet ?"),
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
                                    AppTexts.buttonText("Séléctionnez la devise"),
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
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.formFieldColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTexts.buttonText(selectedCurrency.isEmpty ? "Choisir la dévise" : "${selectedCurrency['currency_label']} (${selectedCurrency['currency']})"),
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