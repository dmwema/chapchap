
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/home_card.dart';
import 'package:chapchap/res/components/info_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
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
  AuthViewModel authViewModel = AuthViewModel();
  List<dynamic> demandes = [];

  List<Widget> msgList = [];

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, 20);
    UserViewModel().getUser().then((value) {
      setState(() {
      user = value;
      });
    });

    authViewModel.getInfoMessages(context).then((value) {
      if (value != null && value['error'] != true && value['data'] != null && value['data'].length > 0) {
        value['data'].forEach((element) => {
          setState(() {
            msgList.add(InfoCard(type: element['type_msg_info'], content: element['msg']));
          })
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.formFieldColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.home,
                          (route) => false,
                        );
                      },
                      child: Container(
                        child: Icon(CupertinoIcons.refresh, color: Colors.black,),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.formFieldBorderColor)
                    ),
                  color: Colors.grey.withOpacity(.1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/logo_black.png", width: 20,),
                          const SizedBox(width: 10,),
                          const Flexible(child: Text("Bienvenue chez ChapChap, la meilleur application de transfert d’argent. Profitez de la belle experience!",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                            ),
                          ))
                        ],
                      ),
                    ),
                    ...msgList,
                    const SizedBox(height: 10,)
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
                              return SizedBox(
                                height: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.asset("assets/empty.png", width: 180,),
                                      const SizedBox(height: 20,),
                                      SizedBox(
                                        width: 230,
                                        child: Text(
                                          "Aucune opération trouvée.",
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(.4),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 40,),
                                    ],
                                  ),
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
        bottomNavigationBar: commonBottomAppBar(context: context, active: 0),
      ),
    );
  }
}