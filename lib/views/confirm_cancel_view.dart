import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/confirm_delete.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmCancelView extends StatefulWidget {
  final int demandeId;
  final DemandesViewModel  demandesViewModel;
  const ConfirmCancelView({Key? key, required this.demandeId, required this.demandesViewModel}) : super(key: key);

  @override
  State<ConfirmCancelView> createState() => _ConfirmCancelViewState();
}

class _ConfirmCancelViewState extends State<ConfirmCancelView> {
  final TextEditingController _motifController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.modeRemboursements({}, context);
  }

  int? selectedModeRemboursement;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: HideKeyBordContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                  context: context,
                  backArrow: true
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                      const Text("Quel mode de remboursement voulez-vous ?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      const SizedBox(height: 10,),
                      ChangeNotifierProvider<DemandesViewModel>(
                          create: (BuildContext context) => demandesViewModel,
                          child: Consumer<DemandesViewModel>(
                              builder: (context, value, _){
                                switch (value.modeRemboursementList.status) {
                                  case Status.LOADING:
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: CupertinoActivityIndicator(color: Colors.black45,),
                                      ),
                                    );
                                  case Status.ERROR:
                                    return Center(
                                      child: Text(value.modeRemboursementList.message.toString()),
                                    );
                                  default:
                                    List<dynamic> modeRemboursements = value.modeRemboursementList.data!;
                                    if (modeRemboursements.isNotEmpty && selectedModeRemboursement == null) {
                                      selectedModeRemboursement = modeRemboursements[0]['id_mode_remboursement'];
                                    }
                                    return Expanded(child: ListView.builder(
                                      itemCount: modeRemboursements.length,
                                      itemBuilder: (context, index) {
                                        Map modeRemboursement = modeRemboursements[index];
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedModeRemboursement = modeRemboursement["id_mode_remboursement"];
                                              });
                                              print(selectedModeRemboursement);
                                              print(modeRemboursement);
                                              print(modeRemboursement['id_mode_remboursement']);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                              margin: const EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                  color: (
                                                      selectedModeRemboursement != null
                                                          && modeRemboursement["id_mode_remboursement"]
                                                          == selectedModeRemboursement
                                                  ) ? AppColors.primaryColor : Colors.white,
                                                  border: (
                                                      selectedModeRemboursement != null
                                                          && selectedModeRemboursement
                                                          == modeRemboursement["id_mode_remboursement"]
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
                                                            selectedModeRemboursement != null
                                                                && selectedModeRemboursement
                                                                == modeRemboursement["id_mode_remboursement"]
                                                        ) ? null : Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration: BoxDecoration(
                                                            color: (
                                                                selectedModeRemboursement != null
                                                                    && selectedModeRemboursement
                                                                    == modeRemboursement["id_mode_remboursement"]
                                                            ) ? AppColors.primaryColor : null,
                                                            borderRadius: BorderRadius.circular(15)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  Text(modeRemboursement["mode_remboursement"], style: TextStyle(
                                                      fontSize: 12,
                                                      color: (
                                                          selectedModeRemboursement != null
                                                              && selectedModeRemboursement
                                                              == modeRemboursement["id_mode_remboursement"]
                                                      ) ? Colors.white : Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),textAlign: TextAlign.center,)
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    ));
                                }
                              })
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedButton(
                            onPress: () {
                              if (_motifController.text.isEmpty) {
                                Utils.flushBarErrorMessage("Vous devez saisir le motif de l'annulation", context);
                              } else if (selectedModeRemboursement == null) {
                                Utils.flushBarErrorMessage("Vous devez séléctionner un mode de remboursement", context);
                              } else {
                                Map data = {
                                  "idDemande" : widget.demandeId,
                                  "id_mode_remboursement": selectedModeRemboursement,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}