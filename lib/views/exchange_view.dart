import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
        ),
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText("Taux de change")
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
                                    AppTexts.bodyText("Source"),
                                    const SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          AppTexts.smallText("Séléctionnez le pays d'expédition"),
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
                                                                        border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                                        const SizedBox(width: 20,),
                                                                        Text(current.paysNom.toString(), style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold
                                                                        ),)
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
                                              width: double.infinity, height: 50,
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: AppColors.formFieldColor,
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Image.asset("packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png", width: 30, height: 20, fit: BoxFit.contain),
                                                  const SizedBox(width: 10,),
                                                  const Expanded(child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Icon(CupertinoIcons.chevron_down, size: 20,),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 40 - 10 - 80),
                                          child: CustomFormField(
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    AppTexts.bodyText("Destination"),
                                    const SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: InkWell(
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
                                                                          const Text("Séléctionnez le pays de destination", style: TextStyle(
                                                                              fontWeight: FontWeight.w600
                                                                          ),),
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
                                                                                        border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                                    ),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.destination![index].codePaysDest}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                                                        const SizedBox(width: 20,),
                                                                                        Text(paysDestinationModel!.destination![index].paysDest.toString(), style: const TextStyle(
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.bold
                                                                                        ),)
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
                                                          const Text("Séléctionnez le pays de destination", style: TextStyle(
                                                              fontWeight: FontWeight.w600
                                                          ),),
                                                          const SizedBox(height: 20,),
                                                          Expanded(child: ListView.builder(
                                                            itemCount: paysDestinationModel!.destination!.length,
                                                            itemBuilder: (context, index) {
                                                              return InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      selectedTo = paysDestinationModel!.destination![index];
                                                                      _amountController.clear();
                                                                    });
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.destination![index].codePaysDest}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                                        const SizedBox(width: 20,),
                                                                        Text(paysDestinationModel!.destination![index].paysDest.toString(), style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold
                                                                        ),)
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
                                              width: double.infinity, height: 50,
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: AppColors.formFieldColor,
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: selectedTo == null ? MainAxisAlignment.center : MainAxisAlignment.start,
                                                children: [
                                                  if (selectedTo != null)
                                                    Image.asset("packages/country_icons/icons/flags/png/${selectedTo!.codePaysDest}.png", width: 30, height: 20, fit: BoxFit.contain),
                                                  if (selectedTo == null)
                                                    AppTexts.cardTitle("_"),
                                                  const SizedBox(width: 10,),
                                                  const Expanded(child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Icon(CupertinoIcons.chevron_down, size: 20,),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          )
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 40 - 10 - 80),
                                          child: CustomFormField(
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    if (selectedFrom.idPays != null && selectedTo != null)
                                    commonRoundedContainer(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                            child: AppTexts.titleText("1 ${selectedFrom.paysCodemonnaie} = ${selectedTo!.rate} ${selectedTo!.paysCodeMonnaieDest}"),
                                          ),
                                          commonDivider(),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppTexts.smallText("Frais de transfert"),
                                                AppTexts.titleText(paysDestinationModel == null ? "0.0" : "$tauxTransfert ${paysDestinationModel!.paysCodeMonnaieSrce}"),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      removePaddingH: true
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline_rounded, color: AppColors.primaryColor, size: 20,),
                                        const SizedBox(width: 10,),
                                        Flexible(child: AppTexts.descriptionText("Tansfert ChapChap utilise son propre taux de change")),
                                      ],
                                    )
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