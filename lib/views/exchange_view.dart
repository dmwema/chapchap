import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExchangeView extends StatefulWidget {
  const ExchangeView({Key? key}) : super(key: key);

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PaysModel selectedFrom = PaysModel();
  Destination? selectedTo;
  PaysDestinationModel? paysDestinationModel;
  List destinationsList = [];
  bool changed = false;

  TextEditingController _amountController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysActifs([], context);
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
          backgroundColor: AppColors.formFieldColor,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonAppBar(
                  context: context,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Taux de change", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                ),
                ChangeNotifierProvider<DemandesViewModel>(
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
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) * 0.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("De", style: TextStyle(
                                                  color: Colors.black.withOpacity(.6),
                                                  fontSize: 13
                                              ),),
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
                                                              const Text("Séléctionnez le pays d'expédition", style: TextStyle(
                                                                  fontWeight: FontWeight.w600
                                                              ),),
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
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.formFieldColor,
                                                    border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                                    borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset("packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png", width: 20, height: 15, fit: BoxFit.contain),
                                                      const SizedBox(width: 10,),
                                                      Text(selectedFrom.paysCodemonnaie.toString(), style: const TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16,
                                                      ),),
                                                      const SizedBox(width: 10,),
                                                      const Expanded(child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Icon(Icons.arrow_drop_down),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) * 0.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("À", style: TextStyle(
                                                  color: Colors.black.withOpacity(.6),
                                                  fontSize: 13
                                              ),),
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
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.formFieldColor,
                                                    border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                                    borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      if (selectedTo != null)
                                                        Image.asset("packages/country_icons/icons/flags/png/${selectedTo!.codePaysDest}.png", width: 20, height: 15, fit: BoxFit.contain),
                                                      if (selectedTo != null)
                                                        const SizedBox(width: 10,),
                                                      if (selectedTo != null)
                                                        Text(selectedTo!.paysCodeMonnaieDest.toString(), style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),),
                                                      if (selectedTo == null)
                                                        const Text("...", style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight: FontWeight.w900
                                                        ),),
                                                      const SizedBox(width: 10,),
                                                      const Expanded(child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Icon(Icons.arrow_drop_down),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Montant à envoyer", style: TextStyle(
                                            color: Colors.black.withOpacity(.6),
                                            fontSize: 13
                                        ),),
                                        const SizedBox(height: 5,),
                                        CustomFormField(
                                          label: "0.00",
                                          hint: "0.00",
                                          controller: _amountController,
                                          type: TextInputType.number,
                                          onChanged: (value) {
                                            if (selectedTo != null) {
                                              if (value != "") {
                                                insert(double.parse(value) * double.parse(selectedTo!.rate.toString()), _toController);
                                              } else {
                                                insert("", _toController);
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 10,),
                                        Text("Montant à recevoir", style: TextStyle(
                                            color: Colors.black.withOpacity(.6),
                                            fontSize: 13
                                        ),),
                                        const SizedBox(height: 5,),
                                        CustomFormField(
                                          label: "0.00",
                                          hint: "0.00",
                                          controller: _toController,
                                          type: TextInputType.number,
                                          onChanged: (value) {
                                            if (selectedTo != null) {
                                              if (value != "") {
                                                insert(double.parse(value) /
                                                    double.parse(selectedTo!.rate.toString()), _amountController);
                                              } else {
                                                insert("", _amountController);
                                              }
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        })
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              child: const Icon(CupertinoIcons.arrow_up_right), onPressed: () {
            Navigator.pushNamed(context, RoutesName.send);
          }
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 66,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: const Icon(CupertinoIcons.square_grid_2x2,), onTap: () {
                        Navigator.pushNamed(context, RoutesName.home);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      const Text("Accueil", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10,),)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: const Icon(CupertinoIcons.person_2), onTap: () {
                        Navigator.pushNamed(context, RoutesName.recipeints);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      const Text("Bénéficiaires", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10,),)
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: Icon(CupertinoIcons.arrow_right_arrow_left_circle_fill, color: AppColors.primaryColor,), onTap: () {
                        // Navigator.pushNamed(context, RoutesName.exchange);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      Flexible(child: Text("Change",  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: AppColors.primaryColor,),))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: const Icon(CupertinoIcons.person), onTap: () {
                        Navigator.pushNamed(context, RoutesName.accountView);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      const Text("Mon compte", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),)
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}