import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Affiche le dialogue de saisie du code PIN wallet.
/// [onSubmit] est appelé avec le PIN ; fermer le dialogue après succès si besoin.
Future<void> showWalletPinDialog(
  BuildContext context, {
  required Future<void> Function(String pin) onSubmit,
}) {
  final pinViewModel = PinViewModel();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      String? pin;
      bool loading = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: AppColors.bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.buttonBlackColor, size: 60),
                  AppTexts.titleText(AppLocalizations.of(context)!.translate("PIN_code")),
                  AppTexts.descriptionText(
                    AppLocalizations.of(context)!.translate("wallet_transactions_protected_by_pin"),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => pinViewModel.resetPin(context),
                        child: AppTexts.bodyText("Code PIN oublié ?", bold: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    length: 5,
                    obscureText: true,
                    animationType: AnimationType.fade,
                    animationDuration: const Duration(milliseconds: 300),
                    keyboardType: TextInputType.number,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    cursorColor: Colors.black,
                    showCursor: true,
                    enabled: !loading,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      errorBorderColor: Colors.black45,
                      inactiveColor: AppColors.formFieldBorderColor,
                      activeColor: AppColors.textGrey,
                      selectedColor: AppColors.textGrey,
                    ),
                    onChanged: (value) => pin = value,
                    appContext: context,
                  ),
                  if (!loading)
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton(
                            title: AppLocalizations.of(context)!.translate("validate"),
                            onPress: () async {
                              if (pin == null || pin!.isEmpty) {
                                Utils.flushBarErrorMessage(
                                  AppLocalizations.of(context)!.translate("enter_pin"),
                                  context,
                                );
                                return;
                              }
                              setDialogState(() => loading = true);
                              try {
                                await onSubmit(pin!);
                              } finally {
                                if (context.mounted) {
                                  setDialogState(() => loading = false);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
