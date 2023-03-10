import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/repository/auth_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class AuthViewModel with ChangeNotifier{
  final _repository = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.loginApi(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          UserModel user = UserModel.fromJson(value['data']);
          user.token = value['token'];
          UserViewModel().updateUser(user).then((value) {
            Utils.toastMessage("Vous êtes connectés avec succès");
            Navigator.pushNamed(context, RoutesName.home);
          });
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> registerApi(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.registerApi(data, context: context).then((value) {
      setLoading(false);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          UserModel user = UserModel();
          user.token = value['token'];
          user.nomClient = value['message'];
          UserViewModel().saveUser(user).then((value) {
            Navigator.pushNamed(context, RoutesName.phoneVerificatiob);
          });
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> phoneVerificationConfirm(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.phoneVerificationConfirm(data, context: context).then((value) {
      setLoading(false);
      if (value["error"] != true){
        Utils.toastMessage(value["message"]);
        Navigator.pushNamed(context, RoutesName.login);
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }

    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

}