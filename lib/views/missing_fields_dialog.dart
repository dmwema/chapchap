import 'package:flutter/material.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/l10n/app_localizations.dart';

class MissingFieldsDialog extends StatefulWidget {
  final BeneficiaireModel beneficiaire;
  final Map<String, dynamic> missingFields;
  final Function(BeneficiaireModel) onComplete;

  const MissingFieldsDialog({
    Key? key,
    required this.beneficiaire,
    required this.missingFields,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<MissingFieldsDialog> createState() => _MissingFieldsDialogState();
}

class _MissingFieldsDialogState extends State<MissingFieldsDialog> {
  final Map<String, TextEditingController> _controllers = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs pour chaque champ manquant
    widget.missingFields.forEach((key, value) {
      _controllers[key] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _updateBeneficiaire() {
    bool allFilled = true;
    _controllers.forEach((key, controller) {
      if (controller.text.isEmpty) {
        allFilled = false;
      }
    });

    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate("fill_all_required_fields")
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    BeneficiaireModel updatedBeneficiaire = widget.beneficiaire;

    _controllers.forEach((fieldKey, controller) {
      _updateBeneficiaireField(updatedBeneficiaire, fieldKey, controller.text);
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _loading = false;
      });
      widget.onComplete(updatedBeneficiaire);
      Navigator.pop(context);
    });
  }

  void _updateBeneficiaireField(
      BeneficiaireModel beneficiaire,
      String fieldKey,
      String value,
      ) {
    switch (fieldKey.toLowerCase()) {
      case 'nom':
      case 'nom_beneficiaire':
        beneficiaire.nomBeneficiaire = value;
        break;
      case 'prenom':
      case 'prenom_beneficiaire':
        beneficiaire.prenomBeneficiaire = value;
        break;
      case 'email':
      case 'email_beneficiaire':
        beneficiaire.emailBeneficiaire = value;
        break;
      case 'telephone':
      case 'tel':
      case 'tel_beneficiaire':
        beneficiaire.telBeneficiaire = value;
        break;
      case 'adresse':
      case 'adresse_beneficiaire':
        beneficiaire.adresseBeneficiaire = value;
        break;
      case 'ville':
      case 'ville_beneficiaire':
        beneficiaire.villeBeneficiaire = value;
        break;
      case 'banque':
        beneficiaire.banque = value;
        break;
      case 'swift':
        beneficiaire.swift = value;
        break;
      case 'iban':
        beneficiaire.iban = value;
        break;
      case 'numero_compte':
      case 'numero_compte_bancaire':
        beneficiaire.numeroCompteCancaire = value;
        break;
      case 'intitule_compte':
      case 'intitule_compte_bancaire':
        beneficiaire.intituleCompteBancaire = value;
        break;
      case 'id_institution_financiere':
        beneficiaire.idInstitutionFinanciere = value;
        break;
      case 'id_transit':
        beneficiaire.idTransit = value;
        break;
      case 'id_compte':
        beneficiaire.idCompte = value;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppTexts.titleText(
                        AppLocalizations.of(context).translate("complete_information")
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              AppTexts.descriptionText(
                  AppLocalizations.of(context).translate("missing_fields_message")
              ),
              SizedBox(height: 24),
              // Afficher les champs manquants
              ...widget.missingFields.entries.map((entry) {
                String fieldKey = entry.key;
                Map<String, dynamic> fieldConfig = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTexts.descriptionText(
                        fieldConfig['label'] ?? fieldKey,
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _controllers[fieldKey],
                        keyboardType: _getKeyboardType(fieldConfig['type']),
                        decoration: InputDecoration(
                          hintText: fieldConfig['placeholder'] ?? '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.formFieldBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.formFieldBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.formFieldBorderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: AppTexts.buttonText(
                          AppLocalizations.of(context).translate("cancel")
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: RoundedButton(
                      title: AppLocalizations.of(context).translate("save"),
                      onPress: _updateBeneficiaire,
                      loading: _loading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextInputType _getKeyboardType(String? type) {
    switch (type?.toLowerCase()) {
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
      case 'phone':
        return TextInputType.number;
      case 'tel':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
