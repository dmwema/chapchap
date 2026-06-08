class TransferIntervalle {
  final int? id;
  final String? codeSens;
  final String? minMontant;
  final String? maxMontant;
  final String? fraisFixe;
  final String? fraisVariable;
  final int? actif;

  TransferIntervalle({
    this.id,
    this.codeSens,
    this.minMontant,
    this.maxMontant,
    this.fraisFixe,
    this.fraisVariable,
    this.actif,
  });

  factory TransferIntervalle.fromJson(Map<String, dynamic> json) {
    return TransferIntervalle(
      id: json['id'],
      codeSens: json['code_sens']?.toString(),
      minMontant: json['min_montant']?.toString(),
      maxMontant: json['max_montant']?.toString(),
      fraisFixe: json['frais_fixe']?.toString(),
      fraisVariable: json['frais_variable']?.toString(),
      actif: json['actif'] is int ? json['actif'] : int.tryParse(json['actif']?.toString() ?? ''),
    );
  }

  double get fraisFixeValue => double.tryParse(fraisFixe ?? '') ?? 0;

  double get fraisVariableValue => double.tryParse(fraisVariable ?? '') ?? 0;

  /// Somme affichée des composantes tarifaires de l'intervalle actif.
  double get fraisAffichage => fraisFixeValue + fraisVariableValue;
}

class TransferCalculation {
  final String? statut;
  final String? codeSens;
  final String? paysSource;
  final String? paysDestination;
  final String? deviseSource;
  final String? deviseDestination;
  final double rate;
  final double amountSource;
  final double amountDestination;
  final double amountFees;
  final double feesFixed;
  final double feesVariable;
  final double amountTotal;
  final bool feeCovered;
  final bool amountWithFee;
  final TransferIntervalle? intervalle;
  final String? formule;
  final bool promoApplied;
  final String? promoCode;
  final double promoReduction;
  final String? promoError;

  TransferCalculation({
    this.statut,
    this.codeSens,
    this.paysSource,
    this.paysDestination,
    this.deviseSource,
    this.deviseDestination,
    required this.rate,
    required this.amountSource,
    required this.amountDestination,
    required this.amountFees,
    required this.feesFixed,
    required this.feesVariable,
    required this.amountTotal,
    required this.feeCovered,
    required this.amountWithFee,
    this.intervalle,
    this.formule,
    required this.promoApplied,
    this.promoCode,
    required this.promoReduction,
    this.promoError,
  });

  factory TransferCalculation.fromJson(Map<String, dynamic> json) {
    return TransferCalculation(
      statut: json['statut']?.toString(),
      codeSens: json['code_sens']?.toString(),
      paysSource: json['pays_source']?.toString(),
      paysDestination: json['pays_destination']?.toString(),
      deviseSource: json['devise_source']?.toString(),
      deviseDestination: json['devise_destination']?.toString(),
      rate: _toDouble(json['rate']),
      amountSource: _toDouble(json['amount_source']),
      amountDestination: _toDouble(json['amount_destination']),
      amountFees: _toDouble(json['amount_fees']),
      feesFixed: _toDouble(json['fees_fixed']),
      feesVariable: _toDouble(json['fees_variable']),
      amountTotal: _toDouble(json['amount_total']),
      feeCovered: json['fee_covered'] == true,
      amountWithFee: json['amount_with_fee'] == true,
      intervalle: json['intervalle'] != null
          ? TransferIntervalle.fromJson(Map<String, dynamic>.from(json['intervalle']))
          : null,
      formule: json['formule']?.toString(),
      promoApplied: json['promo_applied'] == true,
      promoCode: json['promo_code']?.toString(),
      promoReduction: _toDouble(json['promo_reduction']),
      promoError: json['promo_error']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    return double.tryParse(value.toString()) ?? 0;
  }

  bool get isOk => statut?.toUpperCase() == 'OK';

  /// Montant affiché dans « Vous envoyez » : montant source + frais.
  double get amountYouSend => amountSource + amountFees;
}
