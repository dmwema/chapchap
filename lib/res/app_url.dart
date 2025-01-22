class AppUrl {
  static var domainName = 'https://app.mardonatransfert.com';
  static var baseUrl = "$domainName/api";

  static var loginEndPoint = '$baseUrl/login';
  static var registerEndPoint = '$baseUrl/register';
  static var changePassword = '$baseUrl/change_password';
  static var passwordReset = '$baseUrl/reset_password';
  static var deleteAccount = '$baseUrl/close_account';
  static var updateNotifications = '$baseUrl/update_notification';
  static var phoneVerificationEndPoint = '$baseUrl/confirm_number_phone';
  static var confirmContact = '$baseUrl/confirm_contact';
  static var myDemandesEndPoint = '$baseUrl/my_demandes';
  static var myDemandesWPEndPoint = '$baseUrl/demande_with_problem';
  static var myDestinationsEndPoint = '$baseUrl/my_destinations';
  static var allPaysDestinationsEndPoint = '$baseUrl/pays_destination';
  static var beneficiairesEndPoint = '$baseUrl/my_beneficiaires';
  static var beneficiairesArchiveEndPoint = '$baseUrl/my_beneficiaires_archives';
  static var paysActifsEndPoint = '$baseUrl/get_pays';
  static var modeRemboursementApi = '$baseUrl/mode_remboursement';
  static var beneficiaireInfo = '$baseUrl/infos_beneficiaires';
  static var newBeneficiaire = '$baseUrl/creat_beneficiaire';
  static var trasfert = '$baseUrl/transfert';
  static var trasfertWallet = '$baseUrl/transfert_with_wallet';
  static var myInfos = '$baseUrl/my_infos_';
  static var editUser = '$baseUrl/up_client';
  static var uPass = '$baseUrl/up_password';
  static var resendCode = '$baseUrl/send_code_confirm';
  static var updatePhone = '$baseUrl/send_code_by_phone';
  static var deleteRecipient = '$baseUrl/delete_beneficiaire';
  static var archiveRecipient = '$baseUrl/archiver_beneficiaire';
  static var desarchiveRecipient = '$baseUrl/desarchiver_beneficiaire';
  static var applyPromo = '$baseUrl/appliquer_code_promo';
  static var myPromo = '$baseUrl/my_code_promo';
  static var cancelSend = '$baseUrl/annuler_transfert';
  static var updateImage = '$baseUrl/up_profil_client';
  static var changeBeneficiaire = '$baseUrl/change_beneficiaire_transfert';
  static var allInfoMessages = '$baseUrl/get_all_msg_info';

  // CODE PIN
  static var createPin = '$baseUrl/creat_pin';
  static var resetPin = '$baseUrl/reset_pin';
  static var changePin = '$baseUrl/change_pin';
  static var updatePin = '$baseUrl/up_pin';
  static var getCurrencies = '$baseUrl/currency';

  // WALLET
  static var getBalance = '$baseUrl/my_balance';
  static var createWallet = '$baseUrl/creat_wallet';
  static var rechargeWallet = '$baseUrl/recharge_wallets';

  static var getMyWallets = '$baseUrl/my_wallets';
  static var transactionsHistory = '$baseUrl/historique_transactions_wallets';
  static var rechargesHistory = '$baseUrl/historique_recharge_wallets';

  // POINTS
  static var getPointsBalance = '$baseUrl/points_balance';
  static var getPointsRules = '$baseUrl/points_to_cash_rules';
  static var pointToCashConvert = '$baseUrl/convert';
  static var pointsTransactionsHistory = '$baseUrl/points_transactions_historique';
  static var pointsConversionsHistory = '$baseUrl/points_convert_historique';

}
