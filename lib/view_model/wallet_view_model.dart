import 'dart:io';

import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/repository/wallet_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/utils/utils.dart';

class WalletViewModel with ChangeNotifier{
  final _repository = WalletRepository();
  bool _loading = false;
  ApiResponse<dynamic> balance = ApiResponse.loading();
  ApiResponse<dynamic> walletsList = ApiResponse.loading();
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
}