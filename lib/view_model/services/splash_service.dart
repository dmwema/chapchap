import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class SplashService {
  Future<UserModel> getUserDate () => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    getUserDate().then((value) {
      if (value.token == 'null' || value.token == '' || value.token == null) {
        Navigator.pushNamed(context, RoutesName.login);
      } else {
        Navigator.pushNamed(context, RoutesName.home);
      }
    }).onError((error, stackTrace) {
      if(kDebugMode) {
        print(error.toString());
      }
    });
  }
}