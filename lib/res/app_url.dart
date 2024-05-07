class AppUrl {
  static var domainName = 'https://app.chapchap.ca';
  // static var domainName = 'https://sandbox-app.chapchap.ca';
  static var baseUrl = "$domainName/api";

  static var loginEndPoint = '$baseUrl/login';
  static var registerEndPoint = '$baseUrl/register';
  static var changePassword = '$baseUrl/change_password';
  static var resetPassword = '$baseUrl/reset_password';
  static var phoneVerificatiobEndPoint = '$baseUrl/confirm_number_phone';
  static var myDemandesEndPoint = '$baseUrl/my_demandes';
  static var myDemandesWPEndPoint = '$baseUrl/demande_with_problem';
  static var paysDestinationsEndPoint = '$baseUrl/my_destinations';
  static var allPaysDestinationsEndPoint = '$baseUrl/pays_destination';
  static var beneficiairesEndPoint = '$baseUrl/my_beneficiaires';
  static var beneficiairesArchiveEndPoint = '$baseUrl/my_beneficiaires_archives';
  static var paysActifsEndPoint = '$baseUrl/get_pays';
  static var newBeneficiaire = '$baseUrl/creat_beneficiairerolandosou';
  static var beneficiaireInfo = '$baseUrl/infos_beneficiaires';
  static var trasfert = '$baseUrl/transfert';
  static var myInfos = '$baseUrl/my_infos_';
  static var editUser = '$baseUrl/up_client';
  static var uPass = '$baseUrl/up_password';
  static var deleteRecipient = '$baseUrl/delete_beneficiaire';
  static var archiveRecipient = '$baseUrl/archiver_beneficiaire';
  static var desarchiveRecipient = '$baseUrl/desarchiver_beneficiaire';
  static var applyPromo = '$baseUrl/appliquer_code_promo';
  static var myPromo = '$baseUrl/my_code_promo';
  static var cancelSend = '$baseUrl/annuler_transfert';
  static var updateImage = '$baseUrl/up_profil_client';
  static var changeBeneficiaire = '$baseUrl/change_beneficiaire_transfert';
  static var allInfoMessages = '$baseUrl/get_all_msg_info';
}
