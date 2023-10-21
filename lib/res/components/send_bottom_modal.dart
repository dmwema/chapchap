import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/screen_argument.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';

class SendBottomModal extends StatefulWidget {
  Map data;
    SendBottomModal({Key? key, required this.data}) : super(key: key);

  @override
  State<SendBottomModal> createState() => _SendBottomModalState();
}

class _SendBottomModalState extends State<SendBottomModal> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  bool loading = false;
  bool loadingPromo = false;
  bool loadingPromoSucces = false;
  bool load = false;
  double montantSrc = 0;
  double montantDest = 0;
  bool fromToSens = true;
  double rate = 0;
  double promoRabais = 0;
  final TextEditingController _promoContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!load) {
      setState(() {
        montantSrc = double.parse(widget.data["montant_srce"]);
        montantDest = double.parse(widget.data["montant_dest"]);
        load = true;
        rate = widget.data["rate"];
        fromToSens = widget.data["fromToSens"];
      });
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          width: double.infinity,
          child: const Center(
            child: Text("DETAILS DE L'ENVOI", style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Montant", style: TextStyle(
                    color: Colors.black.withOpacity(.5)
                  ),),
                  Text("${widget.data["montant_srce"]} ${widget.data['source']!.paysCodeMonnaieSrce}", style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 5,),
              const Divider(),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Frais d'envoi", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text("0.00 ${widget.data['source']!.paysCodeMonnaieSrce}", style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              if (promoRabais > 0)
              const SizedBox(height: 5,),
              if (promoRabais > 0)
              const Divider(),
              if (promoRabais > 0)
              const SizedBox(height: 5,),
              if (promoRabais > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rabais promo", style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  ),),
                  Text("- $promoRabais ${widget.data['source']!.paysCodeMonnaieSrce}", style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.blueGrey.withOpacity(.2),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Montant à payer", style: TextStyle(
                        color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.w500
                    ),),
                    Text("$montantSrc ${widget.data['source']!.paysCodeMonnaieSrce}", style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) * 0.7,
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        label: const Text("CODE PROMO", style: TextStyle(
                          fontSize: 12
                        ),),
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
                      } else {
                        setState(() {
                          loadingPromo = true;
                          loadingPromoSucces = false;
                        });
                        DemandesViewModel demandeVM = DemandesViewModel();
                        Map data = {
                          "codePromo": _promoContoller.text,
                          "code_pays_srce": widget.data['source']!.codePaysSrce.toString(),
                          "montant": montantSrc
                        };
                        demandeVM.applyPromo(context, data).then((value) {
                          setState(() {
                            loadingPromo = false;
                          });
                          if (demandeVM.applyDetail.status == Status.COMPLETED) {
                            _promoContoller.clear();
                            setState(() {
                              montantSrc = montantSrc - demandeVM.applyDetail.data["reductionPromo"];
                              promoRabais = double.parse(demandeVM.applyDetail.data["reductionPromo"].toString());
                              loadingPromoSucces = true;
                            });
                          }
                        });
                      }
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                        color: AppColors.primaryColor,
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                      child: Center(
                        child: loadingPromo
                            ? const SizedBox(
                                width: 17, height: 17,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,),
                              )
                            : loadingPromoSucces
                              ?
                              const Icon(Icons.check, color: Colors.white, size: 18,)
                              : const Text("Appliquer", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),),
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Source", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text(widget.data['source']!.paysSrce.toString(), style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Destination", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text(widget.data['destination']!.paysDest.toString(), style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bénéficiaire", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text(widget.data['beneficiaire']!.nomBeneficiaire.toString(), style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Téléphone", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text(widget.data['beneficiaire']!.telBeneficiaire.toString(), style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Montant bénéficiaire", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text("$montantDest ${widget.data['destination']!.paysCodeMonnaieDest}", style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              if (widget.data['mode_retrait'] != null)
              const SizedBox(height: 10,),
              if (widget.data['mode_retrait'] != null)
              const Divider(),
              if (widget.data['mode_retrait'] != null)
              const SizedBox(height: 5,),
              if (widget.data['mode_retrait'] != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mode de retrait", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  Text(widget.data['mode_retrait'], style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 15,),

              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        width: (MediaQuery.of(context).size.width - 40) * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                          color: AppColors.primaryColor,
                        ),
                        padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                        child: const Center(
                          child: Text("Annuler", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),),
                        )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      double source = 0;
                      double destination = 0;

                      source = montantSrc;
                      destination = montantDest;

                      if (!loading) {
                        setState(() {
                          loading = true;
                        });
                        Map data2 = {
                          "idBeneficiaire": widget.data["idBeneficiaire"],
                          "codePromo": _promoContoller.text,
                          "code_pays_srce": widget.data["code_pays_srce"],
                          "montant_srce": source,
                          "montant_dest": destination,
                          "code_pays_dest": widget.data["code_pays_dest"],
                          "id_mode_retrait": widget.data["id_mode_retrait"],
                        };

                        demandesViewModel.transfert(data2, context).then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    },
                    child: Container(
                        width: (MediaQuery.of(context).size.width - 40) * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color: Colors.black.withOpacity(.9),
                        ),
                        padding: loading ? const EdgeInsets.only(top: 9.7, bottom: 9.7) : const EdgeInsets.only(top: 16, bottom: 16.6),
                        child: Center(
                          child: !loading ? const Text("Confirmer", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),): Image.asset("assets/loader_btn.gif", width: 30),
                        )
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}