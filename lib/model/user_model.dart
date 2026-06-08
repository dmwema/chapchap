import 'profession_model.dart';

class UserModel {
  int? time;
  int? idClient;
  String? client;
  String? password;
  String? token;
  bool? updatePhone;
  bool? pin;
  bool? wallet;
  int? nbNotifications;
  bool? tontine;
  bool? confirmContact;
  String? nomClient;
  String? prenomClient;
  String? telClient;
  String? villeClient;
  String? username;
  int? idTypeClient;
  String? photoProfil;
  bool? belmoney;
  String? emailClient;
  String? adresse;
  int? soldeParrainage;
  String? codeParrainage;
  String? validationCompte;
  String? paysNationalite;
  int? commissionParrainage;
  int? pointsBalance;
  int? idPays;
  String? codePays;
  String? paysMonnaie;
  String? langue;
  String? paysNom;
  String? codeInterac;
  String? questionInterac;
  String? reponseInterac;
  bool? emailNotification;
  bool? smsNotification;
  bool? pushNotification;
  ProfessionModel? profession;

  UserModel({
    this.time,
      this.idClient,
      this.client,
      this.soldeParrainage,
      this.langue,
      this.profession,
      this.emailNotification,
      this.nbNotifications,
      this.pushNotification,
      this.smsNotification,
      this.belmoney,
      this.nomClient,
      this.prenomClient,
      this.updatePhone,
      this.pin,
      this.paysNationalite,
      this.telClient,
      this.username,
      this.idTypeClient,
      this.photoProfil,
      this.confirmContact,
      this.password,
      this.emailClient,
      this.codeInterac,
      this.wallet,
      this.tontine,
      this.pointsBalance,
      this.questionInterac,
      this.reponseInterac,
      this.villeClient,
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
    if (json['profession'] != null && json['profession'].runtimeType != String) {
      profession = ProfessionModel.fromJson(json['profession']);
    }
    client = json['client'];
    paysNationalite = json['pays_nationalite'];
    langue = json['langue'];
    nomClient = json['nomClient'];
    villeClient = json['villeClient'];
    updatePhone = json['update_phone'];
    emailNotification = json['email_notification'];
    pushNotification = json['push_notification'];
    smsNotification = json['sms_notification'];
    pin = json['pin'];
    pointsBalance = json['points_balance'];
    soldeParrainage = json['solde_parrainage'];
    codeInterac = json['code_interac'];
    questionInterac = json['question_interac'];
    reponseInterac = json['reponse_interac'];
    prenomClient = json['prenomClient'];
    telClient = json['telClient'];
    nbNotifications = json['nombre_notification'];
    confirmContact = json['confirm_contact'];
    username = json['username'];
    adresse = json['adresse'];
    wallet = json['wallet'] == true;
    tontine = json['tontine'] == true;
    idTypeClient = json['idTypeClient'];
    belmoney = json['belmoney'];
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
    data['pays_nationalite'] = paysNationalite;
    data['update_phone'] = updatePhone;
    data['villeClient'] = villeClient;
    data['client'] = this.client;
    data['solde_parrainage'] = soldeParrainage;
    data['points_balance'] = pointsBalance;
    data['token'] = this.token;
    data['pin'] = pin;
    data['nomClient'] = this.nomClient;
    data['prenomClient'] = this.prenomClient;
    data['telClient'] = this.telClient;
    data['username'] = this.username;
    data['idTypeClient'] = this.idTypeClient;
    data['code_interac'] = codeInterac;
    data['quesion_interac'] = questionInterac;
    data['langue'] = langue;
    data['reponse_interac'] = reponseInterac;
    data['photoProfil'] = this.photoProfil;
    data['wallet'] = wallet;
    data['tontine'] = tontine;
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
    data['belmoney'] = belmoney;
    data['nombre_notification'] = nbNotifications;
    data['email_notification'] = emailNotification;
    data['sms_notification'] = smsNotification;
    data['push_notification'] = pushNotification;
    return data;
  }
}
