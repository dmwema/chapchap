import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/l10n/app_localizations.dart';

class ConfirmDesrchive extends StatelessWidget {
  final int recipientId;
  final DemandesViewModel demandesViewModel;

  const ConfirmDesrchive({
    Key? key,
    required this.recipientId,
    required this.demandesViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: Colors.black54,
            size: 50,
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                t.translate("confirm_desarchive_title"),
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                onPress: () {
                  demandesViewModel.desarchiveRecipient(context, recipientId);
                },
                title: t.translate("desarchive"),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  child: Text(
                    t.translate("cancel"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
