import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
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
import 'package:chapchap/views/Tontine_announcement_view.dart';
import 'package:chapchap/views/auth/welcome_view.dart';
import 'package:chapchap/views/payment_webview.dart';
import 'package:chapchap/views/permits_view.dart';
import 'package:chapchap/views/points/points_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chapchap/utils/rate_app_service.dart';
import 'package:chapchap/res/components/rate_app_modal.dart';

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

  String local = "Fr";

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

  void _showIdentityVerificationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool loading = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: AppColors.bgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, color: AppColors.primaryColor, size: 60),
                    const SizedBox(height: 20),
                    AppTexts.titleText(AppLocalizations.of(context)!.translate("verify_my_identity")),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.translate("verify_identity_confirmation"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton(
                            title: AppLocalizations.of(context)!.translate("cancel"),
                            color: Colors.grey.shade300,
                            textColor: Colors.black,
                            onPress: loading ? null : () => Navigator.pop(dialogContext),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RoundedButton(
                            title: AppLocalizations.of(context)!.translate("confirm"),
                            loading: loading,
                            onPress: loading
                                ? null
                                : () async {
                                    setDialogState(() => loading = true);
                                    final value = await authViewModel.initiateIdentityVerification(context);
                                    if (!dialogContext.mounted) return;
                                    setDialogState(() => loading = false);
                                    if (value == null) return;

                                    final isSuccess = value['success'] == true || value['error'] != true;
                                    if (!isSuccess) {
                                      Utils.flushBarErrorMessage(value['message'] ?? '', context);
                                      return;
                                    }

                                    final message = value['message']?.toString() ?? '';
                                    final url = value['data']?['url']?.toString();
                                    Navigator.pop(dialogContext);

                                    if (url == null || url.isEmpty) {
                                      if (message.isNotEmpty) {
                                        Utils.toastMessage(message);
                                      }
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PaymentWebView(
                                            url: url,
                                            // headerMessage: message.isNotEmpty ? message : null,
                                            popOnBack: true,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    UserViewModel().getUserLanguage().then((value) {
      setState(() {
        local = value;
      });
    });

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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppTexts.titleText(AppLocalizations.of(context)!.translate("my_account"))
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
                                      AppTexts.smallText(AppLocalizations.of(context)!.translate("general").toUpperCase(), color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: RoundedButton(
                                          title: AppLocalizations.of(context)!.translate("verify_my_identity"),
                                          icon: Icons.verified_user,
                                          onPress: _showIdentityVerificationDialog,
                                        ),
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("personal_information"),
                                        icon: Icons.notes,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.profile);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("country_of_residence"),
                                        icon: CupertinoIcons.map,
                                        suffix: Image.asset("packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png", width: 20, height: 15, fit: BoxFit.contain),
                                        noIcon: true,
                                        onTap: null,
                                      ),
                                      InkWell(
                                        onTap: () {},
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
                                                    Flexible(child: AppTexts.cardTitle(AppLocalizations.of(context)!.translate("biometric_lock"))),
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
                                                        Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("phone_not_supported"), context);
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
                                      if (user != null && user!.wallet == true)
                                      AppTexts.smallText(AppLocalizations.of(context).translate("wallet").toUpperCase(), color: Colors.black.withOpacity(.2)),

                                      if (user != null && user!.wallet == true)
                                        const SizedBox(height: 10,),
                                      if (user != null && user!.wallet == true)
                                        ProfileMenu(
                                          title: AppLocalizations.of(context)!.translate("wallet"),
                                          icon: Icons.wallet,
                                          suffix: ChangeNotifierProvider<WalletViewModel>(
                                              create: (BuildContext context) => walletViewModel,
                                              child: Consumer<WalletViewModel>(builder: (context, value, _){
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
                                      if (user != null && user!.tontine == true)
                                        ProfileMenu(
                                          title: AppLocalizations.of(context)!.translate("my_tontine"),
                                          icon: Icons.attach_money,
                                          suffix: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.orange,
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                            child: Text(
                                              AppLocalizations.of(context).translate("coming_soon"),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          noIcon: true,
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TontineAnnouncementView()));
                                          },
                                        ),
                                      if (user != null && user!.codeInterac != null && user!.codePays == "ca" && user!.wallet == true)
                                        ProfileMenu(
                                          title: AppLocalizations.of(context)!.translate("recharge_wallet"),
                                          icon: Icons.payment,
                                          noIcon: true,
                                          onTap: () {
                                            Navigator.pushNamed(context, RoutesName.interac);
                                          },
                                        ),
                                      if (user != null && user!.wallet == true)
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("points"),
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
                                              CupertinoPageRoute(builder: (context) => const PointsView())
                                          );
                                        },
                                      ),

                                      ProfileMenu(
                                        title: "${user!.pin == true ? "${AppLocalizations.of(context)!.translate("modify_the")} " : ''}${AppLocalizations.of(context)!.translate("pin_code")}",
                                        icon: Icons.pin,
                                        suffix: Container(
                                          decoration: BoxDecoration(
                                            color: user!.pin == true ? Colors.green.withOpacity(.2) : Colors.red.withOpacity(.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                          child: Text(
                                            user!.pin == true ? AppLocalizations.of(context).translate("defined") : AppLocalizations.of(context).translate("not_defined"),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: user!.pin == true ? Colors.green : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        noIcon: true,
                                        onTap: () {
                                          if (user!.pin != true) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.info_outline,
                                                          color: Colors.red,
                                                          size: 60,
                                                        ),
                                                        const SizedBox(height: 20),
                                                        Text(
                                                          AppLocalizations.of(context)!.translate("pin_code"),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 20),
                                                        Text(
                                                          AppLocalizations.of(context)!.translate("pin_code_description"),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.black),
                                                        ),
                                                        const SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.primaryColor,
                                                                  borderRadius: BorderRadius.circular(30),
                                                                ),
                                                                child: Text(
                                                                  AppLocalizations.of(context)!.translate("set_pin_code"),
                                                                  style: const TextStyle(color: Colors.white),
                                                                ),
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
                                                        ),
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
                                      const SizedBox(height: 20),
                                      AppTexts.smallText(
                                        AppLocalizations.of(context)!.translate("transfers").toUpperCase(),
                                        color: Colors.black.withOpacity(.2),
                                      ),
                                      const SizedBox(height: 10),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("my_history"),
                                        icon: Icons.history_rounded,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.history);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("my_invoices"),
                                        icon: CupertinoIcons.doc_text,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.invoices);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("discount_coupons"),
                                        icon: CupertinoIcons.gift,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.couponView);
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      AppTexts.smallText(
                                        AppLocalizations.of(context)!.translate("notifications").toUpperCase(),
                                        color: Colors.black.withOpacity(.2),
                                      ),
                                      const SizedBox(height: 10),
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
                                              offset: const Offset(0, 4),
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
                                                  Icon(Icons.notifications_active_outlined, color: AppColors.primaryColor, size: 16),
                                                  const SizedBox(width: 20),
                                                  Flexible(child: AppTexts.cardTitle(AppLocalizations.of(context)!.translate("push"))),
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
                                                  'status': pushNotificationsEnabled,
                                                }, context).then((value2) {
                                                  if (!value2) {
                                                    setState(() {
                                                      pushNotificationsEnabled = !value;
                                                    });
                                                  }
                                                });
                                              },
                                            ),
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
                                              offset: const Offset(0, 4),
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
                                                  Icon(Icons.alternate_email, color: AppColors.primaryColor, size: 16),
                                                  const SizedBox(width: 20),
                                                  Flexible(child: AppTexts.cardTitle(AppLocalizations.of(context)!.translate("email"))),
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
                                                  'status': emailNotificationsEnabled,
                                                }, context).then((value2) {
                                                  if (!value2) {
                                                    setState(() {
                                                      emailNotificationsEnabled = !value;
                                                    });
                                                  }
                                                });
                                              },
                                            ),
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
                                              offset: const Offset(0, 4),
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
                                                  Icon(Icons.sms_outlined, color: AppColors.primaryColor, size: 16),
                                                  const SizedBox(width: 20),
                                                  Flexible(child: AppTexts.cardTitle(AppLocalizations.of(context)!.translate("notifications.sms"))),
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
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      AppTexts.smallText(AppLocalizations.of(context)!.translate("chapchap.title").toUpperCase(), color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("profile.contact_us"),
                                        icon: Icons.phone_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.contactView);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Noter l'application",
                                        icon: Icons.star_rounded,
                                        noIcon: true,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => const RateAppModal(),
                                          );
                                        },
                                      ),
                                      if (user != null)
                                        ProfileMenu(
                                          title: AppLocalizations.of(context)!.translate("profile.referral_code").replaceAll("{code}", user!.codeParrainage!),
                                          icon: CupertinoIcons.gift,
                                          noIcon: true,
                                          suffix: InkWell(
                                            onTap: () {
                                              final box = context.findRenderObject() as RenderBox?;
                                              Share.share(
                                                AppLocalizations.of(context)!.translate("profile.share_message").replaceAll("{code}", user!.codeParrainage!),
                                                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                              );
                                            },
                                            child: Icon(Icons.share_rounded, color: AppColors.primaryColor, size: 20),
                                          ),
                                          onTap: () {},
                                        ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("language"),
                                        icon: Icons.language,
                                        noIcon: true,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor: AppColors.bgColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      AppTexts.titleText(AppLocalizations.of(context)!.translate("choose_language")),
                                                      const SizedBox(height: 10),
                                                      ...Utils.languages.map((element) {
                                                        return ProfileMenu(
                                                          title: AppLocalizations.of(context)!.translate("lang.${element['code']!.toLowerCase()}"),
                                                          icon: Icons.language,
                                                          color: local == element['code'] ? AppColors.primaryColor : Colors.grey[200],
                                                          onTap: () async {
                                                            await UserViewModel().setUserLanguage(element['code']!);
                                                            Restart.restartApp(
                                                              notificationTitle: AppLocalizations.of(context)!.translate("restart_app"),
                                                              notificationBody: AppLocalizations.of(context)!.translate("please_tap_here_to_open_the_app_again"),
                                                            );
                                                          },
                                                          noIcon: true,
                                                        );
                                                      })
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      AppTexts.smallText(AppLocalizations.of(context)!.translate("profile.policies.title"), color: Colors.black.withOpacity(.2)),
                                      const SizedBox(height: 10),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context).translate("profile.privacy"),
                                        icon: Icons.privacy_tip_outlined,
                                        noIcon: true,
                                        onTap: () async {
                                          var urllaunchable = await canLaunch("https://transfertchapchap.com/privacy");
                                          if (urllaunchable) {
                                            await launch("https://transfertchapchap.com/privacy");
                                          } else {
                                            Utils.toastMessage("Unable to open privacy policy URL");
                                          }
                                        },
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("profile.terms"),
                                        icon: Icons.privacy_tip_outlined,
                                        noIcon: true,
                                        onTap: () async {
                                          var urllaunchable = await canLaunch("https://transfertchapchap.com/terms_of_condition");
                                          if (urllaunchable) {
                                            await launch("https://transfertchapchap.com/terms_of_condition");
                                          } else {
                                            Utils.toastMessage("Unable to open terms zof use URL");
                                          }
                                        },
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("profile.policy.cancel"),
                                        icon: Icons.privacy_tip_outlined,
                                        noIcon: true,
                                        onTap: () async {
                                          var urllaunchable = await canLaunch("https://transfertchapchap.com/refund_policy");
                                          if (urllaunchable) {
                                            await launch("https://transfertchapchap.com/terms_of_condition");
                                          } else {
                                            Utils.toastMessage("Unable to open terms of use URL");
                                          }
                                        },
                                      ),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("profile.permit"),
                                        icon: Icons.privacy_tip_outlined,
                                        noIcon: true,
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(builder: (context) => const PermitView()),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      ProfileMenu(
                                        title: AppLocalizations.of(context)!.translate("profile.close_account"),
                                        icon: Icons.highlight_remove_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor: AppColors.bgColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      AppTexts.titleText(AppLocalizations.of(context)!.translate("profile.close_account.title")),
                                                      const SizedBox(height: 10),
                                                      AppTexts.bodyText(AppLocalizations.of(context)!.translate("profile.close_account.subtitle")),
                                                      const SizedBox(height: 5),
                                                      Divider(color: AppColors.formFieldColor),
                                                      const SizedBox(height: 5),
                                                      AppTexts.descriptionText(AppLocalizations.of(context)!.translate("profile.close_account.description")),
                                                      const SizedBox(height: 10),
                                                      CustomFormField(
                                                        label: AppLocalizations.of(context)!.translate("profile.close_account.reason"),
                                                        controller: _deletionReasonController,
                                                        hint: AppLocalizations.of(context)!.translate("profile.close_account.reason"),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          RoundedButton(
                                                            title: AppLocalizations.of(context)!.translate("profile.cancel"),
                                                            color: AppColors.buttonBlackColor,
                                                            onPress: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          const SizedBox(width: 5),
                                                          RoundedButton(
                                                            title: AppLocalizations.of(context)!.translate("profile.confirm"),
                                                            onPress: () async {
                                                              await authViewModel.deleteAccount({
                                                                'reason': _deletionReasonController.text,
                                                              }, context).then((message) async {
                                                                if (message != null) {
                                                                  await UserViewModel().remove().then((value) {
                                                                    if (value) {
                                                                      Navigator.pushAndRemoveUntil(
                                                                        context,
                                                                        CupertinoPageRoute(builder: (context) => WelcomeView(message: message)),
                                                                            (route) => false,
                                                                      );
                                                                    }
                                                                  });
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog(
                                                title: Text(AppLocalizations.of(context)!.translate("profile.confirm")),
                                                content: Text(AppLocalizations.of(context)!.translate("profile.logout.confirm")),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: Text(AppLocalizations.of(context)!.translate("profile.cancel"), style: const TextStyle(color: Colors.black)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                    child: Text(AppLocalizations.of(context)!.translate("profile.confirm"), style: TextStyle(color: AppColors.primaryColor)),
                                                    onPressed: () async {
                                                      UserViewModel().remove().then((value) {
                                                        if (value) {
                                                          Navigator.pushAndRemoveUntil(
                                                            context,
                                                            CupertinoPageRoute(builder: (context) => const WelcomeView()),
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
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          child: Center(
                                            child: AppTexts.smallText(AppLocalizations.of(context)!.translate("profile.logout")),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Divider(),
                                      Center(child: Image.asset('assets/logo_red.png', width: 18)),
                                      const SizedBox(height: 5),
                                      Center(
                                        child: AppTexts.menuText(AppLocalizations.of(context)!.translate("profile.version"), color: AppColors.buttonBlackColor.withOpacity(.5)),
                                      ),
                                      const SizedBox(height: 2),
                                      Center(
                                        child: AppTexts.menuText(AppLocalizations.of(context).translate("profile.copyright"), color: AppColors.buttonBlackColor.withOpacity(.8)),
                                      ),
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