import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/confirm_delete.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/modal/confirm_archive.dart';
import 'package:chapchap/res/components/modal/confirm_desarchive.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.newBeneficiaire);
          },
          child: const Center(
            child: Icon(Icons.person_add_alt_1),
          ),
        ),
        appBar: CustomAppBar(
          showBack: true,
          title: "Bénéficiaires",
          backUrl: RoutesName.recipeints,
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: const Text("Bénéficiaires archivés"),
            ),
            Expanded(child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                    builder: (context, value, _){
                      switch (value.beneficiairesList.status) {
                        case Status.LOADING:
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.primaryColor,),
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
                          return Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                              child: ListView.builder(
                                itemCount: value.beneficiairesList.data!.length,
                                itemBuilder: (context, index) {
                                  BeneficiaireModel current = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
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
                                                      current.nomBeneficiaire!.split(" ").length == 2 ? current.nomBeneficiaire!.split(" ")[0][0] + current.nomBeneficiaire!.split(" ")[1][0] : current.nomBeneficiaire!.split(" ")[0][0],
                                                      style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                                    ),  // sets initials text, set your own style, default Text('')
                                                    elevation: 2.0, // sets elevation (shadow of the profile picture), default value is 0.0
                                                    foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                                                    cacheImage: true, // allow widget to cache image against provided url
                                                    showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
                                                  ),
                                                  const SizedBox(height: 20,),
                                                  Text(current.nomBeneficiaire.toString(), style: const TextStyle(
                                                      fontWeight: FontWeight.w600
                                                  ),),
                                                  const SizedBox(height: 10,),
                                                  Text(current.telBeneficiaire.toString(), style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black.withOpacity(.5)
                                                  ),),
                                                  const SizedBox(height: 10,),
                                                  const Divider(),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text("Pays", style: TextStyle(
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                      Row(
                                                        children: [
                                                          Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                          const SizedBox(width: 10,),
                                                          Text("(${current.codePays})"),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Divider(),
                                                  const SizedBox(height: 10,),
                                                  const SizedBox(height: 20,),
                                                  InkWell(
                                                    onTap: () {
                                                      DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        builder: (context) {
                                                          return ConfirmDesrchive(recipientId: current.idBeneficiaire!.toInt(), demandesViewModel: demandesViewModel3);
                                                        },
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(20),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(30)
                                                        ),
                                                        child: Text("Desarchiver ${current.nomBeneficiaire}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),)
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  InkWell(
                                                    onTap: () {
                                                      DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        builder: (context) {
                                                          return ConfirmDelete(recipientId: current.idBeneficiaire!.toInt(), demandesViewModel: demandesViewModel3);
                                                        },
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(20),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius: BorderRadius.circular(30)
                                                        ),
                                                        child: const Text("Supprimer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                                    ),
                                                  ),
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
                                            name: "${current.nomBeneficiaire} (${current.codePays})",
                                            address: current.codePays.toString(),
                                            phone: current.telBeneficiaire.toString(),
                                          ),
                                          const SizedBox(height: 20,)
                                        ],
                                      )
                                  );
                                },
                              )
                          );
                      }
                    })
            ))
          ],
        )
    );
  }
}