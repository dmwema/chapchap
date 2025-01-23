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

class RechargeView extends StatefulWidget {
  Map wallet;
  RechargeView({required this.wallet, Key? key}) : super(key: key);

  @override
  State<RechargeView> createState() => _RechargeViewState();
}

class _RechargeViewState extends State<RechargeView> {
  WalletViewModel walletViewModel = WalletViewModel();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    walletViewModel.getRechargesHistory(widget.wallet['currency'], context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
      ),
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: HideKeyBordContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText("Recharger le wallet ${widget.wallet['currency']}"),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    AppTexts.descriptionText("Combien voulez-vous recharger ?"),
                    const SizedBox(height: 20,),
                    CustomFormField(
                      label: "Montant",
                      hint: "Montant",
                      controller: _amountController,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: AppTexts.cardTitle(widget.wallet['currency']),
                      ),
                      maxLines: 1,
                      type: TextInputType.number,
                    ),
                    const SizedBox(height: 20,),
                    RoundedButton(
                      title: "Valider",
                      loading: walletViewModel.loading,
                      onPress: () {
                        if (_amountController.text == "") {
                          Utils.flushBarErrorMessage("Vous devez entrer le montant", context);
                        } else {
                          Map data = {
                            "currency": widget.wallet['currency'],
                            "amount": _amountController.text
                          };
                          walletViewModel.rechargeWallet(data, context);
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