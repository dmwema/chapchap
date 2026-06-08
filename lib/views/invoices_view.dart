import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/invoice_card.dart';
import 'package:chapchap/res/components/modal/filter_modal.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/filters/history_filter_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicesView extends StatefulWidget {
  const InvoicesView({Key? key}) : super(key: key);

  @override
  State<InvoicesView> createState() => _InvoicesViewState();
}

class _InvoicesViewState extends State<InvoicesView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  FilterViewModel filterViewModel = FilterViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, null, invoice: true);
  }

  void _openFilterModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: filterViewModel,
          child: FilterModal(
            demandesViewModel: demandesViewModel,
            isInvoice: true,
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
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
        // title: AppLocalizations.of(context)!.translate('myInvoices'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppTexts.titleText(AppLocalizations.of(context).translate('myInvoices')),
                      Spacer(),
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
                ],
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(builder: (context, value, _) {
                  switch (value.demandeList.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
                    case Status.ERROR:
                      return Center(
                        child: Text(value.demandeList.message.toString()),
                      );
                    default:
                      List<DemandeModel> invoiceList = [];
                      for (var element in value.demandeList.data) {
                        DemandeModel demande = DemandeModel.fromJson(element);
                        invoiceList.add(demande);
                      }
                      List<DemandeModel> filtered = invoiceList.where((d) {
                        final f = filterViewModel.filter;

                        if (f.dateRange != null) {
                          final parts = d.datePaidBen!.split('-');
                          final formatted = "${parts[2]}-${parts[1]}-${parts[0]}";
                          final date = DateTime.parse(formatted);
                          if (date.isBefore(f.dateRange!.start) || date.isAfter(f.dateRange!.end)) return false;
                        }

                        if (f.beneficiaireId != null && d.beneficiaire!.idBeneficiaire != f.beneficiaireId) return false;

                        if (f.destinationPays != null && d.codePaysDest != f.destinationPays) return false;

                        return true;
                      }).toList();
                      if (invoiceList.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width,
                          child: Center(
                            child: AppTexts.descriptionText(
                              AppLocalizations.of(context).translate('noInvoicesFound'),
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  DemandeModel current = filtered[index];
                                  if (current.facture != null) {
                                    return Column(
                                      children: [
                                        InvoiceCard(
                                          demande: current,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
