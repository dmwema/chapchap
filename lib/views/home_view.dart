
import 'dart:math';
import 'dart:ui';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/beneficiaire_model.dart';
import 'package:mardona/model/demande_model.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/history_card.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:mardona/view_model/points_view_model.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:mardona/view_model/wallet_view_model.dart';
import 'package:mardona/views/account_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mardona/views/send_view.dart';
import 'package:provider/provider.dart';

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

  List colors = [
    AppColors.primaryColor,
    AppColors.accentColor,
    AppColors.buttonBlackColor,
    AppColors.marronRed
  ];
  Random random = Random();

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

    demandesViewModel.beneficiaires([], context);

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
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primaryColor,
        onRefresh: () async {
          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (route) {
            return const HomeView();
          }), (route) => false);
        },
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.primaryColor,
              statusBarIconBrightness: Brightness.light, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (route) {
                  return const AccountView();
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Dernières transactions",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(onTap: () {
                                Navigator.pushNamed(context, RoutesName.history);
                              }, child: Image.asset("assets/icons/arrow-right.png")),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.30,
                          ),
                          child: Container(
                            color: AppColors.formFieldBorderColor,
                            child: ChangeNotifierProvider<DemandesViewModel>(
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
                                              shrinkWrap: true,
                                              itemCount: value.demandeList.data!.length,
                                              itemBuilder: (context, index) {
                                                DemandeModel current = DemandeModel.fromJson(value.demandeList.data![index]);
                                                if (index == 0) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(height: 10,),
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
                                    }))
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Envoyer à nouveau",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ChangeNotifierProvider<DemandesViewModel>(
                              create: (BuildContext context) => demandesViewModel,
                              child: Consumer<DemandesViewModel>(
                                  builder: (context, value, _){
                                    switch (value.beneficiairesList.status) {
                                      case Status.LOADING:
                                        return const Center(
                                          child: CupertinoActivityIndicator(color: Colors.black,),
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
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: value.beneficiairesList.data.length,
                                          itemBuilder: (context, index) {
                                            int randomIndex = random.nextInt(colors.length);

                                            BeneficiaireModel current = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, CupertinoPageRoute(builder: (route) {
                                                  return SendView(beneficiaire: current,);
                                                }));
                                              },
                                              child: Container(
                                                width: 60,
                                                margin: EdgeInsets.only(
                                                  left: index == 0 ? 20 : 0,
                                                  right: index == value.beneficiairesList.data!.length - 1 ? 20 : 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        color: AppColors.buttonBlackColor,
                                                        borderRadius: BorderRadius.circular(40),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          current.nomBeneficiaire!.split(" ").length == 2 ? current.nomBeneficiaire!.split(" ")[0][0] + current.nomBeneficiaire!.split(" ")[1][0] : current.nomBeneficiaire!.split(" ")[0][0],
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8,),
                                                    Flexible(child: AppTexts.cardDescription(current.nomBeneficiaire!))
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                    }
                                  })
                          )
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Offres spéciales",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Image.asset("assets/icons/arrow-right.png"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 240,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              color: AppColors.borderGreyColor,
                                              width: 3,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.asset(
                                              "assets/1.png",
                                              fit: BoxFit.cover,
                                              width: 250,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Flexible(
                                          child: AppTexts.cardTitle("Vos transferts du Burkina Faso vers le Canada")
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: commonBottomAppBar(context: context, active: 0),
        ),
      ),
    );
  }
}