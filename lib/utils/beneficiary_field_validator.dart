import 'dart:convert';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';

class BeneficiaryFieldValidator {
  /// Vérifie les champs manquants du bénéficiaire selon les exigences du mode de retrait
  /// Retourne un Map avec les champs manquants et leurs labels
  static Map<String, dynamic> getMissingFields({
    required BeneficiaireModel beneficiaire,
    required ModeRetrait modeRetrait,
  }) {
    Map<String, dynamic> missingFields = {};

    if (modeRetrait.withdrawalFieldRequired == null ||
        modeRetrait.withdrawalFieldRequired!.isEmpty) {
      return missingFields;
    }

    // Parser le JSON des champs requis
    Map<String, dynamic> requiredFields;
    try {
      requiredFields = json.decode(modeRetrait.withdrawalFieldRequired!);
    } catch (e) {
      print("Erreur lors du parsing de withdrawalFieldRequired: $e");
      return missingFields;
    }

    // Vérifier chaque champ requis
    requiredFields.forEach((fieldKey, fieldConfig) {
      bool isRequired = fieldConfig['required'] == true ||
          fieldConfig['required'] == 1 ||
          fieldConfig['required'] == "1";

      if (isRequired) {
        String? fieldValue = _getBeneficiaireFieldValue(beneficiaire, fieldKey);

        // Si le champ est vide ou null, l'ajouter aux champs manquants
        if (fieldValue == null || fieldValue.isEmpty) {
          missingFields[fieldKey] = {
            'label': fieldConfig['label'] ?? fieldKey,
            'type': fieldConfig['type'] ?? 'text',
            'required': true,
            'placeholder': fieldConfig['placeholder'] ?? '',
          };
        }
      }
    });

    return missingFields;
  }

  /// Récupère la valeur d'un champ du bénéficiaire par son nom
  static String? _getBeneficiaireFieldValue(
      BeneficiaireModel beneficiaire,
      String fieldKey
      ) {
    switch (fieldKey.toLowerCase()) {
      case 'nom':
      case 'nom_beneficiaire':
      case 'nombeneficiaire':
        return beneficiaire.nomBeneficiaire;

      case 'prenom':
      case 'prenom_beneficiaire':
      case 'prenombeneficiaire':
        return beneficiaire.prenomBeneficiaire;

      case 'email':
      case 'email_beneficiaire':
      case 'emailbeneficiaire':
        return beneficiaire.emailBeneficiaire;

      case 'telephone':
      case 'tel':
      case 'tel_beneficiaire':
      case 'telbeneficiaire':
        return beneficiaire.telBeneficiaire;

      case 'adresse':
      case 'adresse_beneficiaire':
      case 'adressebeneficiaire':
        return beneficiaire.adresseBeneficiaire;

      case 'ville':
      case 'ville_beneficiaire':
      case 'villebeneficiaire':
        return beneficiaire.villeBeneficiaire;

      case 'banque':
        return beneficiaire.banque;

      case 'swift':
      case 'code_swift':
        return beneficiaire.swift;

      case 'iban':
        return beneficiaire.iban;

      case 'numero_compte':
      case 'numero_compte_bancaire':
      case 'numerocomptecancaire':
        return beneficiaire.numeroCompteCancaire;

      case 'intitule_compte':
      case 'intitule_compte_bancaire':
      case 'intitulecomptebancaire':
        return beneficiaire.intituleCompteBancaire;

      case 'id_institution_financiere':
      case 'idinstitutionfinanciere':
        return beneficiaire.idInstitutionFinanciere;

      case 'id_transit':
      case 'idtransit':
        return beneficiaire.idTransit;

      case 'id_compte':
      case 'idcompte':
        return beneficiaire.idCompte;

      default:
        return null;
    }
  }

  /// Vérifie si tous les champs requis sont remplis
  static bool hasAllRequiredFields({
    required BeneficiaireModel beneficiaire,
    required ModeRetrait modeRetrait,
  }) {
    Map<String, dynamic> missingFields = getMissingFields(
      beneficiaire: beneficiaire,
      modeRetrait: modeRetrait,
    );
    return missingFields.isEmpty;
  }

  /// Retourne un message descriptif des champs manquants
  static String getMissingFieldsMessage(
      Map<String, dynamic> missingFields,
      String locale,
      ) {
    if (missingFields.isEmpty) return '';

    List<String> fieldLabels = missingFields.values
        .map((field) => field['label'].toString())
        .toList();

    if (locale == 'fr') {
      if (fieldLabels.length == 1) {
        return 'Le champ ${fieldLabels[0]} est requis';
      } else {
        return 'Les champs suivants sont requis: ${fieldLabels.join(", ")}';
      }
    } else {
      if (fieldLabels.length == 1) {
        return 'The field ${fieldLabels[0]} is required';
      } else {
        return 'The following fields are required: ${fieldLabels.join(", ")}';
      }
    }
  }
}
