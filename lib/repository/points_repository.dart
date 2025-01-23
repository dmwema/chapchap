import 'package:mardona/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:mardona/data/network/base_api_services.dart';
import 'package:mardona/data/network/network_api_service.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_url.dart';

class PointsRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getBalance ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.getPointsBalance, {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getRules ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.getPointsRules, {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getTransactionsHistory ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.pointsTransactionsHistory, {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getConversionsHistory ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.pointsConversionsHistory, {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> convert ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.pointToCashConvert, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}