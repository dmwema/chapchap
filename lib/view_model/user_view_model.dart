import 'package:chapchap/model/profession_model.dart';
import 'package:chapchap/utils/utils.dart';
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

  Future<void> reduceNotifications() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? nbNotifications = sp.getInt('nbNotifications');
    if (nbNotifications != null && nbNotifications > 0) {
      sp.setInt('nbNotifications', nbNotifications - 1);
    }
  }

  Future<bool> checkSeenTontineInfo() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool? seenTontineInfo = await sp.getBool('seenTontineInfo');
    return seenTontineInfo == true;
  }

  Future<void> setSeenTontineInfo() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('seenTontineInfo', true);
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
      if (user.langue != null) {
        sp.setString('selected_language', Utils.capitalize(user.langue!)) ?? "";
      }
      sp.setString('adresse', user.adresse.toString());
      sp.setBool('wallet', user.wallet == true);
      sp.setString('code_interac', user.codeInterac.toString());
      sp.setString('question_interac', user.questionInterac.toString());
      sp.setString('reponse_interac', user.reponseInterac.toString());
      sp.setBool('pin', user.pin == true);
      sp.setBool('email_notification', user.emailNotification == true);
      sp.setInt('nbNotifications', user.nbNotifications ?? 0);
      sp.setBool('sms_notification', user.smsNotification == true);
      sp.setBool('push_notification', user.pushNotification == true);
      sp.setString('nomClient', user.nomClient.toString());
      sp.setString('paysNationalite', user.paysNationalite ?? '');
      if (user.soldeParrainage != null) {
        sp.setInt('soldeParrainage', user.soldeParrainage!);
      }
      sp.setString('prenomClient', user.prenomClient.toString());
      sp.setString('villeClient', user.villeClient.toString());
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

      if (user.profession != null) {
        sp.setInt('userProfessionId', user.profession!.idProfession!);
        sp.setString('userProfession', user.profession!.profession.toString());
      }

      sp.setString('validationCompte', user.validationCompte.toString());
      if (user.commissionParrainage != null) {
        sp.setInt('commissionParrainage', user.commissionParrainage!);
      }
      sp.setInt('idPays', user.idPays!);
      sp.setString('codePays', user.codePays!);
      sp.setString('pays_nom', user.paysNom!);
    }

    notifyListeners();
    return true;
  }

  Future<String> getUserLanguage() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? language = sp.getString('selected_language') ?? "";
    return language;
  }

  Future<bool> setUserLanguage(String language) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('selected_language', language);
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? idClient = sp.getInt('idClient');
    String? token = sp.getString('token');
    bool? belmoney = sp.getBool('belmoney');
    String? adresse = sp.getString('adresse');
    bool? wallet = sp.getBool('wallet');
    int? nbNotifications = sp.getInt('nbNotifications');
    String? password = sp.getString('password');
    String? codeInterac = sp.getString('code_interac');
    String? questionInterac = sp.getString('question_interac');
    int? pointsBalance = sp.getInt('points_balance');
    String? reponseInterac = sp.getString('reponse_interac');
    String? client = sp.getString('client');
    bool? pin = sp.getBool('pin');
    String? paysNationalite = sp.getString('paysNationalite');

    ProfessionModel? profession;
    int? professionId = sp.getInt('userProfessionId');
    String? professionName = sp.getString('userProfession');


    if (professionName != null && professionId != null) {
      profession = ProfessionModel(
        idProfession: professionId,
        profession: professionName
      );
    }

    bool? emailNotification = sp.getBool('email_notification');
    bool? smsNotification = sp.getBool('sms_notification');
    bool? pushNotification = sp.getBool('push_notification');
    int? soldeParrainage = sp.getInt('soldeParrainage');
    String? nomClient = sp.getString('nomClient');
    String? prenomClient = sp.getString('prenomClient');
    String? telClient = sp.getString('telClient');
    String? paysMonnaie = sp.getString('paysMonnaie');
    String? villeClient = sp.getString('villeClient');
    String? username = sp.getString('username');
    int? idTypeClient = sp.getInt('idTypeClient');
    String? photoProfil = sp.getString('photoProfil');
    String? emailClient = sp.getString('emailClient');
    String? codeParrainage = sp.getString('codeParrainage');
    String? paysNom = sp.getString('pays_nom');
    String? validationCompte = sp.getString('validationCompte');
    int? commissionParrainage = sp.getInt('commissionParrainage');
    int? idPays = sp.getInt('idPays');
    String? codePays = sp.getString('codePays');

    return UserModel(
      idClient: idClient,
      client: client,
      codeParrainage: codeParrainage,
      commissionParrainage: commissionParrainage,
      paysNationalite: paysNationalite,
      emailClient: emailClient,
      emailNotification: emailNotification,
      smsNotification: smsNotification,
      profession: profession,
      pushNotification: pushNotification,
      nbNotifications: nbNotifications,
      idTypeClient: idTypeClient,
      paysNom: paysNom,
      villeClient: villeClient,
      pin: pin,
      codeInterac: codeInterac,
      questionInterac: questionInterac,
      reponseInterac: reponseInterac,
      wallet: wallet,
      nomClient: nomClient,
      paysMonnaie: paysMonnaie,
      belmoney: belmoney,
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
    await sp.remove('seenTontineInfo');
    return true;
  }
}