import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/views/home_view.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case RoutesName.home:
        return PageTransition(child: HomeView(), type: PageTransitionType.leftToRight );
      case RoutesName.send:
        return PageTransition(
            child: SendView(),
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