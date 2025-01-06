import 'dart:io';

import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/repository/wallet_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletViewModel with ChangeNotifier{
  final _repository = WalletRepository();
  bool _loading = false;
  ApiResponse<dynamic> balance = ApiResponse.loading();
  ApiResponse<dynamic> walletsList = ApiResponse.loading();
  ApiResponse<dynamic> rechargesList = ApiResponse.loading();
  ApiResponse<dynamic> transfersList = ApiResponse.loading();
  ApiResponse<dynamic> currencies = ApiResponse.loading();
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setBalance (ApiResponse<dynamic> response) {
    balance = response;
    notifyListeners();
  }

  setWalletsList (ApiResponse<dynamic> response) {
    walletsList = response;
    notifyListeners();
  }

  setCurrencies (ApiResponse<dynamic> response) {
    currencies = response;
    notifyListeners();
  }

  setRechargesList (ApiResponse<dynamic> response) {
    rechargesList = response;
    notifyListeners();
  }

  setTransfersList (ApiResponse<dynamic> response) {
    transfersList = response;
    notifyListeners();
  }

  Future<int?> getBalance(BuildContext context, String code) async {
    setLoading(true);
    int? returnValue;
    await _repository.getBalance(context: context, code: code).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBalance(ApiResponse.completed(value["data"]));
        } else {
          // Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      // Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> getMyWallets(BuildContext context) async {
    setWalletsList(ApiResponse.loading());
    int? returnValue;
    await _repository.getMyWallets(context: context).then((value) {
      print(value);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setWalletsList(ApiResponse.completed(value["data"]));
        } else {
          setWalletsList(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setWalletsList(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> getCurrencies(BuildContext context) async {
    setCurrencies(ApiResponse.loading());
    int? returnValue;
    await _repository.getCurrencies(context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setCurrencies(ApiResponse.completed(value["data"]));
        } else {
          setCurrencies(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setCurrencies(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> createWallet(dynamic data, BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.createWallet(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage(value['message']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.walletHome,
                (route) => false,
          );
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setWalletsList(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> rechargeWallet(dynamic data, BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.rechargeWallet(data, context: context).then((value) async {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          String url = value["data"]['lien_paiement'].toString();

          var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
          if(urllaunchable){
            await launch(url); //launch is from url_launcher package to launch URL
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.walletHome,
                  (route) => false,
            );
          }else{
            Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
          }
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
      returnValue = 1;
    }).onError((error, stackTrace) {
      setWalletsList(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> getRechargesHistory(String currency, BuildContext context) async {
    setRechargesList(ApiResponse.loading());
    int? returnValue;
    await _repository.rechargeHistory(currency: currency, context: context).then((value) {
      print(value);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setRechargesList(ApiResponse.completed(value["data"]));
        } else {
          setRechargesList(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setRechargesList(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<int?> getTransfersHistory(String currency, BuildContext context) async {
    setTransfersList(ApiResponse.loading());
    int? returnValue;
    await _repository.transactionsHistory(currency: currency, context: context).then((value) {
      print(value);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setTransfersList(ApiResponse.completed(value["data"]));
        } else {
          setTransfersList(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setTransfersList(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }
}