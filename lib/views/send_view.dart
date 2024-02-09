import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/new_beneficiaire.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
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
  int step = 0;
  final PageController _controller = PageController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();
  DemandesViewModel demandesViewModel2 = DemandesViewModel();
  FocusNode? currentFocus = FocusManager.instance.primaryFocus;
  PaysDestinationModel? paysDestinationModel;
  Destination? selectedDesinaion;
  ModeRetrait?  selectedModeRetrait;
  List? beneficiaires;
  BeneficiaireModel? selectedBeneficiaire;
  bool fromToToSens = true;

  bool loadBeneficiaire = false;
  bool loadedDestination = false;
  bool loadedModeRetrait = false;

  bool loading = false;
  bool loadingPromo = false;
  bool loadingPromoSucces = false;
  bool load = false;
  final TextEditingController _promoContoller = TextEditingController();

  bool promo = false;
  double promoRabais = 0;

  _onChanged(int index) {
    setState(() {
      step = index;
    });
  }

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
    demandesViewModel2.beneficiaires([], context);
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

    final List pages = [
      SingleChildScrollView(
          child: ChangeNotifierProvider<DemandesViewModel>(
              create: (BuildContext context) => demandesViewModel,
              child: Consumer<DemandesViewModel>(
                  builder: (context, value, _){
                    switch (value.paysDestination.status) {
                      case Status.LOADING:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
                            child: CupertinoActivityIndicator(color: Colors.black,),
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

                        return Container(
                          color: AppColors.formFieldColor,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                              top: 20,
                              left: 20,
                              right: 20
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Destination", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
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
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1, color: AppColors.formFieldBorderColor)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                                  child: Row(
                                    children: [
                                      if (selectedDesinaion != null)
                                        Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 15, height: 15, fit: BoxFit.contain),
                                      if (selectedDesinaion != null)
                                        const SizedBox(width: 10,),
                                      Text(selectedDesinaion == null ? "Séléctionner le pays de destination" :selectedDesinaion!.paysDest.toString(), style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500
                                      ),),
                                      const SizedBox(width: 10,),
                                      const Expanded(child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.arrow_drop_down, color: Colors.black,),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text("Vous envoyez", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),),
                              const SizedBox(height: 5,),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.formFieldBorderColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (paysDestinationModel != null)
                                      Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.codePaysSrce}.png", width: 30, height: 15, fit: BoxFit.contain),
                                    const SizedBox(width: 16,),
                                    Expanded(
                                        child: TextFormField(
                                          controller: _fromController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              fromToToSens = true;
                                            });
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
                                        )
                                    ),
                                    const SizedBox(width: 10,),
                                    if (paysDestinationModel != null)
                                      Text(paysDestinationModel!.paysCodeMonnaieSrce.toString(), style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text("Votre bénéficiaire réçoit", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),),
                              const SizedBox(height: 5,),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.formFieldBorderColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (selectedDesinaion != null)
                                      Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 30, height: 15, fit: BoxFit.contain),
                                    if (selectedDesinaion != null)
                                      const SizedBox(width: 16,),
                                    Expanded(
                                        child: TextFormField(
                                          controller: _toController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              fromToToSens = false;
                                            });
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
                                        )
                                    ),
                                    const SizedBox(width: 10,),
                                    if (paysDestinationModel != null)
                                      Text(selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest.toString(), style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(bottom: 60),
                                color: Colors.white,
                                padding: const EdgeInsets.only(
                                    bottom: 20,
                                    top: 20,
                                    left: 20,
                                    right: 20
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Vous envoyez", style: TextStyle(
                                            fontSize: 12
                                        ),),
                                        Text("${_fromController.text == "" ? "-" : _fromController.text } ${paysDestinationModel!.paysCodeMonnaieSrce.toString()}", style: const TextStyle(
                                            fontWeight: FontWeight.w600
                                        ),),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Votre bénéficiaire réçoit", style: TextStyle(
                                            fontSize: 12
                                        ),),
                                        Text("${_toController.text == "" ? "-" : _toController.text } ${selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest.toString()}", style: const TextStyle(
                                            fontWeight: FontWeight.w600
                                        ),),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Frais de transfert", style: TextStyle(
                                            fontSize: 12
                                        ),),
                                        Text("0.00 ${paysDestinationModel!.paysCodeMonnaieSrce.toString()}", style: const TextStyle(
                                            fontWeight: FontWeight.w600
                                        ),),
                                      ],
                                    ),
                                    const Divider(),
                                    if (promoRabais > 0)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Rabais promo", style: TextStyle(
                                            fontSize: 12
                                        ),),
                                        Text("- $promoRabais ${paysDestinationModel!.paysCodeMonnaieSrce.toString()}", style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor
                                        ),),
                                      ],
                                    ),
                                    if (promoRabais > 0)
                                    const Divider(),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 80) * 0.7,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              label: const Text("CODE PROMO", style: TextStyle(
                                                  fontSize: 12
                                              ),),
                                              contentPadding: const EdgeInsets.all(10),
                                              fillColor: Colors.white,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                                                borderSide: BorderSide(
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              focusColor: AppColors.primaryColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                                                borderSide: BorderSide(
                                                  color: Colors.black.withOpacity(.4),
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            controller: _promoContoller,
                                            style: const TextStyle(
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (_promoContoller.text.isEmpty) {
                                              Utils.flushBarErrorMessage("Vous n'avez pas saisi un code promo", context);
                                            } else if (_fromController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez entrer les montants", context);
                                            } else {
                                              double montantSrc = promoRabais > 0 ? (double.parse(_fromController.text) - promoRabais) : double.parse(_fromController.text);
                                              setState(() {
                                                loadingPromo = true;
                                                loadingPromoSucces = false;
                                              });
                                              DemandesViewModel demandeVM = DemandesViewModel();
                                              Map data = {
                                                "codePromo": _promoContoller.text,
                                                "code_pays_srce": paysDestinationModel!.codePaysSrce.toString(),
                                                "montant": montantSrc
                                              };
                                              demandeVM.applyPromo(context, data).then((value) {
                                                setState(() {
                                                  loadingPromo = false;
                                                });
                                                if (demandeVM.applyDetail.status == Status.COMPLETED) {
                                                  _promoContoller.clear();
                                                  setState(() {
                                                    promo = true;
                                                    promoRabais = double.parse(demandeVM.applyDetail.data["reductionPromo"].toString());
                                                    loadingPromoSucces = true;
                                                  });
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                              width: (MediaQuery.of(context).size.width - 80) * 0.3,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                                color: AppColors.primaryColor,
                                              ),
                                              padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                                              child: Center(
                                                child:
                                                loadingPromo
                                                    ? const SizedBox(
                                                  width: 17, height: 17,
                                                  child: CupertinoActivityIndicator(color: Colors.white, radius: 15,),
                                                )
                                                    : loadingPromoSucces
                                                    ?
                                                const Icon(Icons.check, color: Colors.white, size: 18,) :
                                                const Text("Appliquer", style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                ),),
                                              )
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                    }
                  })
          )
      ),
      SingleChildScrollView(
        child: Container(
          color: AppColors.formFieldColor,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mode de reception", style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),),
              const SizedBox(height: 5,),
              const Text("Séléctionnez le mode de reception de votre bénéficiaire", style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
              ),),
              const SizedBox(height: 20,),
              if (selectedDesinaion != null)
                ListView.builder(
                  itemCount: selectedDesinaion!.modeRetrait!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            selectedModeRetrait = selectedDesinaion!.modeRetrait![index];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: (
                                  selectedModeRetrait != null
                                      && selectedModeRetrait!.idModeRetrait
                                      == selectedDesinaion!.modeRetrait![index].idModeRetrait
                              ) ? AppColors.primaryColor : Colors.white,
                              border: (
                                  selectedModeRetrait != null
                                      && selectedModeRetrait!.idModeRetrait
                                      == selectedDesinaion!.modeRetrait![index].idModeRetrait
                              ) ? null : Border.all(width: 1, color: AppColors.formFieldBorderColor),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: (
                                        selectedModeRetrait != null
                                            && selectedModeRetrait!.idModeRetrait
                                            == selectedDesinaion!.modeRetrait![index].idModeRetrait
                                    ) ? null : Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: (
                                            selectedModeRetrait != null
                                                && selectedModeRetrait!.idModeRetrait
                                                == selectedDesinaion!.modeRetrait![index].idModeRetrait
                                        ) ? AppColors.primaryColor : null,
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20,),
                              Text(selectedDesinaion!.modeRetrait![index].modeRetrait.toString(), style: TextStyle(
                                  fontSize: 12,
                                  color: (
                                      selectedModeRetrait != null
                                          && selectedModeRetrait!.idModeRetrait
                                          == selectedDesinaion!.modeRetrait![index].idModeRetrait
                                  ) ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.center,)
                            ],
                          ),
                        )
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      Column(
        children: [
          Container(
            color: AppColors.formFieldColor,
            padding: const EdgeInsets.only(
                bottom: 20,
                top: 20,
                left: 20,
                right: 20
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Bénéficiaire", style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),),
                const SizedBox(height: 5,),
                const Text("Séléctionnez votre bénéficiaire", style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                ),),
                const SizedBox(height: 20,),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewBeneficiaireView(destination: selectedDesinaion, parentDemandViewModel: demandesViewModel2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 3),
                            child: Icon(CupertinoIcons.add, color: Colors.white, size: 17,),
                          ),
                          SizedBox(width: 10,),
                          Text("Nouveau bénéficiaire", style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center,)
                        ],
                      ),
                    )
                )
              ],
            ),
          ),
          Expanded(child: ChangeNotifierProvider<DemandesViewModel>(
              create: (BuildContext context) => demandesViewModel2,
              child: Consumer<DemandesViewModel>(
                  builder: (context, value, _){
                    switch (value.beneficiairesList.status) {
                      case Status.LOADING:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
                            child: CupertinoActivityIndicator(color: Colors.black,),
                          ),
                        );
                      case Status.ERROR:
                        return Center(
                          child: Text(value.beneficiairesList.message.toString()),
                        );
                      default:
                        if (value.beneficiairesList.data!.length == 0) {
                          return Center(
                            child: Text(
                              "Aucun bénéficiaire enrégistré",
                              style: TextStyle(
                                color: Colors.black.withOpacity(.2),
                              ),
                            ),
                          );
                        }
                        List data = [];
                        if (value.beneficiairesList.data!.length > 0 && selectedDesinaion != null) {
                          value.beneficiairesList.data!.forEach((element) {
                            BeneficiaireModel ben = BeneficiaireModel.fromJson(element);
                            if (ben.idPays == selectedDesinaion!.idPaysDest) {
                              data.add(element);
                            }
                          });
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  BeneficiaireModel current = BeneficiaireModel.fromJson(data[index]);
                                  return InkWell(
                                      onTap: (){
                                        selectedBeneficiaire = current;
                                        _controller.nextPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.linear
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: RecipientCard2(
                                              name: "${current.nomBeneficiaire}",
                                              address: current.codePays.toString(),
                                              phone: current.telBeneficiaire.toString(),
                                            ),
                                          ),
                                        ],
                                      )
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20,),
                          ],
                        );
                    }
                  })
          ))
        ],
      ),
      if (paysDestinationModel != null)
      Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                bottom: 10,
                top: 0,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Vérifiez que les informations si dessous sont correctes puis confirmez", style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                  ),),
                ),
              ],
            ),
          ),
          if (selectedDesinaion != null)
          Column(
            children: [
              const SizedBox(height: 5,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: AppColors.formFieldColor,
                    border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Source", style: TextStyle(
                      color: Colors.black.withOpacity(.8),
                      fontSize: 12
                    ),),
                    Text("${paysDestinationModel!.paysSrce}", style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Destination", style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 12
                      ),),
                      Text("${selectedDesinaion!.paysDest}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.1),
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Montant à envoyer", style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 12
                      ),),
                      Text("${_fromController.text} ${paysDestinationModel!.paysCodeMonnaieSrce}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(.1),
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Montant à recevoir", style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 12
                      ),),
                      Text("${_toController.text} ${selectedDesinaion!.paysCodeMonnaieDest}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Frais d'envoi", style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 12
                      ),),
                      Text("0.00 ${paysDestinationModel!.paysCodeMonnaieSrce}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              if (promoRabais > 0)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rabais promo", style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 12
                      ),),
                      Text("- $promoRabais ${paysDestinationModel!.paysCodeMonnaieSrce}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldBorderColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total à payer", style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                      ),),
                      Text("${promoRabais > 0 ? (double.parse(_fromController.text) - promoRabais).toString() : _fromController.text} ${paysDestinationModel!.paysCodeMonnaieSrce}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              if (selectedModeRetrait != null)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Mode de retrait", style: TextStyle(
                        color: Colors.black.withOpacity(.8),
                        fontSize: 12,
                      ),),
                      Text("${selectedModeRetrait!.modeRetrait}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              if (selectedBeneficiaire != null)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bénéficiaire", style: TextStyle(
                        color: Colors.black.withOpacity(.8),
                        fontSize: 12,
                      ),),
                      Text("${selectedBeneficiaire!.nomBeneficiaire}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              if (selectedBeneficiaire != null)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.formFieldColor,
                      border: Border(bottom: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Téléphone", style: TextStyle(
                        color: Colors.black.withOpacity(.8),
                        fontSize: 12,
                      ),),
                      Text("${selectedBeneficiaire!.telBeneficiaire}", style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),)
                    ],
                  )
              ),
              // if (promoRabais > 0)
              //   const SizedBox(height: 5,),
              // if (promoRabais > 0)
              //   const Divider(),
              // if (promoRabais > 0)
              //   const SizedBox(height: 5,),
              // if (promoRabais > 0)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text("Rabais promo", style: TextStyle(
              //           color: Colors.green,
              //           fontWeight: FontWeight.bold
              //       ),),
              //       Text("- $promoRabais ${widget.data['source']!.paysCodeMonnaieSrce}", style: const TextStyle(
              //           fontSize: 14,
              //           color: Colors.green,
              //           fontWeight: FontWeight.bold
              //       ),)
              //     ],
              //   ),
              // const SizedBox(height: 10,),
              // Container(
              //   padding: const EdgeInsets.all(15),
              //   color: Colors.blueGrey.withOpacity(.2),
              //   child:
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("Montant à payer", style: TextStyle(
              //           color: Colors.black.withOpacity(.8),
              //           fontWeight: FontWeight.w500
              //       ),),
              //       Text("$montantSrc ${widget.data['source']!.paysCodeMonnaieSrce}", style: const TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w600
              //       ),)
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 15,),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: (MediaQuery.of(context).size.width - 40) * 0.7,
              //       child: TextFormField(
              //         decoration: InputDecoration(
              //           contentPadding: const EdgeInsets.all(10),
              //           label: const Text("CODE PROMO", style: TextStyle(
              //               fontSize: 12
              //           ),),
              //           fillColor: Colors.white,
              //           focusedBorder: OutlineInputBorder(
              //             borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
              //             borderSide: BorderSide(
              //               color: AppColors.primaryColor,
              //             ),
              //           ),
              //           focusColor: AppColors.primaryColor,
              //           enabledBorder: OutlineInputBorder(
              //             borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
              //             borderSide: BorderSide(
              //               color: Colors.black.withOpacity(.4),
              //               width: 1.0,
              //             ),
              //           ),
              //         ),
              //         controller: _promoContoller,
              //         style: const TextStyle(
              //             fontSize: 18
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         if (_promoContoller.text.isEmpty) {
              //           Utils.flushBarErrorMessage("Vous n'avez pas saisi un code promo", context);
              //         } else {
              //           setState(() {
              //             loadingPromo = true;
              //             loadingPromoSucces = false;
              //           });
              //           DemandesViewModel demandeVM = DemandesViewModel();
              //           Map data = {
              //             "codePromo": _promoContoller.text,
              //             "code_pays_srce": widget.data['source']!.codePaysSrce.toString(),
              //             "montant": montantSrc
              //           };
              //           demandeVM.applyPromo(context, data).then((value) {
              //             setState(() {
              //               loadingPromo = false;
              //             });
              //             if (demandeVM.applyDetail.status == Status.COMPLETED) {
              //               _promoContoller.clear();
              //               setState(() {
              //                 montantSrc = montantSrc - demandeVM.applyDetail.data["reductionPromo"];
              //                 promo = true;
              //                 promoRabais = double.parse(demandeVM.applyDetail.data["reductionPromo"].toString());
              //                 loadingPromoSucces = true;
              //               });
              //             }
              //           });
              //         }
              //       },
              //       child: Container(
              //           width: (MediaQuery.of(context).size.width - 40) * 0.3,
              //           decoration: BoxDecoration(
              //             borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              //             color: AppColors.primaryColor,
              //           ),
              //           padding: const EdgeInsets.only(top: 16, bottom: 16.6),
              //           child: Center(
              //             child: loadingPromo
              //                 ? const SizedBox(
              //               width: 17, height: 17,
              //               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,),
              //             )
              //                 : loadingPromoSucces
              //                 ?
              //             const Icon(Icons.check, color: Colors.white, size: 18,)
              //                 : const Text("Appliquer", style: TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.white
              //             ),),
              //           )
              //       ),
              //     )
              //   ],
              // ),
              // const SizedBox(height: 15,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Source", style: TextStyle(
              //         color: Colors.black.withOpacity(.5)
              //     ),),
              //     Text(widget.data['source']!.paysSrce.toString(), style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600
              //     ),)
              //   ],
              // ),
              // const SizedBox(height: 10,),
              // const Divider(),
              // const SizedBox(height: 5,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Destination", style: TextStyle(
              //         color: Colors.black.withOpacity(.5)
              //     ),),
              //     Text(widget.data['destination']!.paysDest.toString(), style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600
              //     ),)
              //   ],
              // ),
              // const SizedBox(height: 10,),
              // const Divider(),
              // const SizedBox(height: 5,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Bénéficiaire", style: TextStyle(
              //         color: Colors.black.withOpacity(.5)
              //     ),),
              //     Text(widget.data['beneficiaire']!.nomBeneficiaire.toString(), style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600
              //     ),)
              //   ],
              // ),
              // const SizedBox(height: 10,),
              // const Divider(),
              // const SizedBox(height: 5,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Téléphone", style: TextStyle(
              //         color: Colors.black.withOpacity(.5)
              //     ),),
              //     Text(widget.data['beneficiaire']!.telBeneficiaire.toString(), style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600
              //     ),)
              //   ],
              // ),
              // const SizedBox(height: 10,),
              // const Divider(),
              // const SizedBox(height: 5,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Montant bénéficiaire", style: TextStyle(
              //         color: Colors.black.withOpacity(.5)
              //     ),),
              //     Text("$montantDest ${widget.data['destination']!.paysCodeMonnaieDest}", style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600
              //     ),)
              //   ],
              // ),
              // if (widget.data['mode_retrait'] != null)
              //   const SizedBox(height: 10,),
              // if (widget.data['mode_retrait'] != null)
              //   const Divider(),
              // if (widget.data['mode_retrait'] != null)
              //   const SizedBox(height: 5,),
              // if (widget.data['mode_retrait'] != null)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("Mode de retrait", style: TextStyle(
              //           color: Colors.black.withOpacity(.5)
              //       ),),
              //       Text(widget.data['mode_retrait'], style: const TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w600
              //       ),)
              //     ],
              //   ),
              // const SizedBox(height: 15,),
              //
              // Row(
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         Navigator.pop(context);
              //       },
              //       child: Container(
              //           width: (MediaQuery.of(context).size.width - 40) * 0.5,
              //           decoration: BoxDecoration(
              //             borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              //             color: AppColors.primaryColor,
              //           ),
              //           padding: const EdgeInsets.only(top: 16, bottom: 16.6),
              //           child: const Center(
              //             child: Text("Annuler", style: TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.white
              //             ),),
              //           )
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         double source = 0;
              //         double destination = 0;
              //
              //         if (fromToSens) {
              //           source = montantSrc;
              //           if (promo) {
              //             destination = (montantSrc + promoRabais) * rate;
              //           } else {
              //             destination = montantSrc * rate;
              //           }
              //         } else {
              //           if (promo) {
              //             source = (montantDest / rate) - promoRabais;
              //           } else {
              //             source = montantDest / rate;
              //           }
              //           destination = montantDest;
              //         }
              //
              //         if (!loading) {
              //           setState(() {
              //             loading = true;
              //           });
              //           Map data2 = {
              //             "idBeneficiaire": widget.data["idBeneficiaire"],
              //             "codePromo": _promoContoller.text,
              //             "code_pays_srce": widget.data["code_pays_srce"],
              //             "montant_srce": source,
              //             "montant_dest": destination,
              //             "code_pays_dest": widget.data["code_pays_dest"],
              //             "id_mode_retrait": widget.data["id_mode_retrait"],
              //           };
              //
              //           demandesViewModel.transfert(data2, context).then((value) {
              //             setState(() {
              //               loading = false;
              //             });
              //           });
              //         }
              //       },
              //       child: Container(
              //           width: (MediaQuery.of(context).size.width - 40) * 0.5,
              //           decoration: BoxDecoration(
              //             borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              //             color: Colors.black.withOpacity(.9),
              //           ),
              //           padding: loading ? const EdgeInsets.only(top: 9.7, bottom: 9.7) : const EdgeInsets.only(top: 16, bottom: 16.6),
              //           child: Center(
              //             child: !loading ? const Text("Confirmer", style: TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.white
              //             ),): Image.asset("assets/loader_btn.gif", width: 30),
              //           )
              //       ),
              //     )
              //   ],
              // ),
            ],
          )
        ],
      ),
    ] ;

    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                context: context,
                backArrow: true,
                appBarColor: Colors.white,
                // backClick: () {
                //   if (step > 0) {
                //     _controller.previousPage(
                //         duration: const Duration(milliseconds: 300),
                //         curve: Curves.linear
                //     );
                //   } else {
                //     Navigator.pop(context);
                //   }
                // }
              ),
              Center(child: Image.asset("assets/logo_black.png", width: 30,)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.formFieldBorderColor,
                  borderRadius: BorderRadius.circular(2)
                ),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 5,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.25 * (step + 1),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(2)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: Text(step == 0 ? "Montant et pays" : (
                  step == 1 ? "Mode de reception" : ( step == 2 ? "Bénéficiaire" : "Terminer")
                ), style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w400
                ),),
              ),
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pages.length,
                      onPageChanged:_onChanged,
                      itemBuilder: (context, int index) {
                        return pages[index];
                      },
                    ),
                    if (step != 2)
                    Positioned(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: RoundedButton(
                            onPress: () {
                              if (currentFocus != null) {
                                currentFocus!.unfocus();
                              }
                              if (step == 0) {
                                if (selectedDesinaion == null) {
                                  Utils.flushBarErrorMessage("Vous devez séléctionner un pays de destination", context);
                                } else if (_fromController.text.isEmpty) {
                                  Utils.flushBarErrorMessage("Vous devez entrer le montant", context);
                                } else {
                                  _controller.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.linear
                                  );
                                }
                              } else if (step == 1) {
                                if (selectedModeRetrait == null) {
                                  Utils.flushBarErrorMessage("Vous devez séléctionner le mode de retrait", context);
                                } else {
                                  _controller.nextPage(
                                      duration: const Duration(
                                          milliseconds: 300),
                                      curve: Curves.linear
                                  );
                                }
                              } else if (step == 3) {
                                DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                if (!loading) {
                                  setState(() {
                                    loading = true;
                                  });

                                  Map data2 = {
                                    "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire,
                                    "codePromo": _promoContoller.text,
                                    "code_pays_srce": paysDestinationModel!.codePaysSrce,
                                    "montant_srce": promoRabais > 0 ? double.parse(_fromController.text) - promoRabais : _fromController.text,
                                    "montant_dest": _toController.text,
                                    "code_pays_dest": selectedDesinaion!.codePaysDest,
                                    "id_mode_retrait": selectedModeRetrait!.idModeRetrait,
                                  };

                                  demandesViewModel3.transfert(data2, context).then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }
                              }
                            },
                            title: step < 3 ? "Continuer": "Confimer et payer",
                            loading: loading,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}