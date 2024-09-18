
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
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

  DemandesViewModel  demandesViewModel = DemandesViewModel();
  WalletViewModel walletViewModel = WalletViewModel();

  AuthViewModel authViewModel = AuthViewModel();
  List<dynamic> demandes = [];
  int? nbProblemes;

  int currentWalletPage = 0;

  var currentWallet;

  int historyPage = 1;

  List<Widget> msgList = [];

  bool loadEmail = false;
  bool loadSMS = false;

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

  void getRechargesHistory (String currency) {

  }

  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.formFieldColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                  context: context,
                  backArrow: true,
                  textColor: Colors.white,
                  appBarColor: AppColors.primaryColor,
                  backClick: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.home,
                          (route) => false,
                    );
                  }
              ),
              Container(
                color: AppColors.primaryColor,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Portefeuilles", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                    const Divider(color: Colors.white24,),
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
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                        child: ChangeNotifierProvider<WalletViewModel>(
                            create: (BuildContext context) => walletViewModel,
                            child: Consumer<WalletViewModel>(
                                builder: (context, value, _){
                                  switch (value.walletsList.status) {
                                    case Status.LOADING:
                                      return const Center(
                                        child: Text("-", style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 12
                                        ),),
                                      );
                                    case Status.ERROR:
                                      return Center(
                                        child: Text(value.walletsList.message.toString()),
                                      );
                                    default:
                                      wallets = value.walletsList.data!;
                                      currentWallet = wallets[0];
                                      if (wallets.isEmpty && user != null) {
                                        return InkWell(
                                          onTap: () async {
                                            await walletViewModel.createWallet({
                                              "currency": Utils.countryMoneyCode[user!.codePays]
                                            }, context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (!walletViewModel.loading)
                                                Icon(Icons.add, color: AppColors.primaryColor,),
                                                if (walletViewModel.loading)
                                                  CupertinoActivityIndicator(color: AppColors.primaryColor, radius: 8,),
                                                const SizedBox(width: 10,),
                                                Text("Creer un wallet", style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                                ),)
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return Stack(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              height: 50,
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
                                                    child: Text(wallet['balance'] + " " + wallet['currency'], style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.white
                                                    ),),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
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
                    if (wallets.isNotEmpty)
                    const SizedBox(height: 20,),
                    if (wallets.isNotEmpty)
                    const Text("Que voulez-vous faire ?", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),),
                    if (wallets.isNotEmpty)
                    const SizedBox(height: 10,),
                    if (wallets.isNotEmpty)
                    InkWell(
                      onTap: () {
                        if (wallets.isNotEmpty) {

                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: const Row(
                          children: [
                            Icon(Icons.send_to_mobile, color: Colors.black, size: 20,),
                            SizedBox(width: 8,),
                            Text(
                              "Nouveau transfert",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (wallets.isNotEmpty)
                    const SizedBox(height: 10,),
                    if (wallets.isNotEmpty)
                    InkWell(
                      onTap: () {
                        if (wallets.isNotEmpty) {

                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: const Row(
                          children: [
                            Icon(Icons.compare_arrows_sharp, color: Colors.black, size: 20,),
                            SizedBox(width: 8,),
                            Text(
                              "Transfert entre comptes",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (wallets.isNotEmpty)
                    const SizedBox(height: 10,),
                    if (wallets.isNotEmpty)
                    InkWell(
                      onTap: () {
                        if (wallets.isNotEmpty) {

                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: const Row(
                          children: [
                            Icon(Icons.wallet, color: Colors.black, size: 20,),
                            SizedBox(width: 8,),
                            Text(
                              "Recharger le compte",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Historiques", style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),),
                        Text("De ${historyPage == 1 ? 'recharges' : 'transferts'}", style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),),
                      ],
                    ),
                    if (user != null)
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (historyPage > 0) {
                                historyPageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {
                                  historyPage = 1;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: historyPage == 1 ? AppColors.primaryColor : Colors.white,
                                border: Border.all(width: 1, color: historyPage == 1 ? AppColors.primaryColor : Colors.black26),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Recharges", style: TextStyle(
                                      fontSize: 10,
                                      color: historyPage == 1 ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print(historyPage);
                              if (historyPage < 2) {
                                historyPageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {
                                  historyPage = 2;
                                });
                              }
                              print(historyPage);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: historyPage == 2 ? AppColors.primaryColor : Colors.white,
                                border: Border.all(width: 1, color: historyPage == 2 ? AppColors.primaryColor: Colors.black26),
                                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5), topRight: Radius.circular(5)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Transferts", style: TextStyle(
                                      fontSize: 10,
                                      color: historyPage == 2 ? Colors.white: Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: historyPageController,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                      return ChangeNotifierProvider<DemandesViewModel>(
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

                                      },
                                    ));
                                }
                              })
                      );
                  }
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Vous n'avez encore aucun wallet"),
              )
            ],
          ),
        ),
      ),
    );
  }
}