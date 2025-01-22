import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/confirm_delete.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/account_view.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryColor,
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (route) {
              return AccountView();
            }));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Image.asset("assets/icons/user.png"),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: Image.asset("assets/icons/notification.png"),
          ),
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.newBeneficiaire);
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.accentColor
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.add, size: 25, color: Colors.white,),
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
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.archivebox_fill, size: 20,),
                            const SizedBox(width: 10,),
                            AppTexts.smallText("Bénéficiaires archivés")
                          ],
                        ),
                      ],
                    )
                ),
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
                                child: AppTexts.descriptionText("Aucun bénéficiaire enrégistré"),
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
                                        backgroundColor: AppColors.bgColor,
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
                                                                backgroundColor: AppColors.buttonBlackColor, // sets background color, default Colors.white// sets border, default 0.0
                                                                initialsText: Text(
                                                                  beneficiaire.nomBeneficiaire!.split(" ").length == 2 ? beneficiaire.nomBeneficiaire!.split(" ")[0][0] + beneficiaire.nomBeneficiaire!.split(" ")[1][0] : beneficiaire.nomBeneficiaire!.split(" ")[0][0],
                                                                  style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
                                                                      AppTexts.smallText("${beneficiaire.codePays} (${beneficiaire.paysMonnaie})"),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 5,),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  AppTexts.smallText("E-mail"),
                                                                  AppTexts.smallText(beneficiaire.emailBeneficiaire.toString()),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 5,),

                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  AppTexts.smallText("Téléphone"),
                                                                  AppTexts.smallText(beneficiaire.telBeneficiaire.toString()),
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
                                                                    title: "Nouveau Transfert",
                                                                    onPress: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => SendView(
                                                                          beneficiaire: beneficiaire,
                                                                          destination: beneficiaire.codePays,
                                                                        )),
                                                                      );
                                                                    },
                                                                    icon: CupertinoIcons.arrow_up_right,
                                                                    color: AppColors.buttonBlackColor,
                                                                    textColor: Colors.white,
                                                                  ),
                                                                  RoundedButton(
                                                                    title: "Archiver",
                                                                    onPress: () {
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
                                                                    icon: CupertinoIcons.archivebox,
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
                                                                    icon: CupertinoIcons.delete,
                                                                    color: AppColors.buttonBlackColor,
                                                                    textColor: Colors.white,
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
                                            top: Radius.circular(0),
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
      bottomNavigationBar: commonBottomAppBar(context: context, active: 1),
    );
  }
}