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

  Future<dynamic> verifyPhoneExists (data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.verifyPhoneExists, data, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getLocalization ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.getLocalization, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> verifyEmailExists (data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.verifyEmailExists, data, context: context, auth: false);
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

  Future<dynamic> myInfos ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.myInfos, [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> passwordReset (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.passwordReset, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> updateProfile (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.updateProfile, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> updateNotification (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.updateNotifications, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> deleteAccount (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.deleteAccount, data, context: context, auth: true);
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

  Future<dynamic> resendCode (dynamic data, {required BuildContext context, String? token}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.resendCode, data, context: context, auth: true, token: token);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> updatePhone (dynamic data, {required BuildContext context, required String token}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.updatePhone, data, context: context, auth: true, token: token);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> confirmPhoneVerification (dynamic data, {required BuildContext context, required String token}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.phoneVerificationEndPoint, data, context: context, auth: true, token: token);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> confirmContact (dynamic data, {required BuildContext context, required String token}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.confirmContact, data, context: context, auth: true, token: token);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> initiateIdentityVerification ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.initiateIdentityVerification, {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

}