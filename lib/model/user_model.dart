import 'dart:ffi';

class UserModel {
  int? time;
  int? idClient;
  String? client;
  String? token;
  String? nomClient;
  String? prenomClient;
  String? telClient;
  String? username;
  int? idTypeClient;
  String? photoProfil;
  String? emailClient;
  String? adresse;
  int? soldeParrainage;
  String? codeParrainage;
  String? validationCompte;
  int? commissionParrainage;
  int? idPays;
  String? codePays;
  String? paysMonnaie;
  String? paysNom;

  UserModel(
      {this.time,
        this.idClient,
        this.client,
        this.soldeParrainage,
        this.nomClient,
        this.prenomClient,
        this.telClient,
        this.username,
        this.idTypeClient,
        this.photoProfil,
        this.emailClient,
        this.codeParrainage,
        this.validationCompte,
        this.commissionParrainage,
        this.adresse,
        this.idPays,
        this.token,
        this.codePays,
        this.paysMonnaie,
        this.paysNom});

  UserModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    idClient = json['idClient'];
    client = json['client'];
    nomClient = json['nomClient'];
    soldeParrainage = json['solde_parrainage'];
    prenomClient = json['prenomClient'];
    telClient = json['telClient'];
    username = json['username'];
    adresse = json['adresse'];
    idTypeClient = json['idTypeClient'];
    photoProfil = json['photoProfil'];
    emailClient = json['emailClient'];
    codeParrainage = json['code_parrainage'];
    validationCompte = json['validationCompte'];
    commissionParrainage = json['commissionParrainage'];
    idPays = json['idPays'];
    token = json['token'];
    codePays = json['code_pays'];
    paysMonnaie = json['pays_monnaie'];
    paysNom = json['pays_nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['idClient'] = this.idClient;
    data['adresse'] = this.adresse;
    data['client'] = this.client;
    data['solde_parrainage'] = soldeParrainage;
    data['token'] = this.token;
    data['nomClient'] = this.nomClient;
    data['prenomClient'] = this.prenomClient;
    data['telClient'] = this.telClient;
    data['username'] = this.username;
    data['idTypeClient'] = this.idTypeClient;
    data['photoProfil'] = this.photoProfil;
    data['emailClient'] = this.emailClient;
    data['code_parrainage'] = this.codeParrainage;
    data['validationCompte'] = this.validationCompte;
    data['commissionParrainage'] = this.commissionParrainage;
    data['idPays'] = this.idPays;
    data['code_pays'] = this.codePays;
    data['pays_monnaie'] = this.paysMonnaie;
    data['pays_nom'] = this.paysNom;
    return data;
  }
}
