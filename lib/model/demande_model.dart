import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/motif_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';

class DemandeModel {
  int? idDemande;
  int? idAnnulation;
  ModeRetrait? modeRetrait;
  MotifModel? motif;
  String? lienPaiement;
  String? system;
  String? progression;
  String? facture;
  String? date;
  String? statutDemande;
  String? probleme;
  String? datePaidBen;
  String? montantNet;
  String? montanceSrce;
  String? fees;
  String? montantSansFrais;
  String? montanceDest;
  String? codePaysSrce;
  String? codePaysDest;
  String? paysSrce;
  bool? isPaid;
  String? paysDest;
  BeneficiaireModel? beneficiaire;
  String? paysMonnaieSrce;
  Map<String, dynamic>? paymentInfos;
  String? paysCodeMonnaieSrce;
  String? paysMonnaieDest;
  String? paysCodeMonnaieDest;
  String? rabaisPromo;
  String? bankFieldRequired;

  DemandeModel(
    {
      this.idDemande,
      this.idAnnulation,
      this.isPaid,
      this.system,
      this.paymentInfos,
      this.motif,
      this.modeRetrait,
      this.bankFieldRequired,
      this.statutDemande,
      this.fees,
      this.lienPaiement,
      this.progression,
      this.rabaisPromo,
      this.probleme,
      this.facture,
      this.date,
      this.datePaidBen,
      this.montantSansFrais,
      this.montantNet,
      this.montanceSrce,
      this.montanceDest,
      this.codePaysSrce,
      this.codePaysDest,
      this.paysSrce,
      this.paysDest,
      this.beneficiaire,
      this.paysMonnaieSrce,
      this.paysCodeMonnaieSrce,
      this.paysMonnaieDest,
      this.paysCodeMonnaieDest
    }
  );

  DemandeModel.fromJson(Map<String, dynamic> json) {
    idDemande = json['id_demande'];
    isPaid = json['is_paid'];
    idAnnulation = json['id_annulation'];

    if (json['mode_retrait'] != null) {
      modeRetrait = ModeRetrait.fromJson(json['mode_retrait']);
    }

    if (json['motif'] != null) {
      motif = MotifModel.fromJson(json['motif']);
    }

    lienPaiement = json['lien_paiement'];
    system = json['system'];
    progression = json['progression'];
    facture = json['facture'];
    probleme = json['probleme'];
    date = json['date'];
    datePaidBen = json['datePaidBen'];
    bankFieldRequired = json['bank_field_required'];
    montantNet = json['montant_net'];
    montanceSrce = json['montance_srce'];
    rabaisPromo = json['rabais_promo'];
    montantSansFrais = json['montant_sans_frais'];
    montanceDest = json['montance_dest'];
    codePaysSrce = json['code_pays_srce'];
    codePaysDest = json['code_pays_dest'];
    paysSrce = json['pays_srce'];
    fees = json['frais'];
    statutDemande = json['statut_demande'];
    paysDest = json['pays_dest'];
    if (json['beneficiaire'] != null) {
      beneficiaire = BeneficiaireModel.fromJson(json['beneficiaire']);
    }
    paysMonnaieSrce = json['pays_monnaie_srce'];
    paysCodeMonnaieSrce = json['pays_code_monnaie_srce'];
    paysMonnaieDest = json['pays_monnaie_dest'];
    paysCodeMonnaieDest = json['pays_code_monnaie_dest'];
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
    data['id_demande'] = this.idDemande;
    data['id_annulation'] = idAnnulation;
    data['montant_sans_frais'] = montantSansFrais;
    data['mode_retrait'] = this.modeRetrait;
    data['rabais_promo'] = this.rabaisPromo;
    data['lien_paiement'] = this.lienPaiement;
    data['progression'] = this.progression;
    data['probleme'] = probleme;
    data['facture'] = this.facture;
    data['date'] = this.date;
    data['frais'] = fees;
    data['is_paid'] = isPaid;
    data['datePaidBen'] = this.datePaidBen;
    data['montant_net'] = this.montantNet;
    data['montance_srce'] = this.montanceSrce;
    data['montance_dest'] = this.montanceDest;
    data['code_pays_srce'] = this.codePaysSrce;
    data['code_pays_dest'] = this.codePaysDest;
    data['pays_srce'] = this.paysSrce;
    data['pays_dest'] = this.paysDest;
    data['bank_field_required'] = this.bankFieldRequired;
    data['beneficiaire'] = this.beneficiaire;
    data['pays_monnaie_srce'] = this.paysMonnaieSrce;
    data['pays_code_monnaie_srce'] = this.paysCodeMonnaieSrce;
    data['pays_monnaie_dest'] = this.paysMonnaieDest;
    data['pays_code_monnaie_dest'] = this.paysCodeMonnaieDest;
    if (paymentInfos != null) {
      data['id_institution_financiere'] = paymentInfos!['id_institution_financiere']?['value'];
      data['banque'] = paymentInfos!['banque']?['value'];
      data['swift'] = paymentInfos!['swift']?['value'];
      data['statut_demande'] = statutDemande;
      data['iban'] = paymentInfos!['iban']?['value'];
      data['id_compte'] = paymentInfos!['id_compte']?['value'];
      data['id_transit'] = paymentInfos!['id_transit']?['value'];
    }
    return data;
  }
}
