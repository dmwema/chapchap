import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/screen_argument.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
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
  final TextEditingController _promoContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  Text(widget.data["montant_srce"] + " " + widget.data['source']!.paysCodeMonnaieSrce.toString(), style: const TextStyle(
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
                    Text(widget.data["montant_srce"] + " " + widget.data['source']!.paysCodeMonnaieSrce.toString(), style: const TextStyle(
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
                        contentPadding: EdgeInsets.all(10),
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
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                        color: AppColors.primaryColor,
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                      child: const Center(
                        child: Text("Appliquer", style: TextStyle(
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
                  Text(widget.data['montant_dest'] + " " + widget.data['destination']!.paysCodeMonnaieDest.toString(), style: const TextStyle(
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
                    child: Container(
                        width: (MediaQuery.of(context).size.width - 40) * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                          color: AppColors.primaryColor,
                        ),
                        padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                        child: const Center(
                          child: Text("Annueler", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),),
                        )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!loading) {
                        setState(() {
                          loading = true;
                        });
                        Map data2 = {};

                        widget.data.forEach((key, value) {
                          if (key != 'source' && key != 'mode_retrait' && key != 'destination') {
                            data2[key] = value;
                          }
                        });
                        data2['codePromo'] = _promoContoller.text;
                        demandesViewModel.transfert(data2, context).then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                      }

                      //Navigator.pushNamed(context, RoutesName.sendSuccess);
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