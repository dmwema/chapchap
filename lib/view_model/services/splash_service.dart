import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  Future<UserModel> getUserDate () => UserViewModel().getUser();

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? first = prefs.getBool('first_time');

    if (first == null || first == true) {
      await prefs.setBool('first_time', false);
      return true;
    }
    return false;
  }

  void checkAuthentication(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? lAuth = preferences.getBool('local_auth');
    getUserDate().then((value) {
      if (value.token == 'null' || value.token == '' || value.token == null || value.idClient == null || value.idClient == 'null' || value.idClient == '') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.welcomeView,
              (route) => false,
        );
      } else {
        if (lAuth == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.localAuthView,
                (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.home,
                (route) => false,
          );
        }
      }
    }).onError((error, stackTrace) {
      if(kDebugMode) {
        print(error.toString());
      }
    });
  }
}