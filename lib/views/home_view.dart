
import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/points_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:chapchap/views/notifications_view.dart';
import 'package:chapchap/views/points/points_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin{
  UserModel? user;

  DemandesViewModel  demandesViewModel = DemandesViewModel();
  WalletViewModel walletViewModel = WalletViewModel();
  PointsViewModel pointsViewModel = PointsViewModel();

  bool _isHidden = true;

  AuthViewModel authViewModel = AuthViewModel();
  List<dynamic> demandes = [];
  int? nbProblemes;

  List<Map> msgList = [];

  bool loadEmail = false;
  bool loadSMS = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
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
      pointsViewModel.getBalance(context);
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.bgColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
              systemNavigationBarDividerColor: Colors.white,
            ),
            surfaceTintColor: Colors.transparent
          ),
        ),
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                      child: commonRoundedContainer(
                          removePaddingV: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/icons/coins.png", width: 35,),
                                    const SizedBox(width: 5,),
                                    ChangeNotifierProvider<PointsViewModel>(
                                        create: (BuildContext context) => pointsViewModel,
                                        child: Consumer<PointsViewModel>(
                                            builder: (context, value, _){
                                              switch (value.balance.status) {
                                                case Status.LOADING:
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color: Colors.white,
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    child: const CupertinoActivityIndicator(radius: 8,),
                                                  );
                                                case Status.ERROR:
                                                  return Center(
                                                    child: Text(value.balance.message.toString()),
                                                  );
                                                default:
                                                  var pBalance = value.balance.data!;
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(builder: (context) => PointsView())
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: AppColors.formFieldColor,
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      child: AppTexts.bodyText(pBalance.toString(), bold: true, color: Colors.orange),
                                                    ),
                                                  );
                                              }
                                            })
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (msgList.isEmpty) {
                                          Utils.toastMessage("Vous n'avez aucune notification");
                                        } else {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => NotificationsView(notifications: msgList,),
                                            ),
                                          );
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: AppColors.formFieldColor,
                                              ),
                                              padding: const EdgeInsets.all(7),
                                              child: SvgPicture.asset("assets/icons/bell.svg", width: 25,),
                                            ),
                                          ),
                                          if (msgList.isNotEmpty)
                                            Positioned(
                                              top: 0, left: 0,
                                              child: Container(
                                                width: 17, height: 17,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: AppColors.primaryColor,
                                                ),
                                                child: Center(child: AppTexts.menuText(msgList.length.toString(), color: Colors.white),),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 7,),
                                    InkWell(
                                      onTap: () {
                                        Share.share(
                                          "Découvrez Transfert ChapChap! 🎉 \n\nUne application facile à utiliser pour envoyer de l'argent à ses proche dans plusieurs pays du monde.\nObtenez-le à cette adresse https://chapchap.ca\n\nUtilisez le code ${user!.codeParrainage} pour gagner 10\$ et me faire gagner 10\$",
                                          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: AppColors.formFieldColor,
                                        ),
                                        padding: const EdgeInsets.all(7),
                                        child: SvgPicture.asset("assets/icons/share.svg", width: 25,),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, RoutesName.home);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: AppColors.formFieldColor,
                                        ),
                                        padding: const EdgeInsets.all(7),
                                        child: const Icon(Icons.refresh, weight: 25,),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                        child: commonRoundedContainer(
                          gradient: true,
                          removePaddingV: true,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/icons/wallet.svg", color: Colors.white, width: 40,),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppTexts.bodyText("Portefeuille", bold: true, color: Colors.white),
                                          AppTexts.cardDescription("Simple et Rapide", color: Colors.white)
                                        ],
                                      )
                                    ],
                                  ),
                                  ChangeNotifierProvider<WalletViewModel>(
                                      create: (BuildContext context) => walletViewModel,
                                      child: Consumer<WalletViewModel>(
                                          builder: (context, value, _){
                                            switch (value.balance.status) {
                                              case Status.LOADING:
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.white,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  child: AppTexts.smallText("Commencer", color: AppColors.buttonBlackColor),
                                                );
                                              case Status.ERROR:
                                                return Center(
                                                  child: Text(value.balance.message.toString()),
                                                );
                                              default:
                                                var balance = value.balance.data!;
                                                return Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 15, top: 15),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(30),
                                                          color: Colors.black12,
                                                        ),
                                                        padding: const EdgeInsets.only(right: 10, top: 2, bottom: 2),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: _toggleVisibility,
                                                              child: AnimatedContainer(
                                                                duration: const Duration(milliseconds: 300),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black26,
                                                                  borderRadius: BorderRadius.circular(30),
                                                                ),
                                                                margin: const EdgeInsets.only(right: 7),
                                                                padding: const EdgeInsets.all(7),
                                                                child: Center(
                                                                  child: Icon(
                                                                    _isHidden
                                                                        ? CupertinoIcons.eye_fill
                                                                        : CupertinoIcons.eye_slash_fill,
                                                                    color: Colors.white,
                                                                    size: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            ImageFiltered(
                                                                imageFilter: ImageFilter.blur(sigmaX: _isHidden ? 5 : 0, sigmaY: _isHidden ? 5 : 0),
                                                                child: AppTexts.titleText("${balance["balance"]}", color: Colors.white)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (!_isHidden)
                                                    Positioned(
                                                      right: 0,
                                                      bottom: 0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.black,
                                                        ),
                                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                                        child: Text(
                                                          "${balance["currency"]}",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                            }
                                          })
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTexts.descriptionText("Salut"),
                            if (user != null)
                              AppTexts.titleText("${user!.prenomClient} ${user!.nomClient}",)
                          ],
                        ),
                        if (user != null)
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                              image: AssetImage("packages/country_icons/icons/flags/png/${user!.codePays}.png"),
                              fit: BoxFit.cover
                            )
                          ),
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
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Row(
                                children: [
                                  AppTexts.buttonText("Tout voir", color: Colors.white),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.formFieldBorderColor,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTexts.cardTitle("Dernières Opérations")
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