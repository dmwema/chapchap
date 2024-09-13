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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Recharger le wallet ${widget.wallet['currency']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text("Combien voulez-vous recharger ?", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black45), textAlign: TextAlign.left,),
                    const SizedBox(height: 20,),
                    CustomFormField(
                      label: "Montant",
                      hint: "Combien voulez-vous recharger ?",
                      controller: _amountController,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(widget.wallet['currency']),
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