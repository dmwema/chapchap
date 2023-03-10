import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/country_select_modal.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/payment_methods_modal.dart';
import 'package:chapchap/res/components/recipient_card.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
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
          showBack: true,
          title: 'Historique',
          backUrl: RoutesName.home,
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
                      if (value.demandeList.data!.length == 0) {
                        return Center(
                          child: Text(
                            "Aucune transaction éffectuée",
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
                                return Column(
                                  children: [
                                    HistoryCard(date: current.date.toString(), sent: false, receiver: current.beneficiaire.toString(), amount: current.montanceSrce.toString()),
                                    const SizedBox(height: 5,),
                                    const Divider(),
                                  ],
                                );
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