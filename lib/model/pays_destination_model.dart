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
  int? idPaysDest;
  String? codePaysDest;
  String? paysDest;
  String? paysCodeMonnaieDest;
  String? paysMonnaieDest;
  List<ModeRetrait>? modeRetrait;
  String? paysIndictelDest;

  Destination(
      {this.idSens,
        this.rate,
        this.idPaysDest,
        this.codePaysDest,
        this.paysDest,
        this.paysIndictelDest,
        this.paysCodeMonnaieDest,
        this.paysMonnaieDest,
        this.modeRetrait});

  Destination.fromJson(Map<String, dynamic> json) {
    idSens = json['id_sens'];
    rate = json['rate'];
    idPaysDest = json['id_pays_dest'];
    codePaysDest = json['code_pays_dest'];
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
    data['code_pays_dest'] = this.codePaysDest;
    data['pays_indictel_dest'] = this.paysIndictelDest;
    data['pays_dest'] = this.paysDest;
    data['pays_code_monnaie_dest'] = this.paysCodeMonnaieDest;
    data['pays_monnaie_dest'] = this.paysMonnaieDest;
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

  ModeRetrait({this.idModeRetrait, this.modeRetrait, this.infosModeRetrait});

  ModeRetrait.fromJson(Map<String, dynamic> json) {
    idModeRetrait = json['id_mode_retrait'];
    modeRetrait = json['mode_retrait'];
    infosModeRetrait = json['infos_mode_retrait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_mode_retrait'] = this.idModeRetrait;
    data['mode_retrait'] = this.modeRetrait;
    data['infos_mode_retrait'] = this.infosModeRetrait;
    return data;
  }
}
