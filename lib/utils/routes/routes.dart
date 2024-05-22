import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/views/account_view.dart';
import 'package:chapchap/views/auth/local_auth_view.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:chapchap/views/auth/new_password.dart';
import 'package:chapchap/views/auth/password_reset_view.dart';
import 'package:chapchap/views/auth/phone_verification_view.dart';
import 'package:chapchap/views/auth/register_view.dart';
import 'package:chapchap/views/auth/reset_code_view.dart';
import 'package:chapchap/views/auth/splash_view.dart';
import 'package:chapchap/views/auth/update_phone_view.dart';
import 'package:chapchap/views/contact_view.dart';
import 'package:chapchap/views/coupon_view.dart';
import 'package:chapchap/views/drc/drc_payment_view.dart';
import 'package:chapchap/views/exchange_view.dart';
import 'package:chapchap/views/history_view.dart';
import 'package:chapchap/views/history_w_problemes.dart';
import 'package:chapchap/views/home_view.dart';
import 'package:chapchap/views/invoice_detail_view.dart';
import 'package:chapchap/views/invoices_view.dart';
import 'package:chapchap/views/new_beneficiaire.dart';
import 'package:chapchap/views/auth/on_boarding_view.dart';
import 'package:chapchap/views/pay_view.dart';
import 'package:chapchap/views/profile_view.dart';
import 'package:chapchap/views/recipient_archive.dart';
import 'package:chapchap/views/recipients_view.dart';
import 'package:chapchap/views/recompense_view.dart';
import 'package:chapchap/views/send_success_view.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case RoutesName.home:
        return PageTransition(child: HomeView(), type: PageTransitionType.fade );
      case RoutesName.onBoarding:
        return MaterialPageRoute(builder: (BuildContext context) => OnBoardingView());
      case RoutesName.send:
        return PageTransition(
            child: SendView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.history:
        return PageTransition(
            child: HistoryView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.recompenseView:
        return PageTransition(
            child: RecomenseView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.localAuthView:
        return PageTransition(
            child: LocalAuthView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.historyWP:
        return PageTransition(
            child: HistoryWithProblemView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.accountView:
        return PageTransition(
            child: AccountView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.exchange:
        return PageTransition(
            child: ExchangeView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.recipeints:
        return PageTransition(
            child: RecipientsView(),
            type: PageTransitionType.fade,
            settings: settings
        );
      case RoutesName.recipeintsArchive:
        return PageTransition(
            child: RecipientsArchiveView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.profile:
        return PageTransition(
            child: ProfileView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.login:
        return PageTransition(
            child: LoginView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.register:
        return PageTransition(
            child: RegisterView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.newBeneficiaire:
        return PageTransition(
            child: NewBeneficiaireView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.passwordReset:
        return PageTransition(
            child: PasswordResetView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.resetCodeSend:
        return PageTransition(
            child: ResetCodeView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.invoices:
        return PageTransition(
            child: InvoicesView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.invoiceDetail:
        return PageTransition(
            child: InvoiceDetailView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.pay:
        return PageTransition(
            child: PayView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.drcPayment:
        return PageTransition(
            child: DRCPaymentView(data: settings.arguments as Map,),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.updatePhone:
        return PageTransition(
            child: UpdatePhoneView(data: settings.arguments as Map,),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashView());
      case RoutesName.sendSuccess:
        return PageTransition(
            child: SendSuccessView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.newPasswords:
        return PageTransition(
            child: NewPassword(data: settings.arguments as Map,),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.phoneVerification:
        return PageTransition(
            child: PhoneVerification(data: settings.arguments as Map,),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.contactView:
        return PageTransition(
            child: ContactView(),
            type: PageTransitionType.bottomToTop,
            settings: settings
        );
      case RoutesName.newBeneficiaire:
        return PageTransition(
          child: NewBeneficiaireView(),
          type: PageTransitionType.bottomToTop,
          settings: settings,
        );
      case RoutesName.couponView:
        return PageTransition(
          child: const CouponView(),
          type: PageTransitionType.bottomToTop,
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }
}