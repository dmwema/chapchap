
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/home_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
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
    demandesViewModel.myDemandes([], context, 20);
    UserViewModel().getUser().then((value) {
      setState(() {
      user = value;
      });
    });
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
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Salut!", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.7)
                  ),),
                  Text(user != null ? "${user!.prenomClient} ${user!.nomClient}": "", style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.formFieldBorderColor)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dernières opérations", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.historyWP);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black
                      ),
                      child: const Text(
                        "Demandes avec problèmes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                    builder: (context, value, _){
                      switch (value.demandeList.status) {
                        case Status.LOADING:
                          return const Expanded(child: Center(
                            child: CupertinoActivityIndicator(color: Colors.black),
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
                                return
                                  HistoryCard(
                                    demande: current,
                                  )
                                ;
                              },
                            ));
                      }
                    })
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
      FloatingActionButton(
        backgroundColor: AppColors.primaryColor, 
        child: const Icon(CupertinoIcons.arrow_up_right), onPressed: () {
          Navigator.pushNamed(context, RoutesName.send);
      }
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(child: Icon(CupertinoIcons.square_grid_2x2_fill, color: AppColors.primaryColor,), onTap: () {
                    // Navigator.pushNamed(context, RoutesName.send);
                  }),
                  const SizedBox(height: 5), // The dummy child
                  Text("Accueil", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: AppColors.primaryColor),)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(child: const Icon(CupertinoIcons.person_2), onTap: () {
                    Navigator.pushNamed(context, RoutesName.recipeints);
                  }),
                  const SizedBox(height: 5), // The dummy child
                  const Text("Bénéficiaires", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),)
                ],
              ),
              const SizedBox(width: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(child: const Icon(CupertinoIcons.arrow_right_arrow_left_circle), onTap: () {
                    Navigator.pushNamed(context, RoutesName.exchange);
                  }),
                  const SizedBox(height: 5), // The dummy child
                  const Flexible(child: Text("Change",  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(child: const Icon(CupertinoIcons.person), onTap: () {
                    Navigator.pushNamed(context, RoutesName.profile);
                  }),
                  const SizedBox(height: 5), // The dummy child
                  const Text("Mon compte", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),)
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}