import 'package:flutter/material.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('id', user.idClient!.toInt());
    sp.setString('token', user.token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> updateUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('idClient', user.idClient!.toInt());
    sp.setString('token', user.token.toString());
    sp.setString('client', user.client.toString());
    sp.setString('nomClient', user.nomClient.toString());
    sp.setString('prenomClient', user.prenomClient.toString());
    sp.setString('telClient', user.telClient.toString());
    sp.setString('username', user.username.toString());
    sp.setInt('idTypeClient', user.idTypeClient!);
    sp.setString('photoProfil', user.photoProfil.toString());
    sp.setString('emailClient', user.emailClient.toString());
    sp.setString('codeParrainage', user.codeParrainage.toString());
    sp.setString('validationCompte', user.validationCompte.toString());
    sp.setInt('commissionParrainage', user.commissionParrainage!);

    notifyListeners();
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? idClient = sp.getInt('idClient');
    String? token = sp.getString('token');
    String? client = sp.getString('client');
    String? nomClient = sp.getString('nomClient');
    String? prenomClient = sp.getString('prenomClient');
    String? telClient = sp.getString('telClient');
    String? username = sp.getString('username');
    int? idTypeClient = sp.getInt('idTypeClient');
    String? photoProfil = sp.getString('photoProfil');
    String? emailClient = sp.getString('emailClient');
    String? codeParrainage = sp.getString('codeParrainage');
    String? validationCompte = sp.getString('validationCompte');
    int? commissionParrainage = sp.getInt('commissionParrainage');

    return UserModel(
      idClient: idClient,
      client: client,
      codeParrainage: codeParrainage,
      commissionParrainage: commissionParrainage,
      emailClient: emailClient,
      idTypeClient: idTypeClient,
      nomClient: nomClient,
      photoProfil: photoProfil,
      prenomClient: prenomClient,
      telClient: telClient,
      token: token,
      username: username,
      validationCompte: validationCompte
    );
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    await sp.setBool('initScreen', true);
    return true;
  }
}