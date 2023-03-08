import 'package:flutter/material.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetResponse(String url, {bool auth = false, required BuildContext context});
  Future<dynamic> getPostApiResponse(String url, dynamic data, {required BuildContext context, bool auth = true, String contentType = "application/json"});
  Future<dynamic> getPatchApiResponse(String url, dynamic data, {required BuildContext context});
  Future<dynamic> getMultipartApiResponse(String url, dynamic data, {required BuildContext context, required String filename});
  Future<dynamic> getDeleteApiResponse(String url, {required BuildContext context, bool auth = true, String contentType = "application/json"});
}