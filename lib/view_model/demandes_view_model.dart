import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/repository/demandes_repository.dart';
import 'package:chapchap/res/components/screen_argument.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/utils/utils.dart';

class DemandesViewModel with ChangeNotifier{
  final _repository = DemandesRepository();
  ApiResponse<dynamic> demandeList = ApiResponse.loading();
  ApiResponse<dynamic> beneficiairesList = ApiResponse.loading();
  ApiResponse<dynamic> paysActifList = ApiResponse.loading();
  ApiResponse<dynamic> paysDestination = ApiResponse.loading();
  ApiResponse<dynamic> allPaysDestination = ApiResponse.loading();
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

  Future<void> myDemandes(dynamic data, BuildContext context, int? n) async {
    setLoading(true);
    await _repository.myDemandes(data, context: context, n: n).then((value) {
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

  Future<void> paysDestinations(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.paysDestination(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setPaysDestination(ApiResponse.completed(PaysDestinationModel.fromJson(value["data"])));
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

  Future<bool> newBeneficiaire(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.newBeneficiaire(data, context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          Utils.toastMessage("Bénéficiaire enrégistré avec succès");
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setPaysActif(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return true;
  }

  Future<dynamic> transfert(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.transfert(data, context: context).then((value) async {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          final SharedPreferences sp = await SharedPreferences.getInstance();
          Utils.toastMessage("Demande enrégistrée avec succès");
          Navigator.pushNamed(context, RoutesName.webViewPage, arguments: ScreenArguments(value["data"]['lien_paiement'].toString(), value["data"]['lien_paiement'].toString()));
          return value;
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
    return true;
  }

  Future<void> beneficiaireInfo(int id, BuildContext context) async {
    setLoading(true);
    await _repository.beneficiaireInfo(id, context: context).then((value) async {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBeneficiaireModel(ApiResponse.completed(
              BeneficiaireModel.fromJson(value["data"])
          ));
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
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

}