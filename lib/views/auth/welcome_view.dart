import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:chapchap/views/auth/register_view.dart';
import 'package:chapchap/views/exchange_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  final String? message;
  const WelcomeView({Key? key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  NotificationsService notificationsService = NotificationsService();

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  String? deviceToken;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  bool showMessage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        showHelp: true,
        backArrow: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    commonRoundedContainer(child: Row(
                      children: [
                        if (widget.message == null)
                          Image.asset("assets/logo_red.png", width: 40,),
                        if (widget.message != null)
                          Icon(Icons.error_outline, size: 40, color: AppColors.primaryColor,),
                        const SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.message == null)
                                AppTexts.bodyText(AppLocalizations.of(context).transferChapchap, bold: true, color: AppColors.primaryColor),
                              if (widget.message == null)
                                AppTexts.cardDescription(AppLocalizations.of(context).bestMoneyTransferApp),
                              if (widget.message != null)
                                AppTexts.bodyText(widget.message!)
                            ],
                          ),
                        )
                      ],
                    )),
                    const SizedBox(height: 20,),
                    commonRoundedContainer(
                        removePaddingH: true,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50, height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.primaryColor
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.wallet, color: Colors.white, size: 30,)
                                    ),
                                  ), const SizedBox(width: 10,),
                                  Flexible(child: AppTexts.cardDescription(AppLocalizations.of(context).walletSystemDescription))
                                ],
                              ),
                            ),
                            commonDivider(),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50, height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.primaryColor
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.card_giftcard_outlined, color: Colors.white, size: 30,)
                                    ),
                                  ), const SizedBox(width: 10,),
                                  Flexible(child: AppTexts.cardDescription(AppLocalizations.of(context).giftCardDescription))
                                ],
                              ),
                            ),
                            commonDivider(),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50, height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.primaryColor
                                    ),
                                    child: Center(
                                        child: Image.asset("assets/icons/globe.png", width: 30,)
                                    ),
                                  ), const SizedBox(width: 10,),
                                  Flexible(child: AppTexts.cardDescription(AppLocalizations.of(context).transferCountriesDescription))
                                ],
                              ),
                            ),
                            commonDivider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50, height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.primaryColor
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.currency_exchange, color: Colors.white, size: 30,)
                                    ),
                                  ), const SizedBox(width: 10,),
                                  Flexible(child: AppTexts.cardDescription(AppLocalizations.of(context).exchangeRatesDescription))
                                ],
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                          title: AppLocalizations.of(context).exchangeRatesButton,  // Dynamique avec AppLocalizations
                          icon: Icons.currency_exchange,
                          color: AppColors.buttonBlackColor,
                          onPress: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ExchangeView(public: true,),
                              ),
                            );
                          }
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40 - 10) / 2,
                            child: RoundedButton(
                                title: AppLocalizations.of(context).loginButton,  // Dynamique avec AppLocalizations
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => LoginView(),
                                    ),
                                  );
                                }
                            ),
                          ), const SizedBox(width: 10,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40 - 10) / 2,
                            child: RoundedButton(
                                title: AppLocalizations.of(context).registerButton,  // Dynamique avec AppLocalizations
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => RegisterView(),
                                    ),
                                  );
                                }
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  _WelcomeViewState createState() => _WelcomeViewState();
}
