class CodePromo {
  String? typeCodePromo;
  int? montantMinCodePromo;
  String? codePromo;
  String? nomCodePromo;
  int? montantCodePromo;

  CodePromo(
      {this.typeCodePromo,
        this.montantMinCodePromo,
        this.codePromo,
        this.nomCodePromo,
        this.montantCodePromo});

  CodePromo.fromJson(Map<String, dynamic> json) {
    typeCodePromo = json['typeCodePromo'];
    montantMinCodePromo = json['montantMinCodePromo'];
    codePromo = json['codePromo'];
    nomCodePromo = json['nomCodePromo'];
    montantCodePromo = json['montantCodePromo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeCodePromo'] = this.typeCodePromo;
    data['montantMinCodePromo'] = this.montantMinCodePromo;
    data['codePromo'] = this.codePromo;
    data['nomCodePromo'] = this.nomCodePromo;
    data['montantCodePromo'] = this.montantCodePromo;
    return data;
  }
}
