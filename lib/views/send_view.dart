import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/model/beneficiaire_model.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/motif_model.dart';
import 'package:mardona/model/pays_destination_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:mardona/view_model/pin_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mardona/views/send_confirm_view.dart';
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
  MotifModel? selectedMotif;
  List beneficiaires = [];
  BeneficiaireModel? selectedBeneficiaire;
  bool fromToToSens = true;
  DemandesViewModel demandesViewModel = DemandesViewModel();
  DemandesViewModel demandesViewModel2 = DemandesViewModel();
  DemandesViewModel demandesViewModel3 = DemandesViewModel();
  DemandesViewModel demandesViewModel4 = DemandesViewModel();

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
    demandesViewModel3.motifs(context);

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
        }, title: "Faire un transfert",),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: ChangeNotifierProvider<DemandesViewModel>(
            create: (BuildContext context) => demandesViewModel,
            child: Consumer<DemandesViewModel>(
              builder: (context, value, _){
                switch (value.paysDestination.status) {
                  case Status.LOADING:
                    return const Center(
                      child: CupertinoActivityIndicator(color: Colors.black,),
                    );
                  case Status.ERROR:
                    return const Center(
                      child: Text("Une erreur est survenue"),
                    );
                  default:
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 20),
                            child: pageTitleStyle(title: "Un transfert chap et instantané !", context: context),
                          ),
                          Column(
                            children: [
                              ChangeNotifierProvider<DemandesViewModel>(
                                  create: (BuildContext context) => demandesViewModel,
                                  child: Consumer<DemandesViewModel>(
                                      builder: (context, value, _){
                                        switch (value.paysDestination.status) {
                                          case Status.LOADING:
                                            return const Center(
                                              child: CupertinoActivityIndicator(color: Colors.black,),
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
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppTexts.cardDescription("Destination", color: AppColors.textGrey),
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
                                                            top: Radius.circular(0),
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
                                                        children: [
                                                          if (selectedDesinaion != null)
                                                            Image.asset("assets/flag.png"),
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
                                                ],
                                              ),
                                            );
                                        }
                                      })
                              ),
                              const SizedBox(height: 10,),
                              ChangeNotifierProvider<DemandesViewModel>(
                                  create: (BuildContext context) => demandesViewModel2,
                                  child: Consumer<DemandesViewModel>(
                                      builder: (context, value, _){
                                        switch (value.beneficiairesList.status) {
                                          case Status.LOADING:
                                            return const Center(
                                              child: CupertinoActivityIndicator(color: Colors.black,),
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
                                                  data.add(ben);
                                                }
                                              });
                                            }

                                            return Container(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppTexts.cardDescription("Beneficiaire", color: AppColors.textGrey),
                                                  const SizedBox(height: 5,),
                                                  InkWell(
                                                    onTap: () {
                                                      if (selectedDesinaion == null) {
                                                        Utils.toastMessage("Veuillez selectionner une destination");
                                                      } else {
                                                        showModalBottomSheet(
                                                          backgroundColor: AppColors.bgColor,
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    AppTexts.titleText("Séléctionnez un beneficiaire"),
                                                                    const SizedBox(height: 20,),
                                                                    Expanded(child: ListView.builder(
                                                                      itemCount: data.length,
                                                                      itemBuilder: (context, index) {
                                                                        BeneficiaireModel current = data[index];
                                                                        return InkWell(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                selectedBeneficiaire = current;
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
                                                                                  Container(
                                                                                    width: 20, height: 20,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(40),
                                                                                        border: Border.all(width: 5,
                                                                                            color: selectedBeneficiaire != null
                                                                                                && selectedBeneficiaire!.idBeneficiaire == current.idBeneficiaire ?
                                                                                            AppColors.accentColor
                                                                                                : AppColors.formFieldBorderColor)
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(width: 10,),
                                                                                  AppTexts.bodyText(current.nomBeneficiaire!, color: AppColors.textGrey)
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
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                      child: Row(
                                                        children: [
                                                          AppTexts.smallText(selectedBeneficiaire == null ? "Séléctionner un beneficiaire" :selectedBeneficiaire!.nomBeneficiaire!, color: selectedBeneficiaire == null ? Colors.black : AppColors.accentColor),
                                                          const SizedBox(width: 10,),
                                                          const Expanded(child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Icon(Icons.arrow_drop_down, color: Colors.black,),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                        }
                                      })
                              ),
                              const SizedBox(height: 10,),
                              ChangeNotifierProvider<DemandesViewModel>(
                                  create: (BuildContext context) => demandesViewModel3,
                                  child: Consumer<DemandesViewModel>(
                                      builder: (context, value, _){
                                        switch (value.motifsList.status) {
                                          case Status.LOADING:
                                            return const Center(
                                              child: CupertinoActivityIndicator(color: Colors.black,),
                                            );
                                          case Status.ERROR:
                                            return Center(
                                              child: Text(value.motifsList.message.toString()),
                                            );
                                          default:
                                            if (value.motifsList.data!.length == 0) {
                                              return Center(
                                                child: Text(
                                                  "Empty",
                                                  style: TextStyle(
                                                    color: Colors.black.withOpacity(.2),
                                                  ),
                                                ),
                                              );
                                            }
                                            List data = [];
                                            if (value.motifsList.data!.length > 0) {
                                              value.motifsList.data!.forEach((element) {
                                                MotifModel motif = MotifModel.fromJson(element);
                                                data.add(motif);
                                              });
                                            }

                                            return Container(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppTexts.cardDescription("Motif du transfert", color: AppColors.textGrey),
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
                                                                  AppTexts.titleText("Séléctionnez le motif du transfert"),
                                                                  const SizedBox(height: 20,),
                                                                  Expanded(child: ListView.builder(
                                                                    itemCount: data.length,
                                                                    itemBuilder: (context, index) {
                                                                      MotifModel current = data[index];
                                                                      return InkWell(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              selectedMotif = current;
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
                                                                                Container(
                                                                                  width: 20, height: 20,
                                                                                  decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(40),
                                                                                      border: Border.all(width: 5,
                                                                                          color: selectedMotif != null
                                                                                              && selectedMotif!.idMotif == current.idMotif ?
                                                                                          AppColors.accentColor
                                                                                              : AppColors.formFieldBorderColor)
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 10,),
                                                                                AppTexts.bodyText(current.motif!, color: AppColors.textGrey)
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
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                      child: Row(
                                                        children: [
                                                          AppTexts.smallText(selectedMotif == null ? "Séléctionner le motif du transfert" :selectedMotif!.motif!, color: selectedMotif == null ? Colors.black : AppColors.accentColor),
                                                          const SizedBox(width: 10,),
                                                          const Expanded(child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Icon(Icons.arrow_drop_down, color: Colors.black,),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                        }
                                      })
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTexts.cardDescription("Mode de retrait", color: AppColors.textGrey),
                                    const SizedBox(height: 5,),
                                    InkWell(
                                      onTap: () {
                                        if (selectedDesinaion == null) {
                                          Utils.toastMessage("Veuillez séléctionner le pays de destination");
                                        } else {
                                          showModalBottomSheet(
                                            backgroundColor: AppColors.bgColor,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      AppTexts.titleText("Séléctionnez le Mode de retrait"),
                                                      const SizedBox(height: 20,),
                                                      Expanded(child: ListView.builder(
                                                        itemCount: selectedDesinaion!.modeRetrait!.length,
                                                        itemBuilder: (context, index) {
                                                          ModeRetrait current = selectedDesinaion!.modeRetrait![index];
                                                          return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedModeRetrait = current;
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
                                                                    Container(
                                                                      width: 20, height: 20,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(40),
                                                                          border: Border.all(width: 5,
                                                                              color: selectedModeRetrait != null
                                                                                  && selectedModeRetrait!.idModeRetrait == current.idModeRetrait ?
                                                                              AppColors.accentColor
                                                                                  : AppColors.formFieldBorderColor)
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 10,),
                                                                    AppTexts.bodyText(current.modeRetrait!, color: AppColors.textGrey)
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
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Row(
                                          children: [
                                            AppTexts.smallText(selectedModeRetrait == null ? "Séléctionner le mode de retrait" :selectedModeRetrait!.modeRetrait!, color: selectedModeRetrait == null ? Colors.black : AppColors.accentColor),
                                            const SizedBox(width: 10,),
                                            const Expanded(child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.arrow_drop_down, color: Colors.black,),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTexts.cardDescription("Vous envoyez", bold: true, color: Colors.black),
                                    const SizedBox(height: 5,),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: AppColors.textGrey, width: 1),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTexts.cardDescription("Elle réçoit", bold: true, color: Colors.black),
                                    const SizedBox(height: 5,),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: AppColors.textGrey, width: 1),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTexts.cardDescription("Saisissez un code promo", color: AppColors.textGrey),
                                    const SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: SizedBox(
                                                width: (MediaQuery.of(context).size.width - 15) * 0.7,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.red,
                                                    border: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedErrorBorder: InputBorder.none,
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
                                          ],
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              // if (selectedDesinaion != null && paysDestinationModel != null)
                              //   AppTexts.bodyText("1 ${paysDestinationModel!.paysCodeMonnaieSrce} = ${selectedDesinaion!.rate} ${selectedDesinaion!.paysCodeMonnaieDest}", bold: true),
                              // if (selectedDesinaion != null && paysDestinationModel != null)
                              //   const SizedBox(height: 5,),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     const Icon(Icons.info_outline_rounded, size: 15, color: Colors.red,),
                              //     const SizedBox(width: 5,),
                              //     Flexible(child: AppTexts.smallText(" utilise son propre taux de change!")),
                              //   ],
                              // ),
                              const SizedBox(height: 15,),
                              commonRoundedContainer(
                                removePaddingH: true,
                                child: Column(
                                  children: [
                                    if (paysDestinationModel != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppTexts.cardDescription("Frais de transfert", color: AppColors.textGrey),
                                            AppTexts.cardDescription("$tauxTransfert ${paysDestinationModel!.paysCodeMonnaieSrce}")
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTexts.bodyText("Montant total", bold: true, color: AppColors.accentColor),
                                          if (paysDestinationModel != null)
                                          AppTexts.bodyText("${_fromController.text == "" ? "-" : _fromController.text } ${paysDestinationModel!.paysCodeMonnaieSrce}", bold: true, color: AppColors.accentColor)
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
                              Container(
                                color: AppColors.bgColor,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: RoundedButton(
                                  onPress: () {
                                    FocusScope.of(context).unfocus();
                                    if (currentFocus != null) {
                                      currentFocus!.unfocus();
                                    }
                                    if (selectedDesinaion == null) {
                                      Utils.flushBarErrorMessage("Vous devez séléctionner un pays de destination", context);
                                    } else if (_fromController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer le montant", context);
                                    } else if (selectedModeRetrait == null) {
                                      Utils.flushBarErrorMessage("Vous devez séléctionner le mode de retrait", context);
                                    } else {
                                      DemandesViewModel demandesViewModel3 = DemandesViewModel();
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
                                        "beneficiaire": selectedBeneficiaire!,
                                        "destination": paysDestinationModel!,
                                        "selected_destination": selectedDesinaion!,
                                        "codePromo": promoCode,
                                        "code_pays_srce": paysDestinationModel!.codePaysSrce,
                                        "montant_srce": fromAmount,
                                        "montant_dest": toAmount,
                                        "code_pays_dest": selectedDesinaion!.codePaysDest,
                                        "id_mode_retrait": selectedModeRetrait!.idModeRetrait,
                                        "mode_retrait": selectedModeRetrait!,
                                        "taux" : tauxTransfert,
                                        "promo_rabais": promoRabais
                                      };
                                      Navigator.push(context, CupertinoPageRoute(builder: (route) => SendConfirmView(data: data2)));
                                      // demandesViewModel3.transfert(data2, context, transfer: paysDestinationModel!.codePaysSrce != "cd").then((value) {
                                      //   setState(() {
                                      //     loading = false;
                                      //   });
                                      // });
                                    }
                                  },
                                  title: "Continuer",
                                  loading: loading,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                }
              }
            ),
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