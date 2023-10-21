import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  Future<UserModel> getUserDate () => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? lAuth = preferences.getBool('local_auth');
    getUserDate().then((value) {
      if (value.token == 'null' || value.token == '' || value.token == null || value.idClient == null || value.idClient == 'null' || value.idClient == '') {
        Navigator.pushNamed(context, RoutesName.login);
      } else {
        if (lAuth == true) {
          Navigator.pushNamed(context, RoutesName.localAuthView);
        } else {
          Navigator.pushNamed(context, RoutesName.home);
        }
      }
    }).onError((error, stackTrace) {
      if(kDebugMode) {
        print(error.toString());
      }
    });
  }
}