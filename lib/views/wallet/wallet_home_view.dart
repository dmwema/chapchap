
import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:chapchap/views/wallet/create_wallet_view.dart';
import 'package:chapchap/views/wallet/recharge_history_view.dart';
import 'package:chapchap/views/wallet/recharge_view.dart';
import 'package:chapchap/views/wallet/transfers_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletHomeView extends StatefulWidget {
  const WalletHomeView({Key? key}) : super(key: key);

  @override
  State<WalletHomeView> createState() => _WalletHomeViewSatet();
}

class _WalletHomeViewSatet extends State<WalletHomeView> {
  UserModel? user;
  final PageController pageController = PageController(viewportFraction: 1.0);
  final PageController historyPageController = PageController(viewportFraction: 1.0);
  List wallets = [];
  List recharges = [];
  List transfers = [];

  DemandesViewModel demandesViewModel = DemandesViewModel();
  WalletViewModel walletViewModel = WalletViewModel();

  AuthViewModel authViewModel = AuthViewModel();
  List<dynamic> demandes = [];
  int? nbProblemes;

  int currentWalletPage = 0;

  var currentWallet;
  bool _isHidden = true;

  int historyPage = 1;

  List<Widget> msgList = [];

  bool loadEmail = false;
  bool loadSMS = false;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void getHistory (int type, String currency, WalletViewModel viewModel) {
    if (type == 1) {
      viewModel.getRechargesHistory(currency, context);
    } else if (type == 2) {
      viewModel.getTransfersHistory(currency, context);
    }
  }

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
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
      walletViewModel.getMyWallets(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          context: context,
          navWhite: true,
          backArrow: true,
          color: true,
          backClick: () {
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
          },
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.primaryColor,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppTexts.titleText("Portefeuilles", color: Colors.white),
                        Row(
                          children: [
                            IconButton(onPressed: () {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CreateWalletView()));
                            }, icon: const Icon(CupertinoIcons.add_circled_solid, color: Colors.white, size: 20,)),
                          ],
                        )
                      ],
                    ),
                    // const Text("Vous avez 4 porteffeuilles ChapChap", style: TextStyle(
                    //   color: Colors.white70,
                    //   fontSize: 15,
                    // ),),
                    const SizedBox(height: 10,),
                     Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black26
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: ChangeNotifierProvider<WalletViewModel>(
                            create: (BuildContext context) => walletViewModel,
                            child: Consumer<WalletViewModel>(
                                builder: (context, value, _){
                                  switch (value.walletsList.status) {
                                    case Status.LOADING:
                                      return Center(
                                        child: AppTexts.titleText("-", color: Colors.white)
                                      );
                                    case Status.ERROR:
                                      return Center(
                                        child: Text(value.walletsList.message.toString()),
                                      );
                                    default:
                                      wallets = value.walletsList.data!;
                                      if (wallets.isNotEmpty) {
                                        currentWallet = wallets[0];
                                        WalletViewModel viewModel = WalletViewModel();
                                      }
                                      if (user != null && wallets.isEmpty) {
                                        return RoundedButton(
                                          title: "Creer un wallet",
                                          loading: walletViewModel.loading,
                                          onPress: () async {
                                            await walletViewModel.createWallet({
                                              "currency": Utils.countryMoneyCode[user!.codePays]
                                            }, context);
                                          },
                                          color: Colors.white,
                                          textColor: AppColors.buttonBlackColor,
                                          icon: Icons.add,
                                        );
                                      }
                                      return Stack(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              height: 30,
                                              child: PageView.builder(
                                                itemCount: wallets.length,
                                                scrollDirection: Axis.horizontal,
                                                controller: pageController,
                                                onPageChanged: (index) {
                                                  setState(() {
                                                    currentWalletPage = index;
                                                  });
                                                },
                                                itemBuilder: (BuildContext context, int index) {
                                                  var wallet = wallets[index];
                                                  return Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: _toggleVisibility,
                                                          child: AnimatedContainer(
                                                            duration: const Duration(milliseconds: 300),
                                                            margin: const EdgeInsets.only(right: 3),
                                                            padding: const EdgeInsets.all(5),
                                                            child: Center(
                                                              child: Icon(
                                                                _isHidden
                                                                    ? CupertinoIcons.eye_fill
                                                                    : CupertinoIcons.eye_slash_fill,
                                                                color: Colors.white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ImageFiltered(
                                                            imageFilter: ImageFilter.blur(sigmaX: _isHidden ? 5 : 0, sigmaY: _isHidden ? 5 : 0),
                                                            child: AppTexts.titleText("${wallet['balance']} ${wallet['currency']}", color: Colors.white),
                                                        ),

                                                      ],
                                                    )
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: -10,
                                            child: IconButton(
                                              icon: Icon(Icons.chevron_left, color: currentWalletPage > 0 ? Colors.white : Colors.white24, size: 24,),
                                              onPressed: () {
                                                if (currentWalletPage > 0) {
                                                  pageController.previousPage(
                                                    duration: const Duration(milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                  );
                                                  setState(() {
                                                    currentWalletPage -= 1;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: -10,
                                            child: IconButton(
                                              icon: Icon(Icons.chevron_right, color: currentWalletPage < wallets.length - 1 ? Colors.white: Colors.white24, size: 24,),
                                              onPressed: () {
                                                if (currentWalletPage < wallets.length - 1) {
                                                  pageController.nextPage(
                                                    duration: const Duration(milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                  );
                                                  setState(() {
                                                    currentWalletPage += 1;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                  }
                                }
                            )
                        )
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTexts.bodyText("Operations", bold: true),
                        const SizedBox(height: 5,),
                        AppTexts.descriptionText("Gérez votre Wallet de manière efficace")
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    RoundedButton(
                        title: "Recharger le compte ${wallets.isNotEmpty ? wallets[currentWalletPage]['currency'] : ''}",
                        icon: Icons.wallet,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          if (wallets.isNotEmpty) {
                            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => RechargeView(wallet: wallets[currentWalletPage])));
                          }
                        }
                    ),
                    const SizedBox(height: 10,),
                    RoundedButton(
                        title: "Nouveau transfert",
                        icon: CupertinoIcons.arrow_up_right,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.pushNamed(context, RoutesName.send);
                        }
                    ),

                    if (user != null && user!.codePays == "ca")
                      const SizedBox(height: 10,),
                    if (user != null && user!.codePays == "ca")
                      RoundedButton(
                          title: "informations de recharge",
                          icon: Icons.payment,
                          color: AppColors.buttonBlackColor,
                          textColor: Colors.white,
                          onPress: () {
                            Navigator.pushNamed(context, RoutesName.interac);
                          }
                      ),
                    const SizedBox(height: 20,),
                    Divider(color: AppColors.formFieldColor,),
                    const SizedBox(height: 10,),
                    AppTexts.cardTitle("Historiques"),
                    const SizedBox(height: 20,),
                    RoundedButton(
                        title: "Mes rechargements ${wallets.isNotEmpty ? wallets[currentWalletPage]['currency'] : ''}",
                        icon: Icons.history,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          if (wallets.isNotEmpty) {
                            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => RechargeHistoryView(wallet: wallets[currentWalletPage])));
                          }
                        }
                    ),
                    const SizedBox(height: 10,),
                    RoundedButton(
                        title: "Mes transferts ${wallets.isNotEmpty ? wallets[currentWalletPage]['currency'] : '' }",
                        icon: Icons.history,
                        color: AppColors.buttonBlackColor,
                        textColor: Colors.white,
                        onPress: () {
                          if (wallets.isNotEmpty) {
                            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TransfersHistoryView(  wallet: wallets[currentWalletPage])));
                          }
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}