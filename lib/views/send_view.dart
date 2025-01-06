import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/views/new_beneficiaire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
  int steps = 4;
  final PageController _controller = PageController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  FocusNode? currentFocus = FocusManager.instance.primaryFocus;
  PaysDestinationModel? paysDestinationModel;
  Destination? selectedDesinaion;
  ModeRetrait?  selectedModeRetrait;
  List? beneficiaires;
  BeneficiaireModel? selectedBeneficiaire;
  bool fromToToSens = true;
  DemandesViewModel demandesViewModel = DemandesViewModel();
  DemandesViewModel demandesViewModel2 = DemandesViewModel();

  PinViewModel pinViewModel = PinViewModel();

  double tauxTransfert = 0.0;

  bool loadBeneficiaire = false;
  bool loadedDestination = false;
  bool loadedModeRetrait = false;

  bool vmCalled = false;

  bool loading = false;
  bool loadingPromo = false;
  bool loadingPromoSucces = false;
  bool load = false;
  final TextEditingController _promoContoller = TextEditingController();

  bool promo = false;
  double promoRabais = 0;
  String promoCode = '';

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
    demandesViewModel.myDestinationsApi([], context);
    demandesViewModel2.beneficiaires([], context);
    super.initState();
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
                        if (!loadBeneficiaire) {
                          if (widget.beneficiaire != null) {
                            selectedBeneficiaire = widget.beneficiaire;
                            for (var element in paysDestinationModel!.destination!) {
                              if (element.idPaysDest == widget.beneficiaire!.idPays) {
                                selectedDesinaion = element;
                                for (var rMode in element.modeRetrait!) {
                                  if (widget.beneficiaire!.id_mode_retrait == rMode.idModeRetrait) {
                                    selectedModeRetrait = rMode;
                                  }
                                }
                              }
                            }
                          }
                          if (widget.amount != null) {
                            insert(widget.amount, _fromController);
                          }
                          loadBeneficiaire = true;
                        }

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
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                            left: 20,
                            right: 20,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.formFieldColor, width: 1)
                            )
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTexts.descriptionText("Destination"),
                              const SizedBox(height: 5,),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: AppColors.bgColor,
                                    context: context,
                                    builder: (context) {
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
                                                        child: Row(
                                                          children: [
                                                            Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.destination![index].codePaysDest}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                            const SizedBox(width: 20,),
                                                            AppTexts.bodyText(paysDestinationModel!.destination![index].paysDest.toString(), bold: true)
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
                                        top: Radius.circular(0),
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
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Row(
                                    children: [
                                      if (selectedDesinaion != null)
                                        Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 30, height: 15, fit: BoxFit.contain),
                                      if (selectedDesinaion != null)
                                        const SizedBox(width: 10,),
                                      AppTexts.smallText(selectedDesinaion == null ? "Séléctionner le pays de destination" :selectedDesinaion!.paysDest.toString()),
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
                              AppTexts.descriptionText("Vous envoyez"),
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
                                                setState(() {
                                                  tauxTransfert = double.parse(_fromController.text) * (selectedDesinaion!.taux_transfert! / 100);
                                                });
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
                                          style: GoogleFonts.poppins(
                                            fontSize: 18, fontWeight: FontWeight.bold
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
                              AppTexts.descriptionText("Votre bénéficiaire réçoit"),
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
                                            setState(() {
                                              tauxTransfert = double.parse(_fromController.text) * (selectedDesinaion!.taux_transfert! / 100);
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "0.00",
                                              contentPadding: EdgeInsets.zero
                                          ),
                                          style: GoogleFonts.poppins(
                                              fontSize: 18, fontWeight: FontWeight.bold
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
                              const SizedBox(height: 10,),
                              if (selectedDesinaion != null && paysDestinationModel != null)
                                AppTexts.bodyText("1 ${paysDestinationModel!.paysCodeMonnaieSrce} = ${selectedDesinaion!.rate} ${selectedDesinaion!.paysCodeMonnaieDest}", bold: true),
                              if (selectedDesinaion != null && paysDestinationModel != null)
                              const SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.info_outline_rounded, size: 15, color: Colors.red,),
                                  const SizedBox(width: 5,),
                                  Flexible(child: AppTexts.smallText("ChapChap utilise son propre taux de change!")),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              commonRoundedContainer(
                                removePaddingH: true,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTexts.smallText("Vous envoyez"),
                                          AppTexts.buttonText("${_fromController.text == "" ? "-" : _fromController.text } ${paysDestinationModel!.paysCodeMonnaieSrce.toString()}")
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    commonDivider(),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTexts.smallText("Votre bénéficiaire réçoit"),
                                          AppTexts.buttonText("${_toController.text == "" ? "-" : _toController.text } ${selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest.toString()}")
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    commonDivider(),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTexts.smallText("Frais de transfert"),
                                          AppTexts.buttonText("$tauxTransfert ${paysDestinationModel!.paysCodeMonnaieSrce}")
                                        ],
                                      ),
                                    ),
                                    // if (promoRabais > 0)
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     const Text("Rabais promo", style: TextStyle(
                                    //         fontSize: 12
                                    //     ),),
                                    //     Text("- $promoRabais ${paysDestinationModel!.paysCodeMonnaieSrce.toString()}", style: TextStyle(
                                    //         fontWeight: FontWeight.w600,
                                    //         color: AppColors.primaryColor
                                    //     ),),
                                    //   ],
                                    // ),
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
              AppTexts.descriptionText("Séléctionnez le mode de reception de votre bénéficiaire"),
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
                              AppTexts.cardTitle(selectedDesinaion!.modeRetrait![index].modeRetrait.toString()
                              , color: (
                                      selectedModeRetrait != null
                                          && selectedModeRetrait!.idModeRetrait
                                          == selectedDesinaion!.modeRetrait![index].idModeRetrait
                                  ) ? Colors.white : Colors.black)
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
                AppTexts.descriptionText("Séléctionnez votre bénéficiaire"),
                const SizedBox(height: 20,),
                RoundedButton(
                  title: "Nouveau bénéficiaire",
                  icon: CupertinoIcons.add,
                  color: AppColors.buttonBlackColor,
                  textColor: Colors.white,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewBeneficiaireView(destination: selectedDesinaion, parentDemandViewModel: demandesViewModel),
                      ),
                    );
                  }
                ),
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
                                          RecipientCard2(
                                            name: "${current.nomBeneficiaire}",
                                            address: current.codePays.toString(),
                                            phone: current.telBeneficiaire.toString(),
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
          if (selectedDesinaion != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: commonRoundedContainer(
              removePaddingAll: true,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.smallText("Source"),
                        AppTexts.bodyText("${paysDestinationModel!.paysSrce}", bold: true)
                      ],
                    ),
                  ),
                  commonDivider(),
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Destination"),
                          AppTexts.bodyText("${selectedDesinaion!.paysDest}", bold: true)
                        ],
                      )
                  ),
                  commonDivider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.black.withOpacity(.02),
                          child: SizedBox(
                            width: (MediaQuery.of(context).size.width - 55) * 0.7,
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: AppTexts.descriptionText("Code promo"),
                                fillColor: AppColors.formFieldColor,
                                border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor)),
                                disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor)),
                                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor)),
                                focusedBorder: InputBorder.none,
                                focusColor: AppColors.primaryColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              controller: _promoContoller,
                              style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
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
                                promoCode = _promoContoller.text;
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
                              width: (MediaQuery.of(context).size.width - 55) * 0.3 - 20,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14,),
                              child: Center(
                                child:
                                loadingPromo
                                    ? const SizedBox(
                                  width: 17, height: 17,
                                  child: CupertinoActivityIndicator(color: Colors.white, radius: 10,),
                                )
                                    : loadingPromoSucces
                                    ?
                                const Icon(Icons.check, color: Colors.white, size: 18,) :
                                    AppTexts.smallText("Appliquer", color: Colors.white),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  commonDivider(),
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Montant à envoyer"),
                          AppTexts.bodyText("${_fromController.text} ${paysDestinationModel!.paysCodeMonnaieSrce}", bold: true),
                        ],
                      )
                  ),
                  commonDivider(),
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Montant à recevoir"),
                          AppTexts.bodyText("${_toController.text} ${selectedDesinaion!.paysCodeMonnaieDest}", bold: true),
                        ],
                      )
                  ),
                  commonDivider(),
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Frais de transfert"),
                          AppTexts.bodyText("$tauxTransfert ${paysDestinationModel!.paysCodeMonnaieSrce}", bold: true),
                        ],
                      )
                  ),
                  commonDivider(),
                  if (promoRabais > 0)
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.cardTitle("Rabais promo"),
                          AppTexts.cardTitle("- $promoRabais ${paysDestinationModel!.paysCodeMonnaieSrce}"),
                        ],
                      )
                  ),
                  if (promoRabais > 0)
                    commonDivider(),
                  if (_fromController.text != "" && isDouble(_fromController.text))
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Total à payer", color: AppColors.primaryColor),
                          AppTexts.titleText("${promoRabais > 0 ? (double.parse(_fromController.text) - promoRabais + tauxTransfert).toString() : tauxTransfert + double.parse(_fromController.text)} ${paysDestinationModel!.paysCodeMonnaieSrce}", color: AppColors.primaryColor),
                        ],
                      )
                  ),
                  commonDivider(),
                  if (selectedModeRetrait != null)
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Mode de retrait"),
                          AppTexts.cardTitle("${selectedModeRetrait!.modeRetrait}"),
                        ],
                      )
                  ),
                  if (selectedModeRetrait != null)
                    commonDivider(),
                  if (selectedBeneficiaire != null)
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Bénéficiaire"),
                          AppTexts.cardTitle("${selectedBeneficiaire!.nomBeneficiaire}"),
                        ],
                      )
                  ),
                  if (selectedBeneficiaire != null)
                    commonDivider(),
                  if (selectedBeneficiaire != null)
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText("Téléphone"),
                          AppTexts.cardTitle("${selectedBeneficiaire!.telBeneficiaire}"),
                        ],
                      )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ] ;

    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CommonAppBar(context: context, backArrow: true, backClick: () {
          if (step > 0) {
            _controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear
            );
          } else {
            Navigator.pop(context);
          }
        },),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset("assets/logo_black.png", width: 25,)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.formFieldBorderColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 5,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (1 / steps) * (step + 1),
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
                child: AppTexts.buttonText(step == 0 ? "Montant et pays" : (
                step == 1 ? "Mode de reception" : ( step == 2 ? "Bénéficiaire" : "Terminer")),)
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
                        color: AppColors.bgColor,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedButton(
                                onPress: () {
                                  FocusScope.of(context).unfocus();
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
                                      if (widget.beneficiaire != null) {
                                        _controller.animateToPage(
                                          3,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.linear,
                                        );
                                      } else {
                                        _controller.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.linear
                                        );
                                      }
                                    }
                                  } else if (step == 3) {
                                    DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                    if (!loading) {
                                      setState(() {
                                        loading = true;
                                      });

                                      double fromAmount = 0;
                                      double toAmount = 0;

                                      if (fromToToSens) {
                                        fromAmount = double.parse(_fromController.text);
                                        toAmount = fromAmount * double.parse(selectedDesinaion!.rate.toString());
                                      } else {
                                        toAmount = double.parse(_toController.text);
                                        fromAmount = toAmount / double.parse(selectedDesinaion!.rate.toString());
                                      }
                                      fromAmount += tauxTransfert;

                                      if (promoRabais > 0) {
                                        fromAmount -= promoRabais;
                                      }

                                      Map data2 = {
                                        "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire,
                                        "codePromo": promoCode,
                                        "code_pays_srce": paysDestinationModel!.codePaysSrce,
                                        "montant_srce": fromAmount,
                                        "montant_dest": toAmount,
                                        "code_pays_dest": selectedDesinaion!.codePaysDest,
                                        "id_mode_retrait": selectedModeRetrait!.idModeRetrait,
                                      };
                                      demandesViewModel3.transfert(data2, context, transfer: paysDestinationModel!.codePaysSrce != "cd").then((value) {
                                        setState(() {
                                          loading = false;
                                        });
                                        if (paysDestinationModel!.codePaysSrce == "cd") {
                                          Navigator.pushNamed(context, RoutesName.drcPayment, arguments: {
                                            'idDemande': value['data']['id_demande'],
                                            'nomBeneficiaire': value['data']['beneficiaire'],
                                            'montant': "$fromAmount ${paysDestinationModel!.paysCodeMonnaieSrce}",
                                          });
                                        }
                                      });
                                    }
                                  }
                                },
                                title: step < 3 ? "Continuer": "Confirmer & Payer",
                                loading: loading,
                              ),
                              if (step == 3)
                              const SizedBox(width: 5,),
                              if (step == 3)
                              RoundedButton(
                                color: AppColors.buttonBlackColor,
                                textColor: Colors.white,
                                icon: Icons.wallet_outlined,
                                onPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      String? pin;
                                      return Dialog(
                                        backgroundColor: AppColors.bgColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(
                                                20)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical: 30,
                                              horizontal: 30),
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min,
                                            children: [
                                              Icon(
                                                Icons.info_outline_rounded,
                                                color: AppColors.buttonBlackColor,
                                                size: 60,
                                              ),
                                              AppTexts.titleText("Code PIN"),
                                              AppTexts.descriptionText("Les transactions par wallet sont protégées par Code PIN. Veuillez entrer votre Code PIN"),
                                              const SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      pinViewModel.resetPin(context);
                                                    },
                                                    child: AppTexts.bodyText("Code PIN oublié ?", bold: true),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              PinCodeTextField(
                                                length: 5,
                                                obscureText: true,
                                                animationType: AnimationType.fade,
                                                animationDuration: const Duration(milliseconds: 300),
                                                keyboardType: TextInputType.number,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                cursorColor: Colors.black,
                                                showCursor: true,
                                                pinTheme: PinTheme(
                                                    shape: PinCodeFieldShape.box,
                                                    borderRadius: BorderRadius.circular(10),
                                                    fieldHeight: 50,
                                                    fieldWidth: 50,
                                                    errorBorderColor: Colors.black45,
                                                    inactiveColor: AppColors.formFieldBorderColor,
                                                    activeColor: AppColors.textGrey,
                                                    selectedColor: AppColors.textGrey
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    pin = value;
                                                  });
                                                },
                                                appContext: context,
                                              ),
                                              if (!loading)
                                                RoundedButton(
                                                  loading: loading,
                                                  title: "Valider", onPress: () async {
                                                  if (pin =="") {
                                                    Utils
                                                        .flushBarErrorMessage(
                                                        "Vous devez entrer le code PIN",
                                                        context);
                                                  } else {
                                                    DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                    if (!loading) {
                                                      setState(() {
                                                        loading = true;
                                                      });

                                                      double fromAmount = 0;
                                                      double toAmount = 0;

                                                      if (fromToToSens) {
                                                        fromAmount = double.parse(_fromController.text);
                                                        toAmount = fromAmount * double.parse(selectedDesinaion!.rate.toString());
                                                      } else {
                                                        toAmount = double.parse(_toController.text);
                                                        fromAmount = toAmount / double.parse(selectedDesinaion!.rate.toString());
                                                      }
                                                      fromAmount += tauxTransfert;

                                                      if (promoRabais > 0) {
                                                        fromAmount -= promoRabais;
                                                      }

                                                      Map data2 = {
                                                        "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire,
                                                        "codePromo": promoCode,
                                                        "code_pays_srce": paysDestinationModel!.codePaysSrce,
                                                        "montant_srce": fromAmount,
                                                        "montant_dest": toAmount,
                                                        'code_pin': pin,
                                                        "code_pays_dest": selectedDesinaion!.codePaysDest,
                                                        "id_mode_retrait": selectedModeRetrait!.idModeRetrait,
                                                      };
                                                      demandesViewModel3.transfert(data2, context, transfer: paysDestinationModel!.codePaysSrce != "cd", wallet: true).then((value) {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        if (paysDestinationModel!.codePaysSrce == "cd") {
                                                          Navigator.pushNamed(context, RoutesName.drcPayment, arguments: {
                                                            'idDemande': value['data']['id_demande'],
                                                            'nomBeneficiaire': value['data']['beneficiaire'],
                                                            'montant': "$fromAmount ${paysDestinationModel!.paysCodeMonnaieSrce}",
                                                          });
                                                        }
                                                      });
                                                    }
                                                  }
                                                },
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                title: "Avec Portefeuille",
                                loading: loading,
                              ),
                            ],
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

  bool isDouble(String value) {
    final doubleNumber = double.tryParse(value);
    return doubleNumber != null;
  }

}