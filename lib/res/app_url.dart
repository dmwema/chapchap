class AppUrl {
  static var domainName = 'https://app.chapchap.ca';
  static var baseUrl = "$domainName/api";

  static var loginEndPoint = '$baseUrl/login';
  static var registerEndPoint = '$baseUrl/register';
  static var phoneVerificatiobEndPoint = '$baseUrl/confirm_number_phone';
  static var myDemandesEndPoint = '$baseUrl/my_demandes';
  static var paysDestinationsEndPoint = '$baseUrl/my_destinations';
  static var beneficiairesEndPoint = '$baseUrl/my_beneficiaires';
  static var paysActifsEndPoint = '$baseUrl/get_pays';
}