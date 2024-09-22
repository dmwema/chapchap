import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission () async {
    NotificationSettings? settings;

    await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
        criticalAlert: true,
        provisional: true,
        carPlay: true
    ).then((value) {
      settings = value;
    });

    if (settings != null && settings!.authorizationStatus == AuthorizationStatus.authorized) {
      print("authorized");
    } else if (settings != null && settings!.authorizationStatus == AuthorizationStatus.provisional) {
      print("provisional");
    } else {
      // AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  void initLocalNotifications (BuildContext context) async {
    var androidInitialization = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitialization = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitialization,
        iOS: iosInitialization
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          print(payload);
        }
    );
  }

  void firebaseInit () {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
  }

  Future<void> showNotification (RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(),
        'High Importance Channel',
        importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: 'Notifications ChapChap',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker'
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(
        Duration.zero,
            () {
          _flutterLocalNotificationsPlugin.show(
              0,
              message.notification!.title.toString(),
              message.notification!.body.toString(),
              notificationDetails
          );
        }
    );
  }

  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}