import 'dart:io';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/profession_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:world_info_plus/world_info_plus.dart';

class PasswordValidation {
  late String password;
  late bool minLength;
  late bool hasUpperCase;
  late bool hasDigit;
  late bool hasSpecialChar;

  void validate(String pwd) {
    password = pwd;
    minLength = pwd.length >= 8;
    hasUpperCase = pwd.contains(RegExp(r'[A-Z]'));
    hasDigit = pwd.contains(RegExp(r'[0-9]'));
    hasSpecialChar = pwd.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool get isValid => minLength && hasUpperCase && hasDigit && hasSpecialChar;
}

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  late PageController scrollController;
  int currentPage = 0;
  int maxRegistrationSteps = 5;
  ProfessionModel? selectedProfession;

  late PasswordValidation passwordValidation;

  List<Country> allCountries = [];
  Country? _selectedCountry;
  PaysModel? selectedPays;

  List<String> stepTitles = [
    "personal_information",
    "account_info",
    "address_and_job",
    "promotions_and_policies",
    "review_and_finish"
  ];
  List<ProfessionModel> professions = [];
  List<PaysModel> paysList = [];
  List<String> propCountries = [];
  Map<String, dynamic> data = {};

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> obscurePasswordConfirm = ValueNotifier<bool>(true);
  bool isVerifyingEmail = false;
  bool isVerifyingPhone = false;
  String? emailErrorMessage;
  String? phoneErrorMessage;
  bool loadingPdf1 = false;
  bool loadingPdf2 = false;
  String local = "Fr";
  bool confirmPolicy = false;
  bool confirmNewsletter = false;

  late DemandesViewModel demandesViewModel;
  late AuthViewModel authViewModel;

