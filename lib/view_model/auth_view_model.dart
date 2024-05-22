import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/repository/auth_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthViewModel with ChangeNotifier{
  final _repository = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> userImage(data, {required BuildContext context}) async {
    _repository.userImage(data, context: context).then((value) {
      UserModel user = UserModel.fromJson(value['data']);
      String message = "Photo de profil enrégistrée avec succès!";
      UserViewModel().updateImage(user).then((value) {
        Utils.toastMessage(message);
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future<bool> getLocalAuth() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('local_auth') == true;
  }

  Future<void> setLocalAuth(value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('local_auth', value);
  }

  Future<void> loginApi(dynamic data, BuildContext context, bool biometric) async {
    String password = data['password'];
    String username = data['username'];
    setLoading(true);
    await _repository.loginApi(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          if (value['data'] != null && value['data']['verify_identity_url'] != null) {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_outlined,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 20,),
                        Text(
                          value['message'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: const Text("Vérifier l'identité", style: TextStyle(color: Colors.white),),
                              ),
                              onTap: () async {
                                print(value['data']['verify_identity_url']);
                                String url = value['data']['verify_identity_url'];
                                var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                if(urllaunchable){
                                  await launch(url); //launch is from url_launcher package to launch URL
                                  Navigator.pop(context);
                                }else{
                                  Navigator.pop(context);
                                  Utils.toastMessage("Impossible d'ouvrir l'url");
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          else if (value['data'] != null && value['data']['update_phone'] != null && value['data']['update_phone'] == true) {
            String token = value['token'];
            Utils.flushBarErrorMessage("Veuillez fournir votre numéro de téléphone pour continuer.", context);
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.updatePhone, (route) => false, arguments: {'email':username, 'token': token, 'message': value['message'], 'update': true});
          } else if (value['data'] != null && value['data']['confirm_contact'] != null && value['data']['confirm_contact'] == true) {
            String token = value['token'];
            Utils.flushBarErrorMessage("Veuillez vérifier votre numéro de téléphone.", context);
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.phoneVerification, (route) => false, arguments: {'username': username, 'token': token, 'message': value['message'], 'update': false});
          } else {
            UserModel user = UserModel.fromJson(value['data']);
            user.token = value['token'];
            user.password = password;
            UserViewModel().updateUser(user, true, false).then((value) {
              Utils.toastMessage("Vous êtes connectés avec succès");
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.home,
                    (route) => false,
              );
            });
          }
        } else {

          String errorMessage = biometric ? "Impossible de se connecter avec la biométrie. Veuillez utiliser votre mot de passe. '$password'" : value['message'];
          Utils.flushBarErrorMessage(errorMessage, context);
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
      String message = value['message'].toString();
      String token = value['token'].toString();
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          UserModel user = UserModel();
          user.token = value['token'];
          user.nomClient = value['message'];
          UserViewModel().saveUser(user).then((value) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.phoneVerification,
                  (route) => false,
              arguments: {
                'email': data['email'],
                'message': message,
                'token': token,
                'update': false
              }
            );
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

  Future<void> changePassword(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.changePassword(data, context: context).then((value) {
      setLoading(false);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Mot de passe modifié avec succontextcès");
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.login,
                (route) => false,
          );
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }

      }
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<dynamic> getInfoMessages (BuildContext context) async {
    dynamic response;
    await _repository.getInfoMessages(context: context).then((value) {
      response = value;
    }).onError((error, stackTrace) {
    });

    return response;
  }

  Future<void> passwordReset(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.passwordReset(data, context: context).then((value) {
      setLoading(false);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          String message = value['message'];
          UserModel user = UserModel();
          user.token = value['token'];
          UserViewModel().updateUser(user, true, true).then((value) {
            Utils.toastMessage(message);
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.newPasswords,
                  (route) => false,
              arguments: {
                'username': data['username'],
              }
            );
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

  Future<void> uPassword(dynamic data, BuildContext context) async {
    setLoading(true);
    _repository.uPassword(data, context: context).then((value) {
      setLoading(false);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Mot de passe modifié avec succès");
          Navigator.pop(context);
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> resendCode(dynamic data, BuildContext context, String? token) async {
    await _repository.resendCode(data, context: context, token: token).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Code renvoyé avec succès");
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> updatePhone(dynamic data, BuildContext context, String token) async {
    await _repository.updatePhone(data, context: context, token: token).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage(value['message']);
          Navigator.pushNamedAndRemoveUntil(context, RoutesName.phoneVerification, (route) => false, arguments: {'username':data['username'], 'token': value['token'], 'message': value['message'], 'update': true});
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> confirmPhoneVerification(dynamic data, BuildContext context, String token) async {
    setLoading(true);
    await _repository.confirmPhoneVerification(data, context: context, token: token).then((value) {
      if (value["error"] != true){
        Utils.toastMessage(value["message"]);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
              (route) => false,
        );
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> confirmContact(dynamic data, BuildContext context, String token) async {
    setLoading(true);
    await _repository.confirmContact(data, context: context, token: token).then((value) {
      setLoading(false);
      if (value["error"] != true){
        Utils.toastMessage(value["message"]);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
              (route) => false,
        );
      } else {
        Utils.flushBarErrorMessage(value["message"], context);
      }

    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

}