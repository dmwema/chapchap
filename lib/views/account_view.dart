import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:chapchap/views/auth/welcome_view.dart';
import 'package:chapchap/views/points/points_view.dart';
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.bgColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
              systemNavigationBarDividerColor: Colors.white,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText("Mon compte")
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
                                      AppTexts.smallText("GÉNÉRAL", color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
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
                                                                    Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
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
                                                    Platform.isAndroid ? Icon(Icons.fingerprint, color: AppColors.primaryColor, size: 16,) : SvgPicture.asset("assets/icons/face-id.svg", width: 16, color: AppColors.primaryColor,),
                                                    const SizedBox(width: 20,),
                                                    Flexible(child: AppTexts.cardTitle("Verrouillage biométrique")),
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
                                      const SizedBox(height: 20,),
                                      AppTexts.smallText("PRTEFEUILLE", color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
                                      ProfileMenu(
                                        title: "Mon portefeuille",
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
                                                      return Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: _toggleVisibility,
                                                            child: AnimatedContainer(
                                                              duration: const Duration(milliseconds: 300),
                                                              decoration: BoxDecoration(
                                                                color: AppColors.primaryColor,
                                                                borderRadius: BorderRadius.circular(30),
                                                              ),
                                                              margin: const EdgeInsets.only(right: 3),
                                                              padding: const EdgeInsets.all(5),
                                                              child: Center(
                                                                child: Icon(
                                                                  _isHidden
                                                                      ? CupertinoIcons.eye_fill
                                                                      : CupertinoIcons.eye_slash_fill,
                                                                  color: Colors.white,
                                                                  size: 13,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: AppColors.primaryColor
                                                              ),
                                                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                              child: ImageFiltered(
                                                                  imageFilter: ImageFilter.blur(sigmaX: _isHidden ? 5 : 0, sigmaY: _isHidden ? 5 : 0),
                                                                  child: Text("${balance["balance"]} ${balance["currency"]}", style: const TextStyle(
                                                                      fontWeight: FontWeight.w800,
                                                                      color: Colors.white,
                                                                      fontSize: 12
                                                                  ),)
                                                              ),
                                                          ),
                                                        ],
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
                                      if (user != null && user!.codeInterac != null && user!.codePays == "ca")
                                        ProfileMenu(
                                          title: "Rechargez votre portefeuille",
                                          icon: Icons.payment,
                                          noIcon: true,
                                          onTap: () {
                                            Navigator.pushNamed(context, RoutesName.interac);
                                          },
                                        ),
                                      ProfileMenu(
                                        title: "Points",
                                        icon: Icons.circle,
                                        suffix: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.orange
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                            child: AppTexts.cardTitle(user != null && user!.pointsBalance != null ? user!.pointsBalance.toString(): "0", color: Colors.white)
                                        ),
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(builder: (context) => PointsView())
                                          );
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
                                      const SizedBox(height: 20,),
                                      AppTexts.smallText("TRANSFERTS", color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
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
                                      const SizedBox(height: 20,),
                                      AppTexts.smallText("NOTIFICATIONS", color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
                                      Container(
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
                                                  Icon(Icons.notifications_active_outlined, color: AppColors.primaryColor, size: 16,),
                                                  const SizedBox(width: 20,),
                                                  Flexible(child: AppTexts.cardTitle("Push")),
                                                ],
                                              ),
                                            ),
                                            CupertinoSwitch(
                                              activeTrackColor: AppColors.primaryColor,
                                              value: pushNotificationsEnabled,
                                              onChanged: (value) async {
                                                setState(() {
                                                  pushNotificationsEnabled = value;
                                                });
                                                await authViewModel.updateNotifications({
                                                  'type': 'push_notification',
                                                  'status': pushNotificationsEnabled
                                                }, context).then((value2) {
                                                  if (!value2) {
                                                    setState(() {
                                                      pushNotificationsEnabled = !value;
                                                    });
                                                  } else {
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
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
                                                  Icon(Icons.alternate_email, color: AppColors.primaryColor, size: 16,),
                                                  const SizedBox(width: 20,),
                                                  Flexible(child: AppTexts.cardTitle("E-mail")),
                                                ],
                                              ),
                                            ),
                                            CupertinoSwitch(
                                              activeTrackColor: AppColors.primaryColor,
                                              value: emailNotificationsEnabled,
                                              onChanged: (value) async {
                                                setState(() {
                                                  emailNotificationsEnabled = value;
                                                });
                                                await authViewModel.updateNotifications({
                                                  'type': 'email_notification',
                                                  'status': emailNotificationsEnabled
                                                }, context).then((value2) {
                                                  if (!value2) {
                                                    setState(() {
                                                      emailNotificationsEnabled = !value;
                                                    });
                                                  } else {
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
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
                                                  Icon(Icons.sms_outlined, color: AppColors.primaryColor, size: 16,),
                                                  const SizedBox(width: 20,),
                                                  Flexible(child: AppTexts.cardTitle("SMS")),
                                                ],
                                              ),
                                            ),
                                            CupertinoSwitch(
                                              activeTrackColor: AppColors.primaryColor,
                                              value: smsNotificationsEnabled,
                                              onChanged: (value) async {
                                                setState(() {
                                                  smsNotificationsEnabled = value;
                                                });
                                                await authViewModel.updateNotifications({
                                                  'type': 'sms_notification',
                                                  'status': smsNotificationsEnabled
                                                }, context).then((value2) {
                                                  if (!value2) {
                                                    setState(() {
                                                      smsNotificationsEnabled = !value;
                                                    });
                                                  } else {
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      AppTexts.smallText("TRANSFERT CHAPCHAP", color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
                                      ProfileMenu(
                                        title: "Nous joindre",
                                        icon: Icons.phone_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.contactView);
                                        },
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
                                      ProfileMenu(
                                        title: "Fermer mon compte",
                                        icon: Icons.highlight_remove_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor: AppColors.bgColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(20)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20,
                                                      horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    children: [
                                                      AppTexts.titleText(
                                                        "Voulez-vous vraiment fermer votre compte ?"),
                                                      const SizedBox(
                                                        height: 10,),
                                                      AppTexts.bodyText(
                                                        "Nous sommes désolés de savoir que vous souhaitez fermer votre compte.",),
                                                      const SizedBox(
                                                        height: 5,),
                                                      Divider(color: AppColors.formFieldColor,),
                                                      const SizedBox(
                                                        height: 5,),
                                                      AppTexts.descriptionText(
                                                        "sachez que la fermeture de votre compte vous empêchera d'accéder aux plateformes de CHAPCHAP ainsi qu’aux informations relatives à vos transferts.",),
                                                      const SizedBox(height: 10,),
                                                      CustomFormField(label: "Raison (Optionnelle)", controller: _deletionReasonController, hint: "Raison (Optionnelle)"),
                                                      const SizedBox(height: 20,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          RoundedButton(title: "Annuler", color: AppColors.buttonBlackColor, onPress: () {
                                                            Navigator.pop(context);
                                                          }),
                                                          const SizedBox(width: 5,),
                                                          RoundedButton(title: "Confirmer", onPress: () async {
                                                            await authViewModel.deleteAccount({
                                                              'reason': _deletionReasonController.text,
                                                            }, context).then((message) async {
                                                              if (message != null) {
                                                                await  UserViewModel().remove().then((value) {
                                                                  if (value) {
                                                                    Navigator.pushAndRemoveUntil(
                                                                      context,
                                                                      CupertinoPageRoute(
                                                                        builder: (context) => WelcomeView(message: message),
                                                                      ),
                                                                          (route) => false,
                                                                    );
                                                                  }
                                                                });
                                                              }
                                                            });
                                                          }),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20,),
                                      AppTexts.smallText("NOS POLITIQUES", color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
                                      ProfileMenu(
                                        title: "Politique de confidentialité",
                                        icon: Icons.privacy_tip_outlined,
                                        noIcon: true,
                                        onTap: () async {
                                            var urllaunchable = await canLaunch("https://chapchap.ca/privacy_policy"); //canLaunch is from url_launcher package
                                            if(urllaunchable){
                                              await launch("https://chapchap.ca/privacy_policy"); //launch is from url_launcher package to launch URL
                                            }else{
                                              Utils.toastMessage("Impossible d'ouvrir l'url des politiques");
                                            }
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Conditions d'utilisation",
                                        icon: Icons.privacy_tip_outlined,
                                        noIcon: true,
                                        onTap: () async {
                                          var urllaunchable = await canLaunch("https://chapchap.ca/terms_of_condition"); //canLaunch is from url_launcher package
                                          if(urllaunchable){
                                            await launch("https://chapchap.ca/terms_of_condition"); //launch is from url_launcher package to launch URL
                                          }else{
                                            Utils.toastMessage("Impossible d'ouvrir l'url des politiques");
                                          }
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
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          child: Center(
                                            child: AppTexts.smallText("Se déconnecter"),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30,),
                                      Center(child: Image.asset('assets/logo_red.png', width: 18)),
                                      const SizedBox(height: 5,),
                                      Center(
                                        child: AppTexts.menuText("Version 4.0.0", color: AppColors.buttonBlackColor.withOpacity(.5))
                                      ),
                                      const SizedBox(height: 2,),
                                      Center(child: AppTexts.menuText("@ 2025 Transfert ChapChap", color: AppColors.buttonBlackColor.withOpacity(.8))),
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