class PaysModel {
  int? idPays;
  String? paysNom;
  String? paysMonnaie;
  String? paysCodemonnaie;
  String? paysSymbmonnaie;
  String? paysIndictel;
  String? codePays;

  PaysModel(
      {this.idPays,
        this.paysNom,
        this.paysMonnaie,
        this.paysCodemonnaie,
        this.paysSymbmonnaie,
        this.paysIndictel,
        this.codePays});

  PaysModel.fromJson(Map<String, dynamic> json) {
    idPays = json['idPays'];
    paysNom = json['pays_nom'];
    paysMonnaie = json['pays_monnaie'];
    paysCodemonnaie = json['pays_codemonnaie'];
    paysSymbmonnaie = json['pays_symbmonnaie'];
    paysIndictel = json['pays_indictel'];
    codePays = json['code_pays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPays'] = this.idPays;
    data['pays_nom'] = this.paysNom;
    data['pays_monnaie'] = this.paysMonnaie;
    data['pays_codemonnaie'] = this.paysCodemonnaie;
    data['pays_symbmonnaie'] = this.paysSymbmonnaie;
    data['pays_indictel'] = this.paysIndictel;
    data['code_pays'] = this.codePays;
    return data;
  }
}
