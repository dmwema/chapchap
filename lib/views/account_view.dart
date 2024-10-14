import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> with SingleTickerProviderStateMixin {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PinViewModel pinViewModel = PinViewModel();
  PaysModel selectedFrom = PaysModel();
  bool loadingBio = false;
  WalletViewModel walletViewModel = WalletViewModel();
  UserModel? user;
  Destination? selectedTo;
  PaysDestinationModel? paysDestinationModel;
  List destinationsList = [];
  AuthViewModel authViewModel = AuthViewModel();
  bool changed = false;
  SharedPreferences? preferences;
  bool localAuthEnabled = false;

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

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    loadPr();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    setState(() {
      AuthViewModel().getLocalAuth().then((value) {
        setState(() {
          localAuthEnabled = value;
        });
      });
    });
    demandesViewModel.paysActifs([], context);

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
      walletViewModel.getBalance(context, Utils.countryMoneyCode[user!.codePays.toString()]!);
    });
  }

  Future loadPr() async {
    var pr = await SharedPreferences.getInstance();
    setState(() {
      preferences = pr;
    });
  }

  void insert(content, TextEditingController controller) {
    if (content.runtimeType.toString() == "double"){
      if (controller == _toController) {
        content = double.parse(content.toStringAsFixed(2));
      } else {
        content = double.parse(content.toStringAsFixed(2));
      }
      controller.value = TextEditingValue(
        text: content.toString(),
        selection: TextSelection.collapsed(offset: content.toString().length),
      );
    } else {
      _amountController.clear();
      _toController.clear();
    }
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
              commonAppBar(
                context: context,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Mon compte", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
              ),
              Expanded(
                child: ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                        builder: (context, value, _){
                          switch (value.paysActifList.status) {
                            case Status.LOADING:
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CupertinoActivityIndicator(color: Colors.black,),
                                ),
                              );
                            case Status.ERROR:
                              return Center(
                                child: Text(value.paysActifList.message.toString()),
                              );
                            default:
                              List paysActifsList = value.paysActifList.data!;
                              for (var element in paysActifsList) {
                                PaysModel pays = PaysModel.fromJson(element);
                                if (user != null && selectedFrom.idPays == null && (pays.idPays.toString() == user!.idPays.toString())) {
                                  selectedFrom = pays;
                                }
                              }
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProfileMenu(
                                        title: "informations personnelles",
                                        icon: Icons.notes,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.profile);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Pays de résidence",
                                        icon: CupertinoIcons.map,
                                        suffix: Image.asset("packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png", width: 20, height: 15, fit: BoxFit.contain),
                                        noIcon: true,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text("Séléctionnez le pays", style: TextStyle(
                                                          fontWeight: FontWeight.w600
                                                      ),),
                                                      const SizedBox(height: 20,),
                                                      Expanded(child: ListView.builder(
                                                        itemCount: paysActifsList.length,
                                                        itemBuilder: (context, index) {
                                                          PaysModel current = PaysModel.fromJson(paysActifsList[index]);
                                                          return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedFrom = current;
                                                                  changed = true;
                                                                  if (!demandesViewModel.loading) {
                                                                    Map data = {
                                                                      'idPays': selectedFrom.idPays,
                                                                      'adresse': user!.adresse
                                                                    };
                                                                    demandesViewModel.uClient(data, context, false);
                                                                  }
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                                    const SizedBox(width: 20,),
                                                                    Text(current.paysNom.toString(), style: const TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold
                                                                    ),)
                                                                  ],
                                                                ),
                                                              )
                                                          );
                                                        },
                                                      ))
                                                    ],
                                                  )
                                              );
                                            },
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Mon historique",
                                        icon: Icons.history_rounded,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.history);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Mes factures",
                                        icon: CupertinoIcons.doc_text,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.invoices);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Coupons rabais & Parrainage",
                                        icon: CupertinoIcons.gift,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.couponView);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Nous joindre",
                                        icon: Icons.phone_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.contactView);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Wallet",
                                        icon: Icons.wallet,
                                        suffix: ChangeNotifierProvider<WalletViewModel>(
                                            create: (BuildContext context) => walletViewModel,
                                            child: Consumer<WalletViewModel>(
                                                builder: (context, value, _){
                                                  switch (value.balance.status) {
                                                    case Status.LOADING:
                                                      return const CupertinoActivityIndicator();
                                                    case Status.ERROR:
                                                      return Container();
                                                    default:
                                                      var balance = value.balance.data!;
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: AppColors.primaryColor
                                                        ),
                                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                        child: Text("${balance["balance"]} ${balance["currency"]}", style: const TextStyle(
                                                              fontWeight: FontWeight.w800,
                                                              color: Colors.white,
                                                              fontSize: 12
                                                          ),)
                                                      );
                                                  }
                                                })
                                        ),
                                        noIcon: true,
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
                                      ),
                                      ProfileMenu(
                                        title: "${user!.pin == true ? 'Modifier le ' : ''}Code PIN",
                                        icon: Icons.pin,
                                        suffix: Container(
                                          decoration: BoxDecoration(
                                            color: user!.pin == true ? Colors.green.withOpacity(.2) : Colors.red.withOpacity(.2),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                          child: Text(user!.pin == true ? "Défini" : "Non défini", style: TextStyle(
                                            fontSize: 12,
                                            color: user!.pin == true ? Colors.green : Colors.red,
                                            fontWeight: FontWeight.bold
                                          ),)
                                        ),
                                        noIcon: true,
                                        onTap: () {
                                          if (user!.pin != true) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(20)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(vertical: 30,
                                                          horizontal: 30),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        children: [
                                                          const Icon(
                                                            Icons.info_outline,
                                                            color: Colors.red,
                                                            size: 60,
                                                          ),
                                                          const SizedBox(
                                                            height: 20,),
                                                          const Text(
                                                            "CODE PIN ?",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,),
                                                          const Text(
                                                            "Le code PIN vous permet de renforcer la securite de votre compte",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              InkWell(
                                                                child: Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical: 15,
                                                                      horizontal: 20),
                                                                  decoration: BoxDecoration(
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          30)
                                                                  ),
                                                                  child: const Text(
                                                                    "Definir un code PIN",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.pushNamedAndRemoveUntil(
                                                                    context,
                                                                    RoutesName.createPin,
                                                                        (route) => false,
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                              },
                                            );
                                          } else {
                                            Navigator.pushNamed(context, RoutesName.updatePin);
                                          }
                                        },
                                      ),
                                      InkWell(
                                        onTap: () {

                                        },
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.08),
                                                spreadRadius: 3,
                                                blurRadius: 5,
                                                offset: const Offset(0, 4), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Platform.isAndroid ? const Icon(Icons.fingerprint, color: Colors.black87, size: 16,) : Image.asset("assets/faceid.png", width: 16,),
                                                    const SizedBox(width: 20,),
                                                    Flexible(child: Text("Verrouillage biométrique".toString(), style: const TextStyle(color: Colors.black87, fontSize: 14),),),
                                                  ],
                                                ),
                                              ),
                                              CupertinoSwitch(
                                                activeColor: AppColors.primaryColor,
                                                value: localAuthEnabled,
                                                onChanged: (value) async {
                                                  if (!loadingBio) {
                                                    setState(() {
                                                      loadingBio = true;
                                                    });
                                                    await LocalAuthService.canAuthenticate().then((value2) async {
                                                      if (value2) {
                                                        await LocalAuthService.authenticate().then((value3) {
                                                          if (value3) {
                                                            authViewModel.setLocalAuth(value).then((res) {
                                                              setState(() {
                                                                localAuthEnabled = value;
                                                                loadingBio = false;
                                                              });
                                                            });
                                                          }
                                                        });
                                                      } else {
                                                        Utils.flushBarErrorMessage("Votre téléphone ne supprote pas cette fonctionnalité", context);
                                                      }
                                                    });
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (user != null)
                                      ProfileMenu(
                                        title: 'Parrainage "${user!.codeParrainage}"',
                                        icon: CupertinoIcons.gift,
                                        noIcon: true,
                                        suffix: InkWell(
                                          onTap: () {
                                            final box = context.findRenderObject() as RenderBox?;
                                            Share.share(
                                              "Découvrez Transfert ChapChap! 🎉 \n\nUne application facile à utiliser pour envoyer de l'argent à ses proche dans plusieurs pays du monde.\nObtenez-le à cette adresse https://chapchap.ca\n\nUtilisez le code de parrainage ${user!.codeParrainage} pour gagner 10\$ et me faire gagner 10\$",
                                              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                            );
                                          },
                                          child: Icon(Icons.share_rounded, color: AppColors.primaryColor, size: 20,),
                                        ),
                                        onTap: () {
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: () {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog (
                                                title: const Text('Confirmer'),
                                                content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: const Text('Annuler', style: TextStyle(
                                                        color: Colors.black
                                                    ),),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Fermer le dialogue
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                    child: Text('Confirmer', style: TextStyle(
                                                        color: AppColors.primaryColor
                                                    ),),
                                                    onPressed: () async {
                                                      UserViewModel().remove().then((value) {
                                                        if (value) {
                                                          Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => LoginView(),
                                                            ),
                                                                (route) => false,
                                                          );
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.formFieldBorderColor,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          child: const Center(
                                            child: Text(
                                              "Se déconnecter",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30,),
                                    ],
                                  ),
                                ),
                              );
                          }
                        })
                ),
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
        bottomNavigationBar: commonBottomAppBar(context: context, active: 3),
      ),
    );
  }
}