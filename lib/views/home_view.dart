
import 'package:chapchap/common/common_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
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

  List<Map> msgList = [];

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
            msgList.add(element);
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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0, top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (msgList.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(height: 120.0),
                          items: [1, ...msgList].map((element) {
                            return Builder(
                              builder: (BuildContext context) {
                                if (element is int) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            width: 60,
                                            height: 60,
                                            child: Center(child: Image.asset("assets/logo.png", width: 40,))
                                        ),
                                        const SizedBox(width: 15,),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppTexts.cardTitle("ChapChap"),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              AppTexts.cardDescription("La meilleure application de transfert d’argent."),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(context, RoutesName.send);
                                                  },
                                                  child: AppTexts.buttonText("Commencer", color: AppColors.primaryColor)
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else if (element is Map) {
                                  return InfoCard(type: element['type_msg_info'], content: element['msg']);
                                }
                                return Container();
                              },
                            );
                          }).toList(),
                        ),
                      if (msgList.isEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  width: 60,
                                  height: 60,
                                  child: Center(child: Image.asset("assets/logo.png", width: 40,))
                              ),
                              const SizedBox(width: 15,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTexts.cardTitle("ChapChap"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, RoutesName.send);
                                      },
                                      child: AppTexts.buttonText("Commencer", color: AppColors.primaryColor)
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTexts.smallText("Salut"),
                            if (user != null)
                              AppTexts.titleText("${user!.prenomClient} ${user!.nomClient}",)
                          ],
                        ),
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
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.lightGrey
                                  ),
                                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 6, right: 5),
                                  child: Icon(Icons.share_outlined, color: AppColors.primaryColor, size: 17,)
                              ),
                            ),
                            const SizedBox(width: 10,),
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
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.lightGrey
                                  ),
                                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 6, right: 5),
                                  child: Icon(CupertinoIcons.refresh, color: AppColors.primaryColor, size: 17,)
                              ),
                            ),
                            // const SizedBox(width: 5,),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.pushNamed(context, RoutesName.historyWP);
                            //   },
                            //   child: Stack(
                            //     children: [
                            //       Container(
                            //           decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.circular(5),
                            //               color: Colors.black54
                            //           ),
                            //           padding: const EdgeInsets.only(left: 5, top: 5, bottom: 6, right: 5),
                            //           child: const Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.white, size: 16,)
                            //       ),
                            //       if (nbProblemes != null && nbProblemes! > 0)
                            //         Positioned(
                            //           top: 0,
                            //           right: 0,
                            //           child: Container(
                            //             width: 14,
                            //             height: 14,
                            //             padding: const EdgeInsets.only(bottom: 4),
                            //             decoration: BoxDecoration(
                            //               color: Colors.red,
                            //               borderRadius: BorderRadius.circular(10),
                            //             ),
                            //             child: Center(
                            //               child: Text(nbProblemes.toString(), style: const TextStyle(
                            //                   color: Colors.white,
                            //                   fontWeight: FonnbProblemes.toString()tWeight.bold,
                            //                   fontSize: 12
                            //               ),),
                            //             ),
                            //           ),
                            //         ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                    if (nbProblemes != null && nbProblemes! > 0)
                    const SizedBox(height: 10,),
                    if (nbProblemes != null && nbProblemes! > 0)
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.historyWP);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: Colors.red),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red,),
                                const SizedBox(width: 5,),
                                AppTexts.smallText("$nbProblemes Transfert${nbProblemes! > 1 ? 's': ''} échoué${nbProblemes! > 1 ? 's': ''}"),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.red
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.more_horiz, color: Colors.white,),
                                  const SizedBox(width: 2,),
                                  AppTexts.buttonText("Tout voir", color: Colors.white),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (nbProblemes != null && nbProblemes! > 0)
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
              Divider(
                color: AppColors.lightGrey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
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
                        gradient: const LinearGradient(
                          colors: [Color(0xffe86328), Color(0xffd34040)],
                          stops: [0.25, 0.75],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTexts.titleText("Wallet", color: Colors.white),
                            AppTexts.descriptionText("Simple et Rapide", color: Colors.white)
                          ],
                        ),
                        ChangeNotifierProvider<WalletViewModel>(
                            create: (BuildContext context) => walletViewModel,
                            child: Consumer<WalletViewModel>(
                                builder: (context, value, _){
                                  switch (value.balance.status) {
                                    case Status.LOADING:
                                      return Row(
                                        children: [
                                          const Icon(Icons.wallet_rounded, color: Colors.white, size: 15,),
                                          const SizedBox(width: 5,),
                                          AppTexts.buttonText("Wallet", color: Colors.white),
                                        ],
                                      );
                                    case Status.ERROR:
                                      return Center(
                                        child: Text(value.balance.message.toString()),
                                      );
                                    default:
                                      var balance = value.balance.data!;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          AppTexts.smallText("SOLDE ACTUEL", color: Colors.white ),
                                          AppTexts.titleText("${balance["balance"]} ${balance["currency"]}", color: Colors.white),
                                        ],
                                      );
                                  }
                                })
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: AppColors.lightGrey,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black.withOpacity(.3), width: 1))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTexts.cardTitle("DERNIERES OPERATIONS")
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
                              return Padding(padding: const EdgeInsets.all(20),
                                child: Center(child: AppTexts.descriptionText("Aucune opération récente.")),
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: value.demandeList.data!.length,
                                itemBuilder: (context, index) {
                                  DemandeModel current = DemandeModel.fromJson(value.demandeList.data![index]);
                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 20,),
                                        HistoryCard(
                                          demande: current,
                                        )
                                      ],
                                    );
                                  }
                                  return
                                    HistoryCard(
                                      demande: current,
                                    )
                                  ;
                                },
                              ),
                            );
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