import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/invoice_card.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicesView extends StatefulWidget {
  const InvoicesView({Key? key}) : super(key: key);

  @override
  State<InvoicesView> createState() => _InvoicesViewState();
}

class _InvoicesViewState extends State<InvoicesView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, null);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Factures",
        showBack: true,
      ),
        body: ChangeNotifierProvider<DemandesViewModel>(
            create: (BuildContext context) => demandesViewModel,
            child: Consumer<DemandesViewModel>(
                builder: (context, value, _){
                  switch (value.demandeList.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primaryColor,),
                        ),
                      );
                    case Status.ERROR:
                      return Center(
                        child: Text(value.demandeList.message.toString()),
                      );
                    default:
                      List invoiceList = [];
                      for (var element in value.demandeList.data) {
                        DemandeModel demande = DemandeModel.fromJson(element);
                        if (demande.facture != null && demande.facture != 'null' && demande.facture != '') {
                          invoiceList.add(element);
                        }
                      }
                      if (invoiceList.isEmpty) {
                        return Center(
                          child: Text(
                            "Aucune facture trouvée",
                            style: TextStyle(
                              color: Colors.black.withOpacity(.2),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: ListView.builder(
                              itemCount: value.demandeList.data!.length,
                              itemBuilder: (context, index) {
                                DemandeModel current = DemandeModel.fromJson(value.demandeList.data![index]);
                                if (current.facture != null) {
                                  return Column(
                                  children: [
                                    InvoiceCard(
                                      demande: current,
                                    ),
                                    const SizedBox(height: 5,),
                                    const Divider(),
                                  ],
                                );
                                }
                                return Container();
                              },
                            )),
                          ],
                        ),
                      );
                  }
                })
        )
    );
  }
}