import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/confirm_delete.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientsView extends StatefulWidget {
  const RecipientsView({Key? key}) : super(key: key);

  @override
  State<RecipientsView> createState() => _RecipientsViewState();
}

class _RecipientsViewState extends State<RecipientsView> with SingleTickerProviderStateMixin {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    demandesViewModel.beneficiaires([], context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formFieldColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                context: context,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Bénéficiaires", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.newBeneficiaire);
                      },
                      child: Container(
                        width: 25, height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.primaryColor
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.add, size: 15, color: Colors.white,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.recipeintsArchive);
                },
                child: Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1),
                        top: BorderSide(color: AppColors.formFieldBorderColor, width: 1),
                      )
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.archivebox, size: 15,),
                            SizedBox(width: 10,),
                            Text("Bénéficiaires archivés", style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500
                            ),)
                          ],
                        ),
                        // Text("(3)", style: TextStyle(
                        //     fontWeight: FontWeight.bold
                        // ),)
                      ],
                    )
                ),
              ),
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
                                  "Aucun bénéficiaire enrégistré",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.2),
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: value.beneficiairesList.data!.length,
                              itemBuilder: (context, index) {
                                BeneficiaireModel current = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
                                return InkWell(
                                    onTap: (){
                                      DemandesViewModel demandesViewModel2 = DemandesViewModel();
                                      demandesViewModel2.beneficiaireInfo(current.idBeneficiaire!.toInt(), context);
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return ChangeNotifierProvider<DemandesViewModel>(
                                              create: (BuildContext context) => demandesViewModel2,
                                              child: Consumer<DemandesViewModel>(
                                                  builder: (context, value, _){
                                                    switch (value.beneficiaireModel.status) {
                                                      case Status.LOADING:
                                                        return const SizedBox(
                                                          height: 200,
                                                          child: Center(
                                                            child: CupertinoActivityIndicator(color: Colors.black,),
                                                          ),
                                                        );
                                                      case Status.ERROR:
                                                        return Center(
                                                          child: Text(value.beneficiairesList.message.toString()),
                                                        );
                                                      default:
                                                        BeneficiaireModel beneficiaire = value.beneficiaireModel.data!;
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
                                                              const SizedBox(height: 5,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text("E-mail", style: TextStyle(
                                                                      fontWeight: FontWeight.bold
                                                                  ),),
                                                                  Text(beneficiaire.emailBeneficiaire.toString()),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 5,),
                                                              const Divider(),
                                                              const SizedBox(height: 5,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text("Téléphone", style: TextStyle(
                                                                      fontWeight: FontWeight.bold
                                                                  ),),
                                                                  Text(beneficiaire.telBeneficiaire.toString()),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 20,),
                                                              Wrap(
                                                                spacing: 5,
                                                                runSpacing: 5,
                                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                                alignment: WrapAlignment.spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => SendView(
                                                                          beneficiaire: beneficiaire,
                                                                          destination: beneficiaire.codePays,
                                                                        )),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.green,
                                                                          borderRadius: BorderRadius.circular(5)
                                                                      ),
                                                                      width: MediaQuery.of(context).size.width,
                                                                      child: const Row(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(CupertinoIcons.arrow_up_right, size: 15, color: Colors.white,),
                                                                          SizedBox(width: 3,),
                                                                          Text("Nouveau Transfert", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
                                                                        ],
                                                                      )
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                                      showCupertinoDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return CupertinoAlertDialog(
                                                                            title: Text('Confirmer'),
                                                                            content: Text('Voulez-vous vraiment archiver ce bénéficiaire ?'),
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
                                                                                  await demandesViewModel.archiveRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
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
                                                                        width: MediaQuery.of(context).size.width - 5,
                                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.black,
                                                                            borderRadius: BorderRadius.circular(5)
                                                                        ),
                                                                        child: const Row(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(CupertinoIcons.archivebox, size: 15, color: Colors.white,),
                                                                            SizedBox(width: 3,),
                                                                            Text("Archiver", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
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
                                                                            title: const Text('Confirmer'),
                                                                            content: const Text('Voulez-vous vraiment supprimer ce bénéficiaire ?'),
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

                                                                                  BuildContext modalContext = context;

                                                                                  await demandesViewModel.deleteRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                                                                                    if (value) {
                                                                                      setState(() {
                                                                                        demandesViewModel.beneficiaires([], context);
                                                                                      });
                                                                                    }
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                        width: MediaQuery.of(context).size.width,
                                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.red,
                                                                            borderRadius: BorderRadius.circular(5)
                                                                        ),
                                                                        child: const Row(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    },
                                    child: Column(
                                      children: [
                                        RecipientCard2(
                                          name: "${current.nomBeneficiaire}",
                                          address: current.codePays.toString(),
                                          phone: current.telBeneficiaire.toString(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.send);
          },
          child: const Icon(CupertinoIcons.arrow_up_right_circle, color: Colors.white, size: 35,),
        ),
      ),
      bottomNavigationBar: commonBottomAppBar(context: context, active: 1),
    );
  }
}