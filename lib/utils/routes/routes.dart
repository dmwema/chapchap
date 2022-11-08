import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:chapchap/views/auth/new_password.dart';
import 'package:chapchap/views/auth/password_reset_view.dart';
import 'package:chapchap/views/auth/register_view.dart';
import 'package:chapchap/views/auth/reset_code_view.dart';
import 'package:chapchap/views/exchange_view.dart';
import 'package:chapchap/views/history_view.dart';
import 'package:chapchap/views/home_view.dart';
import 'package:chapchap/views/invoice_detail_view.dart';
import 'package:chapchap/views/invoices_view.dart';
import 'package:chapchap/views/on_boarding_view.dart';
import 'package:chapchap/views/pay_view.dart';
import 'package:chapchap/views/profile_view.dart';
import 'package:chapchap/views/recipients_view.dart';
import 'package:chapchap/views/send_success_view.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case RoutesName.home:
        return PageTransition(child: HomeView(), type: PageTransitionType.leftToRight );
      case RoutesName.onBoarding:
        return MaterialPageRoute(builder: (BuildContext context) => OnBoardingView());
      case RoutesName.send:
        return PageTransition(
            child: SendView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.history:
        return PageTransition(
            child: HistoryView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.exchange:
        return PageTransition(
            child: ExchangeView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.recipeints:
        return PageTransition(
            child: RecipientsView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.profile:
        return PageTransition(
            child: ProfileView(),
            type: PageTransitionType.rightToLeft,
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
            type: PageTransitionType.rightToLeft,
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
      case RoutesName.sendSuccess:
        return PageTransition(
            child: SendSuccessView(),
            type: PageTransitionType.rightToLeft,
            settings: settings
        );
      case RoutesName.newPassword:
        return PageTransition(
            child: NewPassword(),
            type: PageTransitionType.rightToLeft,
            settings: settings
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