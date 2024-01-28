import 'package:chapchap/utils/routes/routes.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? initScreen;
bool goHome = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getBool('initScreen');
  if (initScreen != true) {
    await preferences.setBool('initScreen', true);
  }
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    try {
      NotificationsService notificationsService = NotificationsService();
      notificationsService.requestNotificationPermission();
      notificationsService.initLocalNotifications(context);
      notificationsService.firebaseInit();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

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