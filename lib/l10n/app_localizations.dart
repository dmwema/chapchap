import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  Future<void> load() async {
    String jsonString =
    await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) =>
        MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key; // Si la clé n'est pas trouvée, retourne la clé elle-même
  }

  String authVerification(String method) =>
      translate("authVerification").replaceAll("{method}", method);
  String authDescription(String method) =>
      translate("authDescription").replaceAll("{method}", method);
  String authButton(String method) =>
      translate("authButton").replaceAll("{method}", method);

  String get fingerprint => translate("fingerprint");
  String get faceID => translate("faceID");
  String get loginTitle => translate("loginTitle");
  String get email => translate("email");
  String get password => translate("password");
  String get forgotPassword => translate("forgotPassword");
  String get login => translate("login");
  String get enterEmail => translate("enterEmail");
  String get enterPassword => translate("enterPassword");
  String get passwordLength => translate("passwordLength");
  String get resetPasswordTitle => translate("resetPasswordTitle");
  String get resetPasswordSubtitle => translate("resetPasswordSubtitle");
  String get resendCode => translate("resendCode");
  String get enterCode => translate("enterCode");
  String get createNewPassword => translate("createNewPassword");
  String get confirmPassword => translate("confirmPassword");
  String get validate => translate("validate");
  String get allFieldsRequired => translate("allFieldsRequired");
  String get resetPasswordDescription => translate("resetPasswordDescription");
  String get code => translate("code");
  String get codeHint => translate("codeHint");
  String get submit => translate("submit");
  String get name => translate("name");
  String get nameHint => translate("nameHint");
  String get firstName => translate("firstName");
  String get firstNameHint => translate("firstNameHint");
  String get lastName => translate("lastName");
  String get lastNameHint => translate("lastNameHint");
  String get providePhoneNumber => translate("providePhoneNumber");
  String get phoneNumberDescription => translate("phoneNumberDescription");
  String get phoneNumber => translate("phoneNumber");
  String get selectYourCountry => translate("selectYourCountry");
  String get addressLabel => translate("addressLabel");
  String get addressHint => translate("addressHint");
  String get currentProfessionLabel => translate("currentProfessionLabel");
  String get enterPhoneNumber => translate("enterPhoneNumber");
  String get currentProfessionHint => translate("currentProfessionHint");
  String get referralCodeLabel => translate("referralCodeLabel");
  String get referralCode => translate("referralCode");
  String get referralCodeHint => translate("referralCodeHint");
  String get acceptPolicy => translate("acceptPolicy");
  String get subscribeNewsletter => translate("subscribeNewsletter");
  String get privacyPolicy => translate("privacyPolicy");
  String get urlOpenError => translate("urlOpenError");
  String get termsOfService => translate("termsOfService");
  String get emailLabel => translate("emailLabel");
  String get phoneNumberLabel => translate("phoneNumberLabel");
  String get residenceAddressLabel => translate("residenceAddressLabel");
  String get professionLabel => translate("professionLabel");
  String get fullNameLabel => translate("fullNameLabel");
  String get enterAddressError => translate("enterAddressError");
  String get acceptPolicyError => translate("acceptPolicyError");
  String get passwordMatchError => translate("passwordMatchError");
  String get passwordMinLengthError => translate("passwordMinLengthError");
  String get enterPasswordError => translate("enterPasswordError");
  String get enterPhoneError => translate("enterPhoneError");
  String get enterEmailError => translate("enterEmailError");
  String get enterSurnameError => translate("enterSurnameError");
  String get enterCountryNationnality => translate("enterCountryNationnality");
  String get enterNameError => translate("enterNameError");
  String get nextButtonText => translate("nextButtonText");
  String get registerButtonText => translate("registerButtonText");
  String get phone => translate("phone");
  String get transferChapchap => translate("transferChapchap");
  String get bestMoneyTransferApp => translate("bestMoneyTransferApp");
  String get walletSystemDescription => translate("walletSystemDescription");
  String get rewardSystemDescription => translate("rewardSystemDescription");
  String get giftCardDescription => translate("giftCardDescription");
  String get transferCountriesDescription => translate("transferCountriesDescription");
  String get exchangeRatesDescription => translate("exchangeRatesDescription");
  String get exchangeRatesButton => translate("exchangeRatesButton");
  String get loginButton => translate("loginButton");
  String get registerButton => translate("registerButton");
  String get amount => translate("amount");
  String get beneficiary => translate("beneficiary");
  String get paymentTitle => translate("paymentTitle");
  String get paymentMethodQuestion => translate("paymentMethodQuestion");
  String get payWith => translate("payWith  ");
  String get depositOrTransfer => translate("depositOrTransfer");
  String get toNumber => translate("toNumber");
  String get thenSendProof => translate("thenSendProof");
  String get sendPaymentProof => translate("sendPaymentProof");
  String get earn_more_points => translate("earn_more_points");
  String get understood => translate("understood");
  String get pointsRequired => translate("points_required");
  String get conversion => translate("conversion");
  String get choose_conversion_rule => translate("choose_conversion_rule");
  String get select_conversion_rule => translate("select_conversion_rule");

  String points_required(points) =>
      translate("authVerification").replaceAll("{points}", points);
  String rechargeTitle(currency) =>
      translate("rechargeTitle").replaceAll("{currency}", currency);

}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  // Indique si les localisations doivent être rechargées
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
