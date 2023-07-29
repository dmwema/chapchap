import 'package:chapchap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/data/network/base_api_services.dart';
import 'package:chapchap/data/network/network_api_service.dart';
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

  Future<dynamic> myDemandesWP (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.myDemandesWPEndPoint , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> downloadInvoice(String url, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostDownloadApiResponse(url , [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> changeBeneficiaire (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.changeBeneficiaire , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> paysDestination (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.paysDestinationsEndPoint , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> allPaysDestination (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.allPaysDestinationsEndPoint}/${data["id"]}", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> beneficiaires (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.beneficiairesEndPoint , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> beneficiairesArchive (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.beneficiairesArchiveEndPoint , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> paysActif (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.paysActifsEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> newBeneficiaire (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.newBeneficiaire, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> transfert (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.trasfert, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> beneficiaireInfo (int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.beneficiaireInfo}/$id", [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> myInfos (int id, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.myInfos}/$id", [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> uClient (Map data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.editUser, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> deleteRecipient ({required BuildContext context, required recipientId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.deleteRecipient}/$recipientId", [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> archiveRecipient ({required BuildContext context, required recipientId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.archiveRecipient}/$recipientId", [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> desarchiveRecipient ({required BuildContext context, required recipientId}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.desarchiveRecipient}/$recipientId", [], context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> cancelSend ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.cancelSend, data, context: context, auth: true);
      Utils.flushBarErrorMessage("message", context);
      print("response");
      print(response);
      return response;
    } catch(e) {
      rethrow;
    }
  }

    Future<dynamic> applyPromo ({required BuildContext context, required Map data}) async {
      try  {
        dynamic response = await _apiServices.getPostApiResponse(AppUrl.applyPromo, data, context: context, auth: true);
        return response;
      } catch(e) {
        rethrow;
      }
    }

    Future<dynamic> myPromo ({required BuildContext context}) async {
      try  {
        dynamic response = await _apiServices.getPostApiResponse(AppUrl.myPromo, [], context: context, auth: true);
        return response;
      } catch(e) {
        rethrow;
      }
    }

}