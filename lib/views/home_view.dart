import 'dart:io';
import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/app_url.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/points_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:chapchap/views/Tontine_announcement_view.dart';
import 'package:chapchap/views/notifications_view.dart';
import 'package:chapchap/views/points/points_view.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:chapchap/utils/rate_app_service.dart';
import 'package:chapchap/res/components/rate_app_modal.dart';
import 'package:chapchap/res/components/rounded_button.dart';
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

  bool seenTontineInfo = false;

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

  // void _loadRecentBeneficiaries() {
  //   demandesViewModel.beneficiaires({}, context, recent: true);
  // }

  void _showTontineAnnouncement(BuildContext context) async {
    bool seenTontineInfo = false;
    await UserViewModel().checkSeenTontineInfo().then((value) {
      seenTontineInfo = value;
    });

    if (!seenTontineInfo) {
      await UserViewModel().setSeenTontineInfo();
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '${AppLocalizations.of(context)!.translate("tontine_brand")} ',
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.translate("tontine_name"),
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Image.asset("assets/save.jpg"),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.translate("tontine_soon"),
                        style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.translate("tontine_description"),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme le modal
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const TontineAnnouncementView()),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.translate("learn_more"),
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  bool localAuthDefined = false;
  bool isDialogOpened = false;

  @override
  void initState() {
    super.initState();

    authViewModel.myInfos(context).then((value) {
      if (value == null || !mounted) return;
      setState(() => user = value);

      final message = value.message?.trim();
      if (message != null && message.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showUserMessageDialog(message);
        });
      }
    });

    AuthViewModel().getLocalAuthDefined().then((value) {
      setState(() {
        localAuthDefined = value;
      });
      if (!value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBioDialog();
        });
      }
    });

    if (user != null && user!.wallet == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTontineAnnouncement(context);
      });
    }

    demandesViewModel.myDemandes([], context, 20).then((value) {
      setState(() {
        nbProblemes = value;
      });
    });

    demandesViewModel.myDemandes([], context, 20).then((value) {
      setState(() {
        nbProblemes = value;
      });
    });

    // _loadRecentBeneficiaries();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
      if (user!.wallet == true) {
        walletViewModel.getBalance(context, Utils.countryMoneyCode[user!.codePays.toString()]!);
        pointsViewModel.getBalance(context);
      }
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

    // Afficher le modal de notation après un transfert
    // Selon la doc : requestReview() ne doit pas être déclenché via un bouton
    // On essaie d'abord requestReview() automatiquement, puis on affiche le modal comme fallback
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await RateAppService.shouldShowRatePrompt()) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          final hasRated = await RateAppService.hasRatedApp();
          if (!hasRated) {
            // Essayer d'abord requestReview() automatiquement (après une expérience utilisateur)
            // Note: peut ne rien faire si le quota est dépassé (pas d'exception)
            try {
              await RateAppService.requestReview();
            } catch (_) {
              // Ignorer les erreurs silencieusement
            }
            
            // Attendre un peu pour laisser requestReview() s'afficher si disponible
            // Puis afficher le modal avec openStoreListing() comme option fiable
            // (car requestReview() peut ne rien faire si quota dépassé)
            await Future.delayed(const Duration(milliseconds: 2000));
            
            if (mounted && !await RateAppService.hasRatedApp()) {
              await RateAppService.setRatePromptShown();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const RateAppModal(),
              );
            } else {
              // Si l'utilisateur a noté via requestReview(), marquer comme affiché
              await RateAppService.setRatePromptShown();
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _enableBiometric() async {
    // 1. Vérifier d'abord si le matériel supporte la biométrie
    final supported = await LocalAuthService.canAuthenticate();

    if (!supported) {
      Utils.flushBarErrorMessage(
        AppLocalizations.of(context)!.translate("phone_not_supported"),
        context,
      );
      return;
    }

    // 2. Tenter l'authentification en gérant les erreurs
    try {
      final authenticated = await LocalAuthService.authenticate();

      if (authenticated) {
        await authViewModel.setLocalAuth(true);
        setState(() => localAuthDefined = true);
        Navigator.of(context).pop(); // Fermer le modal en cas de succès
      }
    } on PlatformException catch (e) {
      // C'est ici qu'on intercepte l'erreur -7 (noBiometricsEnrolled)
      if (e.code == 'noBiometricsEnrolled') {
        // Fermer le modal d'activation pour ne pas bloquer l'écran
        Navigator.of(context).pop();
        isDialogOpened = false; // Ne pas oublier de reset ton flag si tu l'utilises

        // Afficher un message clair à l'utilisateur
        Utils.flushBarErrorMessage(
          "Aucune biométrie configurée sur votre iPhone. Veuillez activer Face ID dans les Réglages de votre appareil.",
          context,
        );
      } else {
        // Pour tout autre type d'erreur d'authentification (ex: annulation par l'utilisateur)
        Utils.flushBarErrorMessage("Erreur d'authentification : ${e.message}", context);
      }
    } catch (e) {
      // Sécurité générale pour tout autre type d'exception
      Utils.flushBarErrorMessage("Une erreur inattendue est survenue.", context);
    }
  }

  void _showBioDialog() {
    if (isDialogOpened) return; // éviter doublons
    isDialogOpened = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: AppTexts.titleText("Activer la biométrie"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTexts.descriptionText("Voulez-vous activer l’authentification avec ${Platform.isAndroid ? "empreinte digital ?" : "Face ID ?"}"),
              const SizedBox(height: 10,),
              Icon(Platform.isAndroid ? Icons.fingerprint : Icons.face_unlock_rounded, size: 80, color: AppColors.primaryColor)
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                AuthViewModel().setLocalAuth(false);
                Navigator.of(context).pop();
                isDialogOpened = false;
              },
              child: AppTexts.smallText("Non"),
            ),
            TextButton(
              onPressed: () {
                _enableBiometric();
              },
              child: AppTexts.smallText("Oui", color: AppColors.primaryColor),
            ),
          ],
        );
      },
    );
  }

  void _showUserMessageDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColors.bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: AppColors.primaryColor, size: 60),
                  const SizedBox(height: 20),
                  AppTexts.descriptionText(message),
                  const SizedBox(height: 24),
                  RoundedButton(
                    title: AppLocalizations.of(context)!.translate("understood"),
                    onPress: () => Navigator.pop(dialogContext),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!localAuthDefined) {

      setState(() {
        localAuthDefined = true;
      });
    }
    final box = context.findRenderObject() as RenderBox?;
    return HideKeyBordContainer(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
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
                    // if (AppUrl.domainName == 'https://dev.app.transfertchapchap.com')
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 20),
                    //     child: commonRoundedContainer(
                    //       bgColor: Colors.orange,
                    //       removePaddingV: true,
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 10),
                    //         child: Center(
                    //           child: AppTexts.smallText(AppLocalizations.of(context)!.translate('using_test_version')),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                      child: commonRoundedContainer(
                        removePaddingV: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: (user != null && user!.wallet == true) ? MainAxisSize.max :MainAxisSize.min,
                              children: [
                                if (user != null && user!.wallet == true)
                                  Row(
                                    children: [
                                      Image.asset("assets/icons/coins.png", width: 35),
                                      const SizedBox(width: 5),
                                      ChangeNotifierProvider<PointsViewModel>(
                                        create: (BuildContext context) => pointsViewModel,
                                        child: Consumer<PointsViewModel>(
                                          builder: (context, value, _) {
                                            switch (value.balance.status) {
                                              case Status.LOADING:
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.white,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  child: const CupertinoActivityIndicator(radius: 8),
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
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => NotificationsView(),
                                          ),
                                        );
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
                                              child: SvgPicture.asset("assets/icons/bell.svg", width: 25),
                                            ),
                                          ),
                                          // if (msgList.isNotEmpty)
                                            Positioned(
                                              top: 0, left: 0,
                                              child: Container(
                                                width: 17, height: 17,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: AppColors.primaryColor,
                                                ),
                                                child: Center(child: AppTexts.menuText((user!.nbNotifications ?? 0).toString(), color: Colors.white)),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    InkWell(
                                      onTap: () {
                                        Share.share(
                                          "Découvrez Transfert ChapChap! 🎉 \n\nUne application facile à utiliser pour envoyer de l'argent à ses proches dans plusieurs pays du monde.\nObtenez-le à cette adresse https://transfertchapchap.com\n\nUtilisez le code ${user!.codeParrainage} pour gagner 10\$ et me faire gagner 10\$",
                                          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: AppColors.formFieldColor,
                                        ),
                                        padding: const EdgeInsets.all(7),
                                        child: SvgPicture.asset("assets/icons/share.svg", width: 25),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
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
                                        child: const Icon(Icons.refresh, weight: 25),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (user != null && user!.wallet == true)
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
                                      SvgPicture.asset("assets/icons/wallet.svg", color: Colors.white, width: 40),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppTexts.bodyText(AppLocalizations.of(context)!.translate('wallet'), bold: true, color: Colors.white),
                                          AppTexts.cardDescription(AppLocalizations.of(context)!.translate('simpleAndFast'), color: Colors.white),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ChangeNotifierProvider<WalletViewModel>(
                                    create: (BuildContext context) => walletViewModel,
                                    child: Consumer<WalletViewModel>(
                                      builder: (context, value, _) {
                                        switch (value.balance.status) {
                                          case Status.LOADING:
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.white,
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              child: AppTexts.smallText(AppLocalizations.of(context)!.translate('start'), color: AppColors.buttonBlackColor),
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
                                                          child: AppTexts.titleText("${balance["balance"]}", color: Colors.white),
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
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            AppTexts.descriptionText(AppLocalizations.of(context)!.translate('hello')),
                            if (user != null)
                              AppTexts.titleText("${user!.prenomClient} ${user!.nomClient}", color: Colors.black)
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
                                  const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red),
                                  const SizedBox(width: 5),
                                  AppTexts.smallText("$nbProblemes ${AppLocalizations.of(context)!.translate('failedTransfers')}"),
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
                                    AppTexts.buttonText(AppLocalizations.of(context)!.translate('seeAll'), color: Colors.white),
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

              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTexts.cardTitle(AppLocalizations.of(context)!.translate('latestOperations'))
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

              // ChangeNotifierProvider<DemandesViewModel>(
              //   create: (BuildContext context) => demandesViewModel,
              //   child: Consumer<DemandesViewModel>(
              //     builder: (context, value, _) {
              //       switch (value.beneficiairesList.status) {
              //         case Status.LOADING:
              //           return const Padding(
              //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //             child: SizedBox(
              //               height: 100,
              //               child: Center(
              //                 child: CupertinoActivityIndicator(),
              //               ),
              //             ),
              //           );
              //         case Status.ERROR:
              //           return const SizedBox.shrink();
              //         default:
              //           List<BeneficiaireModel> beneficiaries = [];
              //           if (value.beneficiairesList.data != null) {
              //             beneficiaries = (value.beneficiairesList.data as List)
              //                 .take(4)
              //                 .map((item) => BeneficiaireModel.fromJson(item))
              //                 .toList();
              //           }
              //
              //           if (beneficiaries.isEmpty) return const SizedBox.shrink();
              //
              //           return Container(
              //             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              //             decoration: BoxDecoration(
              //               boxShadow: const [
              //                 BoxShadow(
              //                   color: Color.fromRGBO(0, 0, 0, 0.1),
              //                   blurRadius: 12,
              //                   spreadRadius: 0,
              //                   offset: Offset(0, 4),
              //                 ),
              //               ],
              //               color: Colors.white,
              //               border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1))
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 _buildBeneficiariesLayout(context, beneficiaries),
              //               ],
              //             ),
              //           );
              //       }
              //     },
              //   ),
              // ),
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

  // Widget _buildBeneficiariesLayout(
  //     BuildContext context, List<BeneficiaireModel> list) {
  //   Widget buildItem(BeneficiaireModel beneficiary) {
  //     double width = (MediaQuery.of(context).size.width - 50) / 2;
  //     return GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => SendView(
  //               beneficiaire: beneficiary,
  //               destination: beneficiary.codePays,
  //             ),
  //           ),
  //         );
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: AppColors.buttonBlackColor,
  //           borderRadius:   BorderRadius.circular(5)
  //         ),
  //         width: width,
  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               CupertinoIcons.arrow_up_right,
  //               color: Colors.white,
  //               size: 20,
  //             ),
  //             const SizedBox(width: 5,),
  //             Text(
  //               beneficiary.fullName(),
  //               textAlign: TextAlign.center,
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //               style: const TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.white,
  //                 overflow: TextOverflow.clip
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //   switch (list.length) {
  //     case 1:
  //       return Center(child: buildItem(list[0]));
  //     case 2:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           buildItem(list[0]),
  //           const SizedBox(width: 40),
  //           buildItem(list[1]),
  //         ],
  //       );
  //     case 3:
  //       return Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [buildItem(list[0])],
  //           ),
  //           const SizedBox(height: 15),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               buildItem(list[1]),
  //               const SizedBox(width: 40),
  //               buildItem(list[2]),
  //             ],
  //           ),
  //         ],
  //       );
  //     default:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               buildItem(list[0]),
  //               const SizedBox(height: 10),
  //               buildItem(list[1]),
  //             ],
  //           ),
  //           const SizedBox(height: 15),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               buildItem(list[2]),
  //               const SizedBox(height: 10),
  //               buildItem(list[3]),
  //             ],
  //           ),
  //         ],
  //       );
  //   }
  // }

}
