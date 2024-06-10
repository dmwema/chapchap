import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryWithProblemView extends StatefulWidget {
  const HistoryWithProblemView({Key? key}) : super(key: key);

  @override
  State<HistoryWithProblemView> createState() => _HistoryWithProblemState();
}

class _HistoryWithProblemState extends State<HistoryWithProblemView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandesWProblems([], context, null);
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonAppBar(
                  context: context,
                  backArrow: true,
                ),
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Demandes avec problèmes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                ),
                const SizedBox(height: 10,),
                ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                        builder: (context, value, _){
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
                              if (value.demandeList.data!.length == 0) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.asset("assets/empty.png", width: 180,),
                                        const SizedBox(height: 20,),
                                        SizedBox(
                                          width: 230,
                                          child: Text(
                                            "Aucune demande avec problème signalée.",
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(.4),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(height: 40,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: value.demandeList.data!.length,
                                      itemBuilder: (context, index) {
                                        DemandeModel current = DemandeModel.fromJson(value.demandeList.data![index]);
                                        return Column(
                                          children: [
                                            HistoryCard(
                                              demande: current,
                                              hasProblem: true,
                                            ),
                                            const SizedBox(height: 5,),
                                            const Divider(),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                          }
                        })
                ),
              ],
            ),
          )
      ),
    );
  }
}