import 'package:chapchap/model/filters/history_filter.dart';
import 'package:flutter/material.dart';

class FilterViewModel extends ChangeNotifier {
  HistoryFilter filter = HistoryFilter();

  void setDateRange(DateTimeRange? range) {
    filter.dateRange = range;
    notifyListeners();
  }

  void setBeneficiaire(int? id) {
    filter.beneficiaireId = id;
    notifyListeners();
  }

  void setDestination(String? code) {
    filter.destinationPays = code;
    notifyListeners();
  }

  void setStatus(String? status) {
    filter.statut = status;
    notifyListeners();
  }

  void removeFilter(String key) {
    filter.clearFilter(key);
    notifyListeners();
  }

  int get count => filter.filterCount;

  bool get hasFilters => filter.hasFilters;
}
