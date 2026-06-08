import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
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
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(context: context, backArrow: true),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText(AppLocalizations.of(context)!.translate('requestsWithProblem')),
              ),
              const SizedBox(height: 10),
              ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                  builder: (context, value, _) {
                    switch (value.demandeList.status) {
                      case Status.LOADING:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
                            child: CupertinoActivityIndicator(color: Colors.black),
                          ),
                        );
                      case Status.ERROR:
                        return Center(
                          child: Text(value.demandeList.message.toString()),
                        );
                      default:
                        if (value.demandeList.data!.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  AppTexts.descriptionText(
                                      AppLocalizations.of(context)!.translate('noProblemRequests')
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
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
                                    const SizedBox(height: 5),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
