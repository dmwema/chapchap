import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/recipient_card2.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendConfirmView extends StatefulWidget {
  Map data;
  SendConfirmView({Key? key, required this.data}) : super(key: key);

  @override
  State<SendConfirmView> createState() => _SendConfirmViewState();
}

class _SendConfirmViewState extends State<SendConfirmView> {
  bool loading = false;
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CommonAppBar(context: context, backArrow: true, title: "Confirmation",),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  pageTitleStyle(title: "Voyons si tout est correct !", context: context),
                  const SizedBox(height: 20,),
                  AppTexts.cardTitle("Montant", color: Colors.black),
                  const SizedBox(height: 8,),
                  commonRoundedContainer(
                    removePaddingAll: true,
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTexts.smallText("Vous envoyez"),
                                AppTexts.bodyText("${double.parse(widget.data['montant_srce'].toString()).toStringAsFixed(2)} ${widget.data['destination']!.paysCodeMonnaieSrce}", bold: true),
                              ],
                            )
                        ),
                        commonDivider(),
                        Container(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTexts.smallText("Elle réçoit"),
                                AppTexts.bodyText("${double.parse(widget.data['montant_dest'].toString()).toStringAsFixed(2)} ${widget.data['selected_destination']!.paysCodeMonnaieDest}", bold: true),
                              ],
                            )
                        ),
                        commonDivider(),
                        Container(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTexts.cardDescription("Frais de transfert"),
                                AppTexts.cardDescription("${double.parse(widget.data['taux'].toString()).toStringAsFixed(2)} ${widget.data['destination']!.paysCodeMonnaieSrce}"),
                              ],
                            )
                        ),
                        commonDivider(),
                        if (widget.data['promo_rabais'] > 0)
                          Container(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AppTexts.cardTitle("Rabais promo"),
                                  AppTexts.cardTitle("${widget.data['promo_rabais']} ${widget.data['destination']!.paysCodeMonnaieSrce}"),
                                ],
                              )
                          ),
                        if (widget.data['promo_rabais'] > 0)
                          commonDivider(),
                        Container(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTexts.smallText("Total à payer", color: AppColors.primaryColor),
                              AppTexts.titleText("${widget.data['promo_rabais'] > 0 ? (double.parse(widget.data['montant_srce']) - widget.data['promo_rabais'] + widget.data['taux']).toStringAsFixed(2) : (double.parse(widget.data['taux'].toString()) + double.parse(widget.data['montant_srce'].toString())).toStringAsFixed(2)} ${widget.data['destination']!.paysCodeMonnaieSrce}", color: AppColors.primaryColor),
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  AppTexts.cardTitle("Bénéficiaire", color: Colors.black),
                  const SizedBox(height: 8,),
                  Container(
                      child: RecipientCard2(name: widget.data['beneficiaire'].nomBeneficiaire, address: "", phone: widget.data['beneficiaire'].telBeneficiaire)
                  ),
                  const SizedBox(height: 10,),
                  AppTexts.cardTitle("Mode de retrait", color: Colors.black),
                  const SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: commonRoundedContainer(
                      child: Row(
                        children: [
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(width: 5,
                                    color: AppColors.accentColor)
                            ),
                          ),
                          const SizedBox(width: 10,),
                          AppTexts.bodyText(widget.data['mode_retrait'].modeRetrait, bold: true, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  AppTexts.cardTitle("Destination", color: Colors.black),
                  const SizedBox(height: 8,),
                  const SizedBox(height: 8,),
                  commonRoundedContainer(
                    removePaddingAll: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppTexts.bodyText(widget.data['selected_destination'].codePaysDest.toString().toUpperCase(), bold: true),
                          Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.accentColor,
                                border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
                                image: DecorationImage(
                                    image: AssetImage("packages/country_icons/icons/flags/png/${widget.data['destination'].codePaysSrce}.png"),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          Image.asset("assets/line.png"),
                          Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.accentColor,
                              border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
                              image: DecorationImage(
                                image: AssetImage("packages/country_icons/icons/flags/png/${widget.data['selected_destination'].codePaysDest}.png"),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                          AppTexts.bodyText(widget.data['destination'].codePaysSrce.toString().toUpperCase(), bold: true),
                        ],
                      ),
                    )
                  ),
                  const SizedBox(height: 20,),
                  RoundedButton(
                    onPress: () {
                      setState(() {
                        loading = true;
                      });
                      Map localData = {
                        "idBeneficiaire": widget.data["idBeneficiaire"],
                        "codePromo": widget.data["codePromo"],
                        "code_pays_srce": widget.data["code_pays_srce"],
                        "montant_srce": widget.data["montant_srce"],
                        "montant_dest": widget.data["montant_dest"],
                        "code_pays_dest": widget.data["code_pays_dest"],
                        "id_mode_retrait": widget.data["id_mode_retrait"],
                      };
                      demandesViewModel.transfert(localData, context).then((value) {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    title: "confirmer et envoyer",
                    loading: loading,
                  )
                ],
              ),
            ),
                      ),
        ),
      ),
    );
  }

  bool isDouble(String value) {
    final doubleNumber = double.tryParse(value);
    return doubleNumber != null;
  }

}