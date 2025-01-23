import 'package:mardona/data/response/api_response.dart';
import 'package:mardona/model/conversion_rule.dart';
import 'package:mardona/repository/points_repository.dart';
import 'package:mardona/views/points/conversion_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mardona/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsViewModel with ChangeNotifier{
  final _repository = PointsRepository();
  bool _loading = false;
  ApiResponse<dynamic> balance = ApiResponse.loading();
  ApiResponse<dynamic> conversionRules = ApiResponse.loading();
  ApiResponse<dynamic> transactions = ApiResponse.loading();
  ApiResponse<dynamic> conversions = ApiResponse.loading();
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setBalance (ApiResponse<dynamic> response) {
    balance = response;
    notifyListeners();
  }

  setTransactions (ApiResponse<dynamic> response) {
    transactions = response;
    notifyListeners();
  }

  setConversions (ApiResponse<dynamic> response) {
    conversions = response;
    notifyListeners();
  }

  setConversionRules (ApiResponse<dynamic> response) {
    conversionRules = response;
    notifyListeners();
  }

  Future<int?> getBalance(BuildContext context) async {
    setLoading(true);
    int? returnValue;
    await _repository.getBalance(context: context).then((value) async {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setBalance(ApiResponse.completed(value["points_balance"]));
          final SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setInt('points_balance', value["points_balance"]);
          setLoading(false);
        } else {
          setLoading(false);
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      // Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<List<ConversionRule>?> getConversionRules(BuildContext context) async {
    setConversionRules(ApiResponse.loading());
    List<ConversionRule>? returnValue;
    await _repository.getRules(context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          List<ConversionRule> rules = [];
          value['data'].forEach((element) {
            rules.add(ConversionRule.fromJson(element));
          });
          setConversionRules(ApiResponse.completed(rules));
          returnValue = rules;
        } else {
          setConversionRules(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setConversionRules(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

  Future<dynamic> getTransactionsHistory(BuildContext context) async {
    setTransactions(ApiResponse.loading());
    await _repository.getTransactionsHistory(context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setTransactions(ApiResponse.completed(value['data']));
        } else {
          setTransactions(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setTransactions(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<dynamic> getConversionsHistory(BuildContext context) async {
    setConversions(ApiResponse.loading());
    await _repository.getConversionsHistory(context: context).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          setConversions(ApiResponse.completed(value['data']));
        } else {
          setConversions(ApiResponse.error(value["message"]));
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      setConversions(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
  }

  Future<Map?> convert(Map data, BuildContext context) async {
    Map? returnData;
    await _repository.convert(context: context, data: data).then((value) {
      if (value!=null){
        setLoading(false);
        if (value['error'] != true) {
          returnData = value;
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnData;
  }
}