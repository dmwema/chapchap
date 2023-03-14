class AppUrl {
  static var domainName = 'https://app.chapchap.ca';
  static var baseUrl = "$domainName/api";

  static var loginEndPoint = '$baseUrl/login';
  static var registerEndPoint = '$baseUrl/register';
  static var phoneVerificatiobEndPoint = '$baseUrl/confirm_number_phone';
  static var myDemandesEndPoint = '$baseUrl/my_demandes';
  static var paysDestinationsEndPoint = '$baseUrl/my_destinations';
  static var allPaysDestinationsEndPoint = '$baseUrl/pays_destination';
  static var beneficiairesEndPoint = '$baseUrl/my_beneficiaires';
  static var paysActifsEndPoint = '$baseUrl/get_pays';
  static var newBeneficiaire = '$baseUrl/creat_beneficiaire';
  static var beneficiaireInfo = '$baseUrl/infos_beneficiaires';
  static var trasfert = '$baseUrl/transfert';
}