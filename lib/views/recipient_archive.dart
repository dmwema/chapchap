import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/beneficiaire_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/recipient_card2.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientsArchiveView extends StatefulWidget {
  const RecipientsArchiveView({Key? key}) : super(key: key);

  @override
  State<RecipientsArchiveView> createState() => _RecipientsArchiveViewState();
}

class _RecipientsArchiveViewState extends State<RecipientsArchiveView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.beneficiairesArchive([], context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(context: context, backArrow: true, title: "Bénéficiaires archivés",),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Expanded(child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
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
                              child: AppTexts.descriptionText("Aucun bénéficiaire archivé"),
                            );
                          }
                          return ListView.builder(
                            itemCount: value.beneficiairesList.data!.length,
                            itemBuilder: (context, index) {
                              BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
                              return InkWell(
                                  onTap: (){
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: AppColors.bgColor,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:  [
                                              CircularProfileAvatar(
                                                "",
                                                radius: 25, // sets radius, default 50.0
                                                backgroundColor: AppColors.primaryColor.withOpacity(.4), // sets background color, default Colors.white// sets border, default 0.0
                                                initialsText: Text(
                                                  beneficiaire.nomBeneficiaire!.split(" ").length == 2 ? beneficiaire.nomBeneficiaire!.split(" ")[0][0] + beneficiaire.nomBeneficiaire!.split(" ")[1][0] : beneficiaire.nomBeneficiaire!.split(" ")[0][0],
                                                  style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                                ),  // sets initials text, set your own style, default Text('')
                                                elevation: 2.0, // sets elevation (shadow of the profile picture), default value is 0.0
                                                foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                                                cacheImage: true, // allow widget to cache image against provided url
                                                showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
                                              ),
                                              const SizedBox(height: 10,),
                                              AppTexts.titleText(beneficiaire.nomBeneficiaire.toString()),
                                              AppTexts.descriptionText(beneficiaire.telBeneficiaire.toString()),
                                              const SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppTexts.smallText("Pays"),
                                                  Row(
                                                    children: [
                                                      Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                      // const SizedBox(width: 5,),
                                                      // AppTexts.smallText("(${beneficiaire.paysMonnaie})"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              Wrap(
                                                spacing: 5,
                                                runSpacing: 5,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.spaceBetween,
                                                children: [
                                                  RoundedButton(
                                                    title: "Desarchiver",
                                                    onPress: () {
                                                      DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text('Confirmer'),
                                                            content: Text('Voulez-vous vraiment desarchiver ce bénéficiaire ?'),
                                                            actions: [
                                                              CupertinoDialogAction(
                                                                child: const Text('Annuler', style: TextStyle(
                                                                    color: Colors.black
                                                                ),),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(); // Fermer le dialogue
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child: Text('Confirmer', style: TextStyle(
                                                                    color: AppColors.primaryColor
                                                                ),),
                                                                onPressed: () async {
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();
                                                                  await demandesViewModel.desarchiveRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                                                                    setState(() {
                                                                      demandesViewModel.beneficiairesArchive([], context);
                                                                    });
                                                                  });// Fermer le dialogue
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icons.unarchive_outlined,
                                                    color: AppColors.buttonBlackColor,
                                                    textColor: Colors.white,
                                                  ),
                                                  RoundedButton(
                                                    title: "Supprimer",
                                                    onPress: () {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text('Confirmer'),
                                                            content: Text('Voulez-vous vraiment supprimer ce bénéficiaire ?'),
                                                            actions: [
                                                              CupertinoDialogAction(
                                                                child: const Text('Annuler', style: TextStyle(
                                                                    color: Colors.black
                                                                ),),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(); // Fermer le dialogue
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child: Text('Confirmer', style: TextStyle(
                                                                    color: AppColors.primaryColor
                                                                ),),
                                                                onPressed: () async {
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();
                                                                  await demandesViewModel.deleteRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                                                                    setState(() {
                                                                      demandesViewModel.beneficiaires([], context);
                                                                    });
                                                                  });// Fermer le dialogue
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: CupertinoIcons.delete_solid,
                                                    color: AppColors.buttonBlackColor,
                                                    textColor: Colors.white,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(0),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      RecipientCard2(
                                        name: "${beneficiaire.nomBeneficiaire}",
                                        address: beneficiaire.codePays.toString(),
                                        phone: beneficiaire.telBeneficiaire.toString(),
                                      ),
                                    ],
                                  )
                              );
                            },
                          );
                      }
                    })
            ))
          ],
        ),
      ),
    );
  }
}