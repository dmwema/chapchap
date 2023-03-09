import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/repository/demandes_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/repository/auth_repository.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class DemandesViewModel with ChangeNotifier{
  final _repository = DemandesRepository();
  ApiResponse<dynamic> demandeList = ApiResponse.loading();

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

}