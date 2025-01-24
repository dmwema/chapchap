import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/pays_destination_model.dart';
import 'package:mardona/model/pays_model.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/custom_field.dart';
import 'package:mardona/res/components/hide_keyboard_container.dart';
import 'package:mardona/res/components/profile_menu.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:mardona/view_model/pin_view_model.dart';
import 'package:mardona/view_model/services/local_auth_service.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:mardona/view_model/wallet_view_model.dart';
import 'package:mardona/views/auth/welcome_view.dart';
import 'package:mardona/views/points/points_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool smsNotificationsEnabled = false;
  bool emailNotificationsEnabled = false;
  bool pushNotificationsEnabled = false;
  bool _isHidden = true;

  bool loadEmail = false;
  bool loadSMS = false;
  String appVersion = '';

  final TextEditingController _deletionReasonController = TextEditingController();

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

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPr();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    AuthViewModel().getLocalAuth().then((value) {
      setState(() {
        localAuthEnabled = value;
      });
    });

    demandesViewModel.paysActifs([], context);

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
        emailNotificationsEnabled = user!.emailNotification == true;
        smsNotificationsEnabled = user!.smsNotification == true;
        pushNotificationsEnabled = user!.pushNotification == true;
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
        backgroundColor: AppColors.bgColor,
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
          title: "Mon compte",
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                child: AppTexts.descriptionText(value.paysActifList.message.toString()),
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
                                        icon: Icons.sticky_note_2_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.profile);
                                        },
                                      ),
                                      if (selectedFrom != null)
                                      ProfileMenu(
                                        title: "Pays de résidence",
                                        icon: CupertinoIcons.map_pin_ellipse,
                                        suffix: AppTexts.bodyText(selectedFrom.codePays!.toUpperCase()),
                                        noIcon: true,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: AppColors.bgColor,
                                            builder: (context) {
                                              return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      AppTexts.titleText("Séléctionnez le pays"),
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
                                                                child: Row(
                                                                  children: [
                                                                    Image.asset("assets/flag.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                                    const SizedBox(width: 20,),
                                                                    AppTexts.descriptionText(current.paysNom.toString())
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
                                                top: Radius.circular(0),
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
                                        title: "Coupons rabais",
                                        icon: CupertinoIcons.ticket,
                                        noIcon: true,
                                        onTap: () {
                                          // Navigator.pushNamed(context, RoutesName.couponView);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Nous joindre",
                                        icon: Icons.sms_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          // Navigator.pushNamed(context, RoutesName.contactView);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: 'Parrainage',
                                        icon: Icons.share_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          final box = context.findRenderObject() as RenderBox?;
                                          Share.share(
                                            "Découvrez Mardona Transfert! 🎉 \n\nUne application facile à utiliser pour envoyer de l'argent à ses proche dans plusieurs pays du monde.\nObtenez-le à cette adresse https://mardonatransfert.com\n\nUtilisez le code de parrainage ${user!.codeParrainage} pour gagner 10\$ et me faire gagner 10\$",
                                            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                          );
                                        },
                                        suffix: AppTexts.cardTitle("${user!.codeParrainage}"),
                                      ),
                                      InkWell(
                                        onTap: () {
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)),
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
                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(width: 15,),
                                                    Platform.isAndroid ? Icon(Icons.fingerprint, color: AppColors.primaryColor, size: 16,) : SvgPicture.asset("assets/icons/face-id.svg", width: 16, color: AppColors.textGrey,),
                                                    const SizedBox(width: 20,),
                                                    Flexible(child: AppTexts.cardTitle("Verrouillage biométrique", color: AppColors.textGrey)),
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
                                                            CupertinoPageRoute(
                                                              builder: (context) => const WelcomeView(),
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
                                            color: AppColors.formFieldColor,
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                AppTexts.smallText("Se déconnecter"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      Center(
                                        child: AppTexts.menuText("Version 1.0.0", color: AppColors.buttonBlackColor.withOpacity(.5))
                                      ),
                                      const SizedBox(height: 2,),
                                      Center(child: AppTexts.menuText("@ 2025 Mardona Transfert", color: AppColors.buttonBlackColor.withOpacity(.8))),
                                      const SizedBox(height: 40),
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
        bottomNavigationBar: commonBottomAppBar(context: context, active: 3),
      ),
    );
  }
}