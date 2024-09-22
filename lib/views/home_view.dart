
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/info_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin{
  UserModel? user;

  DemandesViewModel  demandesViewModel = DemandesViewModel();
  WalletViewModel walletViewModel = WalletViewModel();

  AuthViewModel authViewModel = AuthViewModel();
  List<dynamic> demandes = [];
  int? nbProblemes;

  List<Widget> msgList = [];

  bool loadEmail = false;
  bool loadSMS = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      setState(() {
        loadEmail = false;
        loadSMS = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, 20).then((value) {
      setState(() {
        nbProblemes = value;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    UserViewModel().getUser().then((value) {
      setState(() {
      user = value;
      });
      walletViewModel.getBalance(context, Utils.countryMoneyCode[user!.codePays.toString()]!);
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.formFieldColor,
        resizeToAvoidBottomInset: false,
        body: SuperScaffold(
          appBar: SuperAppBar(
            border: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
            backgroundColor: Colors.transparent,
            // title: const Text("Hello"),
            leading: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.accountView);
                },
                child: const Icon(CupertinoIcons.profile_circled, size: 28,),
              ),
            ),
            // alwaysShowTitle: true,
            largeTitle: SuperLargeTitle(
              enabled: true,
              largeTitle: "ChapChap",
              textStyle: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.w900
              )
            ),
            actions: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Share.share(
                            "Découvrez Transfert ChapChap! 🎉 \n\nUne application facile à utiliser pour envoyer de l'argent à ses proche dans plusieurs pays du monde.\nObtenez-le à cette adresse https://chapchap.ca\n\nUtilisez le code ${user!.codeParrainage} pour gagner 10\$ et me faire gagner 10\$",
                            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primaryColor
                            ),
                            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 6, right: 5),
                            child: const Icon(Icons.share_outlined, color: Colors.white, size: 16,)
                        ),
                      ),
                      const SizedBox(width: 5,),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesName.home,
                                (route) => false,
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black
                            ),
                            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 6, right: 5),
                            child: const Icon(CupertinoIcons.refresh, color: Colors.white, size: 16,)
                        ),
                      ),
                      const SizedBox(width: 5,),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.historyWP);
                        },
                        child: Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black54
                                ),
                                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 6, right: 5),
                                child: const Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.white, size: 16,)
                            ),
                            if (nbProblemes != null && nbProblemes! > 0)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  padding: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(nbProblemes.toString(), style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    ),),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5,),
                      InkWell(
                        onTap: () async {
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          bool? presentationWalletPassed = preferences.getBool('wallet_presentation_passed');

                          if (presentationWalletPassed != true || user!.pin != true) {
                            await preferences.setBool('wallet_presentation_passed', true);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesName.walletPresentation,
                                  (route) => false,
                            );
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesName.walletHome,
                                  (route) => false,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.primaryColor
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                          child: ChangeNotifierProvider<WalletViewModel>(
                              create: (BuildContext context) => walletViewModel,
                              child: Consumer<WalletViewModel>(
                                  builder: (context, value, _){
                                    switch (value.balance.status) {
                                      case Status.LOADING:
                                        return const Row(
                                          children: [
                                            Icon(Icons.wallet_rounded, color: Colors.white, size: 15,),
                                            SizedBox(width: 5,),
                                            Text("Wallet", style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 12
                                            ),)
                                          ],
                                        );
                                      case Status.ERROR:
                                        return Center(
                                          child: Text(value.balance.message.toString()),
                                        );
                                      default:
                                        var balance = value.balance.data!;
                                        return Row(
                                          children: [
                                            const Icon(Icons.wallet_rounded, color: Colors.white, size: 15,),
                                            const SizedBox(width: 5,),
                                            Text("${balance["balance"]} ${balance["currency"]}", style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 12
                                            ),)
                                          ],
                                        );
                                    }
                                  })
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
            searchBar: SuperSearchBar(
              enabled: false,
            ),
            bottom: SuperAppBarBottom(
              enabled: true,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Salut!,", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),),
                    const SizedBox(width: 5),
                    Text(user != null ? "${user!.prenomClient} ${user!.nomClient}": "", style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black
                    ),),
                  ],
                ),
              ), // Any widget of yours
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 250.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    // border: Border.all(color: Colors.black38, width: 1)
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54, width: 1)
                          ),
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/logo_red.png", width: 20,),
                              const SizedBox(width: 10,),
                              const Flexible(child: Text("Bienvenue chez ChapChap, la meilleure application de transfert d’argent. Profitez de la belle expérience!",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                ),
                              ))
                            ],
                          ),
                        ),
                        ...msgList,
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Colors.black45),
                    bottom: BorderSide(color: Colors.black45),
                  ),
                  color: AppColors.primaryColor.withOpacity(.1)
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dernières opérations", style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                        ),),
                      ],
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
                              return const Padding(padding: EdgeInsets.all(20),
                                child: Center(child: Text("Aucune opération récente.")),
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
        bottomNavigationBar: commonBottomAppBar(context: context, active: 0),
      ),
    );
  }
}