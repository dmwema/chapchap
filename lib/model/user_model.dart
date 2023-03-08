class UserModel {
  int? idClient;
  String? token;
  String? client;
  String? nomClient;
  String? prenomClient;
  String? telClient;
  String? username;
  int? idTypeClient;
  String? photoProfil;
  String? emailClient;
  String? codeParrainage;
  String? validationCompte;
  int? commissionParrainage;

  UserModel(
      {
        this.idClient,
        this.token,
        this.client,
        this.nomClient,
        this.prenomClient,
        this.telClient,
        this.username,
        this.idTypeClient,
        this.photoProfil,
        this.emailClient,
        this.codeParrainage,
        this.validationCompte,
        this.commissionParrainage});

  UserModel.fromJson(Map<String, dynamic> json) {
    idClient = json['idClient'];
    token = json['token'];
    client = json['client'];
    nomClient = json['nomClient'];
    prenomClient = json['prenomClient'];
    telClient = json['telClient'];
    username = json['username'];
    idTypeClient = json['idTypeClient'];
    photoProfil = json['photoProfil'];
    emailClient = json['emailClient'];
    codeParrainage = json['codeParrainage'];
    validationCompte = json['validationCompte'];
    commissionParrainage = json['commissionParrainage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idClient'] = this.idClient;
    data['token'] = this.token;
    data['client'] = this.client;
    data['nomClient'] = this.nomClient;
    data['prenomClient'] = this.prenomClient;
    data['telClient'] = this.telClient;
    data['username'] = this.username;
    data['idTypeClient'] = this.idTypeClient;
    data['photoProfil'] = this.photoProfil;
    data['emailClient'] = this.emailClient;
    data['codeParrainage'] = this.codeParrainage;
    data['validationCompte'] = this.validationCompte;
    data['commissionParrainage'] = this.commissionParrainage;
    return data;
  }
}
