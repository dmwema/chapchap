import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/repository/demandes_repository.dart';
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
          Utils.flushBarErrorMessage("Bénéficiaire enrégistré avec succès", context);
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

}