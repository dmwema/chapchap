class ModeRemboursementModel {
  int? idModeRemboursement;
  String? modeRemboursement;

  ModeRemboursementModel({this.idModeRemboursement, this.modeRemboursement});

  ModeRemboursementModel.fromJson(Map<String, dynamic> json) {
    idModeRemboursement = json['id_mode_remboursement'];
    modeRemboursement = json['mode_remboursement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_mode_remboursement'] = idModeRemboursement;
    data['mode_remboursement'] = modeRemboursement;
    return data;
  }
}
