import 'package:chapchap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/data/network/base_api_services.dart';
import 'package:chapchap/data/network/network_api_service.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_url.dart';

class DemandesRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> myDemandes (dynamic data, {required BuildContext context, int? n}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.myDemandesEndPoint + ((n != null) ? "/$n": "") , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

}