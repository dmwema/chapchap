import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/modal/filter_modal.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/filters/history_filter_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  FilterViewModel filterViewModel = FilterViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, null);
  }

  void _openFilterModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: filterViewModel,
          child: SafeArea(
            child: FilterModal(
              demandesViewModel: demandesViewModel,
            ),
          ),
        );
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      extendBodyBehindAppBar: false,
      appBar: CommonAppBar(context: context, backArrow: true),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTexts.titleText(AppLocalizations.of(context)!.translate('myHistory')),
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          _openFilterModal();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),),
                          child: Icon(Icons.search, color: Colors.white, size: 30),
                        ),
                      ),
                      if (filterViewModel.count > 0)
                        Positioned(
                          right: 0,
                          top: -1,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              filterViewModel.count.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.historyWP);
              },
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: AppColors.buttonBlackColor,
                  border: Border(
                    bottom: BorderSide(color: AppColors.formFieldColor, width: 1),
                    top: BorderSide(color: AppColors.formFieldColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 20, color: Colors.white,),
                        const SizedBox(width: 10,),
                        AppTexts.smallText(AppLocalizations.of(context)!.translate('requestsWithProblem'), color: Colors.white)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                  builder: (context, value, _) {
                    switch (value.demandeList.status) {
                      case Status.LOADING:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
                            child: CupertinoActivityIndicator(color: Colors.black,),
                          ),
                        );
                      case Status.ERROR:
                        return Center(
                          child: Text(value.demandeList.message.toString()),
                        );
                      default:
                        if (value.demandeList.data!.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('noTransactions'),
                              style: TextStyle(
                                color: Colors.black.withOpacity(.2),
                              ),
                            ),
                          );
                        }
                        List demandeRaw = value.demandeList.data!;
                        List filtered = demandeRaw.where((d) {
                          DemandeModel m = DemandeModel.fromJson(d);

                          final f = filterViewModel.filter;

                          if (f.dateRange != null) {
                            final parts = m.date!.split('-');
                            final formatted = "${parts[2]}-${parts[1]}-${parts[0]}";
                            final date = DateTime.parse(formatted);
                            if (date.isBefore(f.dateRange!.start) || date.isAfter(f.dateRange!.end)) return false;
                          }

                          if (f.beneficiaireId != null && m.beneficiaire!.idBeneficiaire != f.beneficiaireId) return false;

                          if (f.destinationPays != null && m.codePaysDest != f.destinationPays) return false;

                          if (f.statut != null && m.statutDemande != f.statut) return false;

                          return true;
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('noTransactions'),
                              style: TextStyle(
                                color: Colors.black.withOpacity(.2),
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  DemandeModel current = DemandeModel.fromJson(filtered[index]);
                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 20,),
                                        HistoryCard(
                                          demande: current,
                                        ),
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      HistoryCard(
                                        demande: current,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
