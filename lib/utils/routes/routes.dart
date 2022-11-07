import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/views/exchange_view.dart';
import 'package:chapchap/views/history_view.dart';
import 'package:chapchap/views/home_view.dart';
import 'package:chapchap/views/on_boarding_view.dart';
import 'package:chapchap/views/recipients_view.dart';
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