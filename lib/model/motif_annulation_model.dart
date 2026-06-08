class MotifAnnulationModel {
  int? idMotifAnnulation;
  String? motifAnnulation;

  MotifAnnulationModel({this.idMotifAnnulation, this.motifAnnulation});

  MotifAnnulationModel.fromJson(Map<String, dynamic> json) {
    idMotifAnnulation = json['id_motif_annulation'];
    motifAnnulation = json['motif_annulation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_motif_annulation'] = idMotifAnnulation;
    data['motif_annulation'] = motifAnnulation;
    return data;
  }
}
