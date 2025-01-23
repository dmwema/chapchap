class MotifModel {
  int? idMotif;
  String? motif;

  MotifModel({this.idMotif, this.motif});

  MotifModel.fromJson(Map<String, dynamic> json) {
    idMotif = json['idMotif'];
    motif = json['motif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idMotif'] = this.idMotif;
    data['motif'] = this.motif;
    return data;
  }
}
