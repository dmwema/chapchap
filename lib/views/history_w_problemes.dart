import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/demande_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/history_card.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
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
  AuthViewModel authViewModel = AuthViewModel();
  List<Map> msgList = [];

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandesWProblems([], context, null);
    authViewModel.getInfoMessages(context).then((value) {
      if (value != null && value['error'] != true && value['data'] != null && value['data'].length > 0) {
        value['data'].forEach((element) => {
          setState(() {
            msgList.add(element);
          })
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
          backgroundColor: AppColors.bgColor,
          resizeToAvoidBottomInset: false,
          appBar: CommonAppBar(context: context, backArrow: true,),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: AppTexts.titleText("Demandes avec problèmes"),
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
                                        AppTexts.descriptionText(
                                          "Aucune demande avec problème signalée."
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