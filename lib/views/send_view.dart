import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/NewBeneficiaireForm.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendView extends StatefulWidget {
  BeneficiaireModel? beneficiaire;
  String? destination;
  double? amount;
  int? modeRetrait;
  SendView({Key? key, this.beneficiaire, this.destination, this.amount, this.modeRetrait}) : super(key: key);

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PaysDestinationModel? paysDestinationModel;
  Destination? selectedDesinaion;
  ModeRetrait?  selectedModeRetrait;
  List? beneficiaires;
  BeneficiaireModel? selectedBeneficiaire;

  bool loadBeneficiaire = false;
  bool loadedDestination = false;
  bool loadedModeRetrait = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysDestinations([], context);
    demandesViewModel.beneficiaires([], context);
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
      _fromController.clear();
      _toController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!loadBeneficiaire) {
      if (widget.beneficiaire != null) {
        setState(() {
          selectedBeneficiaire = widget.beneficiaire;
        });
      }
      if (widget.amount != null) {
        setState(() {
          insert(widget.amount, _fromController);
        });
      }
      setState(() {
        loadBeneficiaire = true;
      });
    }

    return Scaffold(
        appBar: CustomAppBar(
          showBack: true,
          title: "Envoi d'argent",
          backUrl: RoutesName.home,
        ),
        drawer:
        const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ChangeNotifierProvider<DemandesViewModel>(
              create: (BuildContext context) => demandesViewModel,
              child: Consumer<DemandesViewModel>(
                  builder: (context, value, _){
                    switch (value.paysDestination.status) {
                      case Status.LOADING:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primaryColor,),
                          ),
                        );
                      case Status.ERROR:
                        return Center(
                          child: Text(value.paysDestination.message.toString()),
                        );
                      default:
                        paysDestinationModel = value.paysDestination.data!;
                        if (!loadedDestination) {
                          if (widget.destination != null) {
                            for (var element in paysDestinationModel!.destination!) {
                              if (element.codePaysDest == widget.destination) {
                                selectedDesinaion = element;
                              }
                            }
                          }
                          loadedDestination = true;
                        }

                        if (selectedDesinaion != null && widget.amount != null && selectedBeneficiaire != null) {
                          _toController.text = (widget.amount! * double.parse(selectedDesinaion!.rate.toString())).toStringAsFixed(2);
                        }

                        if (!loadedModeRetrait) {
                          if (selectedDesinaion != null && selectedDesinaion!.modeRetrait != null && widget.modeRetrait != null) {
                            for (var element in selectedDesinaion!.modeRetrait!) {
                              if (widget.modeRetrait == element.idModeRetrait) {
                                selectedModeRetrait = element;
                              }
                            }
                          }
                          loadedModeRetrait = true;
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                            top: 20,
                            left: 20,
                            right: 20
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Montant à envoyer *", style: TextStyle(
                                  color: Colors.black.withOpacity(.6),
                                  fontSize: 13
                              ),),
                              const SizedBox(height: 10,),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (paysDestinationModel != null)
                                    Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.codePaysSrce}.png", width: 30, height: 15, fit: BoxFit.contain),
                                    const SizedBox(width: 10,),
                                    if (paysDestinationModel != null)
                                    Text(paysDestinationModel!.paysCodeMonnaieSrce.toString(), style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                        child: TextFormField(
                                      controller: _fromController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        if (selectedDesinaion != null) {
                                          if (value != "") {
                                            insert(double.parse(value) * double.parse(selectedDesinaion!.rate.toString()), _toController);
                                          } else {
                                            insert("", _toController);
                                          }
                                        } else {
                                          Utils.flushBarErrorMessage("Vous devez selectionner un pays de destination", context);
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0.00",
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 18
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Text("Motant à recevoir *", style: TextStyle(
                                  color: Colors.black.withOpacity(.6),
                                  fontSize: 13
                              ),),
                              const SizedBox(height: 10,),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest.toString(), style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),),
                                          const SizedBox(width: 10,),
                                          Expanded(child: TextFormField(
                                            controller: _toController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              if (selectedDesinaion != null) {
                                                if (value != "") {
                                                  insert(double.parse(value) / double.parse(selectedDesinaion!.rate.toString()), _fromController);
                                                } else {
                                                  insert("", _fromController);
                                                }
                                              } else {
                                                Utils.flushBarErrorMessage("Vous devez selectionner un pays de destination", context);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "0.00",
                                                contentPadding: EdgeInsets.zero
                                            ),
                                            style: const TextStyle(
                                                fontSize: 18
                                            ),
                                          )),
                                        ],
                                      ),
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
                                                                selectedDesinaion = paysDestinationModel!.destination![index];
                                                                beneficiaires = null;
                                                                selectedBeneficiaire = null;
                                                                if (
                                                                  selectedDesinaion!.modeRetrait != null
                                                                    && selectedDesinaion!.modeRetrait!.isNotEmpty
                                                                ) {
                                                                  selectedModeRetrait = null;
                                                                }
                                                                _toController.clear();
                                                                _fromController.clear();
                                                                insert(00, _toController);
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
                                          color: Colors.black.withOpacity(.05),
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              if (selectedDesinaion != null)
                                              Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 15, height: 15, fit: BoxFit.contain),
                                              const SizedBox(width: 10,),
                                              Text(selectedDesinaion == null ? "Séléctionner le pays de destination" :selectedDesinaion!.paysDest.toString(), style: const TextStyle(
                                                  fontSize: 12  ,
                                                  fontWeight: FontWeight.w500
                                              ),),
                                              const SizedBox(width: 10,),
                                              const Expanded(child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Icon(Icons.arrow_drop_down, color: Colors.green,),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      if (selectedDesinaion != null)
                                      Text("(1${paysDestinationModel!.paysCodeMonnaieSrce} = ${selectedDesinaion!.rate}${selectedDesinaion!.paysCodeMonnaieDest})", style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(.4)
                                      ),),
                                      const SizedBox(height: 10,),
                                      if (selectedDesinaion != null)
                                      Row(
                                        children: [
                                          if (selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                                          const Text("Mode de reception", style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          if (selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                                          const SizedBox(width: 10,),
                                          if (selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
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
                                                          const Text("Séléctionnez le mode de reception", style: TextStyle(
                                                              fontWeight: FontWeight.w600
                                                          ),),
                                                          const SizedBox(height: 20,),
                                                          Expanded(child: ListView.builder(
                                                            itemCount: selectedDesinaion!.modeRetrait!.length,
                                                            itemBuilder: (context, index) {
                                                              return InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      selectedModeRetrait = selectedDesinaion!.modeRetrait![index];
                                                                    });
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(selectedDesinaion!.modeRetrait![index].modeRetrait.toString(), style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold
                                                                        ),textAlign: TextAlign.center,)
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
                                            child: Row(
                                              children: [
                                                if (selectedModeRetrait != null)
                                                Text(selectedModeRetrait!.modeRetrait.toString()),
                                                const SizedBox(width: 5,),
                                                const Icon(Icons.arrow_drop_down, color: Colors.green,)
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                              ),
                              if (selectedModeRetrait != null && selectedDesinaion != null && selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              const SizedBox(height: 20,),
                              if (selectedModeRetrait != null && selectedDesinaion != null && selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              Text(selectedModeRetrait!.infosModeRetrait.toString(), style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(.5)
                              ),),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Bénéficiaire *", style: TextStyle(
                                      color: Colors.black.withOpacity(.6),
                                      fontSize: 14
                                  ),),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        beneficiaires = null;
                                      });
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: NewBeneficiaireForm(
                                              destinations: paysDestinationModel!.destination!,
                                              parentCotext: context,
                                              initialDestination: selectedDesinaion,
                                            ),
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
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.3),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: const Text("+ Ajouter un bénéficiaire", style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15,),

                              InkWell(
                                onTap: () {
                                  if (selectedDesinaion == null) {
                                    Utils.flushBarErrorMessage("Vous devez selectionner une destination", context);
                                  } else if (beneficiaires == null) {
                                    DemandesViewModel demandesViewModel2 = DemandesViewModel();
                                    demandesViewModel2.beneficiaires([], context);
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ChangeNotifierProvider<DemandesViewModel>(
                                            create: (BuildContext context) => demandesViewModel2,
                                            child: Consumer<DemandesViewModel>(
                                                builder: (context, value, _){
                                                  switch (value.beneficiairesList.status) {
                                                    case Status.LOADING:
                                                      return Column(
                                                        children: [Expanded(child: Center(
                                                          child: CircularProgressIndicator(color: AppColors.primaryColor,),
                                                        ))],
                                                      );
                                                    case Status.ERROR:
                                                      return Center(
                                                        child: Text(value.beneficiairesList.message.toString()),
                                                      );
                                                    default:
                                                      beneficiaires = [];
                                                      value.beneficiairesList.data!.forEach((element) {
                                                        BeneficiaireModel beneficiaireD = BeneficiaireModel.fromJson(element);
                                                        if (beneficiaireD.codePays == selectedDesinaion!.codePaysDest) {
                                                          beneficiaires!.add(element);
                                                        }
                                                      });
                                                      if (beneficiaires!.isEmpty) {
                                                        return Center(
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(vertical: 20),
                                                            child: const Text("Aucune bénéficiaire trouvée"),
                                                          ),
                                                        );
                                                      }
                                                      return Container(
                                                        padding: const EdgeInsets.all(20),
                                                        child: Column(
                                                          children: [
                                                            const Text("Séléctionnez un bénéficiaire", style: TextStyle(
                                                                fontWeight: FontWeight.w600
                                                            ),),
                                                            const SizedBox(height: 20,),
                                                            Expanded(
                                                              child: ListView.builder(
                                                                itemCount: beneficiaires!.length,
                                                                itemBuilder: (context, index) {
                                                                  BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(beneficiaires![index]);
                                                                  bool last = index == beneficiaires!.length - 1;

                                                                  return InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedBeneficiaire = beneficiaire;
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(10),
                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(width: 1, color: Colors.black.withOpacity(.2)),
                                                                          borderRadius: BorderRadius.circular(5)
                                                                      ),
                                                                      child: Column(
                                                                          children: [
                                                                            Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                                            const SizedBox(height: 10,),
                                                                            Text(beneficiaire.nomBeneficiaire.toString(), style: const TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16
                                                                            ),),
                                                                            const SizedBox(height: 10,),
                                                                            Text(beneficiaire.telBeneficiaire.toString()),
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                  }
                                                })
                                        );
                                      },
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                    );
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        if (beneficiaires!.isEmpty) {
                                          return Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: const Text("Aucun bénéficiaire trouvée"),
                                            ),
                                          );
                                        }
                                        return Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const Text("Séléctionnez un bénéficiaire", style: TextStyle(
                                                  fontWeight: FontWeight.w600
                                              ),),
                                              const SizedBox(height: 20,),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: beneficiaires!.length,
                                                  itemBuilder: (context, index) {
                                                    BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(beneficiaires![index]);
                                                    bool last = index == beneficiaires!.length - 1;

                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedBeneficiaire = beneficiaire;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        margin: const EdgeInsets.only(bottom: 10),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(width: 1, color: Colors.black.withOpacity(.2)),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Column(
                                                            children: [
                                                              Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                              const SizedBox(height: 10,),
                                                              Text(beneficiaire.nomBeneficiaire.toString(), style: const TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 16
                                                              ),),
                                                              const SizedBox(height: 10,),
                                                              Text(beneficiaire.telBeneficiaire.toString()),
                                                            ]
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text("Choisissez un bénéficiaire", style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),),
                                      SizedBox(width: 10,),
                                     Expanded(child: Align(
                                       alignment: Alignment.centerRight,
                                       child: Icon(Icons.arrow_drop_down, size: 30,),
                                     ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              if (selectedBeneficiaire != null)
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Nom", style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black.withOpacity(.5)
                                      ),),
                                      Row(
                                        children: [
                                          Image.asset("packages/country_icons/icons/flags/png/${selectedBeneficiaire!.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                          const SizedBox(width: 10,),
                                          Text(selectedBeneficiaire!.nomBeneficiaire.toString(), style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600
                                          ),),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Téléphone", style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black.withOpacity(.5)
                                      ),),
                                      Text(selectedBeneficiaire!.telBeneficiaire.toString(), style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600
                                      ),),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: RoundedButton(
                                  onPress: () {
                                    if (selectedDesinaion == null) {
                                      Utils.flushBarErrorMessage("Vous devez séléctionner un pays de destination", context);
                                    } else if (_fromController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer le montant", context);
                                    } else if (selectedBeneficiaire == null) {
                                      Utils.flushBarErrorMessage("Vous devez choisir un bénéficiaire", context);
                                    } else {
                                      Map data = {
                                        "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire,
                                        "code_pays_srce": paysDestinationModel!.codePaysSrce,
                                        "montant_srce": _fromController.text,
                                        "montant_dest":_toController.text,
                                        "code_pays_dest": selectedDesinaion!.codePaysDest,
                                        "id_mode_retrait": selectedModeRetrait == null ? null : selectedModeRetrait!.idModeRetrait,
                                        "beneficiaire": selectedBeneficiaire,
                                        "source": paysDestinationModel,
                                        "destination": selectedDesinaion,
                                        "mode_retrait": selectedModeRetrait == null ? null : selectedModeRetrait!.modeRetrait.toString()
                                      };
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return SendBottomModal(data: data,);
                                        },
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  title: "Envoyer",
                                  loading: demandesViewModel.loading,
                                )
                              )
                            ],
                          ),
                        );
                    }
                  })
          )
        )
    );
  }
}