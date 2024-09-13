import 'dart:io';

import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/repository/demandes_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DemandesViewModel with ChangeNotifier{
  final _repository = DemandesRepository();
  ApiResponse<dynamic> demandeList = ApiResponse.loading();
  ApiResponse<dynamic> promoList = ApiResponse.loading();
  ApiResponse<dynamic> beneficiairesList = ApiResponse.loading();
  ApiResponse<dynamic> paysActifList = ApiResponse.loading();
  ApiResponse<dynamic> paysDestination = ApiResponse.loading();
  ApiResponse<dynamic> allPaysDestination = ApiResponse.loading();
  ApiResponse<dynamic> applyDetail = ApiResponse.loading();
  ApiResponse<BeneficiaireModel> beneficiaireModel = ApiResponse.loading();


  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setDemandeList (ApiResponse<dynamic> response) {
    demandeList = response;
    notifyListeners();
  }

  setBeneficiairesList (ApiResponse<dynamic> response) {
    beneficiairesList = response;
    notifyListeners();
  }

  setApplyDetail (ApiResponse<dynamic> response) {
    applyDetail = response;
    notifyListeners();
  }

  setPromoList (ApiResponse<dynamic> response) {
    promoList = response;
    notifyListeners();
  }

  setPaysDestination (ApiResponse<PaysDestinationModel> response) {
    paysDestination = response;
    notifyListeners();
  }

  setAllPaysDestination (ApiResponse<PaysDestinationModel> response) {
    allPaysDestination = response;
    notifyListeners();
  }

  setBeneficiaireModel (ApiResponse<BeneficiaireModel> response) {
    beneficiaireModel = response;
    notifyListeners();
  }

  setPaysActif (ApiResponse<dynamic> response) {
    paysActifList = response;
    notifyListeners();
  }

  Future<int?> myDemandes(dynamic data, BuildContext context, int? n) async {
    setLoading(true);
    int? returnValue;
    await _repository.myDemandes(data, context: context, n: n).then((value) {
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
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<void> myDemandesWProblems(dynamic data, BuildContext context, int? n) async {
    setLoading(true);
    await _repository.myDemandesWP(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setDemandeList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> myDestinationsApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.myDestinationsApi(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setPaysDestination(ApiResponse.completed(PaysDestinationModel.fromJson(value["data"])));
        } else {
          //Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      //Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> myPromos(BuildContext context) async {
    setLoading(true);
    await _repository.myPromo(context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setPromoList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> allPaysDestinations(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.allPaysDestination(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setAllPaysDestination(ApiResponse.completed(PaysDestinationModel.fromJson(value["data"])));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> beneficiaires(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.beneficiaires(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBeneficiairesList(ApiResponse.completed(value["data"]));
        } else {
          //Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      //Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> beneficiairesArchive(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.beneficiairesArchive(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBeneficiairesList(ApiResponse.completed(value["data"]));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> paysActifs(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.paysActif(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setPaysActif(ApiResponse.completed(value["data"]));
        } else {
          setPaysActif(ApiResponse.error(value['message']));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setPaysActif(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<dynamic> newBeneficiaire(dynamic data, BuildContext context, {bool redirect = false}) async {

    setLoading(true);
    Map? returnValue;
    await _repository.newBeneficiaire(data, context: context).then((value) {
      returnValue = value;
      setLoading(false);
    }).onError((error, stackTrace) {
      setPaysActif(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
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
      final String fileName =
          "${DateTime
              .now()
              .microsecondsSinceEpoch}.pdf";
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
      Utils.toastMessage("Une erreur est suvenue, veuillez ressayer plutard");
      setLoading(false);
    });
  }

  Future<dynamic> transfert(dynamic data, BuildContext context, {bool transfer = true, bool wallet = false}) async {
    dynamic returnValue;
    setLoading(true);
    await _repository.transfert(data, context: context, wallet: wallet).then((value) async {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          final SharedPreferences sp = await SharedPreferences.getInstance();
          if (wallet == true) {
            Utils.toastMessage(value["data"]["progression"]);
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
          } else {
            Utils.toastMessage("Demande enrégistrée avec succès");
            String url = value["data"]['lien_paiement'].toString();
            if (transfer) {
              var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
              if(urllaunchable){
                await launch(url); //launch is from url_launcher package to launch URL
                Navigator.pushNamed(context,RoutesName.home);
              }else{
                Utils.toastMessage("Impossible d'ouvrir l'url de paiement");
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

  Future<void>  uClient(Map data, BuildContext context, bool pop) async {
    setLoading(true);
    await _repository.uClient(data, context: context).then((value) async {
      print(value);
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          UserModel newUser = UserModel.fromJson(value['data']);
          UserViewModel().updateUser(newUser, false, false).then((value) {
            if (pop) {
              Utils.toastMessage("Profile modifié avec succès");
            }
            if (pop) {
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
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage(value["message"]);
          // Navigator.pushNamed(context, RoutesName.recipeints);
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

  Future<void>  cancelSend(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.cancelSend(context: context, data: data).then((value) async {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Demande d'annulation envoyée avec succès");
          Navigator.pushNamed(context, RoutesName.home);
        } else {
          Utils.flushBarErrorMessage("Impossible d'éffectuer l'opération. Veuillez réessayer plutard.", context);
          Navigator.pushNamed(context, RoutesName.home);
        }
      }
    });
  }

  Future<void> applyPromo(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.applyPromo(context: context, data: data).then((value) async {
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

}