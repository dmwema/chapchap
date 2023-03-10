import 'package:chapchap/utils/routes/routes.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ChapChap Transfert",
        initialRoute: (initScreen == false || initScreen == null) ? RoutesName.onBoarding: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
        //home:  NetworkError(),
      )
    );
  }
}