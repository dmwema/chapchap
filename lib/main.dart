import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/firebase_options.dart';
import 'package:chapchap/utils/routes/routes.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'dart:ui';
// l.
bool? initScreen;
bool goHome = false;
String local = "Fr";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  await UserViewModel().getUserLanguage().then((value) {
    local = value;
  });

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getBool('initScreen2');
  if (initScreen != true) {
    await preferences.setBool('initScreen2', true);
  }

  final Locale deviceLocale = window.locale;
  if (deviceLocale.languageCode == 'fr' || deviceLocale.languageCode == 'en' || deviceLocale.languageCode == 'es') {
    if (local == "") {
      local = Utils.capitalize(deviceLocale.languageCode);
      preferences.setString('selected_language', local);
      preferences.setString('default_country', deviceLocale.countryCode ?? "");
    }
  }

  runApp(const RestartWidget(child: MyApp()));
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
        theme: ThemeData(
          fontFamily: 'Roboto'
        ),
        debugShowCheckedModeBanner: false,
        title: "ChapChap Transfert",
        locale: Locale(local.toLowerCase()),
        supportedLocales: const [
          Locale('fr'),
          Locale('en'),
          Locale('es'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: (initScreen == false || initScreen == null) ? RoutesName.onBoarding: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
        builder: FlashyFlushbarProvider.init(),
        //home:  NetworkError(),
      )
    );
  }
}