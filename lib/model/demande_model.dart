class DemandeModel {
  int? idDemande;
  int? idModeRetrait;
  int? idAnnulation;
  String? modeRetrait;
  String? lienPaiement;
  String? progression;
  String? facture;
  String? date;
  String? probleme;
  String? datePaidBen;
  String? montantNet;
  String? montanceSrce;
  String? montanceDest;
  String? codePaysSrce;
  String? codePaysDest;
  String? paysSrce;
  bool? isPaid;
  String? paysDest;
  int? idBeneficiaire;
  String? beneficiaire;
  String? telBeneficiaire;
  String? paysMonnaieSrce;
  String? paysCodeMonnaieSrce;
  String? paysMonnaieDest;
  String? paysCodeMonnaieDest;

  DemandeModel(
    {
      this.idDemande,
      this.idAnnulation,
      this.idModeRetrait,
      this.isPaid,
      this.modeRetrait,
      this.lienPaiement,
      this.progression,
      this.probleme,
      this.facture,
      this.date,
      this.datePaidBen,
      this.montantNet,
      this.montanceSrce,
      this.montanceDest,
      this.codePaysSrce,
      this.codePaysDest,
      this.paysSrce,
      this.paysDest,
      this.idBeneficiaire,
      this.beneficiaire,
      this.telBeneficiaire,
      this.paysMonnaieSrce,
      this.paysCodeMonnaieSrce,
      this.paysMonnaieDest,
      this.paysCodeMonnaieDest
    }
  );

  DemandeModel.fromJson(Map<String, dynamic> json) {
    idDemande = json['id_demande'];
    idModeRetrait = json['id_mode_retrait'];
    isPaid = json['is_paid'];
    idAnnulation = json['id_annulation'];
    modeRetrait = json['mode_retrait'];
    lienPaiement = json['lien_paiement'];
    progression = json['progression'];
    facture = json['facture'];
    probleme = json['probleme'];
    date = json['date'];
    datePaidBen = json['datePaidBen'];
    montantNet = json['montant_net'];
    montanceSrce = json['montance_srce'];
    montanceDest = json['montance_dest'];
    codePaysSrce = json['code_pays_srce'];
    codePaysDest = json['code_pays_dest'];
    paysSrce = json['pays_srce'];
    paysDest = json['pays_dest'];
    idBeneficiaire = json['id_beneficiaire'];
    beneficiaire = json['beneficiaire'];
    telBeneficiaire = json['tel_beneficiaire'];
    paysMonnaieSrce = json['pays_monnaie_srce'];
    paysCodeMonnaieSrce = json['pays_code_monnaie_srce'];
    paysMonnaieDest = json['pays_monnaie_dest'];
    paysCodeMonnaieDest = json['pays_code_monnaie_dest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_demande'] = this.idDemande;
    data['id_mode_retrait'] = this.idModeRetrait;
    data['id_annulation'] = idAnnulation;
    data['mode_retrait'] = this.modeRetrait;
    data['lien_paiement'] = this.lienPaiement;
    data['progression'] = this.progression;
    data['probleme'] = probleme;
    data['facture'] = this.facture;
    data['date'] = this.date;
    data['is_paid'] = isPaid;
    data['datePaidBen'] = this.datePaidBen;
    data['montant_net'] = this.montantNet;
    data['montance_srce'] = this.montanceSrce;
    data['montance_dest'] = this.montanceDest;
    data['code_pays_srce'] = this.codePaysSrce;
    data['code_pays_dest'] = this.codePaysDest;
    data['pays_srce'] = this.paysSrce;
    data['pays_dest'] = this.paysDest;
    data['id_beneficiaire'] = this.idBeneficiaire;
    data['beneficiaire'] = this.beneficiaire;
    data['tel_beneficiaire'] = this.telBeneficiaire;
    data['pays_monnaie_srce'] = this.paysMonnaieSrce;
    data['pays_code_monnaie_srce'] = this.paysCodeMonnaieSrce;
    data['pays_monnaie_dest'] = this.paysMonnaieDest;
    data['pays_code_monnaie_dest'] = this.paysCodeMonnaieDest;
    return data;
  }
}
