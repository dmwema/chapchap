import 'package:chapchap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/data/network/base_api_services.dart';
import 'package:chapchap/data/network/network_api_service.dart';
import 'package:chapchap/res/app_url.dart';

class DemandesRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> myDemandes (dynamic data, {required BuildContext context, int? n, bool invoice = false}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(invoice ? AppUrl.invoicesEndPoint : AppUrl.myDemandesEndPoint + ((n != null) ? "/$n": "") , data, context: context, auth: true);
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

  Future<dynamic> myDestinationsApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.myDestinationsEndPoint , data, context: context, auth: true);
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

  Future<dynamic> beneficiaires (dynamic data, {required BuildContext context, bool recent = false}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(recent ? AppUrl.beneficiairesRecentEndPoint : AppUrl.beneficiairesEndPoint , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> relations ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.relationEndPoint , {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> professions ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.professionEndPoint , {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> motifs (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.motifsEndPoint , data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> motifsAnulation (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.motifsAnulationEndPoint , data, context: context, auth: true);
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

  Future<dynamic> readNotification ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse("${AppUrl.readNotificationEndPoint}/$id", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> notifications ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.notificationsEndPoint ,
          {}, context: context, auth: true);
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

  Future<dynamic> modeRemboursement (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.modeRemboursementApi, data, context: context, auth: true);
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

  Future<dynamic> updateBeneficiaire (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.updateBeneficiaire, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> transfert (dynamic data, {required BuildContext context, bool wallet = false}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(wallet == true ? AppUrl.trasfertWallet : AppUrl.trasfert, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> paidWithWallet({required BuildContext context, required Map data}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        AppUrl.paidWithWallet,
        data,
        context: context,
        auth: true,
      );
      return response;
    } catch (e) {
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
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> calculateTransfer(dynamic data, {required BuildContext context}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        AppUrl.calculateTransferEndPoint,
        data,
        context: context,
        auth: true,
      );
      return response;
    } catch (e) {
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