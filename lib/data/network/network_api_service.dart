import 'dart:convert';
import 'dart:io';

import 'package:chapchap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chapchap/data/app_exceptions.dart';
import 'package:chapchap/data/network/base_api_services.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class NetworkApiService extends BaseApiServices {
  Future<UserModel> getUserData () => UserViewModel().getUser();
  UserModel user = UserModel();

  @override
  Future getGetResponse(String url, {bool auth = false, required BuildContext context}) async {
    await getUserData ().then((value) {
      user = value;
    });

    var header = {
      'Content-Type': "application/json"
    };

    var header_auth = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer ${user.token}'
    };

    dynamic responseJson;
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: auth ? header_auth : header,
      ).timeout(const Duration(seconds: 120));
      responseJson = returnResponse(response, context);
    } on SocketException {
      return;
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data, {required BuildContext context, bool auth = false, String contentType = "application/json"}) async {
    dynamic responseJson;

    await getUserData ().then((value) {
      user = value;
    });

    var header = {
      'Content-Type': contentType
    };

    var header_auth = {
      'Content-Type': contentType,
      'Authorization': 'Bearer ${user.token}'
    };
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: auth? header_auth: header,
      ).timeout(const Duration(seconds: 120));

      responseJson = returnResponse(response, context);

    } on SocketException {
      //Navigator.pushNamed(context, RoutesName.network_error);
    } catch (e) {
      rethrow;
    }
    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, {required BuildContext context, bool auth = true, String contentType = "application/json"}) async {
    dynamic responseJson;

    await getUserData ().then((value) {
      user = value;
    });

    var header = {
      'Content-Type': contentType
    };

    var headerAuth = {
      'Content-Type': contentType,
      'Authorization': 'Bearer ${user.token}'
    };
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: auth? headerAuth: header,
      ).timeout(const Duration(seconds: 120));
      responseJson = response;

    } on SocketException {
      //Navigator.pushNamed(context, RoutesName.network_error);
    } catch (e) {
      rethrow;
    }
    return responseJson;
  }

  @override
  Future getPatchApiResponse(String url, dynamic data, {required BuildContext context}) async {
    dynamic responseJson;
    var header = {
      'Content-Type': 'application/merge-patch+json'
    };
    try {
      http.Response response = await http.patch(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: header,
      ).timeout(const Duration(seconds: 60));

      responseJson = returnResponse(response, context);
    } on SocketException {
     // Navigator.pushNamed(context, RoutesName.network_error);
      //throw FetchDataException('Pas de connexion internet');
    }
    return responseJson;
  }

  dynamic returnResponse (http.Response response, context) {
    switch(response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 204:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 401:
        if (ModalRoute.of(context)?.settings.name != RoutesName.login) {
          Utils.flushBarErrorMessage("Vous devez vous connecter", context);
          Navigator.pushNamed(context, RoutesName.login);
        }
        throw UnauthorisedException("Non autorisé");
      default:
        throw FetchDataException('Erreur survenue lors de la connexion avec notre serveur' +  ' avec le code de statut ' + response.statusCode.toString() + response.body.toString());
    }
  }

  @override
  Future getMultipartApiResponse(String url, data, {required BuildContext context, required String filename}) async {
    dynamic responseJson;
    await getUserData ().then((value) {
      user = value;
    });
    try {
      var postUri = Uri.parse(url);
      http.MultipartRequest request = http.MultipartRequest("POST", postUri);
      request.headers["Authorization"] = 'Bearer ${user.token}';

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(filename, data[filename].path);
      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();
      var responseData = await http.Response.fromStream(response);
      responseJson = returnResponse(responseData, context);
    } on SocketException {
      Utils.flushBarErrorMessage("Pas de connexion internet", context);
    }
    return responseJson;

  }
}