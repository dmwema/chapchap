import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmCancel extends StatefulWidget {
  final int demandeId;
  final DemandesViewModel  demandesViewModel;
  const ConfirmCancel({Key? key, required this.demandeId, required this.demandesViewModel}) : super(key: key);

  @override
  State<ConfirmCancel> createState() => _ConfirmCancelState();
}

class _ConfirmCancelState extends State<ConfirmCancel> {
  final TextEditingController _motifController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.modeRemboursements({}, context);
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: MediaQuery.of(context).viewInsets.bottom + 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: Colors.black54,
            size: 50,
          ),
          const SizedBox(height: 10,),
          const Column(
            children: [
              Text("Voulez-vous vraiment faire une demande d'annulation de ce transfert ?",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(),
              Text("Des frais d'annulation pourraient s'appliquer.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          CustomFormField(
            hint: "Motif",
            label: "Motif",
            radius: const BorderRadius.all(Radius.circular(10)),
            controller: _motifController,
            type: TextInputType.text,
            maxLines: 2,
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                onPress: () {
                  if (_motifController.text.isEmpty) {
                    Utils.flushBarErrorMessage("Vous devez saisir le motif de l'annulation", context);
                  } else {
                    Map data = {
                      "idDemande" : widget.demandeId,
                      "motif": _motifController.text
                    };
                    widget.demandesViewModel.cancelSend(context, data);
                  }
                },
                title: "Confirmer",
              ),
              const SizedBox(width: 10,),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: AppColors.primaryColor, width: 2)
                  ),
                  child: Text("Annuler", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor
                  ),),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}