import 'package:chapchap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/data/network/base_api_services.dart';
import 'package:chapchap/data/network/network_api_service.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> userImage (data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getMultipartApiResponse(AppUrl.updateImage, data, context: context, filename: "img");
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> registerApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.registerEndPoint, data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> resetPassword (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.resetPassword, data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> changePassword (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.changePassword, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getInfoMessages ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.allInfoMessages, [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> uPassword (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.uPass, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> resendCode (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.resendCode, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> phoneVerificationConfirm (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.phoneVerificatiobEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

}