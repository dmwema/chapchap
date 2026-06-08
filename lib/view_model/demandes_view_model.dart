import 'dart:convert';
import 'dart:io';

import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/model/RelationModel.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/mode_remboursement_model.dart';
import 'package:chapchap/model/motif_annulation_model.dart';
import 'package:chapchap/model/motif_model.dart';
import 'package:chapchap/model/profession_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/transfer_calculation_model.dart';
import 'package:chapchap/repository/demandes_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chapchap/utils/rate_app_service.dart';

class DemandesViewModel with ChangeNotifier {
  final _repository = DemandesRepository();

  // Flag pour vérifier si le ViewModel est démonté (évite le crash notifyListeners)
  bool _isDisposed = false;

  ApiResponse<dynamic> demandeList = ApiResponse.loading();
  ApiResponse<dynamic> promoList = ApiResponse.loading();
  ApiResponse<dynamic> beneficiairesList = ApiResponse.loading();
  ApiResponse<List<RelationModel>> relationsList = ApiResponse.loading();
  ApiResponse<List<ProfessionModel>> professionsList = ApiResponse.loading();
  ApiResponse<dynamic> paysActifList = ApiResponse.loading();
  ApiResponse<List<ModeRemboursementModel>> modeRemboursementList = ApiResponse.loading();
  ApiResponse<PaysDestinationModel> paysDestination = ApiResponse.loading();
  ApiResponse<dynamic> allPaysDestination = ApiResponse.loading();
  ApiResponse<dynamic> applyDetail = ApiResponse.loading();
  ApiResponse<BeneficiaireModel> beneficiaireModel = ApiResponse.loading();
  ApiResponse<dynamic> notificationsList = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  @override
  void dispose() {
    _isDisposed = true; // Indique que le ViewModel est détruit
    super.dispose();
  }

  // Helper sécurisé pour appeler notifyListeners() sans risquer un crash
  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  setLoading(bool value) {
    _loading = value;
    safeNotifyListeners();
  }

  setDemandeList (ApiResponse<dynamic> response) {
    demandeList = response;
    safeNotifyListeners();
  }

  setNotificationsList (ApiResponse<dynamic> response) {
    notificationsList = response;
    safeNotifyListeners();
  }

  setModeRemboursementList (ApiResponse<List<ModeRemboursementModel>> response) {
    modeRemboursementList = response;
    safeNotifyListeners();
  }

  setRelationsList (ApiResponse<List<RelationModel>> response) {
    relationsList = response;
    safeNotifyListeners();
  }

  setProfessionsList (ApiResponse<List<ProfessionModel>> response) {
    // CORRECTION : c'était promoList qui était ciblé ici par erreur !
    professionsList = response;
    safeNotifyListeners();
  }

  setBeneficiairesList (ApiResponse<dynamic> response) {
    beneficiairesList = response;
    safeNotifyListeners();
  }

  setApplyDetail (ApiResponse<dynamic> response) {
    applyDetail = response;
    safeNotifyListeners();
  }

  setPromoList (ApiResponse<dynamic> response) {
    promoList = response;
    safeNotifyListeners();
  }

  setPaysDestination (ApiResponse<PaysDestinationModel> response) {
    paysDestination = response;
    safeNotifyListeners();
  }

  setAllPaysDestination (ApiResponse<PaysDestinationModel> response) {
    allPaysDestination = response;
    safeNotifyListeners();
  }

  setBeneficiaireModel (ApiResponse<BeneficiaireModel> response) {
    beneficiaireModel = response;
    safeNotifyListeners();
  }

  setPaysActif (ApiResponse<dynamic> response) {
    paysActifList = response;
    safeNotifyListeners();
  }

