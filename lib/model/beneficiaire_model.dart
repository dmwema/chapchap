import 'package:chapchap/model/pays_destination_model.dart';

import 'profession_model.dart';

class BeneficiaireModel {
  int? idPays;
  String? codePays;
  String? paysMonnaie;
  int? idBeneficiaire;
  String? emailBeneficiaire;
  String? prenomBeneficiaire;
  Destination? destination;
  String? nomBeneficiaire;
  int? id_mode_retrait;
  String? adresseBeneficiaire;
  String? telBeneficiaire;
  Map<String, dynamic>? paymentInfos;
  String? banque;
  String? swift;
  String? iban;
  String? idInstitutionFinanciere;
  String? idTransit;
  String? idCompte;
  String? intituleCompteBancaire;
  String? numeroCompteCancaire;
  String? villeBeneficiaire;
  ProfessionModel? professionBeneficiaire;
  String? bankFieldRequired;

  BeneficiaireModel(
      {this.idPays,
        this.codePays,
        this.professionBeneficiaire,
        this.paysMonnaie,
        this.idBeneficiaire,
        this.bankFieldRequired,
        this.emailBeneficiaire,
        this.prenomBeneficiaire,
        this.nomBeneficiaire,
        this.numeroCompteCancaire,
        this.paymentInfos,
        this.destination,
        this.villeBeneficiaire,
        this.adresseBeneficiaire,
        this.telBeneficiaire,
        this.intituleCompteBancaire,
        this.banque,
        this.swift,
        this.iban,
        this.id_mode_retrait,
        this.idInstitutionFinanciere,
        this.idTransit,
        this.idCompte});

  BeneficiaireModel.fromJson(Map<String, dynamic> json) {
    idPays = json['idPays'];
    codePays = json['code_pays'];
    id_mode_retrait = json['id_mode_retrait'];
    paysMonnaie = json['pays_monnaie'];
    if (json['destination'] != null) {
      destination = Destination.fromJson(json['destination']);
    }
    bankFieldRequired = json['bank_field_required'];
    idBeneficiaire = json['idBeneficiaire'];
    if (json['professionBeneficiaire'] != null) {
      professionBeneficiaire = ProfessionModel.fromJson(json['professionBeneficiaire']);
    }
    villeBeneficiaire = json['villeBeneficiaire'];
    adresseBeneficiaire = json['adresseBeneficiaire'];
    emailBeneficiaire = json['emailBeneficiaire'];
    intituleCompteBancaire = json['intitule_compte_bancaire'];
    nomBeneficiaire = json['nomBeneficiaire'];
    numeroCompteCancaire = json['numero_compte_bancaire'];
    prenomBeneficiaire = json['prenomBeneficiaire'];
    telBeneficiaire = json['telBeneficiaire'];
    banque = json['banque'];
    swift = json['swift'];
    iban = json['iban'];
    idInstitutionFinanciere = json['id_institution_financiere'];
    idTransit = json['id_transit'];
    idCompte = json['id_compte'];

    paymentInfos = {
      "id_institution_financiere": {'name': 'ID Institution Bancaire', 'value': json['id_institution_financiere']},
      "banque": {'name': 'Banque', 'value': json['banque']},
      "swift": {'name': 'Swift', 'value': json['swift']},
      "iban": {'name': 'Iban', 'value': json['iban']},
      "id_compte": {'name': 'ID Compte', 'value': json['id_compte']},
      "id_transit": {'name': 'ID Transit', 'value': json['id_transit']},
      "emailBeneficiaire": {'name': 'Email Beneficiaire', 'value': json['emailBeneficiaire']},
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPays'] = this.idPays;
    data['code_pays'] = this.codePays;
    data['pays_monnaie'] = this.paysMonnaie;
    data['villeBeneficiaire'] = this.villeBeneficiaire;
    data['idBeneficiaire'] = this.idBeneficiaire;
    data['professionBeneficiaire'] = this.professionBeneficiaire;
    data['emailBeneficiaire'] = this.emailBeneficiaire;
    data['id_mode_retrait'] = id_mode_retrait;
    data['intitule_compte_bancaire'] = intituleCompteBancaire;
    data['nomBeneficiaire'] = nomBeneficiaire;
    if (destination != null) {
      data['destination'] = destination!.toJson();
    }
    data['prenomBeneficiaire'] = prenomBeneficiaire;
    data['numero_compte_bancaire'] = numeroCompteCancaire;
    data['telBeneficiaire'] = this.telBeneficiaire;
    data['banque'] = this.banque;
    data['adresseBeneficiaire'] = adresseBeneficiaire;
    data['bank_field_required'] = this.bankFieldRequired;
    data['swift'] = this.swift;
    data['iban'] = this.iban;
    data['id_institution_financiere'] = this.idInstitutionFinanciere;
    data['id_transit'] = this.idTransit;
    data['id_compte'] = this.idCompte;
    if (paymentInfos != null) {
      data['id_institution_financiere'] = paymentInfos!['id_institution_financiere']?['value'];
      data['banque'] = paymentInfos!['banque']?['value'];
      data['swift'] = paymentInfos!['swift']?['value'];
      data['iban'] = paymentInfos!['iban']?['value'];
      data['id_compte'] = paymentInfos!['id_compte']?['value'];
      data['id_transit'] = paymentInfos!['id_transit']?['value'];
    }
    return data;
  }

  String fullName () {
    String fname = '';
    if (prenomBeneficiaire != null) {
      fname += '${prenomBeneficiaire!} ';
    }
    if (nomBeneficiaire != null) {
      fname += nomBeneficiaire!;
    }
    return fname;
  }

  String initials () {
    String initials = '';
    if (prenomBeneficiaire != null && prenomBeneficiaire!.isNotEmpty) {
      initials += prenomBeneficiaire![0];
    }
    if (nomBeneficiaire != null && nomBeneficiaire!.isNotEmpty) {
      initials += nomBeneficiaire![0];
    }
    return initials;
  }
}
