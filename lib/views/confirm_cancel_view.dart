import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';

import '../data/response/status.dart';
import '../utils/utils.dart';

class ConfirmCancelView extends StatefulWidget {
  final int demandeId;
  final DemandesViewModel demandesViewModel;

  const ConfirmCancelView({Key? key, required this.demandeId, required this.demandesViewModel}) : super(key: key);

  @override
  State<ConfirmCancelView> createState() => _ConfirmCancelViewState();
}

class _ConfirmCancelViewState extends State<ConfirmCancelView> {
  final TextEditingController _motifController = TextEditingController();
  int? selectedModeRemboursement;

  @override
  void initState() {
    super.initState();
    widget.demandesViewModel.modeRemboursements({}, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.black54,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate('confirm_cancel_title')),
            const SizedBox(height: 20),
            TextField(
              controller: _motifController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('reason_label'),
                labelText: AppLocalizations.of(context).translate('reason_label'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate('choose_refund_method')),
            const SizedBox(height: 10),
            ChangeNotifierProvider<DemandesViewModel>(
              create: (context) => widget.demandesViewModel,
              child: Consumer<DemandesViewModel>(
                builder: (context, value, _) {
                  switch (value.modeRemboursementList.status) {
                    case Status.LOADING:
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CupertinoActivityIndicator(color: Colors.black45),
                        ),
                      );
                    case Status.ERROR:
                      return Center(
                        child: Text(value.modeRemboursementList.message.toString()),
                      );
                    default:
                      List<dynamic> modeRemboursements = value.modeRemboursementList.data!;
                      if (modeRemboursements.isNotEmpty && selectedModeRemboursement == null) {
                        selectedModeRemboursement = modeRemboursements[0]['id_mode_remboursement'];
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: modeRemboursements.length,
                          itemBuilder: (context, index) {
                            Map modeRemboursement = modeRemboursements[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedModeRemboursement = modeRemboursement["id_mode_remboursement"];
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: (selectedModeRemboursement != null &&
                                      modeRemboursement["id_mode_remboursement"] == selectedModeRemboursement)
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  border: (selectedModeRemboursement != null &&
                                      selectedModeRemboursement == modeRemboursement["id_mode_remboursement"])
                                      ? null
                                      : Border.all(width: 1, color: AppColors.formFieldBorderColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: (selectedModeRemboursement != null &&
                                            selectedModeRemboursement == modeRemboursement["id_mode_remboursement"])
                                            ? null
                                            : Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: (selectedModeRemboursement != null &&
                                                selectedModeRemboursement == modeRemboursement["id_mode_remboursement"])
                                                ? AppColors.primaryColor
                                                : null,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(modeRemboursement["mode_remboursement"]),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
            RoundedButton(
              onPress: () {
                if (_motifController.text.isEmpty) {
                  Utils.flushBarErrorMessage(AppLocalizations.of(context).translate('enter_reason'), context);
                } else if (selectedModeRemboursement == null) {
                  Utils.flushBarErrorMessage(AppLocalizations.of(context).translate('select_refund_method'), context);
                } else {
                  Map data = {
                    "idDemande": widget.demandeId,
                    "id_mode_remboursement": selectedModeRemboursement,
                    "motif": _motifController.text,
                  };
                  widget.demandesViewModel.cancelSend(context, data);
                }
              },
              title: AppLocalizations.of(context).translate('confirm_button'),
            ),
            const SizedBox(height: 10),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
                child: Text(
                  AppLocalizations.of(context).translate('cancel_button'),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
