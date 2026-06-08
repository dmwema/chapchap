import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/profession_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:world_info_plus/world_info_plus.dart';

class EditProfileView extends StatefulWidget {
  final UserModel? user;

  const EditProfileView({super.key, this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  ProfessionModel? selectedProfession;
  List<ProfessionModel> professions = [];
  List<Country> allCountries = [];
  Country? _selectedCountry;
  List<String> propCountries = [];

  late TextEditingController nom;
  late TextEditingController prenom;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController adresse;
  late TextEditingController ville;

  DemandesViewModel demandesViewModel = DemandesViewModel();
  AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    allCountries = WorldInfoPlus.countries;
    super.initState();
    demandesViewModel.professions(context).then((value) {
      setState(() {
        professions = value;
      });
    });

    if (widget.user!.profession != null) {
      setState(() {
        selectedProfession = widget.user!.profession;
      });
    }

    if (widget.user!.paysNationalite != null) {
      setState(() {
        _selectedCountry = allCountries.firstWhere((element) => element.alpha2.toLowerCase() == widget.user!.paysNationalite);
      });
    }

    setState(() {
      nom = TextEditingController(text: widget.user?.nomClient ?? "");
      prenom = TextEditingController(text: widget.user?.prenomClient ?? "");
      email = TextEditingController(text: widget.user?.emailClient ?? "");
      phone = TextEditingController(text: widget.user?.telClient ?? "");
      adresse = TextEditingController(text: widget.user?.adresse ?? "");
      ville = TextEditingController(text: widget.user?.villeClient ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: AppTexts.titleText(AppLocalizations.of(context)!.translate('edit_profile')),
                    ),
                    const SizedBox(height: 20,),
                    CustomFormField(label: t.translate('name'), controller: nom, hint: '', disabled: true,),
                    const SizedBox(height: 10,),
                    CustomFormField(label: t.translate('firstName'), controller: prenom, hint: '', disabled: true,),
                    const SizedBox(height: 10,),
                    CustomFormField(label: t.translate('emailLabel'), controller: email, hint: '', disabled: true,),
                    const SizedBox(height: 10,),
                    CustomFormField(label: t.translate('phone'), controller: phone, hint: '',),
                    const SizedBox(height: 10,),
                    CustomFormField(label: t.translate('city'), controller: ville, hint: '',),
                    const SizedBox(height: 10,),
                    CustomFormField(label: t.translate('addressLabel'), controller: adresse, hint: '',),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context).translate('job')),
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
                            List<ProfessionModel> filteredProfessions = List.from(professions);

                            return StatefulBuilder(
                              builder: (context, setStateModal) {
                                void filterProfessions(String query) {
                                  setStateModal(() {
                                    filteredProfessions = professions
                                        .where((r) => r.profession!
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
                                        AppTexts.titleText(AppLocalizations.of(context).translate('select_job')),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: searchController,
                                          onChanged: filterProfessions,
                                          decoration: InputDecoration(
                                            hintText: t.translate('search'),
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
                                          child: filteredProfessions.isEmpty
                                              ? Center(
                                            child: AppTexts.bodyText(
                                              "Aucun résultat trouvé",
                                              color: AppColors.textGrey,
                                            ),
                                          )
                                              : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: filteredProfessions.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedProfession =
                                                    filteredProfessions[index];
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
                                                            color: selectedProfession !=
                                                                null &&
                                                                selectedProfession!
                                                                    .idProfession ==
                                                                    filteredProfessions[
                                                                    index]
                                                                        .idProfession
                                                                ? AppColors.primaryColor
                                                                : AppColors
                                                                .formFieldBorderColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      AppTexts.bodyText(
                                                        filteredProfessions[index]
                                                            .profession!,
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
                            selectedProfession == null
                                ? AppTexts.cardTitle(AppLocalizations.of(context).translate('job'), bold: false)
                                : Row(
                              children: [
                                AppTexts.bodyText(selectedProfession!.profession!),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down_sharp),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Row(
                      children: [
                        AppTexts.smallText(AppLocalizations.of(context).translate('nationnality')),
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
                            List<Country> filteredCountries = List.from(allCountries);

                            return StatefulBuilder(
                              builder: (context, setStateModal) {
                                void filterCountries(String query) {
                                  setStateModal(() {
                                    filteredCountries = allCountries
                                        .where((r) => r.name
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
                                        AppTexts.titleText(AppLocalizations.of(context).translate('nationnality')),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: searchController,
                                          onChanged: filterCountries,
                                          decoration: InputDecoration(
                                            hintText: t.translate('search'),
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
                                          child: filteredCountries.isEmpty
                                              ? Center(
                                            child: AppTexts.bodyText(
                                              t.translate('emptyList'),
                                              color: AppColors.textGrey,
                                            ),
                                          )
                                              : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: filteredCountries.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedCountry =
                                                    filteredCountries[index];
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
                                                            color: _selectedCountry !=
                                                                null &&
                                                                _selectedCountry!
                                                                    .alpha2 ==
                                                                    filteredCountries[index].alpha2
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
                                                            "packages/country_icons/icons/flags/png/${filteredCountries[index].alpha2.toLowerCase()}.png",
                                                            width: 20,
                                                            errorBuilder: (context, error, stackTrace) {
                                                              return const Icon(Icons.flag_outlined, size: 20, color: Colors.grey);
                                                            },
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          AppTexts.bodyText(
                                                            filteredCountries[index]
                                                                .name,
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
                            _selectedCountry == null
                                ? AppTexts.cardTitle(AppLocalizations.of(context).translate('nationnality'), bold: false)
                                : Row(
                              children: [
                                Image.asset(
                                  "packages/country_icons/icons/flags/png/${_selectedCountry!.alpha2.toLowerCase()}.png", width: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.flag_outlined, size: 20, color: Colors.grey);
                                  },
                                ),
                                const SizedBox(width: 10,),
                                AppTexts.bodyText(_selectedCountry!.name),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down_sharp),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    RoundedButton(
                      title: t.translate('save'),
                      loading: authViewModel.loading,
                      onPress: () {
                        if (nom.text.isEmpty || prenom.text.isEmpty || phone.text.isEmpty || adresse.text.isEmpty || selectedProfession == null || _selectedCountry == null) {
                          Utils.flushBarErrorMessage(t.translate('fillAllFields'), context);
                        } else {
                          final data = {
                            "nomClient": nom.text,
                            "prenomClient": prenom.text,
                            // "emailClient": email.text,
                            "telClient": phone.text,
                            "adresse": adresse.text,
                            "villeClient": ville.text,
                            "id_profession": selectedProfession?.idProfession,
                            "pays_nationalite": _selectedCountry?.alpha2.toLowerCase()
                          };
                          authViewModel.updateProfile(data, context);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
