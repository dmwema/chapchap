import 'package:chapchap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/data/network/base_api_services.dart';
import 'package:chapchap/data/network/network_api_service.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_url.dart';

class WalletRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getBalance ({required BuildContext context, required String code}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.getBalance}/$code", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getMyWallets ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.getMyWallets, {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> createWallet (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.createWallet, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}