  Future<int?> myDemandes(dynamic data, BuildContext context, int? n, {bool invoice = false}) async {
    setLoading(true);
    int? returnValue;
    await _repository.myDemandes(data, context: context, n: n, invoice: invoice).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          returnValue = value['nombre_probleme'] ?? int.parse(value['nombre_probleme'].toString());
          setDemandeList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
    });
    return returnValue;
  }

  Future<void> myDemandesWProblems(dynamic data, BuildContext context, int? n) async {
    setLoading(true);
    await _repository.myDemandesWP(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setDemandeList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
    });
  }

  Future<PaysDestinationModel?> myDestinationsApi(dynamic data, BuildContext context) async {
    setLoading(true);
    PaysDestinationModel? response;

    await _repository.myDestinationsApi(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value != null) {
        setLoading(false);

        if (value['error'] != true) {
          Map<String, dynamic> paysDestinationJson = value['data'];

          if (paysDestinationJson['destination'] != null) {
            List dest = paysDestinationJson['destination'];
            dest.sort((a, b) => a['pays_dest'].toString()
                .compareTo(b['pays_dest'].toString()));
            paysDestinationJson['destination'] = dest;
          }

          response = PaysDestinationModel.fromJson(paysDestinationJson);
          setPaysDestination(ApiResponse.completed(response));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
    });

    return response;
  }

  Future<void> myPromos(BuildContext context) async {
    setLoading(true);
    await _repository.myPromo(context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setPromoList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });
  }

  Future<void> allPaysDestinations(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.allPaysDestination(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setAllPaysDestination(ApiResponse.completed(PaysDestinationModel.fromJson(value["data"])));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });
  }

  Future<void> beneficiaires(dynamic data, BuildContext context, {bool recent = false}) async {
    setLoading(true);
    await _repository.beneficiaires(data, context: context, recent: recent).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBeneficiairesList(ApiResponse.completed(value["data"]));
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
    });
  }

  Future<List<MotifModel>> motifs(dynamic data, BuildContext context) async {
    List<MotifModel> response = [];
    setLoading(true);
    await _repository.motifs(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value != null) {
        setLoading(false);
        if (value['error'] != true) {
          for (var motif in value['data']) {
            response.add(MotifModel.fromJson(motif));
          }
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
    });
    return response;
  }

  Future<List<MotifAnnulationModel>> motifsAnnulation(dynamic data, BuildContext context) async {
    List<MotifAnnulationModel> response = [];
    setLoading(true);
    await _repository.motifsAnulation(data, context: context).then((value) {
      if (_isDisposed) return;
      setLoading(false);
      if (value['error'] != true) {
        for (var motif in value['data']) {
          response.add(MotifAnnulationModel.fromJson(motif));
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
    });

    return response;
  }

  Future<void> beneficiairesArchive(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.beneficiairesArchive(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBeneficiairesList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });
  }

  Future<List<RelationModel>> relations(BuildContext context) async {
    setLoading(true);
    List<RelationModel> response = [];
    await _repository.relations(context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          for (var relation in value["data"]) {
            response.add(RelationModel.fromJson(relation));
          }
          setRelationsList(ApiResponse.completed(response));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });

    return response;
  }

  Future<List<ProfessionModel>> professions(BuildContext context) async {
    setLoading(true);
    List<ProfessionModel> response = [];
    await _repository.professions(context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          for (var profession in value["data"]) {
            response.add(ProfessionModel.fromJson(profession));
          }
          setProfessionsList(ApiResponse.completed(response));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });

    return response;
  }

  Future<bool> paysActifs(dynamic data, BuildContext context) async {
    setLoading(true);
    bool response = false;
    await _repository.paysActif(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setPaysActif(ApiResponse.completed(value["data"]));
          response = true;
        } else {
          setPaysActif(ApiResponse.error(value['message']));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      setPaysActif(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });
    return response;
  }

  Future<List<ModeRemboursementModel>> modeRemboursements(dynamic data, BuildContext context) async {
    List<ModeRemboursementModel> response = [];
    setLoading(true);
    await _repository.modeRemboursement(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value != null){
        setLoading(false);
        if (value['error'] != true) {
          List responseJson = value['data'];
          for (var rMode in responseJson) {
            response.add(ModeRemboursementModel.fromJson(rMode));
          }
          setModeRemboursementList(ApiResponse.completed(value["data"]));
        } else {
          setModeRemboursementList(ApiResponse.error(value['message']));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      } else {
        setLoading(false);
      }
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      setLoading(false);
    });
    return response;
  }

  Future<dynamic> newBeneficiaire(dynamic data, BuildContext context, {bool redirect = false}) async {
    setLoading(true);
    Map? returnValue;
    await _repository.newBeneficiaire(data, context: context).then((value) {
      if (_isDisposed) return;
      returnValue = value;
      setLoading(false);
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      setBeneficiaireModel(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<bool> updateBeneficiaire(dynamic data, BuildContext context) async {
    setLoading(true);
    bool returnValue = false;
    await _repository.updateBeneficiaire(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value['error'] == true) {
        Utils.flushBarErrorMessage(value['message'], context);
      } else {
        returnValue = true;
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plutard.", context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<dynamic> getFileContent(String url, {required BuildContext context}) async {
    Response response = await _repository.downloadInvoice(url, context: context);

    if (response != null) {
      final Directory? appDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      String tempPath = appDir!.path;
      final String fileName = "${DateTime.now().microsecondsSinceEpoch}.pdf";
      File file = File('$tempPath/$fileName');
      if (!await file.exists()) {
        await file.create();
      }
      await file.writeAsBytes(response.bodyBytes);
      return file;
    }
  }

  Future<void> changeBeneficiaire(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.changeBeneficiaire(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value != null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Demande modifiée avec succès.");
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.home,
                (route) => false,
          );
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
          setLoading(false);
        }
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      Utils.toastMessage("Une erreur est suvenue, veuillez ressayer plutard");
      setLoading(false);
    });
  }

  Future<void> openPaymentUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      await RateAppService.markTransferCompleted();
      if (context.mounted) {
        Navigator.pushNamed(context, RoutesName.home);
      }
    } else {
      Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
    }
  }

  void _logTransfertApiResponse(dynamic value) {
    const tag = '[Transfert API]';
    if (value == null) {
      return;
    }
    try {
      debugPrint('$tag response:\n${const JsonEncoder.withIndent('  ').convert(value)}');
    } catch (_) {
      debugPrint('$tag response: $value');
    }
  }

  Future<dynamic> transfert(dynamic data, BuildContext context, {bool transfer = true, bool wallet = false}) async {
    dynamic returnValue;
    setLoading(true);
    await _repository.transfert(data, context: context, wallet: wallet).then((value) async {
      if (_isDisposed) return;
      _logTransfertApiResponse(value);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          if (wallet == true) {
            Utils.toastMessage(value["data"]["progression"]);
            await RateAppService.markTransferCompleted();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
            }
          } else {
            Utils.toastMessage("Demande enrégistrée avec succès");
            String url = value["data"]['lien_paiement'].toString();
            if (transfer && context.mounted) {
              if (value['data']['system'].toString().toUpperCase() == "CHAPCHAP") {
                await openPaymentUrl(url, context);
              } else {
                await RateAppService.markTransferCompleted();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentWebView(
                      url: url,
                    ),
                  ),
                );
              }
            }
          }
          returnValue = value;
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
    return returnValue;
  }

  Future<void> beneficiaireInfo(int id, BuildContext context) async {
    setLoading(true);
    await _repository.beneficiaireInfo(id, context: context).then((value) async {
      if (_isDisposed) return;
      setLoading(false);
      if (value!=null && value["data"] != null){
        if (value['error'] != true) {
          setBeneficiaireModel(ApiResponse.completed(
              BeneficiaireModel.fromJson(value["data"])
          ));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      } else {
        Utils.flushBarErrorMessage("Une erreur est survenure", context);
      }
    });
  }

  Future<void> uClient(Map data, BuildContext context, bool pop) async {
    setLoading(true);
    await _repository.uClient(data, context: context).then((value) async {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          UserModel newUser = UserModel.fromJson(value['data']);
          UserViewModel().updateUser(newUser, false, false).then((value) {
            if (_isDisposed) return;
            if (pop) {
              Utils.toastMessage("Profile modifié avec succès");
            }
            if (pop && context.mounted) {
              Navigator.pop(context);
            }
          });
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
  }

  Future<bool> deleteRecipient(BuildContext context, int id) async {
    setLoading(true);
    bool success = true;
    await _repository.deleteRecipient(context: context, recipientId: id).then((value) async {
      if (_isDisposed) return success;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Bénéficiaire supprimé avec succès");
        } else {
          success = false;
          Utils.flushBarErrorMessage("Vous ne pouvez pas supprimer ce bénéficiaire. Pensez plutôt à l'archiver", context);
        }
      }
    });
    return success;
  }

  Future<bool> archiveRecipient(BuildContext context, int id) async {
    setLoading(true);
    await _repository.archiveRecipient(context: context, recipientId: id).then((value) async {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage(value["message"]);
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
    return true;
  }

  Future<bool> desarchiveRecipient(BuildContext context, int id) async {
    setLoading(true);
    await _repository.desarchiveRecipient(context: context, recipientId: id).then((value) async {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage(value["message"]);
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
    return true;
  }

  Future<void> cancelSend(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.cancelSend(context: context, data: data).then((value) async {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Demande d'annulation envoyée avec succès");
          if (context.mounted) Navigator.pushNamed(context, RoutesName.home);
        } else {
          Utils.flushBarErrorMessage("Impossible d'éffectuer l'opération. Veuillez réessayer plutard.", context);
          if (context.mounted) Navigator.pushNamed(context, RoutesName.home);
        }
      }
    });
  }

  Future<TransferCalculation?> calculateTransfer(BuildContext context, Map<String, dynamic> data) async {
    TransferCalculation? result;
    await _repository.calculateTransfer(data, context: context).then((value) {
      if (_isDisposed) return;
      if (value == null) return;
      final hasError = value['error'] == true;
      final isSuccess = value['success'] == true || value['error'] != true;
      if (!hasError && isSuccess && value['data'] != null) {
        result = TransferCalculation.fromJson(Map<String, dynamic>.from(value['data']));
      } else if (value['message'] != null && value['message'].toString().isNotEmpty) {
        Utils.flushBarErrorMessage(value['message'].toString(), context);
      }
    }).onError((_, __) {});
    return result;
  }

  Future<bool> paidWithWallet(
    BuildContext context, {
    required int idDemande,
    required String codePin,
  }) async {
    setLoading(true);
    var success = false;
    await _repository.paidWithWallet(
      context: context,
      data: {
        'id_demande': idDemande,
        'code_pin': codePin,
      },
    ).then((value) {
      setLoading(false);
      if (value != null && value['error'] != true) {
        success = true;
        final message = value['message']?.toString();
        if (message != null && message.isNotEmpty) {
          Utils.toastMessage(message);
        } else {
          Utils.toastMessage('Paiement effectué avec succès');
        }
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
      } else if (value != null) {
        Utils.flushBarErrorMessage(
          value['message']?.toString() ?? 'Impossible d\'effectuer le paiement',
          context,
        );
      }
    }).onError((error, _) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
    });
    return success;
  }

  Future<void> applyPromo(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.applyPromo(context: context, data: data).then((value) async {
      if (_isDisposed) return;
      setLoading(false); // Ajouté pour couper le chargement si applicable
      if (value != null) {
        if (value['error'] != true) {
          setApplyDetail(ApiResponse.completed(value['data']));
          Utils.toastMessage("Code promo appliqué avec succès");
        } else {
          setApplyDetail(ApiResponse.error("erreur"));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
  }

  Future<int?> notifications(BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.notifications(context: context).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setNotificationsList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<bool?> readNotification(BuildContext context, int id) async {
    setLoading(true);
    bool? returnValue;
    await _repository.readNotification(context: context, id: id).then((value) {
      if (_isDisposed) return;
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          returnValue = true;
        }
      }
    }).onError((error, stackTrace) {
      if (_isDisposed) return;
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }
}