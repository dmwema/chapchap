import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
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
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          Column(
            children: [
              AppTexts.titleText("Voulez-vous vraiment faire une demande d'annulation de ce transfert ?"),
              Divider(color: AppColors.formFieldBorderColor,),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18,), const SizedBox(width: 5,),
                  AppTexts.smallText("Des frais d'annulation pourraient s'appliquer."),
                ],
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
          const SizedBox(height: 10,),
          RoundedButton(
            onPress: () {
              Navigator.pop(context);
            },
            color: AppColors.buttonBlackColor,
            title: "Annuler",
          ),
        ],
      ),
    );
  }
}