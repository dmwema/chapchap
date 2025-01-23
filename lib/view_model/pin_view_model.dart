import 'dart:io';

import 'package:mardona/data/response/api_response.dart';
import 'package:mardona/model/beneficiaire_model.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/repository/pin_repository.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mardona/model/pays_destination_model.dart';
import 'package:mardona/repository/demandes_repository.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mardona/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PinViewModel with ChangeNotifier{
  final _repository = PinRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<int?> updatePin(dynamic data, BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.updatePin(data, context: context).then((value) {
      if (value!=null){
        print("22222222222222222222");
        print("22222222222222222222");
        print(data);
        print(value);
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage(value['message']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.home,
                (route) => false,
          );
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> createPin(dynamic data, BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.createPin(data, context: context).then((value) async {
      setLoading(false);
      if (value!=null){
        if (value['error'] != true) {
          await UserViewModel().getUser().then((user) async {
            user.pin = true;
            await UserViewModel().updateUser(user, false, false).then((result) {
              setLoading(false);
              Utils.toastMessage(value['message']);
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.accountView,
                    (route) => false,
              );
            });
          });
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> resetPin(BuildContext context) async {
    UserModel? user = UserModel();
    await UserViewModel().getUser().then((value) {
      user = value;
      print(user!.toJson());
    });
    Map data = {
      "username": user!.emailClient
    };
    setLoading(true);
    int? returnValue;
    await _repository.resetPin(data, context: context).then((value) async {
      setLoading(false);
      if (value!=null){
        if (value['error'] != true) {
          Utils.toastMessage(value['message']);
          Navigator.pushNamed(
            context,
            RoutesName.resetPin,
          );
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> changePin(dynamic data, BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.changePin(data, context: context).then((value) async {
      setLoading(false);
      if (value!=null){
        if (value['error'] != true) {
          await UserViewModel().getUser().then((user) async {
            user.pin = true;
            await UserViewModel().updateUser(user, false, false).then((result) {
              setLoading(false);
              Utils.toastMessage(value['message']);
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.home,
                    (route) => false,
              );
            });
          });
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }
}