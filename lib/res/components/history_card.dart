import 'dart:developer' as developer;

import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/confirm_cancel.dart';
import 'package:chapchap/res/components/modal/change_beneficiaire_modal.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/res/components/wallet_pin_dialog.dart';
import 'package:chapchap/utils/repeat_transfer_helper.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/payment_webview.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryCard extends StatefulWidget {
  DemandeModel demande;
  bool? hasProblem;

  HistoryCard({super.key, required this.demande, this.hasProblem});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {

  Future<void> _startRepeatTransfer(BuildContext sheetContext, DemandeModel demande) async {
    if (user == null || !mounted) {
      developer.log('abort: user null or widget unmounted', name: 'RepeatTransfer');
      return;
    }

    developer.log('start repeat transfer demande=${demande.idDemande}', name: 'RepeatTransfer');
    RepeatTransferHelper.showLoadingDialog(context);

    RepeatTransferResult result;
    try {
      result = await RepeatTransferHelper.resolve(context: context, demande: demande);
    } catch (error, stackTrace) {
      developer.log(
        'resolve threw in history_card',
        name: 'RepeatTransfer',
        error: error,
        stackTrace: stackTrace,
      );
      result = RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
    } finally {
      if (mounted) {
        RepeatTransferHelper.hideLoadingDialog(context);
      }
    }

    if (!mounted) {
      developer.log('widget unmounted after resolve', name: 'RepeatTransfer');
      return;
    }

    if (!result.isSuccess) {
      developer.log('resolve failed: ${result.failure}', name: 'RepeatTransfer');
      final failure = result.failure!;
      if (failure == RepeatTransferFailure.beneficiaryNotFound ||
          failure == RepeatTransferFailure.beneficiaryArchived ||
          failure == RepeatTransferFailure.missingBeneficiary) {
        Navigator.pop(sheetContext);
        RepeatTransferHelper.openSendViewForMissingBeneficiary(
          context: context,
          demande: demande,
          failure: failure,
        );
        return;
      }

      RepeatTransferHelper.showFailureDialog(
        context,
        RepeatTransferHelper.failureMessage(context, failure),
      );
      return;
    }

    developer.log('resolve success, opening SendView confirmation', name: 'RepeatTransfer');
    final prefill = result.prefill!;
    Navigator.pop(sheetContext);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendView(
          beneficiaire: prefill.beneficiaire,
          destination: demande.codePaysDest,
          selectedDestination: prefill.destination,
          paysDestination: prefill.paysDestination,
          modeRetrait: prefill.modeRetrait,
          motif: prefill.motif,
          amount: prefill.amount,
          repeatFromHistory: true,
          repeatTransferValidated: true,
          prefilledBeneficiaires: prefill.beneficiaires,
          prefilledMotifs: prefill.motifs,
        ),
      ),
    );
  }

  UserModel? user;

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DemandeModel demande = widget.demande;
    bool? hasProblem = widget.hasProblem;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
                color: AppColors.bgColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const SizedBox(height: 20,),
                    if (demande.probleme != null && demande.probleme != "")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.formFieldBorderColor
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: AppTexts.descriptionText(demande.probleme.toString()),
                            ),
                          ),
                        ],
                      ),
                    if (demande.probleme != null && demande.probleme != "")
                    const SizedBox(height: 10,),
                    if (demande.progression != null)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.formFieldColor
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: AppTexts.smallText(
                          demande.progression.toString(),
                          color: demande.statutDemande == Utils.demandeStatusCompleted ?
                            Colors.green: (
                              demande.statutDemande == Utils.demandeStatusPending ?
                              Colors.orange: (demande.statutDemande == Utils.demandeStatusProcessing ? Colors.blue : Colors.red))),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('transaction_id')),  // Traduction dynamique
                        AppTexts.bodyText("#${demande.idDemande}", bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('date')),  // Traduction dynamique
                        AppTexts.bodyText(demande.date.toString(), bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('sourceAmount')),  // Traduction dynamique
                        AppTexts.bodyText("${demande.montantSansFrais} ${demande.paysCodeMonnaieSrce}", bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('transfer_fees')),  // Traduction dynamique
                        AppTexts.bodyText("${demande.fees} ${demande.paysCodeMonnaieSrce}", bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('sent_amount'), color: AppColors.primaryColor),  // Traduction dynamique
                        AppTexts.bodyText("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", bold: true, color: AppColors.primaryColor),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('amount_to_receive')),  // Traduction dynamique
                        AppTexts.bodyText("${demande.montanceDest} ${demande.paysCodeMonnaieDest}", bold: true),
                      ],
                    ),
                    if (demande.rabaisPromo != null && demande.rabaisPromo!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('promotional_discount')),  // Traduction dynamique
                        AppTexts.bodyText("${demande.montanceDest} ${demande.rabaisPromo}", bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('withdrawal_mode')),  // Traduction dynamique
                        AppTexts.bodyText("${demande.modeRetrait?.modeRetrait}", bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('direction')),  // Traduction dynamique
                        AppTexts.bodyText("${demande.paysSrce} vers ${demande.paysDest}", bold: true),
                      ],
                    ),
                    Divider(color: AppColors.formFieldColor,),
                    if (demande.beneficiaire != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText(AppLocalizations.of(context).translate('beneficiary')),
                          AppTexts.bodyText(demande.beneficiaire!.fullName(), bold: true),
                        ],
                      ),
                      Divider(color: AppColors.formFieldColor,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText(AppLocalizations.of(context)!.translate('phone')),
                          AppTexts.bodyText(demande.beneficiaire!.telBeneficiaire.toString(), bold: true),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20,),
                    Wrap(
                      spacing: 1,
                      runSpacing: 1,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        if (demande.lienPaiement != null && demande.facture == null && hasProblem != true)
                          RoundedButton(
                              onPress: () async {
                                String url = demande.lienPaiement.toString();
                                if (demande.system.toString().toUpperCase() == "CHAPCHAP") {
                                  var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                  if(urllaunchable){
                                    await launch(url); //launch is from url_launcher package to launch URL
                                    Navigator.pushNamed(context,RoutesName.home);
                                  }else{
                                    Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentWebView(
                                        url: url,
                                      ),
                                    ),
                                  );
                                }
                              },
                              color: AppColors.buttonBlackColor,
                              title: "Payer",
                              icon: CupertinoIcons.creditcard
                          ),
                        if (demande.lienPaiement != null &&
                            demande.facture == null &&
                            hasProblem != true &&
                            user?.wallet == true)
                          RoundedButton(
                            onPress: () async {
                              final demandeId = demande.idDemande;
                              if (demandeId == null) return;
                              Navigator.pop(context);
                              await showWalletPinDialog(
                                context,
                                onSubmit: (pin) async {
                                  await DemandesViewModel().paidWithWallet(
                                    context,
                                    idDemande: demandeId,
                                    codePin: pin,
                                  );
                                },
                              );
                            },
                            color: AppColors.buttonBlackColor,
                            title: AppLocalizations.of(context).translate("with_wallet"),
                            icon: Icons.wallet_outlined,
                          ),
                        if (demande.lienPaiement != null && demande.facture == null && hasProblem != true)
                          const SizedBox(height: 5,),
                        if (hasProblem != true && user != null && demande.beneficiaire != null)
                          RoundedButton(
                            onPress: () => _startRepeatTransfer(context, demande),
                            color: AppColors.buttonBlackColor,
                            title: AppLocalizations.of(context)!.translate('new_transfer'),
                            icon: CupertinoIcons.arrow_up_right
                          ),
                        if (
                          demande.facture == null
                          && hasProblem != true
                        )
                          const SizedBox(height: 5,),
                        if (demande.statutDemande == Utils.demandeStatusPending || demande.statutDemande == Utils.demandeStatusProcessing)
                          RoundedButton(
                              onPress: () {
                                DemandesViewModel demandeViewModel = DemandesViewModel();
                                if (demande.isPaid == true) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: AppColors.bgColor,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return ConfirmCancel(demandeId: demande.idDemande!.toInt(), demandesViewModel: demandeViewModel, paid: true,);
                                        }
                                      );
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(0),
                                      ),
                                    ),
                                  );
                                } else {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: AppColors.bgColor,
                                    builder: (context) {
                                      return ConfirmCancel(demandeId: demande.idDemande!.toInt(), demandesViewModel: demandeViewModel);
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(0),
                                      ),
                                    ),
                                  );
                                }
                              },
                              color: AppColors.buttonBlackColor,
                              title: "Annuler la demande",
                              icon: CupertinoIcons.xmark_circle
                          ),
                        if (hasProblem == true)
                          RoundedButton(
                              onPress: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: AppColors.bgColor,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(0),
                                      ),
                                    ),
                                    builder: (context) {
                                      return ChangeBeneficiaireModal(demande: demande,);
                                    }
                                );
                              },
                              color: AppColors.buttonBlackColor,
                              title: "Changer de beneficiaire",
                              icon: CupertinoIcons.pencil
                          ),
                      ],
                    )
                  ],
                ),
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
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ]
            ),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: demande.statutDemande == Utils.demandeStatusCompleted
                              ? Colors.green.withOpacity(.1)
                              : (demande.statutDemande == Utils.demandeStatusPending
                              ? Colors.orange.withOpacity(.1)
                              : (demande.statutDemande == Utils.demandeStatusProcessing? Colors.blue.withOpacity(.1) : Colors.red.withOpacity(.2))),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Center(
                          child: demande.statutDemande == Utils.demandeStatusProcessing ?
                            Image.asset("assets/icons/processing.png", width: 20,)
                            : Icon(
                            demande.statutDemande == Utils.demandeStatusCompleted
                                ? CupertinoIcons.checkmark_alt
                                : (demande.statutDemande == Utils.demandeStatusPending
                                ? CupertinoIcons.refresh_thick
                                : (demande.statutDemande == Utils.demandeStatusProcessing ? CupertinoIcons.gear : CupertinoIcons.nosign)),
                            size: 20,
                            color: demande.statutDemande == Utils.demandeStatusCompleted
                                ? Colors.green
                                : (demande.statutDemande == Utils.demandeStatusPending
                                ? Colors.orange
                                : (demande.statutDemande == Utils.demandeStatusProcessing ? Colors.blue : Colors.red)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppTexts.cardTitle(
                              demande.beneficiaire?.fullName() ?? AppLocalizations.of(context)!.translate('beneficiary'),
                            ),
                            const SizedBox(height: 2),
                            AppTexts.cardDescription(demande.date.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.formFieldColor
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: AppTexts.bodyText("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", bold: true),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}