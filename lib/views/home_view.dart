
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/home_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserModel? user;
  DemandesViewModel  demandesViewModel = DemandesViewModel();
  List<dynamic> demandes = [];

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, 5);
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const AppbarDrawer(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salut!", style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.5)
            ),),
            Text(user != null ? "${user!.prenomClient} ${user!.nomClient}": "", style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black
            ),),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    HomeCard(
                      h: 150,
                      color: AppColors.primaryColor,
                      icon: Icons.payment_rounded,
                      title: "Envoi d'argent",
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.send);
                      },
                    ),
                    const SizedBox(height: 20,),
                    HomeCard(h: 90, color: AppColors.darkRed2, icon: Icons.bar_chart, title: "Bénéficiaires", onTap: (){
                      Navigator.pushNamed(context, RoutesName.recipeints);
                    },)
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    HomeCard(h: 90, color: AppColors.darkRed, icon: Icons.compare_arrows_rounded, title: "Taux de change", onTap: () {
                      Navigator.pushNamed(context, RoutesName.exchange);
                    },),
                    const SizedBox(height: 20,),
                    HomeCard(
                      h: 150,
                      color: AppColors.marronRed,
                      icon: Icons.history_rounded,
                      title: "Historique des transferts",
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.history);
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40,),
            const Text("Dernières opérations", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.historyWP);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black
                ),
                child: const Text(
                  "Demandes avec problèmes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                    builder: (context, value, _){
                      switch (value.demandeList.status) {
                        case Status.LOADING:
                          return Expanded(child: Center(
                            child: CircularProgressIndicator(color: AppColors.primaryColor,),
                          ));
                        case Status.ERROR:
                          return Center(
                            child: Text(value.demandeList.message.toString()),
                          );
                        default:
                          demandes = value.demandeList.data!;
                          if (demandes.isEmpty) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: const Text("Aucune opération trouvée"),
                              ),
                            );
                          }
                          return Expanded(child: ListView.builder(
                              itemCount: value.demandeList.data!.length,
                              itemBuilder: (context, index) {
                                DemandeModel current = DemandeModel.fromJson(value.demandeList.data![index]);
                                return Column(
                                  children: [
                                    HistoryCard(
                                      demande: current,
                                    ),
                                    const SizedBox(height: 5,),
                                    const Divider(),
                                  ],
                                );
                              },
                            ));
                      }
                    })
            ),
          ],
        ),
      )
    );
  }
}