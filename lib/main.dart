import 'package:chapchap/utils/routes/routes.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? initScreen;
bool goHome = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getBool('initScreen');
  if (initScreen != true) {
    await preferences.setBool('initScreen', true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QuickDep",
      initialRoute: (initScreen == false || initScreen == null) ? RoutesName.onBoarding: RoutesName.login,
      //initialRoute: RoutesName.onBoarding,
      // initialRoute: RoutesName.login,
      onGenerateRoute: Routes.generateRoute,
      //home:  NetworkError(),
    );
  }
}