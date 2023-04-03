import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/confirm_delete.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientsView extends StatefulWidget {
  const RecipientsView({Key? key}) : super(key: key);

  @override
  State<RecipientsView> createState() => _RecipientsViewState();
}

class _RecipientsViewState extends State<RecipientsView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.beneficiaires([], context);
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
          backUrl: RoutesName.home,
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider<DemandesViewModel>(
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
                          padding: const EdgeInsets.all(20),
                          child: ListView.builder(
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
                                                    return SizedBox(
                                                      height: 200,
                                                      child: Center(
                                                        child: CircularProgressIndicator(color: AppColors.primaryColor,),
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
                                                          const SizedBox(height: 20,),
                                                          Text(beneficiaire.nomBeneficiaire.toString(), style: const TextStyle(
                                                              fontWeight: FontWeight.w600
                                                          ),),
                                                          const SizedBox(height: 10,),
                                                          Text(beneficiaire.telBeneficiaire.toString(), style: TextStyle(
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
                                                                  Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                                  const SizedBox(width: 10,),
                                                                  Text("(${beneficiaire.paysMonnaie})"),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          const Divider(),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              const Text("E-mail", style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                              ),),
                                                              Text(beneficiaire.emailBeneficiaire.toString()),
                                                            ],
                                                          ),
                                                          if (beneficiaire.banque != null || beneficiaire.banque == "")
                                                            const SizedBox(height: 10,),
                                                          if (beneficiaire.banque != null || beneficiaire.banque == "")
                                                            const Divider(),
                                                          if (beneficiaire.banque != null || beneficiaire.banque == "")
                                                            const SizedBox(height: 10,),
                                                          if (beneficiaire.banque != null || beneficiaire.banque == "")
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Text("Banque", style: TextStyle(
                                                                    fontWeight: FontWeight.bold
                                                                ),),
                                                                Text(beneficiaire.banque.toString()),
                                                              ],
                                                            ),
                                                          if (beneficiaire.swift != null)
                                                            const SizedBox(height: 10,),
                                                          if (beneficiaire.swift != null)
                                                            const Divider(),
                                                          if (beneficiaire.swift != null)
                                                            const SizedBox(height: 10,),
                                                          if (beneficiaire.swift != null)
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Text("Swift", style: TextStyle(
                                                                    fontWeight: FontWeight.bold
                                                                ),),
                                                                Text(beneficiaire.swift.toString()),
                                                              ],
                                                            ),
                                                          if (beneficiaire.iban != null)
                                                            const SizedBox(height: 10,),
                                                          if (beneficiaire.iban != null)
                                                            const Divider(),
                                                          if (beneficiaire.iban != null)
                                                            const SizedBox(height: 10,),
                                                          if (beneficiaire.iban != null)
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Text("Iban", style: TextStyle(
                                                                    fontWeight: FontWeight.bold
                                                                ),),
                                                                Text(beneficiaire.iban.toString()),
                                                              ],
                                                            ),
                                                          SizedBox(height: 20,),
                                                          RoundedButton(
                                                            title: "Supprimer",
                                                            onPress: () {
                                                              DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                              showModalBottomSheet(
                                                                context: context,
                                                                isScrollControlled: true,
                                                                builder: (context) {
                                                                  return ConfirmDelete(recipientId: beneficiaire.idBeneficiaire!.toInt(), demandesViewModel: demandesViewModel3);
                                                                },
                                                                shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.vertical(
                                                                    top: Radius.circular(20),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            color: Colors.red,
                                                            textColor: Colors.white,
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
        )
    );
  }
}