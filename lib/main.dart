import 'package:chapchap/utils/routes/routes.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool? initScreen;
bool goHome = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  //FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /*@override
  void initState() {
    super.initState();

    firebaseMessaging.getToken().then((value) {
      print("Firebase token : ${value}");
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QuickDep",
      initialRoute: RoutesName.home,
      onGenerateRoute: Routes.generateRoute,
      //home:  NetworkError(),
    );
  }
}