class BeneficiaireModel {
  int? idPays;
  String? codePays;
  int? idBeneficiaire;
  String? emailBeneficiaire;
  String? nomBeneficiaire;
  String? telBeneficiaire;
  String? banque;
  String? swift;
  String? iban;
  String? idInstitutionFinanciere;
  String? idTransit;
  String? idCompte;

  BeneficiaireModel(
      {this.idPays,
        this.codePays,
        this.idBeneficiaire,
        this.emailBeneficiaire,
        this.nomBeneficiaire,
        this.telBeneficiaire,
        this.banque,
        this.swift,
        this.iban,
        this.idInstitutionFinanciere,
        this.idTransit,
        this.idCompte});

  BeneficiaireModel.fromJson(Map<String, dynamic> json) {
    idPays = json['idPays'];
    codePays = json['code_pays'];
    idBeneficiaire = json['idBeneficiaire'];
    emailBeneficiaire = json['emailBeneficiaire'];
    nomBeneficiaire = json['nomBeneficiaire'];
    telBeneficiaire = json['telBeneficiaire'];
    banque = json['banque'];
    swift = json['swift'];
    iban = json['iban'];
    idInstitutionFinanciere = json['id_institution_financiere'];
    idTransit = json['id_transit'];
    idCompte = json['id_compte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPays'] = this.idPays;
    data['code_pays'] = this.codePays;
    data['idBeneficiaire'] = this.idBeneficiaire;
    data['emailBeneficiaire'] = this.emailBeneficiaire;
    data['nomBeneficiaire'] = this.nomBeneficiaire;
    data['telBeneficiaire'] = this.telBeneficiaire;
    data['banque'] = this.banque;
    data['swift'] = this.swift;
    data['iban'] = this.iban;
    data['id_institution_financiere'] = this.idInstitutionFinanciere;
    data['id_transit'] = this.idTransit;
    data['id_compte'] = this.idCompte;
    return data;
  }
}
