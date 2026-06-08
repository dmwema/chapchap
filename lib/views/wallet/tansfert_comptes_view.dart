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
import 'package:chapchap/l10n/app_localizations.dart';  // Importer les traductions

class TransferCompteWalletView extends StatefulWidget {
  TransferCompteWalletView({Key? key}) : super(key: key);

  @override
  State<TransferCompteWalletView> createState() => _TransferCompteWalletViewState();
}

class _TransferCompteWalletViewState extends State<TransferCompteWalletView> {
  WalletViewModel walletViewModel = WalletViewModel();
  final TextEditingController _amountController = TextEditingController();
  Map selectedSourceCurrency = {};
  Map selectedDestinationCurrency = {};

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
              //commonAppBar(
              //   context: context,
              //   backArrow: true
              //),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.translate('transferMoneyBetweenAccounts'), // Utilisation de la clé
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    CustomFormField(
                      label: AppLocalizations.of(context)!.translate('sourceAmount'), // Utilisation de la clé
                      hint: AppLocalizations.of(context)!.translate('sourceAmount'), // Utilisation de la clé
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(selectedSourceCurrency.isNotEmpty ? selectedSourceCurrency['currency'] : '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      type: TextInputType.number,
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      AppLocalizations.of(context)!.translate('source'), // Utilisation de la clé
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10,),
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
                                    Text(
                                      AppLocalizations.of(context)!.translate('selectSourceCurrency'), // Utilisation de la clé
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
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
                                                  selectedSourceCurrency = currency;
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
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedSourceCurrency.isEmpty
                                  ? AppLocalizations.of(context)!.translate('chooseSourceCurrency') // Utilisation de la clé
                                  : "${selectedSourceCurrency['currency_label']} (${selectedSourceCurrency['currency']})",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const Icon(Icons.wallet, size: 20,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      AppLocalizations.of(context)!.translate('destination'), // Utilisation de la clé
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10,),
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
                                    Text(
                                      AppLocalizations.of(context)!.translate('selectDestinationCurrency'), // Utilisation de la clé
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
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
                                                  selectedDestinationCurrency = currency;
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
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDestinationCurrency.isEmpty
                                  ? AppLocalizations.of(context)!.translate('chooseDestinationCurrency') // Utilisation de la clé
                                  : "${selectedDestinationCurrency['currency_label']} (${selectedDestinationCurrency['currency']})",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const Icon(Icons.wallet, size: 20,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    RoundedButton(
                        title: AppLocalizations.of(context)!.translate('validate'),  // Utilisation de la clé
                        loading: walletViewModel.loading,
                        onPress: () async {
                          // Action pour valider la transaction
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
