import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/pays_destination_model.dart';
import 'package:mardona/model/pays_model.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/custom_field.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExchangeView extends StatefulWidget {
  bool? public;
  ExchangeView({Key? key, this.public}) : super(key: key);

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> with SingleTickerProviderStateMixin {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PaysModel selectedFrom = PaysModel();
  Destination? selectedTo;
  double tauxTransfert = 0;
  PaysDestinationModel? paysDestinationModel;
  List destinationsList = [];
  bool changed = false;

  UserModel? user;

  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    demandesViewModel.paysActifs([], context);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void insert(content, TextEditingController controller) {
    if (content.runtimeType.toString() == "double"){
      if (controller == _toController) {
        content = double.parse(content.toStringAsFixed(2));
      } else {
        content = double.parse(content.toStringAsFixed(2));
      }
      controller.value = TextEditingValue(
        text: content.toString(),
        selection: TextSelection.collapsed(offset: content.toString().length),
      );
    } else {
      _amountController.clear();
      _toController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        appBar: widget.public == true ? CommonAppBar(
          context: context,
          title: "Estimation",
          backArrow: true,
        ) : PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.bgColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
              systemNavigationBarDividerColor: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: pageTitleStyle(context: context, title: 'Constatez vous-même le taux de change très bas :)')
              ),
              Expanded(
                child: ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                        builder: (context, value, _){
                          switch (value.paysActifList.status) {
                            case Status.LOADING:
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CupertinoActivityIndicator(color: Colors.black,),
                                ),
                              );
                            case Status.ERROR:
                              return Center(
                                child: Text(value.paysActifList.message.toString()),
                              );
                            default:
                              List paysActifsList = value.paysActifList.data!;
                              if (selectedFrom.codePays == null) {
                                selectedFrom = PaysModel.fromJson(paysActifsList[0]);
                              }
                              return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTexts.cardDescription("Source"),
                                    const SizedBox(height: 5,),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    AppTexts.titleText("Séléctionnez le pays d'expédition"),
                                                    const SizedBox(height: 20,),
                                                    Expanded(child: ListView.builder(
                                                      itemCount: paysActifsList.length,
                                                      itemBuilder: (context, index) {
                                                        PaysModel current = PaysModel.fromJson(paysActifsList[index]);
                                                        return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedFrom = current;
                                                                selectedTo = null;
                                                                changed = true;
                                                                _amountController.clear();
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                  border: Border(bottom: BorderSide(width: 1, color: AppColors.borderGreyColor))
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Image.asset("assets/flag.png"),
                                                                  const SizedBox(width: 20,),
                                                                  AppTexts.bodyText(current.paysNom.toString(), color: AppColors.textGrey)
                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      },
                                                    ))
                                                  ],
                                                )
                                            );
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset("assets/flag.png"),
                                            const SizedBox(width: 10,),
                                            if (selectedFrom.idPays != null)
                                            AppTexts.bodyText(selectedFrom.paysNom!),
                                            const Expanded(child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(CupertinoIcons.chevron_down, size: 20,),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
                                    AppTexts.cardDescription("Destination"),
                                    const SizedBox(height: 5,),
                                    InkWell(
                                      onTap: () {
                                        DemandesViewModel newDemandeViewModel = DemandesViewModel();
                                        if (paysDestinationModel == null || changed) {
                                          newDemandeViewModel.allPaysDestinations(
                                              {"id": selectedFrom.idPays.toString()}, context);
                                        }
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            if (paysDestinationModel == null || changed) {
                                              changed = false;
                                              return ChangeNotifierProvider<DemandesViewModel>(
                                                  create: (BuildContext context) => newDemandeViewModel,
                                                  child: Consumer<DemandesViewModel>(
                                                      builder: (context, value, _){
                                                        switch (value.allPaysDestination.status) {
                                                          case Status.LOADING:
                                                            return Container(
                                                              height: MediaQuery.of(context).size.height - 200,
                                                              child: const Center(
                                                                child: CupertinoActivityIndicator(color: Colors.black,),
                                                              ),
                                                            );
                                                          case Status.ERROR:
                                                            return Center(
                                                              child: Text(value.allPaysDestination.message.toString()),
                                                            );
                                                          default:
                                                            paysDestinationModel = value.allPaysDestination.data!;
                                                            return Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    AppTexts.titleText("Séléctionnez le pays de destination"),
                                                                    const SizedBox(height: 20,),
                                                                    Expanded(child: ListView.builder(
                                                                      itemCount: paysDestinationModel!.destination!.length,
                                                                      itemBuilder: (context, index) {
                                                                        return InkWell(
                                                                            onTap: () {
                                                                              Navigator.pop(context);
                                                                              setState(() {
                                                                                selectedTo = paysDestinationModel!.destination![index];
                                                                                _amountController.clear();
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                              padding: const EdgeInsets.all(10),
                                                                              decoration: BoxDecoration(
                                                                                border: Border(bottom: BorderSide(width: 1, color: AppColors.borderGreyColor))
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset("assets/flag.png"),
                                                                                  const SizedBox(width: 20,),
                                                                                  AppTexts.bodyText(paysDestinationModel!.destination![index].paysDest.toString(), color: AppColors.textGrey)
                                                                                ],
                                                                              ),
                                                                            )
                                                                        );
                                                                      },
                                                                    ))
                                                                  ],
                                                                )
                                                            );
                                                        }
                                                      })
                                              );
                                            }
                                            return Container(
                                                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    AppTexts.titleText("Séléctionnez le pays de destination"),
                                                    const SizedBox(height: 20,),
                                                    Expanded(child: ListView.builder(
                                                      itemCount: paysDestinationModel!.destination!.length,
                                                      itemBuilder: (context, index) {
                                                        return InkWell(
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                              setState(() {
                                                                selectedTo = paysDestinationModel!.destination![index];
                                                                _amountController.clear();
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                  border: Border(bottom: BorderSide(width: 1, color: AppColors.borderGreyColor))
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Image.asset("assets/flag.png"),
                                                                  const SizedBox(width: 20,),
                                                                  AppTexts.bodyText(paysDestinationModel!.destination![index].paysDest.toString(), color: AppColors.textGrey)
                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      },
                                                    ))
                                                  ],
                                                )
                                            );
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset("assets/flag.png"),
                                            const SizedBox(width: 10,),
                                            if (selectedTo != null)
                                              AppTexts.bodyText(selectedTo!.paysDest!),
                                            const Expanded(child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(CupertinoIcons.chevron_down, size: 20,),
                                            ))
                                          ],
                                        ),
                                      ),
                                      ),
                                    const SizedBox(height: 15,),
                                    AppTexts.cardDescription("Vous envoyez :", color: Colors.black, bold: true),
                                    const SizedBox(height: 5,),
                                    CustomFormField(
                                      label: "0.00",
                                      hint: "0.00",
                                      controller: _amountController,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: AppTexts.bodyText(selectedFrom.paysCodemonnaie.toString(), bold: true),
                                      ),
                                      type: TextInputType.number,
                                      onChanged: (value) {
                                        if (selectedTo != null) {
                                          if (value != "") {
                                            insert(double.parse(value) * double.parse(selectedTo!.rate.toString()), _toController);
                                            if (selectedTo != null) {
                                              if (value != "" && selectedTo!.taux_transfert != null) {
                                                setState(() {
                                                  tauxTransfert = double.parse(_amountController.text) * (selectedTo!.taux_transfert! / 100);
                                                });
                                              }
                                            }
                                          } else {
                                            insert("", _toController);
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10,),
                                    AppTexts.cardDescription("Elle réçoit :", color: Colors.black, bold: true),
                                    const SizedBox(height: 5,),
                                    CustomFormField(
                                      label: "0.00",
                                      hint: "0.00",
                                      controller: _toController,
                                      type: TextInputType.number,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: AppTexts.bodyText(selectedFrom.paysCodemonnaie.toString(), bold: true),
                                      ),
                                      onChanged: (value) {
                                        if (selectedTo != null) {
                                          if (value != "") {
                                            insert(double.parse(value) /
                                                double.parse(selectedTo!.rate.toString()), _amountController);
                                            setState(() {
                                              tauxTransfert = double.parse(_amountController.text) * (selectedTo!.taux_transfert! / 100);
                                            });
                                          } else {
                                            insert("", _amountController);
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20,),
                                    if (selectedFrom.idPays != null && selectedTo != null)
                                    commonRoundedContainer(
                                      removePaddingAll: true,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AppTexts.cardTitle("Frais de transfert"),
                                                AppTexts.cardTitle(paysDestinationModel == null ? "0.0" : "${tauxTransfert.toStringAsFixed(2)} ${paysDestinationModel!.paysCodeMonnaieSrce}"),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                            child: AppTexts.titleText("1 ${selectedFrom.paysCodemonnaie} = ${selectedTo!.rate} ${selectedTo!.paysCodeMonnaieDest}", color: AppColors.accentColor),
                                          ),
                                        ],
                                      ),
                                      removePaddingH: true
                                    ),
                                    const SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            );
                          }
                        })
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: user == null || widget.public == true ? null : FloatingActionButtonLocation.centerDocked,
        floatingActionButton: user == null || widget.public == true ? null : ScaleTransition(
          scale: _animation,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.send);
            },
            child: const Icon(CupertinoIcons.arrow_up_right_circle, color: Colors.white, size: 35,),
          ),
        ),
        bottomNavigationBar: user == null || widget.public == true ? null : commonBottomAppBar(context: context, active: 2),
      ),
    );
  }
}