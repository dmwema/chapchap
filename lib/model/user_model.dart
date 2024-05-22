class UserModel {
  int? time;
  int? idClient;
  String? client;
  String? password;
  String? token;
  bool? updatePhone;
  bool? confirmContact;
  String? nomClient;
  String? profession;
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
        this.profession,
        this.nomClient,
        this.prenomClient,
        this.updatePhone,
        this.telClient,
        this.username,
        this.idTypeClient,
        this.photoProfil,
        this.confirmContact,
        this.password,
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
    idClient = int.parse(json['idClient'].toString());
    password = json['password'];
    profession = json['profession'];
    client = json['client'];
    nomClient = json['nomClient'];
    updatePhone = json['update_phone'];
    soldeParrainage = json['solde_parrainage'];
    prenomClient = json['prenomClient'];
    telClient = json['telClient'];
    confirmContact = json['confirm_contact'];
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
    data['password'] = password;
    data['adresse'] = this.adresse;
    data['update_phone'] = updatePhone;
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
    data['confirm_contact'] = confirmContact;
    data['code_parrainage'] = this.codeParrainage;
    data['validationCompte'] = this.validationCompte;
    data['commissionParrainage'] = this.commissionParrainage;
    data['idPays'] = this.idPays;
    data['profession'] = profession;
    data['code_pays'] = this.codePays;
    data['pays_monnaie'] = this.paysMonnaie;
    data['pays_nom'] = this.paysNom;
    return data;
  }
}
