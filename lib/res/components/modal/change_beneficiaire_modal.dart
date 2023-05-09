import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeBeneficiaireModal extends StatefulWidget {
  final DemandeModel demande;
  const ChangeBeneficiaireModal({super.key, required this.demande});

  @override
  State<ChangeBeneficiaireModal> createState() => _ChangeBeneficiaireModalState();
}

class _ChangeBeneficiaireModalState extends State<ChangeBeneficiaireModal> {
  DemandesViewModel demandeViewModel = DemandesViewModel();
  BeneficiaireModel? selectedBeneficiaire;
  List? beneficiaires;

  @override
  Widget build(BuildContext context) {
    DemandeModel demande = widget.demande;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(demande.date.toString(), style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),),
                    const SizedBox(height: 5,),
                    Text("#${demande.idDemande}", style: TextStyle(
                        color: Colors.black.withOpacity(.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5 - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${demande.montanceSrce} ${demande.paysCodeMonnaieSrce}", style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16
                    ),),
                    const SizedBox(height: 5,),
                    if (demande.progression != null)
                      Text(demande.progression.toString(), style: TextStyle(
                          color: demande.facture != null ? Colors.green: (demande.lienPaiement != null ? Colors.orange: Colors.red),
                          fontWeight: FontWeight.w500,
                          fontSize: 11
                      ),)
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Divider(),
          const SizedBox(height: 10,),
          const Text(
            "Si vous ne trouvez pas le bénéficiaire, vous pouvez l'ajouter en faisant :",
            style: TextStyle(
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 5,),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text("Accueil ", style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              Icon(Icons.chevron_right_rounded, color: Colors.green,),
              Text(" Bénéficiaires ", style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              Icon(Icons.chevron_right_rounded, color: Colors.green,),
              Text(" Ajouter un bénéficiaire ", style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
            ],
          ),
          const SizedBox(height: 15,),
          InkWell(
            onTap: () {
              if (beneficiaires == null) {
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
                                    if (beneficiaireD.codePays == demande.codePaysDest) {
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
                                              return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
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
                                                  }
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
          const SizedBox(height: 15,),
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
          if (selectedBeneficiaire != null)
            const SizedBox(height: 15,),
          InkWell(
            onTap: () {
              if (selectedBeneficiaire == null) {
                Utils.flushBarErrorMessage("Vous devez séléctionner un bénéficiaire.", context);
              } else {
                Map data = {
                  "idDemande": demande.idDemande,
                  "idBeneficiaire": selectedBeneficiaire!.idBeneficiaire
                };
                DemandesViewModel changeBeneficiaireDemande = DemandesViewModel();
                demandeViewModel.changeBeneficiaire(data, context);
              }
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.save, color: Colors.white,),
                    SizedBox(width: 5,),
                    Text(
                      "Enrégistrer",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
                    ),
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}