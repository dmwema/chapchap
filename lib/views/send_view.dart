import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/NewBeneficiaireForm.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
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
  PaysDestinationModel? paysDestinationModel;
  Destination? selectedDesinaion;
  ModeRetrait?  selectedModeRetrait;
  List? beneficiaires;
  BeneficiaireModel? selectedBeneficiaire;
  bool fromToToSens = true;

  bool loadBeneficiaire = false;
  bool loadedDestination = false;
  bool loadedModeRetrait = false;

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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Rabais promo", style: TextStyle(
                                            fontSize: 12
                                        ),),
                                        Text("- 0.00 ${paysDestinationModel!.paysCodeMonnaieSrce.toString()}", style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor
                                        ),),
                                      ],
                                    ),
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
                                            // controller: _promoContoller,
                                            style: const TextStyle(
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // if (_promoContoller.text.isEmpty) {
                                            //   Utils.flushBarErrorMessage("Vous n'avez pas saisi un code promo", context);
                                            // } else {
                                            //   setState(() {
                                            //     loadingPromo = true;
                                            //     loadingPromoSucces = false;
                                            //   });
                                            //   DemandesViewModel demandeVM = DemandesViewModel();
                                            //   Map data = {
                                            //     "codePromo": _promoContoller.text,
                                            //     "code_pays_srce": widget.data['source']!.codePaysSrce.toString(),
                                            //     "montant": montantSrc
                                            //   };
                                            //   demandeVM.applyPromo(context, data).then((value) {
                                            //     setState(() {
                                            //       loadingPromo = false;
                                            //     });
                                            //     if (demandeVM.applyDetail.status == Status.COMPLETED) {
                                            //       _promoContoller.clear();
                                            //       setState(() {
                                            //         montantSrc = montantSrc - demandeVM.applyDetail.data["reductionPromo"];
                                            //         promo = true;
                                            //         promoRabais = double.parse(demandeVM.applyDetail.data["reductionPromo"].toString());
                                            //         loadingPromoSucces = true;
                                            //       });
                                            //     }
                                            //   });
                                            // }
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
                                                // loadingPromo
                                                //     ? const SizedBox(
                                                //   width: 17, height: 17,
                                                //   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,),
                                                // )
                                                //     : loadingPromoSucces
                                                //     ?
                                                // const Icon(Icons.check, color: Colors.white, size: 18,) :
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
                              // Container(
                              //     padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                              //         borderRadius: BorderRadius.circular(10)
                              //     ),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Row(
                              //           crossAxisAlignment: CrossAxisAlignment.center,
                              //           mainAxisAlignment: MainAxisAlignment.start,
                              //           children: [
                              //             Text(selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest.toString(), style: const TextStyle(
                              //               fontWeight: FontWeight.w600,
                              //               fontSize: 18,
                              //             ),),
                              //             const SizedBox(width: 10,),
                              //             Expanded(child: TextFormField(
                              //               controller: _toController,
                              //               keyboardType: TextInputType.number,
                              //               onChanged: (value) {
                              //                 setState(() {
                              //                   fromToToSens = false;
                              //                 });
                              //                 if (selectedDesinaion != null) {
                              //                   if (value != "") {
                              //                     insert(double.parse(value) / double.parse(selectedDesinaion!.rate.toString()), _fromController);
                              //                   } else {
                              //                     insert("", _fromController);
                              //                   }
                              //                 } else {
                              //                   Utils.flushBarErrorMessage("Vous devez selectionner un pays de destination", context);
                              //                 }
                              //               },
                              //               decoration: const InputDecoration(
                              //                   border: InputBorder.none,
                              //                   hintText: "0.00",
                              //                   contentPadding: EdgeInsets.zero
                              //               ),
                              //               style: const TextStyle(
                              //                   fontSize: 18
                              //               ),
                              //             )),
                              //           ],
                              //         ),
                              //         InkWell(
                              //           onTap: () {
                              //             showModalBottomSheet(
                              //               context: context,
                              //               builder: (context) {
                              //                 return Container(
                              //                     padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                              //                     child: Column(
                              //                       mainAxisSize: MainAxisSize.min,
                              //                       children: [
                              //                         const Text("Séléctionnez le pays de destination", style: TextStyle(
                              //                             fontWeight: FontWeight.w600
                              //                         ),),
                              //                         const SizedBox(height: 20,),
                              //                         Expanded(child: ListView.builder(
                              //                           itemCount: paysDestinationModel!.destination!.length,
                              //                           itemBuilder: (context, index) {
                              //                             return InkWell(
                              //                               onTap: () {
                              //                                 setState(() {
                              //                                   selectedDesinaion = paysDestinationModel!.destination![index];
                              //                                   beneficiaires = null;
                              //                                   selectedBeneficiaire = null;
                              //                                   if (
                              //                                     selectedDesinaion!.modeRetrait != null
                              //                                       && selectedDesinaion!.modeRetrait!.isNotEmpty
                              //                                   ) {
                              //                                     selectedModeRetrait = null;
                              //                                   }
                              //                                   _toController.clear();
                              //                                   _fromController.clear();
                              //                                   insert(00, _toController);
                              //                                 });
                              //                                 Navigator.pop(context);
                              //                               },
                              //                               child: Container(
                              //                                 padding: const EdgeInsets.all(10),
                              //                                 decoration: BoxDecoration(
                              //                                   border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                              //                                 ),
                              //                                 child: Row(
                              //                                   children: [
                              //                                     Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.destination![index].codePaysDest}.png", width: 20, height: 20, fit: BoxFit.contain,),
                              //                                     const SizedBox(width: 20,),
                              //                                     Text(paysDestinationModel!.destination![index].paysDest.toString(), style: const TextStyle(
                              //                                         fontSize: 14,
                              //                                       fontWeight: FontWeight.bold
                              //                                     ),)
                              //                                   ],
                              //                                 ),
                              //                               )
                              //                             );
                              //                           },
                              //                         ))
                              //                       ],
                              //                     )
                              //                 );
                              //               },
                              //               shape: const RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.vertical(
                              //                   top: Radius.circular(20),
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //           child: Container(
                              //             color: Colors.black.withOpacity(.05),
                              //             padding: const EdgeInsets.all(10),
                              //             child: Row(
                              //               children: [
                              //                 if (selectedDesinaion != null)
                              //                 Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 15, height: 15, fit: BoxFit.contain),
                              //                 const SizedBox(width: 10,),
                              //                 Text(selectedDesinaion == null ? "Séléctionner le pays de destination" :selectedDesinaion!.paysDest.toString(), style: const TextStyle(
                              //                     fontSize: 12  ,
                              //                     fontWeight: FontWeight.w500
                              //                 ),),
                              //                 const SizedBox(width: 10,),
                              //                 const Expanded(child: Align(
                              //                   alignment: Alignment.centerRight,
                              //                   child: Icon(Icons.arrow_drop_down, color: Colors.green,),
                              //                 ))
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         const SizedBox(height: 10,),
                              //         if (selectedDesinaion != null)
                              //         Text("(1${paysDestinationModel!.paysCodeMonnaieSrce} = ${selectedDesinaion!.rate}${selectedDesinaion!.paysCodeMonnaieDest})", style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 12,
                              //             color: Colors.black.withOpacity(.4)
                              //         ),),
                              //         const SizedBox(height: 10,),
                              //         if (selectedDesinaion != null)
                              //         Row(
                              //           children: [
                              //             if (selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              //             const Text("Mode de reception", style: TextStyle(
                              //                 fontWeight: FontWeight.w500
                              //             ),),
                              //             if (selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              //             const SizedBox(width: 10,),
                              //             if (selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              //             InkWell(
                              //               onTap: () {
                              //                 showModalBottomSheet(
                              //                   context: context,
                              //                   builder: (context) {
                              //                     return Container(
                              //                         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                              //                         child: Column(
                              //                           mainAxisSize: MainAxisSize.min,
                              //                           children: [
                              //                             const Text("Séléctionnez le mode de reception", style: TextStyle(
                              //                                 fontWeight: FontWeight.w600
                              //                             ),),
                              //                             const SizedBox(height: 20,),
                              //                             Expanded(child: ListView.builder(
                              //                               itemCount: selectedDesinaion!.modeRetrait!.length,
                              //                               itemBuilder: (context, index) {
                              //                                 return InkWell(
                              //                                     onTap: () {
                              //                                       setState(() {
                              //                                         selectedModeRetrait = selectedDesinaion!.modeRetrait![index];
                              //                                       });
                              //                                       Navigator.pop(context);
                              //                                     },
                              //                                     child: Container(
                              //                                       padding: const EdgeInsets.all(10),
                              //                                       decoration: BoxDecoration(
                              //                                           border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                              //                                       ),
                              //                                       child: Row(
                              //                                         mainAxisSize: MainAxisSize.max,
                              //                                         mainAxisAlignment: MainAxisAlignment.center,
                              //                                         crossAxisAlignment: CrossAxisAlignment.center,
                              //                                         children: [
                              //                                           Text(selectedDesinaion!.modeRetrait![index].modeRetrait.toString(), style: const TextStyle(
                              //                                               fontSize: 14,
                              //                                               fontWeight: FontWeight.bold
                              //                                           ),textAlign: TextAlign.center,)
                              //                                         ],
                              //                                       ),
                              //                                     )
                              //                                 );
                              //                               },
                              //                             ))
                              //                           ],
                              //                         )
                              //                     );
                              //                   },
                              //                   shape: const RoundedRectangleBorder(
                              //                     borderRadius: BorderRadius.vertical(
                              //                       top: Radius.circular(20),
                              //                     ),
                              //                   ),
                              //
                              //                 );
                              //               },
                              //               child: Row(
                              //                 children: [
                              //                   if (selectedModeRetrait != null)
                              //                   Text(selectedModeRetrait!.modeRetrait.toString()),
                              //                   const SizedBox(width: 5,),
                              //                   const Icon(Icons.arrow_drop_down, color: Colors.green,)
                              //                 ],
                              //               ),
                              //             )
                              //           ],
                              //         )
                              //       ],
                              //     )
                              // ),
                              // if (selectedModeRetrait != null && selectedDesinaion != null && selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              // const SizedBox(height: 20,),
                              // if (selectedModeRetrait != null && selectedDesinaion != null && selectedDesinaion!.modeRetrait != null && selectedDesinaion!.modeRetrait!.isNotEmpty)
                              // Text(selectedModeRetrait!.infosModeRetrait.toString(), style: TextStyle(
                              //     fontWeight: FontWeight.w500,
                              //     fontSize: 12,
                              //     color: Colors.black.withOpacity(.5)
                              // ),),
                              // const SizedBox(height: 20,),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text("Bénéficiaire *", style: TextStyle(
                              //         color: Colors.black.withOpacity(.6),
                              //         fontSize: 14
                              //     ),),
                              //     InkWell(
                              //       onTap: () {
                              //         setState(() {
                              //           beneficiaires = null;
                              //         });
                              //         showModalBottomSheet(
                              //           isScrollControlled: true,
                              //           context: context,
                              //           builder: (context) {
                              //             return Padding(
                              //               padding: EdgeInsets.only(
                              //                   bottom: MediaQuery.of(context).viewInsets.bottom),
                              //               child: NewBeneficiaireForm(
                              //                 destinations: paysDestinationModel!.destination!,
                              //                 parentCotext: context,
                              //                 initialDestination: selectedDesinaion,
                              //               ),
                              //             );
                              //           },
                              //           shape: const RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.vertical(
                              //               top: Radius.circular(20),
                              //             ),
                              //           ),
                              //
                              //         );
                              //       },
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              //         decoration: BoxDecoration(
                              //             color: Colors.grey.withOpacity(.3),
                              //             borderRadius: BorderRadius.circular(20)
                              //         ),
                              //         child: const Text("+ Ajouter un bénéficiaire", style: TextStyle(
                              //             fontSize: 12,
                              //             fontWeight: FontWeight.w500
                              //         ),),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              // const SizedBox(height: 15,),
                              //
                              // InkWell(
                              //   onTap: () {
                              //     if (selectedDesinaion == null) {
                              //       Utils.flushBarErrorMessage("Vous devez selectionner une destination", context);
                              //     } else if (beneficiaires == null) {
                              //       DemandesViewModel demandesViewModel2 = DemandesViewModel();
                              //       demandesViewModel2.beneficiaires([], context);
                              //       showModalBottomSheet(
                              //         context: context,
                              //         builder: (context) {
                              //           return ChangeNotifierProvider<DemandesViewModel>(
                              //               create: (BuildContext context) => demandesViewModel2,
                              //               child: Consumer<DemandesViewModel>(
                              //                   builder: (context, value, _){
                              //                     switch (value.beneficiairesList.status) {
                              //                       case Status.LOADING:
                              //                         return Column(
                              //                           children: [Expanded(child: Center(
                              //                             child: CircularProgressIndicator(color: AppColors.primaryColor,),
                              //                           ))],
                              //                         );
                              //                       case Status.ERROR:
                              //                         return Center(
                              //                           child: Text(value.beneficiairesList.message.toString()),
                              //                         );
                              //                       default:
                              //                         beneficiaires = [];
                              //                         value.beneficiairesList.data!.forEach((element) {
                              //                           BeneficiaireModel beneficiaireD = BeneficiaireModel.fromJson(element);
                              //                           if (beneficiaireD.codePays == selectedDesinaion!.codePaysDest) {
                              //                             beneficiaires!.add(element);
                              //                           }
                              //                         });
                              //                         if (beneficiaires!.isEmpty) {
                              //                           return Center(
                              //                             child: Container(
                              //                               padding: const EdgeInsets.symmetric(vertical: 20),
                              //                               child: const Text("Aucune bénéficiaire trouvée"),
                              //                             ),
                              //                           );
                              //                         }
                              //                         return Container(
                              //                           padding: const EdgeInsets.all(20),
                              //                           child: Column(
                              //                             children: [
                              //                               const Text("Séléctionnez un bénéficiaire", style: TextStyle(
                              //                                   fontWeight: FontWeight.w600
                              //                               ),),
                              //                               const SizedBox(height: 20,),
                              //                               Expanded(
                              //                                 child: ListView.builder(
                              //                                   itemCount: beneficiaires!.length,
                              //                                   itemBuilder: (context, index) {
                              //                                     BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(beneficiaires![index]);
                              //                                     bool last = index == beneficiaires!.length - 1;
                              //
                              //                                     return InkWell(
                              //                                       onTap: () {
                              //                                         setState(() {
                              //                                           selectedBeneficiaire = beneficiaire;
                              //                                         });
                              //                                         Navigator.pop(context);
                              //                                       },
                              //                                       child: Container(
                              //                                         padding: const EdgeInsets.all(10),
                              //                                         margin: const EdgeInsets.only(bottom: 10),
                              //                                         decoration: BoxDecoration(
                              //                                             border: Border.all(width: 1, color: Colors.black.withOpacity(.2)),
                              //                                             borderRadius: BorderRadius.circular(5)
                              //                                         ),
                              //                                         child: Column(
                              //                                             children: [
                              //                                               Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                              //                                               const SizedBox(height: 10,),
                              //                                               Text(beneficiaire.nomBeneficiaire.toString(), style: const TextStyle(
                              //                                                   fontWeight: FontWeight.w600,
                              //                                                   fontSize: 16
                              //                                               ),),
                              //                                               const SizedBox(height: 10,),
                              //                                               Text(beneficiaire.telBeneficiaire.toString()),
                              //                                             ]
                              //                                         ),
                              //                                       ),
                              //                                     );
                              //                                   },
                              //                                 ),
                              //                               )
                              //                             ],
                              //                           ),
                              //                         );
                              //                     }
                              //                   })
                              //           );
                              //         },
                              //         shape: const RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.vertical(
                              //             top: Radius.circular(20),
                              //           ),
                              //         ),
                              //       );
                              //     } else {
                              //       showModalBottomSheet(
                              //         context: context,
                              //         builder: (context) {
                              //           if (beneficiaires!.isEmpty) {
                              //             return Center(
                              //               child: Container(
                              //                 padding: const EdgeInsets.symmetric(vertical: 20),
                              //                 child: const Text("Aucun bénéficiaire trouvée"),
                              //               ),
                              //             );
                              //           }
                              //           return Container(
                              //             padding: const EdgeInsets.all(20),
                              //             child: Column(
                              //               children: [
                              //                 const Text("Séléctionnez un bénéficiaire", style: TextStyle(
                              //                     fontWeight: FontWeight.w600
                              //                 ),),
                              //                 const SizedBox(height: 20,),
                              //                 Expanded(
                              //                   child: ListView.builder(
                              //                     itemCount: beneficiaires!.length,
                              //                     itemBuilder: (context, index) {
                              //                       BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(beneficiaires![index]);
                              //                       bool last = index == beneficiaires!.length - 1;
                              //
                              //                       return InkWell(
                              //                         onTap: () {
                              //                           setState(() {
                              //                             selectedBeneficiaire = beneficiaire;
                              //                           });
                              //                           Navigator.pop(context);
                              //                         },
                              //                         child: Container(
                              //                           padding: const EdgeInsets.all(10),
                              //                           margin: const EdgeInsets.only(bottom: 10),
                              //                           decoration: BoxDecoration(
                              //                               border: Border.all(width: 1, color: Colors.black.withOpacity(.2)),
                              //                               borderRadius: BorderRadius.circular(5)
                              //                           ),
                              //                           child: Column(
                              //                               children: [
                              //                                 Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                              //                                 const SizedBox(height: 10,),
                              //                                 Text(beneficiaire.nomBeneficiaire.toString(), style: const TextStyle(
                              //                                     fontWeight: FontWeight.w600,
                              //                                     fontSize: 16
                              //                                 ),),
                              //                                 const SizedBox(height: 10,),
                              //                                 Text(beneficiaire.telBeneficiaire.toString()),
                              //                               ]
                              //                           ),
                              //                         ),
                              //                       );
                              //                     },
                              //                   ),
                              //                 )
                              //               ],
                              //             ),
                              //           );
                              //         },
                              //         shape: const RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.vertical(
                              //             top: Radius.circular(20),
                              //           ),
                              //         ),
                              //       );
                              //     }
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                              //         borderRadius: BorderRadius.circular(10)
                              //     ),
                              //     child: const Row(
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       children: [
                              //         Text("Choisissez un bénéficiaire", style: TextStyle(
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 13,
                              //         ),),
                              //         SizedBox(width: 10,),
                              //        Expanded(child: Align(
                              //          alignment: Alignment.centerRight,
                              //          child: Icon(Icons.arrow_drop_down, size: 30,),
                              //        ))
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 20,),
                              // if (selectedBeneficiaire != null)
                              // Column(
                              //   children: [
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text("Nom", style: TextStyle(
                              //             fontSize: 13,
                              //             color: Colors.black.withOpacity(.5)
                              //         ),),
                              //         Row(
                              //           children: [
                              //             Image.asset("packages/country_icons/icons/flags/png/${selectedBeneficiaire!.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                              //             const SizedBox(width: 10,),
                              //             Text(selectedBeneficiaire!.nomBeneficiaire.toString(), style: const TextStyle(
                              //                 fontSize: 13,
                              //                 fontWeight: FontWeight.w600
                              //             ),),
                              //           ],
                              //         )
                              //       ],
                              //     ),
                              //     const Divider(),
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text("Téléphone", style: TextStyle(
                              //             fontSize: 13,
                              //             color: Colors.black.withOpacity(.5)
                              //         ),),
                              //         Text(selectedBeneficiaire!.telBeneficiaire.toString(), style: const TextStyle(
                              //             fontSize: 13,
                              //             fontWeight: FontWeight.w600
                              //         ),),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(height: 50,),
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
                  backArrow: true
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
                    widthFactor: 0.25,
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
                  child: Text("Montant et pays", style: TextStyle(
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
                      Positioned(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: RoundedButton(
                              onPress: () {
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
                                }
                                // if (selectedDesinaion == null) {
                                //   Utils.flushBarErrorMessage("Vous devez séléctionner un pays de destination", context);
                                // } else if (_fromController.text.isEmpty) {
                                //   Utils.flushBarErrorMessage("Vous devez entrer le montant", context);
                                // } else if (selectedBeneficiaire == null) {
                                //   Utils.flushBarErrorMessage("Vous devez choisir un bénéficiaire", context);
                                // } else {
                                //   Map data = {
                                //     "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire,
                                //     "code_pays_srce": paysDestinationModel!.codePaysSrce,
                                //     "montant_srce": _fromController.text,
                                //     "montant_dest":_toController.text,
                                //     "fromToSens": fromToToSens,
                                //     "rate": double.parse(selectedDesinaion!.rate.toString()),
                                //     "code_pays_dest": selectedDesinaion!.codePaysDest,
                                //     "id_mode_retrait": selectedModeRetrait == null ? null : selectedModeRetrait!.idModeRetrait,
                                //     "beneficiaire": selectedBeneficiaire,
                                //     "source": paysDestinationModel,
                                //     "destination": selectedDesinaion,
                                //     "mode_retrait": selectedModeRetrait == null ? null : selectedModeRetrait!.modeRetrait.toString()
                                //   };
                                //   showModalBottomSheet(
                                //     isScrollControlled: true,
                                //     context: context,
                                //     builder: (context) {
                                //       return SendBottomModal(data: data,);
                                //     },
                                //     shape: const RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.vertical(
                                //         top: Radius.circular(20),
                                //       ),
                                //     ),
                                //   );
                                // }
                              },
                              title: "Continuer",
                              loading: false,
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