  @override
  void initState() {
    allCountries = WorldInfoPlus.countries;
    super.initState();
    scrollController = PageController();
    demandesViewModel = DemandesViewModel();
    authViewModel = AuthViewModel();
    passwordValidation = PasswordValidation();

    UserViewModel().getUserLanguage().then((value) {
      if (value != "") {
        setState(() {
          local = value;
        });
      }
    });

    demandesViewModel.professions(context).then((value) {
      setState(() {
        professions = value;
      });
    });

    demandesViewModel.paysActifs([], context).then((value) {
      authViewModel.getLocalization(context).then((value2) {
        if (value2 != null) {
          for (var p in demandesViewModel.paysActifList.data!) {
            PaysModel pM = PaysModel.fromJson(p);
            if (pM.codePays.toString().toLowerCase() == value2['pays'].toString().toLowerCase()) {
              selectedPays = pM;
              setState(() {
                _cityController.text = value2['ville'];
              });
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _codeController.dispose();
    super.dispose();
  }

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
      await authViewModel.verifyEmailExists({"username": email, "type": "client"}, context);
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
    if (phone.isEmpty || selectedPays == null) {
      setState(() {
        phoneErrorMessage = null;
      });
      return;
    }

    String fullPhoneNumber = selectedPays!.paysIndictel.toString() + phone;

    setState(() {
      isVerifyingPhone = true;
      phoneErrorMessage = null;
    });

    try {
      await authViewModel.verifyPhoneExists({
        "telephone": fullPhoneNumber,
        "pays_adresse": selectedPays!.codePays.toString(),
        "type": "client"
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
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    bool isVerifying = isVerifyingEmail || isVerifyingPhone || authViewModel.loading;

    return HideKeyBordContainer(
      child: Scaffold(
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
          backClick: () {
            if (currentPage == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                currentPage--;
              });

              scrollController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, t),
              Expanded(
                child: PageView(
                  controller: scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(context, t),
                    _buildStep2(context, t),
                    _buildStep3(context, t),
                    _buildStep4(context, t),
                    _buildStep5(context, t),
                  ],
                ),
              ),
              _buildBottomButton(context, t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.smallText(t.translate("registration"), color: AppColors.primaryColor),
          AppTexts.titleText(t.translate(stepTitles[currentPage])),
          const SizedBox(height: 10),
          _buildStepIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final containerWidth = MediaQuery.of(context).size.width - 40 - 40 - (20 * 4);

    return Row(
      children: List.generate(5, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: index == currentPage ? containerWidth : 20,
          height: 5,
          decoration: BoxDecoration(
            color: index == currentPage
                ? AppColors.primaryColor
                : (index < currentPage
                ? AppColors.primaryColor.withOpacity(.5)
                : AppColors.formFieldBorderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          margin: EdgeInsets.only(right: index < 4 ? 10 : 0),
        );
      }),
    );
  }

  Widget _buildStep1(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomFormField(
              label: t.name,
              controller: _nomController,
              hint: t.nameHint,
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            CustomFormField(
              label: t.firstName,
              controller: _prenomController,
              hint: t.firstNameHint,
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
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
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomFormField(
              label: t.translate("emailLabel"),
              controller: _emailController,
              maxLines: 1,
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
              hint: t.translate("emailHint"),
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
            Builder(
              builder: (context) {
                switch (demandesViewModel.paysActifList.status) {
                  case Status.LOADING:
                    return const Center(
                      child: CupertinoActivityIndicator(color: Colors.black),
                    );
                  case Status.ERROR:
                    return Text(demandesViewModel.paysActifList.message.toString());
                  default:
                    paysList = List<PaysModel>.from(
                      demandesViewModel.paysActifList.data?.map((el) => PaysModel.fromJson(el)) ?? [],
                    );
                    for (var paysModel in paysList) {
                      propCountries.add(paysModel.codePays.toString());
                    }
                    selectedPays ??= paysList.isNotEmpty ? paysList[0] : null;

                    return Column(
                      children: [
                        Row(
                          children: [
                            AppTexts.smallText(AppLocalizations.of(context).translate('country_of_residence')),
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
                                List<PaysModel> filteredPays = List.from(paysList);

                                return StatefulBuilder(
                                  builder: (context, setStateModal) {
                                    void filterPays(String query) {
                                      setStateModal(() {
                                        filteredPays = paysList
                                            .where((r) => r.paysNom.toString()
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
                                            AppTexts.titleText(AppLocalizations.of(context).translate('selectCountry')),
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
                                                        selectedPays =
                                                        filteredPays[index];
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
                                                                color: selectedPays !=
                                                                    null &&
                                                                    selectedPays!
                                                                        .codePays ==
                                                                        filteredPays[
                                                                        index].codePays
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
                                                                "packages/country_icons/icons/flags/png/${filteredPays[index].codePays.toString().toLowerCase()}.png",
                                                                width: 20,
                                                                errorBuilder: (context, error, stackTrace) {
                                                                  return const Icon(Icons.flag_outlined, size: 20, color: Colors.grey);
                                                                },
                                                              ),
                                                              const SizedBox(width: 10,),
                                                              AppTexts.bodyText(
                                                                filteredPays[index]
                                                                    .paysNom.toString(),
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
                                selectedPays == null
                                    ? AppTexts.cardTitle("${AppLocalizations.of(context).translate('selectCountry')} *", bold: false)
                                    : Row(
                                  children: [
                                    Image.asset(
                                      "packages/country_icons/icons/flags/png/${selectedPays!.codePays.toString().toLowerCase()}.png", width: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.flag_outlined, size: 20, color: Colors.grey);
                                      },
                                    ),
                                    const SizedBox(width: 10,),
                                    AppTexts.bodyText(selectedPays!.paysNom.toString()),
                                  ],
                                ),
                                const Icon(Icons.arrow_drop_down_sharp),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomFormField(
                          label: t.translate("phoneNumberLabel"),
                          hint: t.translate("phoneNumberHint"),
                          controller: _phoneController,
                          type: TextInputType.phone,
                          onChanged: (value) {
                            if (selectedPays == null) {
                              Utils.flushBarErrorMessage(
                                "Veuillez sélectionner votre pays de résidence",
                                context,
                              );
                              return;
                            }
                            _verifyPhone(value);
                          },
                          suffixIcon: isVerifyingPhone
                              ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                              : (_phoneController.text.isNotEmpty &&
                              _phoneController.text.length > 2 &&
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
                              left: selectedPays == null ? 0 : 20,
                            ),
                            child: Text(
                              selectedPays == null ? "" : selectedPays!.paysIndictel.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    );
                }
              },
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
              label: t.translate("passwordLabel"),
              hint: t.translate("passwordHint"),
              controller: _passwordController,
              maxLines: 1,
              obscurePassword: obscurePassword.value,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscurePassword.value = !obscurePassword.value;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: obscurePassword.value
                      ? const Icon(Icons.visibility_off, size: 20)
                      : const Icon(Icons.visibility, size: 20),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildPasswordRulesDisplay(t),
            ],
            const SizedBox(height: 10),
            CustomFormField(
              label: t.translate("confirmPasswordLabel"),
              controller: _confirmPasswordController,
              hint: t.translate("confirmPasswordHint"),
              maxLines: 1,
              obscurePassword: obscurePasswordConfirm.value,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscurePasswordConfirm.value = !obscurePasswordConfirm.value;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: obscurePasswordConfirm.value
                      ? const Icon(Icons.visibility_off, size: 20)
                      : const Icon(Icons.visibility, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRulesDisplay(AppLocalizations t) {
    passwordValidation.validate(_passwordController.text);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.formFieldBorderColor),
        borderRadius: BorderRadius.circular(5),
        color: AppColors.formFieldColor.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTexts.smallText("Règles du mot de passe:", color: AppColors.primaryColor),
          const SizedBox(height: 8),
          _buildRuleItem("Au moins 8 caractères", passwordValidation.minLength),
          const SizedBox(height: 6),
          _buildRuleItem("Au moins une majuscule (A-Z)", passwordValidation.hasUpperCase),
          const SizedBox(height: 6),
          _buildRuleItem("Au moins un chiffre (0-9)", passwordValidation.hasDigit),
          const SizedBox(height: 6),
          _buildRuleItem("Au moins un caractère spécial (!@#\$%^&*)", passwordValidation.hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 15,
          color: isValid ? Colors.green : AppColors.textGrey,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: AppTexts.menuText(
            text,
            color: isValid ? Colors.green : AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomFormField(
              label: t.translate('city'),
              controller: _cityController,
              hint: t.translate('enter_city'),
            ),
            const SizedBox(height: 10),
            CustomFormField(
              label: t.residenceAddressLabel,
              controller: _addressController,
              hint: t.residenceAddressLabel,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
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
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep4(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomFormField(
              label: t.referralCodeLabel,
              controller: _codeController,
              hint: t.referralCode,
              required: false,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  confirmPolicy = !confirmPolicy;
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    checkColor: Colors.white,
                    value: confirmPolicy,
                    onChanged: (bool? value) {
                      setState(() {
                        confirmPolicy = !confirmPolicy;
                      });
                    },
                  ),
                  Flexible(
                    child: AppTexts.smallText(t.acceptPolicy),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  confirmNewsletter = !confirmNewsletter;
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    visualDensity: const VisualDensity(vertical: -4),
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    checkColor: Colors.white,
                    value: confirmNewsletter,
                    onChanged: (bool? value) {
                      setState(() {
                        confirmNewsletter = !confirmNewsletter;
                      });
                    },
                  ),
                  Flexible(
                    child: AppTexts.smallText(t.subscribeNewsletter),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                if (!loadingPdf1) {
                  setState(() {
                    loadingPdf1 = true;
                  });

                  var urllaunchable = await canLaunch(
                    "https://transfertchapchap.com/privacy_policy",
                  );
                  if (urllaunchable) {
                    await launch("https://transfertchapchap.com/privacy_policy");
                  } else {
                    Utils.toastMessage(t.urlOpenError);
                  }

                  setState(() {
                    loadingPdf1 = false;
                  });
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: loadingPdf1
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(
                t.privacyPolicy,
                style: const TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (!loadingPdf2) {
                  setState(() {
                    loadingPdf2 = true;
                  });

                  var urllaunchable = await canLaunch(
                    "https://transfertchapchap.com/terms_of_condition",
                  );
                  if (urllaunchable) {
                    await launch("https://transfertchapchap.com/terms_of_condition");
                  } else {
                    Utils.toastMessage(t.urlOpenError);
                  }

                  setState(() {
                    loadingPdf2 = false;
                  });
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: loadingPdf2
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(
                t.termsOfService,
                style: const TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: commonRoundedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTexts.smallText(
                      t.fullNameLabel,
                      color: Colors.black54,
                    ),
                    AppTexts.bodyText("${data["prenom"]} ${data["nom"]}", bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              commonDivider(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTexts.smallText(
                      t.emailLabel,
                      color: Colors.black54,
                    ),
                    AppTexts.bodyText("${data["email"]}", bold: true),
                    const SizedBox(height: 10),
                    AppTexts.smallText(
                      t.phoneNumberLabel,
                      color: Colors.black54,
                    ),
                    AppTexts.bodyText("${data["telephone"]}", bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              commonDivider(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTexts.smallText(
                      t.residenceAddressLabel,
                      color: Colors.black54,
                    ),
                    AppTexts.bodyText("${data["adresse"]}", bold: true),
                    const SizedBox(height: 10),
                    AppTexts.smallText(
                      t.translate('city'),
                      color: Colors.black54,
                    ),
                    AppTexts.bodyText("${data["villeClient"]}", bold: true),
                    const SizedBox(height: 10),
                    AppTexts.smallText(
                      t.professionLabel,
                      color: Colors.black54,
                    ),
                    AppTexts.bodyText(
                      "${data["profession"] == '' || selectedProfession == null ? '_' : selectedProfession!.profession}",
                      bold: true,
                    ),
                  ],
                ),
              ),
              if (_codeController.text != "")
                const SizedBox(height: 15),
              if (_codeController.text != "")
                commonDivider(),
              if (_codeController.text != "")
                const SizedBox(height: 15),
              if (_codeController.text != "")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTexts.smallText(
                        t.referralCode,
                        color: Colors.black54,
                      ),
                      AppTexts.bodyText(
                        "${data["code_parrainage"] == '' ? '_' : data["code_parrainage"]}",
                        bold: true,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          removePaddingH: true,
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, AppLocalizations t) {
    bool isVerifying = isVerifyingEmail || isVerifyingPhone || authViewModel.loading;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: RoundedButton(
        title: currentPage == maxRegistrationSteps - 1
            ? t.registerButtonText
            : t.nextButtonText,
        loading: authViewModel.loading || isVerifying,
        onPress: () {
          if (!authViewModel.loading && !isVerifying) {
            _handleNextPage(context, t);
          }
        },
      ),
    );
  }

  void _handleNextPage(BuildContext context, AppLocalizations t) {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    if (currentPage == 0) {
      if (_nomController.text.isEmpty) {
        Utils.flushBarErrorMessage(t.enterNameError, context);
      } else if (_prenomController.text.isEmpty) {
        Utils.flushBarErrorMessage(t.enterSurnameError, context);
      } else if (_selectedCountry == null) {
        Utils.flushBarErrorMessage(t.enterCountryNationnality, context);
      } else {
        data["prenom"] = _prenomController.text;
        data["nom"] = _nomController.text;
        data["pays_nationalite"] = _selectedCountry?.alpha2.toLowerCase();

        setState(() {
          currentPage = 1;
        });

        scrollController.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else if (currentPage == 1) {
      passwordValidation.validate(_passwordController.text);

      if (_emailController.text.isEmpty) {
        Utils.flushBarErrorMessage(t.enterEmailError, context);
      } else if (_phoneController.text.isEmpty) {
        Utils.flushBarErrorMessage(t.enterPhoneError, context);
      } else if (_passwordController.text.isEmpty) {
        Utils.flushBarErrorMessage(t.enterPasswordError, context);
      } else if (!passwordValidation.isValid) {
        Utils.flushBarErrorMessage(
          "Le mot de passe doit respecter toutes les règles requises",
          context,
        );
      } else if (_passwordController.text != _confirmPasswordController.text) {
        Utils.flushBarErrorMessage(t.passwordMatchError, context);
      } else {
        data["username"] = _emailController.text;
        data["email"] = _emailController.text;
        data["idPays"] = selectedPays!.idPays.toString();
        data["pays_adresse"] = selectedPays!.codePays.toString();
        data["telephone"] = selectedPays!.paysIndictel.toString() + _phoneController.text;
        data["password"] = _passwordController.text;

        setState(() {
          currentPage = 2;
        });

        scrollController.animateToPage(
          2,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else if (currentPage == 2) {
      if (_addressController.text.isEmpty) {
        Utils.flushBarErrorMessage(t.enterAddressError, context);
      } else if (selectedProfession == null) {
        Utils.flushBarErrorMessage(t.translate('select_job'), context);
      } else {
        data["adresse"] = _addressController.text;
        data["villeClient"] = _cityController.text;
        data['id_profession'] = selectedProfession!.idProfession;

        setState(() {
          currentPage = 3;
        });

        scrollController.animateToPage(
          3,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else if (currentPage == 3) {
      if (!confirmPolicy) {
        Utils.flushBarErrorMessage(t.acceptPolicyError, context);
      } else {
        data["code_parrainage"] = _codeController.text;

        setState(() {
          currentPage = 4;
        });

        scrollController.animateToPage(
          4,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      data['langue'] = local;
      authViewModel.registerApi(data, context);
    }
  }
}
