import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/RelationModel.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/profession_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_info_plus/world_info_plus.dart';

class NewBeneficiaireForm extends StatefulWidget {
  List<Destination>? destinations;
  BuildContext parentCotext;
  Destination? initialDestination;
  BeneficiaireModel? beneficiaireModel;
  DemandesViewModel? demandesViewModel;
  List? bankFieldsRequired;
  bool? redirect;
  DemandeModel? demande;
  void Function()? updateSucess;
  bool? hideTitle;
  Map? fields;
  void Function(BeneficiaireModel)? onBeneficiaireCreated;

  NewBeneficiaireForm({super.key,
    this.demande,
    this.updateSucess,
    this.demandesViewModel,
    this.beneficiaireModel,
    this.bankFieldsRequired,
    this.fields,
    this.destinations,
    this.initialDestination,
    this.hideTitle,
    required BuildContext this.parentCotext,
    this.redirect,
    this.onBeneficiaireCreated,
  });

  @override
  State<NewBeneficiaireForm> createState() => _NewBeneficiaireFormState();
}

class _NewBeneficiaireFormState extends State<NewBeneficiaireForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  // final TextEditingController _telConfirmController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  DemandesViewModel demandesViewModel = DemandesViewModel();

  final TextEditingController _idInstitutionFinanciereController = TextEditingController();
  final TextEditingController _banqueController = TextEditingController();
  final TextEditingController _swiftController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _idCompteController = TextEditingController();
  final TextEditingController _idTransitController = TextEditingController();

  List<Country> allCountries = [];
  Country? _selectedCountry;

  bool isVerifyingEmail = false;
  bool isVerifyingPhone = false;
  String? emailErrorMessage;
  String? phoneErrorMessage;

  AuthViewModel authViewModel = AuthViewModel();

  List<String> countriesPropositionCodes = [];
  Map<String, TextEditingController> controllers = {};

  bool emailRequired = false;
  bool loadDest = false;
  bool loading = false;
  bool confirmNumber = false;
  bool canEditDestination = true;

  Destination? selectedDesinaion;
  RelationModel? selectedRelation;
  ProfessionModel? selectedProfession;

  List<RelationModel> relations = [];
  List<ProfessionModel> professions = [];

  late final List<Map<String, dynamic>> _paymentInfoFields = [
    {'key': 'id_institution_financiere', 'label': 'Numéro Institution Bancaire', 'controller': _idInstitutionFinanciereController, 'type': TextInputType.number},
    {'key': 'banque', 'label': 'Nom Banque', 'controller': _banqueController, 'type': null},
    {'key': 'swift', 'label': 'Code Swift', 'controller': _swiftController, 'type': null},
    {'key': 'iban', 'label': 'Numéro Iban', 'controller': _ibanController, 'type': null},
    {'key': 'id_compte', 'label': 'Numéro Compte', 'controller': _idCompteController, 'type': TextInputType.number},
    {'key': 'id_transit', 'label': 'Numéro Transit', 'controller': _idTransitController, 'type': TextInputType.number},
  ];

  Future<void> _verifyEmail(String email) async {
    if (email.isEmpty) {
      setState(() {
        emailErrorMessage = null;
      });
      return;
    }

    setState(() {
      isVerifyingEmail = true;
      emailErrorMessage = null;
    });

    try {
      await authViewModel.verifyEmailExists({
        "username": email,
        "type": "beneficiaire"
      }, context);
      setState(() {
        emailErrorMessage = authViewModel.emailMessage;
      });
    } catch (e) {
      setState(() {
        emailErrorMessage = null;
      });
    } finally {
      setState(() {
        isVerifyingEmail = false;
      });
    }
  }

  Future<void> _verifyPhone(String phone) async {
    if (phone.isEmpty || selectedDesinaion == null) {
      setState(() {
        phoneErrorMessage = null;
      });
      return;
    }

    String fullPhoneNumber = selectedDesinaion!.paysIndictelDest.toString() + phone;

    setState(() {
      isVerifyingPhone = true;
      phoneErrorMessage = null;
    });

    try {
      await authViewModel.verifyPhoneExists({
        "telephone": fullPhoneNumber,
        "pays_adresse": selectedDesinaion!.codePaysDest.toString(),
        "type": "beneficiaire"
      }, context);
      setState(() {
        phoneErrorMessage = authViewModel.phoneMessage;
      });
    } catch (e) {
      setState(() {
        phoneErrorMessage = null;
      });
    } finally {
      setState(() {
        isVerifyingPhone = false;
      });
    }
  }

  @override
  void initState() {
    allCountries = WorldInfoPlus.countries;
    if (widget.fields != null) {
      widget.fields!.forEach((key, name) {
        controllers[key] = TextEditingController();
      });
    }
    demandesViewModel.relations(context).then((value) {
      setState(() {
        relations = value;
      });
    });
    // demandesViewModel.professions(context).then((value) {
    //   setState(() {
    //     professions = value;
    //   });
    // });
    if (widget.initialDestination != null) {
      setState(() {
        canEditDestination = false;
        selectedDesinaion = widget.initialDestination;
        if (selectedDesinaion!.codePaysDest == "ca") {
          emailRequired = true;
        } else {
          emailRequired = false;
        }
      });
    }

    for (Destination destination in widget.destinations ?? []) {
      setState(() {
        countriesPropositionCodes.add(destination.codePaysDest.toString());
      });
    }
    UserViewModel().getUser().then((value) {
      setState(() {
        countriesPropositionCodes.add(value.codePays.toString());
      });
    });
    super.initState();
  }

  Widget _buildPaymentInfo(BeneficiaireModel? beneficiaire, DemandeModel? demande, List bankFieldsRequired) {
    if (beneficiaire == null && demande == null && (selectedDesinaion == null || selectedDesinaion!.bankFieldRequired == null)) {
      return Container();
    }

    String? countryBanqInfos;

    if (demande != null) {
      countryBanqInfos = demande.bankFieldRequired;
    } else if (beneficiaire != null) {
      countryBanqInfos = beneficiaire.bankFieldRequired;
    } else {
      countryBanqInfos = selectedDesinaion!.bankFieldRequired;
    }

    if (countryBanqInfos == null || countryBanqInfos == '') {
      return Container();
    }

    List<String> countryFieldsArray = [];

    if (demande != null) {
      countryFieldsArray = demande.bankFieldRequired!.split(',');
    } else if (beneficiaire != null) {
      countryFieldsArray = beneficiaire.bankFieldRequired!.split(',');
    } else {
      countryFieldsArray = selectedDesinaion!.bankFieldRequired!.split(',');
    }

    List<Widget> paymentInfoWidgets = [];
    for (var value in _paymentInfoFields) {
      if (countryFieldsArray.contains(value['key'])) {
        paymentInfoWidgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10,),
                CustomFormField(
                  label: value['label'] + (bankFieldsRequired.contains(value['key']) ? ' *' : ''),
                  hint: value['label'] + (bankFieldsRequired.contains(value['key']) ? ' *' : ''),
                  controller: value['controller'],
                  type: value['type'],
                  required: false,
                ),
              ],
            )
        );
      }
    }

    if (paymentInfoWidgets.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...paymentInfoWidgets,
        const SizedBox(height: 20,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isVerifying = isVerifyingEmail || isVerifyingPhone || authViewModel.loading;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 20
        ),
        child: widget.fields == null ? Column(
          children: [
            if (widget.hideTitle != true)
              AppTexts.titleText(AppLocalizations.of(context)!.translate('add_beneficiary')),
            if (widget.hideTitle != true)
              const SizedBox(height: 20,),
            CustomFormField(
              label: AppLocalizations.of(context)!.translate('name'),
              hint: AppLocalizations.of(context)!.translate('enter_beneficiary_name'),
              controller: _nomController,
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: AppLocalizations.of(context)!.translate('firstName'),
              hint: AppLocalizations.of(context)!.translate('enter_beneficiary_firstname'),
              controller: _prenomController,
            ),
            const SizedBox(height: 10,),
            Column(
              children: [
                Row(
                  children: [
                    AppTexts.smallText(AppLocalizations.of(context)!.translate('country_of_residence')),
                    const SizedBox(width: 5,),
                    AppTexts.bodyText("*", bold: true, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 5,),
                InkWell(
                  onTap: canEditDestination != true ? null : () {
                    Utils.removeFocus(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.bgColor,
                      isScrollControlled: true,
                      builder: (context) {
                        TextEditingController searchController = TextEditingController();
                        List<Destination> filteredPays = List.from(widget.destinations ?? []);

                        return StatefulBuilder(
                          builder: (context, setStateModal) {
                            void filterPays(String query) {
                              setStateModal(() {
                                filteredPays = widget.destinations == null ? [] :
                                widget.destinations!
                                    .where((r) => r.paysDest.toString()
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                    .toList();
                              });
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppTexts.titleText(AppLocalizations.of(context).translate('select_beneficiary_country')),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: searchController,
                                      onChanged: filterPays,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context).translate('search'),
                                        prefixIcon: const Icon(Icons.search),
                                        filled: true,
                                        fillColor: AppColors.formFieldColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide:
                                          BorderSide(color: AppColors.formFieldBorderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Flexible(
                                      child: filteredPays.isEmpty
                                          ? Center(
                                        child: AppTexts.bodyText(
                                          AppLocalizations.of(context).translate('emptyList'),
                                          color: AppColors.textGrey,
                                        ),
                                      )
                                          : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: filteredPays.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedDesinaion =
                                                filteredPays[index];
                                                if (selectedDesinaion!.codePaysDest == "ca") {
                                                  emailRequired = true;
                                                } else {
                                                  emailRequired = false;
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    width: 1,
                                                    color: AppColors.lightGrey,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(40),
                                                      border: Border.all(
                                                        width: 5,
                                                        color: selectedDesinaion !=
                                                            null &&
                                                            selectedDesinaion!
                                                                .codePaysDest ==
                                                                filteredPays[
                                                                index].codePaysDest
                                                            ? AppColors.primaryColor
                                                            : AppColors
                                                            .formFieldBorderColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "packages/country_icons/icons/flags/png/${filteredPays[index].codePaysDest.toString().toLowerCase()}.png",
                                                        width: 20,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return const Icon(Icons.flag_outlined, size: 20, color: Colors.grey);
                                                        },
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      AppTexts.bodyText(
                                                        filteredPays[index]
                                                            .paysDest.toString(),
                                                        color: AppColors.textGrey,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: AppColors.formFieldColor,
                      border: Border.all(
                          color: AppColors.formFieldBorderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedDesinaion == null
                            ? AppTexts.cardTitle(AppLocalizations.of(context).translate('beneficiary_country'), bold: false)
                            : Row(
                          children: [
                            Image.asset(
                              "packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest.toString().toLowerCase()}.png", width: 20,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.flag_outlined, size: 20, color: Colors.grey);
                              },
                            ),
                            const SizedBox(width: 10,),
                            AppTexts.bodyText(selectedDesinaion!.paysDest.toString()),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: AppLocalizations.of(context)!.translate('beneficiary_phone'),
              hint: AppLocalizations.of(context)!.translate('enter_beneficiary_phone'),
              controller: _telController,
              onChanged: (value) {
                if (selectedDesinaion == null) {
                  Utils.flushBarErrorMessage(
                    "Veuillez sélectionner votre pays de résidence",
                    context,
                  );
                  return;
                }
                _verifyPhone(value);
              },
              type: TextInputType.phone,
              suffixIcon: isVerifyingPhone
                  ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CupertinoActivityIndicator(),
                ),
              )
                  : (_telController.text.isNotEmpty &&
                  _telController.text.length > 2 &&
                  !isVerifyingPhone
                  ? (authViewModel.phoneExists
                  ? const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  CupertinoIcons.exclamationmark_octagon,
                  color: Colors.red,
                  weight: 10,
                ),
              )
                  : const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  CupertinoIcons.check_mark_circled,
                  color: Colors.green,
                  weight: 10,
                ),
              ))
                  : null),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: selectedDesinaion == null ? 0 : 20,
                ),
                child: Text(
                  selectedDesinaion == null ? "" : selectedDesinaion!.paysIndictelDest.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            if (phoneErrorMessage != null && phoneErrorMessage!.isNotEmpty) ...[
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  phoneErrorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 10),
            CustomFormField(
              label: AppLocalizations.of(context).translate('beneficiary_email'),
              hint: AppLocalizations.of(context).translate('beneficiary_email'),
              controller: _emailController,
              onChanged: (value) {
                _verifyEmail(value);
              },
              type: TextInputType.emailAddress,
              suffixIcon: isVerifyingEmail
                  ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CupertinoActivityIndicator(),
                ),
              )
                  : (_emailController.text.isNotEmpty && !isVerifyingEmail
                  ? (authViewModel.emailExists
                  ? const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  CupertinoIcons.exclamationmark_octagon,
                  color: Colors.red,
                  weight: 10,
                ),
              )
                  : const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  CupertinoIcons.check_mark_circled,
                  color: Colors.green,
                  weight: 10,
                ),
              ))
                  : null),
              required: emailRequired,
            ),
            if (emailErrorMessage != null && emailErrorMessage!.isNotEmpty) ...[
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  emailErrorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 10),
            CustomFormField(
              label: AppLocalizations.of(context)!.translate('beneficiary_city'),
              hint: AppLocalizations.of(context)!.translate('enter_beneficiary_city'),
              controller: _cityController,
            ),
            const SizedBox(height: 10,),
            CustomFormField(
              label: AppLocalizations.of(context)!.translate('beneficiary_address'),
              hint: AppLocalizations.of(context)!.translate('enter_beneficiary_address'),
              controller: _adresseController,
            ),
            const SizedBox(height: 10,),
            Column(
              children: [
                Row(
                  children: [
                    AppTexts.smallText(AppLocalizations.of(context)!.translate('relation')),
                    const SizedBox(width: 5,),
                    AppTexts.bodyText("*", bold: true, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 5,),
                InkWell(
                  onTap: () {
                    Utils.removeFocus(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.bgColor,
                      isScrollControlled: true,
                      builder: (context) {
                        TextEditingController searchController = TextEditingController();
                        List<RelationModel> filteredRelations = List.from(relations);

                        return SafeArea(
                          child: StatefulBuilder(
                            builder: (context, setStateModal) {
                              void filterRelations(String query) {
                                setStateModal(() {
                                  filteredRelations = relations
                                      .where((r) => r.relation!
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                                      .toList();
                                });
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                                ),
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppTexts.titleText(AppLocalizations.of(context)!.translate('beneficiary_relation')),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: searchController,
                                        onChanged: filterRelations,
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)!.translate('search'),
                                          prefixIcon: const Icon(Icons.search),
                                          filled: true,
                                          fillColor: AppColors.formFieldColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide:
                                            BorderSide(color: AppColors.formFieldBorderColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Flexible(
                                        child: filteredRelations.isEmpty
                                            ? Center(
                                          child: AppTexts.bodyText(
                                            "Aucun résultat trouvé",
                                            color: AppColors.textGrey,
                                          ),
                                        )
                                            : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: filteredRelations.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedRelation =
                                                  filteredRelations[index];
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 1,
                                                      color: AppColors.lightGrey,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(40),
                                                        border: Border.all(
                                                          width: 5,
                                                          color: selectedRelation != null &&
                                                              selectedRelation!
                                                                  .idRelation ==
                                                                  filteredRelations[
                                                                  index]
                                                                      .idRelation
                                                              ? AppColors.primaryColor
                                                              : AppColors
                                                              .formFieldBorderColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    AppTexts.bodyText(
                                                      filteredRelations[index].relation!,
                                                      color: AppColors.textGrey,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: AppColors.formFieldColor,
                      border: Border.all(
                          color: AppColors.formFieldBorderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedRelation == null
                            ? AppTexts.cardTitle(AppLocalizations.of(context)!.translate('beneficiary_relation'), bold: false)
                            : Row(
                          children: [
                            AppTexts.bodyText(selectedRelation!.relation!),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentInfo(widget.beneficiaireModel, widget.demande, widget.bankFieldsRequired ?? [])
              ],
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                setState(() {
                  confirmNumber = !confirmNumber;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: AppColors.primaryColor,
                    checkColor: Colors.white,
                    value: confirmNumber,
                    onChanged: (bool? value) {
                      setState(() {
                        confirmNumber = !confirmNumber;
                      });
                    },
                  ),
                  Flexible(
                    child: AppTexts.smallText(AppLocalizations.of(context)!.translate('confirm_phone_text')),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            RoundedButton(
              loading: loading || isVerifying,
              title: AppLocalizations.of(context).translate('save'),
              onPress: () {
                if (!loading) {
                  if (!demandesViewModel.loading) {
                    if (selectedDesinaion == null) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('select_country'), context);
                    } else if (_nomController.text.isEmpty) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('beneficiary_name_required'), context);
                    } else if (selectedRelation == null) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('select_beneficiary_relation'), context);
                    }
                    // else if (_selectedCountry == null) {
                    //   Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('enterCountryNationnality'), context);
                    // }
                    else if (_prenomController.text.isEmpty) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('beneficiary_firstname_required'), context);
                    }  else if (_telController.text.isEmpty) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('phone_required'), context);
                    } else if (_adresseController.text.isEmpty) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('address_required'), context);
                    } else if (selectedDesinaion!.codePaysDest == "ca" && _emailController.text.isEmpty) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('email_required'), context);
                    } else if (_cityController.text == '') {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('enter_beneficiary_city'), context);
                    } else if (!confirmNumber) {
                      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('confirm_phone_checkbox'), context);
                    } else  {
                      bool hasErrors = false;

                      if (widget.bankFieldsRequired != null && widget.bankFieldsRequired!.isNotEmpty) {
                        for (String field in widget.bankFieldsRequired!) {
                          for (Map pField in _paymentInfoFields) {
                            if (pField['key'] == field && pField['controller']!.text == '') {
                              Utils.flushBarErrorMessage("enter_$field", context);
                              Utils.flushBarErrorMessage(AppLocalizations.of(context).translate("enter_$field"), context);
                              hasErrors = true;
                              break;
                            }
                          }
                        }
                      }

                      if (!hasErrors) {
                        setState(() {
                          loading = true;
                        });
                        Map data = {
                          "id_pays": selectedDesinaion!.idPaysDest.toString(),
                          "pays_adresse": selectedDesinaion!.codePaysDest.toString(),
                          "emailBeneficiaire": _emailController.text,
                          "nomBeneficiaire": _nomController.text,
                          "prenomBeneficiaire": _prenomController.text,
                          "villeBeneficiaire": _cityController.text,
                          "telBeneficiaire": selectedDesinaion!.paysIndictelDest.toString() + _telController.text,
                          "adresseBeneficiaire": _adresseController.text,
                          "id_relation": selectedRelation!.idRelation,
                          "pays_nationalite": _selectedCountry?.alpha2,
                          "banque":"",
                          "swift":"",
                          "iban":"",
                          "id_institution_financiere":"",
                          "id_transit":"",
                          "id_compte":""
                        };
                        demandesViewModel.newBeneficiaire(data, widget.parentCotext, redirect: canEditDestination).then((value) async {
                          if (value != null){
                            if (value['error'] != true) {
                              Utils.toastMessage(AppLocalizations.of(context)!.translate('beneficiary_registered'));
                              BeneficiaireModel newBeneficiaire = BeneficiaireModel.fromJson(value['data']);
                              if (widget.onBeneficiaireCreated != null) {
                                widget.onBeneficiaireCreated!(newBeneficiaire);
                              }
                              if (widget.redirect != true || !canEditDestination) {
                                DemandesViewModel demandesViewModels = DemandesViewModel();
                                await demandesViewModels.beneficiaires([], context);
                                Navigator.pop(widget.parentCotext);
                              } else {
                                Navigator.pushReplacementNamed(context, RoutesName.recipeints);
                              }
                            } else {
                              Utils.flushBarErrorMessage(value['message'], context);
                            }
                          } else {
                            Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('generic_error'), context);
                          }
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    }
                  }
                }
              },
            )
          ],
        ) : Column(
          children: [
            ...widget.fields!.entries.map((entry) {
              final String key = entry.key;
              final String label = entry.value;
              final type = (key == "id_transit" || key == "id_compte" || key == "id_institution_financiere") ? TextInputType.number : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    label: "${AppLocalizations.of(context).translate(key.toLowerCase())} *",
                    hint: "${AppLocalizations.of(context).translate('enter_${key.toLowerCase()}')} *",
                    controller: controllers[key],
                    type: type,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
            const SizedBox(height: 10),
            RoundedButton(
              loading: loading,
              title: AppLocalizations.of(context)!.translate('save'),
              onPress: () async {
                if (!loading) {
                  if (!demandesViewModel.loading) {
                    bool hasErrors = false;
                    for (var e in widget.fields!.entries) {
                      var f = e.key;
                      if (controllers[f]!.text == "") {
                        hasErrors = true;
                        Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('enter_' + f.toLowerCase()), context);
                        break;
                      }
                    }

                    if (!hasErrors) {
                      setState(() {
                        loading = true;
                      });
                      Map data = {
                        "idBeneficiaire": widget.beneficiaireModel!.idBeneficiaire
                      };

                      for (var c in controllers.entries) {
                        var k = c.key;
                        var v = c.value;
                        data[k] = v.text;
                      }

                      await demandesViewModel.updateBeneficiaire(data, widget.parentCotext).then((value) async {
                        if (value == true) {
                          if (widget.onBeneficiaireCreated != null) {
                            widget.onBeneficiaireCreated!(widget.beneficiaireModel!);
                          }
                          if (widget.redirect != true || !canEditDestination) {
                            Future.delayed(const Duration(milliseconds: 500), () async {
                              if (widget.demandesViewModel != null) {
                                await widget.demandesViewModel!.beneficiaires([], context);
                              }
                              widget.updateSucess!();
                              Navigator.pop(widget.parentCotext);
                            });
                          }
                        }
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  }
                }
              },
            )
          ],
        )
      )
    );
  }
}
