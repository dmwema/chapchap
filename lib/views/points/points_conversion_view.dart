import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/conversion_rule.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/points_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PointsConversionView extends StatefulWidget {
  const PointsConversionView({Key? key}) : super(key: key);

  @override
  State<PointsConversionView> createState() => _PointsConversionViewSatet();
}

class _PointsConversionViewSatet extends State<PointsConversionView> {
  UserModel? user;
  PointsViewModel pointsViewModel = PointsViewModel();

  bool loadFirstRule = false;
  bool loading = false;

  List<ConversionRule>? conversionRules;

  Map? selectedRule;

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    pointsViewModel.getBalance(context);
    pointsViewModel.getConversionRules(context).then((value) {
      setState(() {
        conversionRules = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTexts.titleText(AppLocalizations.of(context)!.conversion),
                        const SizedBox(height: 10,),
                        Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.formFieldColor, width: 1),
                                  top: BorderSide(color: AppColors.formFieldColor, width: 1),
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/icons/coins.png", width: 20,),
                                    const SizedBox(width: 5,),
                                    ChangeNotifierProvider<PointsViewModel>(
                                        create: (BuildContext context) => pointsViewModel,
                                        child: Consumer<PointsViewModel>(
                                            builder: (context, value, _){
                                              switch (value.balance.status) {
                                                case Status.LOADING:
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color: Colors.white,
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    child: const CupertinoActivityIndicator(radius: 8,),
                                                  );
                                                case Status.ERROR:
                                                  return Center(
                                                    child: Text(value.balance.message.toString()),
                                                  );
                                                default:
                                                  var pBalance = value.balance.data!;
                                                  return AppTexts.cardTitle(user != null && user!.pointsBalance != null ? user!.pointsBalance.toString() : "0");
                                              }
                                            })
                                    )
                                  ],
                                ),
                              ],
                            )
                        ),
                        const SizedBox(height: 20,),
                        AppTexts.descriptionText(AppLocalizations.of(context)!.choose_conversion_rule)
                      ],
                    ),
                  ],
                ),
              ),
              ChangeNotifierProvider<PointsViewModel>(
                create: (BuildContext context) => pointsViewModel,
                child: Consumer<PointsViewModel>(
                    builder: (context, value, _) {
                      switch (value.conversionRules.status) {
                        case Status.LOADING:
                          return const Center(
                            child: CupertinoActivityIndicator(color: Colors.black,),
                          );
                        case Status.ERROR:
                          return AppTexts.descriptionText(value.conversionRules.message.toString());
                        default:
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.conversionRules.data.length,
                              itemBuilder: (context, index) {
                                ConversionRule current = value.conversionRules.data[index];
                                List availableRules = [];
                                int? currentMerge = current.pointsRequired;

                                if (!loadFirstRule) {
                                  selectedRule = {
                                    "points": current.pointsRequired,
                                    "amount": double.parse(current.cashValue!)
                                  };
                                  loadFirstRule = true;
                                }

                                int i = 0;
                                do {
                                  availableRules.add({
                                    "points": currentMerge,
                                    "amount": double.parse(current.cashValue!) * (i + 1)
                                  });
                                  i++;
                                  currentMerge = currentMerge! + current.pointsRequired!;
                                } while (user!.pointsBalance! >= currentMerge);

                                if (user!.pointsBalance! < current.pointsRequired!) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.buttonBlackColor,
                                        size: 60,
                                      ),
                                      const SizedBox(height: 10,),
                                      // AppTexts.titleText(AppLocalizations.of(context)!.points_required(current.pointsRequired.toString())),
                                      // const SizedBox(height: 5,),
                                      AppTexts.descriptionText(AppLocalizations.of(context)!.earn_more_points),
                                      const SizedBox(height: 20,),
                                      RoundedButton(
                                        title: AppLocalizations.of(context)!.understood,
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    RoundedButton(
                                        title: selectedRule == null ? "-" : "${selectedRule!['points']} Points = ${selectedRule!['amount']} CAD",
                                        color: AppColors.formFieldColor,
                                        textColor: AppColors.buttonBlackColor,
                                        select: true,
                                        onPress: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: AppColors.bgColor,
                                            builder: (context) {
                                              return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      AppTexts.titleText(AppLocalizations.of(context)!.select_conversion_rule),
                                                      const SizedBox(height: 20,),
                                                      Expanded(child: ListView.builder(
                                                        itemCount: availableRules.length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (context, index) {
                                                          Map cRule = availableRules[index];
                                                          return Padding(
                                                            padding: const EdgeInsets.only(bottom: 5.0),
                                                            child: RoundedButton(
                                                              onPress: (cRule["points"] == selectedRule!["points"]) ? null : () {
                                                                setState(() {
                                                                  selectedRule = cRule;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              color: cRule["points"] == selectedRule!["points"] ? AppColors.buttonBlackColor.withOpacity(.2) : AppColors.buttonBlackColor,
                                                              textColor: cRule["points"] == selectedRule!["points"] ? AppColors.buttonBlackColor.withOpacity(.3) : Colors.white,
                                                              title: "${cRule["points"]} Points for ${cRule["amount"]} CAD",
                                                            ),
                                                          );
                                                        },
                                                      ))
                                                    ],
                                                  )
                                              );
                                            },
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(0),
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                    const SizedBox(height: 10,),
                                    RoundedButton(
                                        title: AppLocalizations.of(context)!.validate,
                                        loading: loading,
                                        onPress: () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          Map data = {"points": selectedRule!['points']};
                                          await pointsViewModel.convert(data, context).then((value) async {
                                            if (value != null) {
                                              if (value['error'] == true) {
                                                Utils.flushBarErrorMessage(value["message"], context);
                                              } else {
                                                Utils.toastMessage(value["message"]);
                                                Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
                                              }
                                            }
                                            setState(() {
                                              loading = false;
                                            });
                                          });
                                        }
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                );
                              },
                            ),
                          );
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
