class PaysDestinationModel {
  int? idPaysSrce;
  String? paysSrce;
  String? codePaysSrce;
  String? paysMonnaieSrce;
  String? paysCodeMonnaieSrce;
  List<Destination>? destination;

  PaysDestinationModel(
      {this.idPaysSrce,
        this.paysSrce,
        this.codePaysSrce,
        this.paysMonnaieSrce,
        this.paysCodeMonnaieSrce,
        this.destination});

  PaysDestinationModel.fromJson(Map<String, dynamic> json) {
    idPaysSrce = json['id_pays_srce'];
    paysSrce = json['pays_srce'];
    codePaysSrce = json['code_pays_srce'];
    paysMonnaieSrce = json['pays_monnaie_srce'];
    paysCodeMonnaieSrce = json['pays_code_monnaie_srce'];
    if (json['destination'] != null) {
      destination = <Destination>[];
      json['destination'].forEach((v) {
        destination!.add(new Destination.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_pays_srce'] = this.idPaysSrce;
    data['pays_srce'] = this.paysSrce;
    data['code_pays_srce'] = this.codePaysSrce;
    data['pays_monnaie_srce'] = this.paysMonnaieSrce;
    data['pays_code_monnaie_srce'] = this.paysCodeMonnaieSrce;
    if (this.destination != null) {
      data['destination'] = this.destination!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Destination {
  int? idSens;
  double? rate;
  double? taux_transfert;
  double? taux_transfert_fixe;
  int? idPaysDest;
  String? codePaysDest;
  String? bankFieldRequired;
  String? paysDest;
  String? paysCodeMonnaieDest;
  String? paysMonnaieDest;
  List<ModeRetrait>? modeRetrait;
  String? paysIndictelDest;

  Destination(
      {this.idSens,
        this.taux_transfert,
        this.rate,
        this.idPaysDest,
        this.codePaysDest,
        this.paysDest,
        this.paysIndictelDest,
        this.paysCodeMonnaieDest,
        this.taux_transfert_fixe,
        this.paysMonnaieDest,
        this.bankFieldRequired,
        this.modeRetrait});

  Destination.fromJson(Map<String, dynamic> json) {
    idSens = json['id_sens'];
    rate = json['rate'] == null ? null : double.parse(json['rate'].toString());
    taux_transfert = json['taux_transfert'] == null ? null : double.parse(json['taux_transfert'].toString());
    taux_transfert_fixe = json['taux_transfert_fixe'] == null ? null : double.parse(json['taux_transfert_fixe'].toString());
    idPaysDest = json['id_pays_dest'];
    codePaysDest = json['code_pays_dest'];
    if (json['bank_field_required'] is String) {
      bankFieldRequired = json['bank_field_required'];
    }
    paysDest = json['pays_dest'];
    paysIndictelDest = json['pays_indictel_dest'];
    paysCodeMonnaieDest = json['pays_code_monnaie_dest'];
    paysMonnaieDest = json['pays_monnaie_dest'];
    if (json['mode_retrait'] != null) {
      modeRetrait = <ModeRetrait>[];
      json['mode_retrait'].forEach((v) {
        modeRetrait!.add(ModeRetrait.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_sens'] = this.idSens;
    data['rate'] = this.rate;
    data['id_pays_dest'] = this.idPaysDest;
    data['taux_transfert'] = this.taux_transfert;
    data['code_pays_dest'] = this.codePaysDest;
    data['pays_indictel_dest'] = this.paysIndictelDest;
    data['pays_dest'] = this.paysDest;
    data['bank_field_required'] = this.bankFieldRequired;
    data['pays_code_monnaie_dest'] = this.paysCodeMonnaieDest;
    data['pays_monnaie_dest'] = this.paysMonnaieDest;
    data['taux_transfert_fixe'] = taux_transfert_fixe;
    if (this.modeRetrait != null) {
      data['mode_retrait'] = this.modeRetrait!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModeRetrait {
  int? idModeRetrait;
  String? modeRetrait;
  String? infosModeRetrait;
  String? withdrawalFieldRequired;

  ModeRetrait({this.idModeRetrait, this.modeRetrait, this.withdrawalFieldRequired, this.infosModeRetrait});

  ModeRetrait.fromJson(Map<String, dynamic> json) {
    idModeRetrait = json['id_mode_retrait'];
    modeRetrait = json['mode_retrait'];
    infosModeRetrait = json['infos_mode_retrait'];
    withdrawalFieldRequired = json['withdrawal_field_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_mode_retrait'] = this.idModeRetrait;
    data['mode_retrait'] = this.modeRetrait;
    data['infos_mode_retrait'] = this.infosModeRetrait;
    data['withdrawal_field_required'] = withdrawalFieldRequired;
    return data;
  }
}
