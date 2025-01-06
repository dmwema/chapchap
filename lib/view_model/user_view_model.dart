import 'package:flutter/material.dart';
  import 'package:chapchap/model/user_model.dart';
  import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('nomClient', user.nomClient!.toString());
    sp.setString('token', user.token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> updateImage(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('photoProfil', user.photoProfil.toString());
    notifyListeners();
    return true;
  }

  Future<bool> updateUser(UserModel user, bool token, bool reset) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (token) {
      sp.setString('token', user.token.toString());
    }
    if (!reset) {
      sp.setInt('idClient', user.idClient!.toInt());
      sp.setString('client', user.client.toString());
      sp.setString('password', user.password.toString());
      sp.setString('adresse', user.adresse.toString());
      sp.setString('code_interac', user.codeInterac.toString());
      sp.setString('question_interac', user.questionInterac.toString());
      sp.setString('reponse_interac', user.reponseInterac.toString());
      sp.setBool('pin', user.pin == true);
      sp.setBool('email_notification', user.emailNotification == true);
      sp.setBool('sms_notification', user.smsNotification == true);
      sp.setBool('push_notification', user.pushNotification == true);
      sp.setString('nomClient', user.nomClient.toString());
      if (user.soldeParrainage != null) {
        sp.setInt('soldeParrainage', user.soldeParrainage!);
      }
      sp.setString('prenomClient', user.prenomClient.toString());
      if (user.pointsBalance! != null) {
        sp.setInt('points_balance', user.pointsBalance!);
      }
      sp.setString('telClient', user.telClient.toString());
      sp.setString('username', user.username.toString());
      if (user.idTypeClient != null) {
        sp.setInt('idTypeClient', user.idTypeClient!);
      }
      sp.setString('photoProfil', user.photoProfil.toString());
      sp.setString('emailClient', user.emailClient.toString());
      sp.setString('codeParrainage', user.codeParrainage.toString());
      if (user.paysMonnaie != null) {
        sp.setString('paysMonnaie', user.paysMonnaie.toString());
      }
      sp.setString('validationCompte', user.validationCompte.toString());
      if (user.commissionParrainage != null) {
        sp.setInt('commissionParrainage', user.commissionParrainage!);
      }
      sp.setInt('idPays', user.idPays!);
      sp.setString('codePays', user.codePays!);
    }

    notifyListeners();
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? idClient = sp.getInt('idClient');
    String? token = sp.getString('token');
    String? adresse = sp.getString('adresse');
    String? password = sp.getString('password');
    String? codeInterac = sp.getString('code_interac');
    String? questionInterac = sp.getString('question_interac');
    int? pointsBalance = sp.getInt('points_balance');
    String? reponseInterac = sp.getString('reponse_interac');
    String? client = sp.getString('client');
    bool? pin = sp.getBool('pin');
    bool? emailNotification = sp.getBool('email_notification');
    bool? smsNotification = sp.getBool('sms_notification');
    bool? pushNotification = sp.getBool('push_notification');
    int? soldeParrainage = sp.getInt('soldeParrainage');
    String? nomClient = sp.getString('nomClient');
    String? prenomClient = sp.getString('prenomClient');
    String? telClient = sp.getString('telClient');
    String? paysMonnaie = sp.getString('paysMonnaie');
    String? username = sp.getString('username');
    int? idTypeClient = sp.getInt('idTypeClient');
    String? photoProfil = sp.getString('photoProfil');
    String? emailClient = sp.getString('emailClient');
    String? codeParrainage = sp.getString('codeParrainage');
    String? validationCompte = sp.getString('validationCompte');
    int? commissionParrainage = sp.getInt('commissionParrainage');
    int? idPays = sp.getInt('idPays');
    String? codePays = sp.getString('codePays');

    return UserModel(
      idClient: idClient,
      client: client,
      codeParrainage: codeParrainage,
      commissionParrainage: commissionParrainage,
      emailClient: emailClient,
      emailNotification: emailNotification,
      smsNotification: smsNotification,
      pushNotification: pushNotification,
      idTypeClient: idTypeClient,
      pin: pin,
      codeInterac: codeInterac,
      questionInterac: questionInterac,
      reponseInterac: reponseInterac,
      nomClient: nomClient,
      paysMonnaie: paysMonnaie,
      password: password,
      photoProfil: photoProfil,
      prenomClient: prenomClient,
      telClient: telClient,
      pointsBalance: pointsBalance,
      token: token,
      username: username,
      idPays: idPays,
      soldeParrainage: soldeParrainage,
      adresse: adresse,
      validationCompte: validationCompte,
      codePays: codePays
    );
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    return true;
  }
}