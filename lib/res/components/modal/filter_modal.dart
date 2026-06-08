import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/filters/history_filter.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/filters/history_filter_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterModal extends StatefulWidget {
  final DemandesViewModel demandesViewModel;
  final bool isInvoice;

  const FilterModal({super.key, required this.demandesViewModel, this.isInvoice = false});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  @override
  void initState() {
    super.initState();
    widget.demandesViewModel.beneficiaires({}, context);
    widget.demandesViewModel.myDestinationsApi({}, context);
  }

  void _showBeneficiaryModal(FilterViewModel filterVM, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgColor,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<BeneficiaireModel> filteredBeneficiaries = widget.demandesViewModel.beneficiairesList.data
            ?.map<BeneficiaireModel>((e) => BeneficiaireModel.fromJson(e))
            .toList() ?? [];

        return StatefulBuilder(
          builder: (context, setStateModal) {
            void filterBeneficiaries(String query) {
              setStateModal(() {
                filteredBeneficiaries = (widget.demandesViewModel.beneficiairesList.data
                    ?.map<BeneficiaireModel>((e) => BeneficiaireModel.fromJson(e))
                    .where((b) => b.fullName().toLowerCase().contains(query.toLowerCase()))
                    .toList()) ?? [];
              });
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTexts.titleText(t.translate('beneficiary')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: filterBeneficiaries,
                      decoration: InputDecoration(
                        hintText: t.translate('search'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: filteredBeneficiaries.isEmpty
                          ? AppTexts.bodyText(
                        t.translate('emptyList'),
                        color: AppColors.textGrey,
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredBeneficiaries.length,
                        itemBuilder: (context, index) {
                          final ben = filteredBeneficiaries[index];
                          return InkWell(
                            onTap: () {
                              filterVM.setBeneficiaire(ben.idBeneficiaire);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: AppColors.lightGrey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        width: 5,
                                        color: filterVM.filter.beneficiaireId == ben.idBeneficiaire
                                            ? AppColors.primaryColor
                                            : AppColors.formFieldBorderColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Icon(Icons.person, size: 20),
                                  const SizedBox(width: 5),
                                  AppTexts.bodyText(
                                    ben.fullName(),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
    );
  }

  void _showDestinationModal(FilterViewModel filterVM, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgColor,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<dynamic> filteredDestinations = widget.demandesViewModel.paysDestination.data?.destination ?? [];

        return StatefulBuilder(
          builder: (context, setStateModal) {
            void filterDestinations(String query) {
              setStateModal(() {
                filteredDestinations = (widget.demandesViewModel.paysDestination.data?.destination
                    ?.where((e) => e.paysDest.toString().toLowerCase().contains(query.toLowerCase()))
                    .toList()) ?? [];
              });
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTexts.titleText("Pays destination"),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: filterDestinations,
                      decoration: InputDecoration(
                        hintText: t.translate('search'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: filteredDestinations.isEmpty
                          ? AppTexts.bodyText(
                        t.translate('emptyList'),
                        color: AppColors.textGrey,
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredDestinations.length,
                        itemBuilder: (context, index) {
                          final dest = filteredDestinations[index];
                          return InkWell(
                            onTap: () {
                              filterVM.setDestination(dest.codePaysDest);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: AppColors.lightGrey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        width: 5,
                                        color: filterVM.filter.destinationPays == dest.codePaysDest
                                            ? AppColors.primaryColor
                                            : AppColors.formFieldBorderColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Image.asset(
                                      "packages/country_icons/icons/flags/png/${dest.codePaysDest}.png",
                                      width: 30,
                                      height: 15,
                                      fit: BoxFit.contain
                                  ),
                                  const SizedBox(width: 8),
                                  AppTexts.bodyText(
                                    dest.paysDest.toString(),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
    );
  }

  void _showStatusModal(FilterViewModel filterVM, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgColor,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<String> statuses = [
          Utils.demandeStatusPending,
          Utils.demandeStatusProcessing,
          Utils.demandeStatusCompleted,
          Utils.demandeStatusWarning,
          Utils.demandeStatusFailed
        ];
        List<String> filteredStatuses = List.from(statuses);

        return StatefulBuilder(
          builder: (context, setStateModal) {
            void filterStatuses(String query) {
              setStateModal(() {
                filteredStatuses = statuses
                    .where((s) => t.translate(s).toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTexts.titleText("Statut"),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: filterStatuses,
                      decoration: InputDecoration(
                        hintText: t.translate('search'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: filteredStatuses.isEmpty
                          ? AppTexts.bodyText(
                        t.translate('emptyList'),
                        color: AppColors.textGrey,
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredStatuses.length,
                        itemBuilder: (context, index) {
                          final s = filteredStatuses[index];
                          return InkWell(
                            onTap: () {
                              filterVM.setStatus(s);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: AppColors.lightGrey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        width: 5,
                                        color: filterVM.filter.statut == s
                                            ? AppColors.primaryColor
                                            : AppColors.formFieldBorderColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  s == Utils.demandeStatusProcessing
                                      ? Image.asset("assets/icons/processing.png", width: 20)
                                      : Icon(
                                    s == Utils.demandeStatusCompleted
                                        ? CupertinoIcons.checkmark_alt
                                        : (s == Utils.demandeStatusPending
                                        ? CupertinoIcons.refresh_thick
                                        : (s == Utils.demandeStatusProcessing
                                        ? CupertinoIcons.gear
                                        : CupertinoIcons.nosign)),
                                    size: 20,
                                    color: s == Utils.demandeStatusCompleted
                                        ? Colors.green
                                        : (s == Utils.demandeStatusPending
                                        ? Colors.orange
                                        : (s == Utils.demandeStatusProcessing
                                        ? Colors.blue
                                        : Colors.red)),
                                  ),
                                  const SizedBox(width: 8),
                                  AppTexts.bodyText(
                                    t.translate(s),
                                    color: s == Utils.demandeStatusCompleted
                                        ? Colors.green
                                        : (s == Utils.demandeStatusPending
                                        ? Colors.orange
                                        : (s == Utils.demandeStatusProcessing
                                        ? Colors.blue
                                        : Colors.red)),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterVM = Provider.of<FilterViewModel>(context);
    AppLocalizations t = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTexts.titleText(t.translate('search')),
                    if (filterVM.hasFilters)
                      InkWell(
                        onTap: () {
                          filterVM.filter = HistoryFilter();
                          filterVM.notifyListeners();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20,), const SizedBox(width: 8,),
                            AppTexts.descriptionText(t.translate("reset")),
                          ],
                        ),
                      )
                  ],
                ),

                const SizedBox(height: 20),

                _chipHeader("Date", filterVM.filter.dateRange != null, () => filterVM.removeFilter("date")),
                InkWell(
                  onTap: () async {
                    DateTimeRange? range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (range != null) filterVM.setDateRange(range);
                  },
                  child: _selectorBox(
                    filterVM.filter.dateRange == null
                        ? ""
                        : "${filterVM.filter.dateRange!.start.toString().split(' ')[0]} → ${filterVM.filter.dateRange!.end.toString().split(' ')[0]}",
                  ),
                ),

                const SizedBox(height: 10),

                _chipHeader(t.translate("beneficiary"), filterVM.filter.beneficiaireId != null,
                        () => filterVM.removeFilter("beneficiaire")),

                InkWell(
                  onTap: () => _showBeneficiaryModal(filterVM, t),
                  child: _selectorBox(
                    filterVM.filter.beneficiaireId == null
                        ? ""
                        : (widget.demandesViewModel.beneficiairesList.data
                        ?.map<BeneficiaireModel>((e) => BeneficiaireModel.fromJson(e))
                        .firstWhere(
                          (b) => b.idBeneficiaire == filterVM.filter.beneficiaireId,
                      orElse: () => BeneficiaireModel.fromJson({}),
                    )
                        .fullName() ?? ""),
                  ),
                ),

                const SizedBox(height: 10),

                _chipHeader("Pays destination", filterVM.filter.destinationPays != null,
                        () => filterVM.removeFilter("pays")),

                InkWell(
                  onTap: () => _showDestinationModal(filterVM, t),
                  child: _selectorBox(
                    filterVM.filter.destinationPays == null
                        ? ""
                        : (widget.demandesViewModel.paysDestination.data?.destination
                        ?.firstWhere(
                          (e) => e.codePaysDest == filterVM.filter.destinationPays,
                      orElse: () => Destination(paysDest: ""),
                    )
                        .paysDest
                        .toString() ?? ""),
                  ),
                ),

                const SizedBox(height: 10),

                if (!widget.isInvoice)
                  ...[
                    _chipHeader("Statut", filterVM.filter.statut != null,
                            () => filterVM.removeFilter("statut")),

                    InkWell(
                      onTap: () => _showStatusModal(filterVM, t),
                      child: _selectorBox(
                        filterVM.filter.statut == null
                            ? ""
                            : t.translate(filterVM.filter.statut!),
                      ),
                    ),

                  ],
                const SizedBox(height: 40),

                // --- APPLY BUTTON ---------------------
                RoundedButton(
                  title: t.translate("apply"),
                  onPress: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chipHeader(String title, bool active, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTexts.smallText(title),
          if (active)
            InkWell(
              onTap: onRemove,
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            )
        ],
      ),
    );
  }

  Widget _selectorBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.formFieldBorderColor),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: AppTexts.descriptionText(text),
    );
  }
}
