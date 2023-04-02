class AppUrl {
  static var domainName = 'https://sandbox-app.chapchap.ca';
  static var baseUrl = "$domainName/api";

  static var loginEndPoint = '$baseUrl/login';
  static var registerEndPoint = '$baseUrl/register';
  static var changePassword = '$baseUrl/change_password';
  static var resetPassword = '$baseUrl/reset_password';
  static var phoneVerificatiobEndPoint = '$baseUrl/confirm_number_phone';
  static var myDemandesEndPoint = '$baseUrl/my_demandes';
  static var paysDestinationsEndPoint = '$baseUrl/my_destinations';
  static var allPaysDestinationsEndPoint = '$baseUrl/pays_destination';
  static var beneficiairesEndPoint = '$baseUrl/my_beneficiaires';
  static var paysActifsEndPoint = '$baseUrl/get_pays';
  static var newBeneficiaire = '$baseUrl/creat_beneficiaire';
  static var beneficiaireInfo = '$baseUrl/infos_beneficiaires';
  static var trasfert = '$baseUrl/transfert';
  static var myInfos = '$baseUrl/my_infos_';
  static var editUser = '$baseUrl/up_client';
  static var uPass = '$baseUrl/up_password';
}