import 'package:flutter/material.dart';

class HistoryFilter {
  DateTimeRange? dateRange;
  int? beneficiaireId;
  String? destinationPays;
  String? statut;

  HistoryFilter({
    this.dateRange,
    this.beneficiaireId,
    this.destinationPays,
    this.statut,
  });

  bool get hasFilters =>
      dateRange != null ||
          beneficiaireId != null ||
          destinationPays != null ||
          statut != null;

  int get filterCount {
    int count = 0;
    if (dateRange != null) count++;
    if (beneficiaireId != null) count++;
    if (destinationPays != null) count++;
    if (statut != null) count++;
    return count;
  }

  void clearFilter(String key) {
    switch (key) {
      case "date":
        dateRange = null;
        break;
      case "beneficiaire":
        beneficiaireId = null;
        break;
      case "pays":
        destinationPays = null;
        break;
      case "statut":
        statut = null;
        break;
    }
  }
}
