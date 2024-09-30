import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
              context: context,
              backArrow: true,
              backClick: () {
                Navigator.pushNamed(context, RoutesName.recipeints);
              }
            ),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Bénéficiaires archivés", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
            ),
            const SizedBox(height: 10,),
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
                              child: Text(
                                "Aucun bénéficiaire archivé",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.2),
                                ),
                              ),
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
                                              Text(beneficiaire.nomBeneficiaire.toString(), style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18
                                              ),),
                                              const SizedBox(height: 5,),
                                              Text(beneficiaire.telBeneficiaire.toString(), style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black.withOpacity(.5)
                                              ),),
                                              const SizedBox(height: 10,),
                                              const Divider(),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Pays", style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                                  Row(
                                                    children: [
                                                      Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                      const SizedBox(width: 10,),
                                                      Text("(${beneficiaire.paysMonnaie})"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              const Divider(),
                                              const SizedBox(height: 20,),
                                              Wrap(
                                                spacing: 5,
                                                runSpacing: 5,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
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
                                                    child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: const Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(CupertinoIcons.archivebox, size: 15, color: Colors.white,),
                                                            SizedBox(width: 3,),
                                                            Text("Desarchiver", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
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
                                                    child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: const Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(CupertinoIcons.delete, size: 15, color: Colors.white,),
                                                            SizedBox(width: 3,),
                                                            Text("Supprimer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                ],
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