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
      print("aze");
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data, context: context);
      print(response);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> registerApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/register", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> completeProfileApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/register", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> clientCompleteProfileApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.clientsEndPoint}/register", data, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> clientEditProfileApi (dynamic data, {required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPatchApiResponse("${AppUrl.clientsEndPoint}/$id", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> clientPaiementMethod (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPatchApiResponse("${AppUrl.clientsEndPoint}/${data['id']}", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> resetPasswordRequest (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.passwordReset}/reset-request", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> resetPasswordConfirm (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.passwordReset}/reset-confirm", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> emailVerificationConfirm (dynamic data, int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/$id/email-verifivation-confirm", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> phoneVerificationConfirm (dynamic data, int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/$id/phone-verifivation-confirm", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> newPasswordApi (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/${id}/password", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> emailVerification (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/${id}/email-verifivation", data, context: context);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> phoneVerification (dynamic data, id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.userEndPoint}/${id}/phone-verifivation", data, context: context);

      return response;
    } catch(e) {
      rethrow;
    }
  }

}