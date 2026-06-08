import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/mode_remboursement_model.dart';
import 'package:chapchap/model/motif_annulation_model.dart';
import 'package:chapchap/model/motif_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmCancel extends StatefulWidget {
  final int demandeId;
  final DemandesViewModel demandesViewModel;
  final bool paid;

  const ConfirmCancel({super.key, required this.demandeId, required this.demandesViewModel, this.paid = false});

  @override
  State<ConfirmCancel> createState() => _ConfirmCancelState();
}

class _ConfirmCancelState extends State<ConfirmCancel> {
  final TextEditingController _motifController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();
  DemandesViewModel demandesViewModel2 = DemandesViewModel();

  List<MotifAnnulationModel> motifs = [];
  List<ModeRemboursementModel> modeRemboursements = [];

  MotifAnnulationModel? selectedMotif;
  ModeRemboursementModel? selectedModeRemboursement;

  bool loadingModeRemboursement = true;
  bool loadingMotif = true;

  @override
  void initState() {
    super.initState();
    if (widget.paid) {
      demandesViewModel.modeRemboursements({
        "demande_id": widget.demandeId
      }, context).then((value) {
        setState(() {
          modeRemboursements = value;
          loadingModeRemboursement = false;
        });
      });
    } else {
      setState(() {
        loadingModeRemboursement = false;
      });
    }
    demandesViewModel2.motifsAnnulation([], context).then((value) {
      setState(() {
        motifs = value;
        loadingMotif = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    if (loadingModeRemboursement || loadingMotif) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(color: Colors.black45),
          ],
        ),
      );
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),
            Column(
              children: [
                AppTexts.titleText(localizations!.translate('confirm_cancel_title') ?? "Voulez-vous vraiment faire une demande d'annulation de ce transfert ?", small: true),
                Divider(color: AppColors.formFieldBorderColor,),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 18,),
                    const SizedBox(width: 5,),
                    // Affichage de l'avertissement avec traduction
                    AppTexts.smallText(localizations.translate('cancellation_fee_warning') ?? "Des frais d'annulation pourraient s'appliquer."),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppTexts.descriptionText(localizations.translate('motif_label')),
                const SizedBox(width: 5,),
                AppTexts.bodyText("*", bold: true, color: Colors.red),
              ],
            ),
            const SizedBox(height: 5,),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.bgColor,
                  isScrollControlled: true,
                  builder: (context) {
                    TextEditingController searchController = TextEditingController();
                    List<MotifAnnulationModel> filteredMotifs = List.from(motifs);

                    return StatefulBuilder(
                      builder: (context, setStateModal) {
                        void filterMotifs(String query) {
                          setStateModal(() {
                            filteredMotifs = motifs
                                .where((r) => r.motifAnnulation.toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                                .toList();
                          });
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppTexts.titleText(AppLocalizations.of(context).translate('motif_label'), small: true),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: searchController,
                                  onChanged: filterMotifs,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).translate('search'),
                                    prefixIcon: const Icon(Icons.search),
                                    filled: true,
                                    fillColor: AppColors.formFieldColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                      BorderSide(color: AppColors.formFieldBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(
                                  child: filteredMotifs.isEmpty
                                      ? Center(
                                    child: AppTexts.bodyText(
                                      AppLocalizations.of(context).translate('emptyList'),
                                      color: AppColors.textGrey,
                                    ),
                                  )
                                      : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredMotifs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedMotif =
                                            filteredMotifs[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: AppColors.lightGrey,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(40),
                                                  border: Border.all(
                                                    width: 5,
                                                    color: selectedMotif !=
                                                        null &&
                                                        selectedMotif!
                                                            .idMotifAnnulation ==
                                                            filteredMotifs[
                                                            index].idMotifAnnulation
                                                        ? AppColors.primaryColor
                                                        : AppColors
                                                        .formFieldBorderColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              AppTexts.bodyText(
                                                filteredMotifs[index]
                                                    .motifAnnulation.toString(),
                                                color: AppColors.textGrey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(0),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: AppColors.formFieldColor,
                  border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectedMotif == null
                        ? AppTexts.cardTitle(AppLocalizations.of(context).translate('motif_label'), bold: false)
                        : AppTexts.bodyText(selectedMotif!.motifAnnulation.toString()),
                    const Icon(Icons.arrow_drop_down_sharp),
                  ],
                ),
              ),
            ),
            if (widget.paid)
              ...[
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppTexts.cardTitle(localizations.translate('refund_method')),
                    const SizedBox(width: 5,),
                    AppTexts.bodyText("*", bold: true, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 5,),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.bgColor,
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setStateModal) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppTexts.titleText(AppLocalizations.of(context).translate('choose_refund_method'), small: true),
                                    const SizedBox(height: 10),
                                    Flexible(
                                      child: modeRemboursements.isEmpty
                                          ? Center(
                                        child: AppTexts.bodyText(
                                          AppLocalizations.of(context).translate('emptyList'),
                                          color: AppColors.textGrey,
                                        ),
                                      )
                                          : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: modeRemboursements.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedModeRemboursement =
                                                modeRemboursements[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    width: 1,
                                                    color: AppColors.lightGrey,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(40),
                                                      border: Border.all(
                                                        width: 5,
                                                        color: selectedModeRemboursement !=
                                                            null &&
                                                            selectedModeRemboursement!
                                                                .idModeRemboursement ==
                                                                modeRemboursements[index].idModeRemboursement
                                                            ? AppColors.primaryColor
                                                            : AppColors
                                                            .formFieldBorderColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  AppTexts.bodyText(
                                                    modeRemboursements[index]
                                                        .modeRemboursement.toString(),
                                                    color: AppColors.textGrey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: AppColors.formFieldColor,
                      border: Border.all(
                          color: AppColors.formFieldBorderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedModeRemboursement == null
                            ? AppTexts.cardTitle(AppLocalizations.of(context).translate('refund_method'), bold: false)
                            : AppTexts.bodyText(selectedModeRemboursement!.modeRemboursement.toString()),
                        const Icon(Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ),
                ),
              ],
            const SizedBox(height: 20,),
            RoundedButton(
              onPress: () {
                if (selectedMotif == null) {
                  Utils.flushBarErrorMessage(localizations.translate('enter_reason') ?? "Vous devez saisir le motif de l'annulation", context);
                } else if (widget.paid && selectedModeRemboursement == null) {
                  Utils.flushBarErrorMessage(localizations.translate('select_refund_method') ?? "Vous devez sélectionner la méthode de remboursement", context);
                } else {
                  Map data = {
                    "idDemande": widget.demandeId,
                    "id_motif_annlation": selectedMotif!.idMotifAnnulation,
                    "motif": _motifController.text
                  };

                  if (widget.paid) {
                    data["id_mode_remboursement"] = selectedModeRemboursement!.idModeRemboursement;
                  }

                  widget.demandesViewModel.cancelSend(context, data);
                }
              },
              title: localizations.translate('confirm') ?? "Confirmer",
            ),
            const SizedBox(height: 10,),
            RoundedButton(
              onPress: () {
                Navigator.pop(context);
              },
              color: AppColors.buttonBlackColor,
              title: localizations.translate('cancel') ?? "Annuler",
            ),
          ],
        ),
      ),
    );
  }
}
