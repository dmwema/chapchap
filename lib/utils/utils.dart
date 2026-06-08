import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

class Utils {
  static String pusherAppId = "1543547";
  static String pusherKey = "edff47cb96049de87027";
  static String pusherSecret = "af29f17f93dac673ee31";
  static String pusherCluster = "us2";

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static List<Map<String, String>> languages = [
    {
      "code": "Fr", "name": "Français"
    },
    {
      "code": "En", "name": "English"
    },
    {
      "code": "Es", "name": "Espanish"
    },
  ];

  static String messageParrainage = "Voici%20mon%20code%20de%20parrainage%20ChapChap%20%3A%20%24%7Buser%21.codeParrainage%7D%0AUtilise%20le%20pour%20t%E2%80%99inscrire%20sur%20transfert%20ChapChap%20et%20b%C3%A9n%C3%A9ficie%20de%2010%24%20gratuit%0A%0AT%C3%A9l%C3%A9charge%20l%27application%20ChapChap%20et%20suivant%20ce%20lien%0Ahttps%3A%2F%2Fwww.chapchap.ca";

  static void flushBarErrorMessage(String message, BuildContext context) {
    FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.error_outline,
        color: Colors.black,
        size: 24,
      ),
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.white,
      boxShadows: const [
        BoxShadow(
            color: Colors.red, blurRadius: 4.0, spreadRadius: 2.0),
      ],
    ).show();
  }

  static removeFocus (BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Map<String, String> countryMoneyCode = {
    'ca': 'CAD',
    'cd': 'USD',
    'cn': 'CNY',
    'bj': 'XOF',
    'bf': 'XOF',
    'cm': 'XOF',
    'gn': 'GNF',
    'ci': 'XOF',
    'ml': 'XOF',
    'sn': 'XOF',
    'tg': 'XOF',
  };

  static Future<void> launchUrl(String _url) async {
    if (await canLaunchUrl(Uri.parse(_url))) {
      await launchUrl(_url);
    } else {
      throw "Could not launch $_url";
    }
  }

  static snakBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ),
    );
  }

  static void showPinDialog (UserModel user, BuildContext context, PinViewModel pinViewModel) {
    TextEditingController _pinController = TextEditingController();
    TextEditingController _pinConfirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (
          context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius
                  .circular(
                  20)
          ),
          child: Padding(
            padding: const EdgeInsets
                .symmetric(
                vertical: 30,
                horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min,
              children: [
                const Icon(
                  Icons
                      .edit_note,
                  color: Colors
                      .black,
                  size: 60,
                ),
                const SizedBox(
                  height: 20,),
                const Text(
                  "Definir un code PIN",
                  textAlign: TextAlign
                      .center,
                  style: TextStyle(
                      color: Colors
                          .black,
                      fontWeight: FontWeight
                          .bold
                  ),
                ),
                const SizedBox(
                  height: 20,),
                CustomFormField(
                  label: "Entrez le code PIN",
                  hint: "Entrez le code PIN",
                  type: TextInputType
                      .number,
                  controller: _pinController,
                ),
                const SizedBox(
                  height: 20,),
                CustomFormField(
                  label: "Confirmer le code PIN",
                  hint: "Confirmer le code PIN",
                  type: TextInputType
                      .number,
                  controller: _pinConfirmController,
                ),
                const SizedBox(
                  height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center,
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets
                            .symmetric(
                            vertical: 15,
                            horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors
                                .primaryColor,
                            borderRadius: BorderRadius
                                .circular(
                                30)
                        ),
                        child: const Text(
                          "Enregistrer",
                          style: TextStyle(
                              color: Colors
                                  .white),),
                      ),
                      onTap: () async {
                        if (_pinController
                            .text ==
                            "") {
                          Utils
                              .flushBarErrorMessage(
                              "Vous devez entrer le code PIN",
                              context);
                        } else
                        if (_pinConfirmController
                            .text ==
                            "") {
                          Utils
                              .flushBarErrorMessage(
                              "Vous devez confirmer le code PIN",
                              context);
                        } else
                        if (_pinController
                            .text !=
                            _pinConfirmController
                                .text) {
                          Utils
                              .flushBarErrorMessage(
                              "Les deux pins ne correspondent pas",
                              context);
                        } else {
                          Map data = {
                            'code_pin': _pinController
                                .text,
                          };
                          await pinViewModel
                              .createPin(
                              data,
                              context)
                              .then((
                              value) {
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesName.home,
                                    (route) => false,
                              );
                            };
                          });
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static BoxShadow customShadow () {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: .5,
      blurRadius: 7,
      offset: Offset(0, 1), // changes position of shadow
    );
  }

  static getMonthName (String date) {
    var month = date.split(' ')[0];
    Map<String, String> months = {
      "1": "Janvier",
      "2": "Fevrier",
      "3": "Mars",
      "4": "Avril",
      "5": "Mai",
      "6": "Juin",
      "7": "Juillet",
      "8": "Août",
      "9": "Septembre",
      "10": "Octobre",
      "11": "Novembre",
      "12": "Decembre",
    };
    return "${months[month]} ${date.split(' ')[1]}";
  }

  static String demandeStatusPending = "pending";
  static String demandeStatusProcessing = "processing";
  static String demandeStatusCompleted = "completed";
  static String demandeStatusWarning = "warning";
  static String demandeStatusFailed = "failed";

  static String getTimeDiff(TimeOfDay startTime, TimeOfDay endTime, int? pause) {
    int h_s = startTime.hour;
    int m_s = startTime.minute;

    int h_e = endTime.hour;
    int m_e = endTime.minute;

    int h_t = h_e - h_s;
    int m_t;

    if (m_s > m_e) {
      h_t -= 1;
      m_t = (60 - m_s) + m_e;
    } else {
      m_t = m_e - m_s;
    }

    if (pause != null) {
      int m_p = pause;

      //h_t -= h_p;

      if (m_p > m_t) {
        h_t -= 1;
        m_t = (60 - m_p) + m_t;
      } else {
        m_t = m_t - m_p;
      }
    }

    String h;
    String m;

    if (h_t.toString().length == 1) {
      h = "0$h_t";
    } else {
      h = h_t.toString();
    }

    if (m_t.toString().length == 1) {
      m = "0$m_t";
    } else {
      m = m_t.toString();
    }

    if (m == "00") {
      m = "";
    }

    return "${h}H$m";
  }

  static timeToMin(String time) {
    int timeMMM = 0;
    var timeArr = time.split("H");
    int timeH = int.parse(timeArr[0]);

    timeMMM += timeH * 60;

    if (timeArr[1] != "") {
      var timeM = int.parse(timeArr[1]);
      timeMMM += timeM;
    }

    return timeMMM;
  }

  static bool emailValid (email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  static Map<String, String> allRequiredFields ({required BeneficiaireModel beneficiaire, required String typeRetrait}) {

    Map<String, String>? fields = ChampsRequisParModeRetrait.FIELDS[typeRetrait];
    Map beneficiaireJson = beneficiaire.toJson();

    if (fields == null) {
      return {};
    }
    
    Map<String, String> requiredFields = {};
    for (var entry in fields!.entries) {
      var f = entry.key;
      var name = entry.value;
      
      if (beneficiaireJson[f] == null || beneficiaireJson[f].toString().trim() == "null" || beneficiaireJson[f].toString().trim() == "") {
        requiredFields[f] = name;
      }
    }
    return requiredFields;
  }

  static List<Map<String, String>> countries = [
    {'name': 'Afghanistan', 'code': 'AF'},
    {'name': 'Åland Islands', 'code': 'AX'},
    {'name': 'Albania', 'code': 'AL'},
    {'name': 'Algeria', 'code': 'DZ'},
    {'name': 'American Samoa', 'code': 'AS'},
    {'name': 'AndorrA', 'code': 'AD'},
    {'name': 'Angola', 'code': 'AO'},
    {'name': 'Anguilla', 'code': 'AI'},
    {'name': 'Antarctica', 'code': 'AQ'},
    {'name': 'Antigua and Barbuda', 'code': 'AG'},
    {'name': 'Argentina', 'code': 'AR'},
    {'name': 'Armenia', 'code': 'AM'},
    {'name': 'Aruba', 'code': 'AW'},
    {'name': 'Australia', 'code': 'AU'},
    {'name': 'Austria', 'code': 'AT'},
    {'name': 'Azerbaijan', 'code': 'AZ'},
    {'name': 'Bahamas', 'code': 'BS'},
    {'name': 'Bahrain', 'code': 'BH'},
    {'name': 'Bangladesh', 'code': 'BD'},
    {'name': 'Barbados', 'code': 'BB'},
    {'name': 'Belarus', 'code': 'BY'},
    {'name': 'Belgium', 'code': 'BE'},
    {'name': 'Belize', 'code': 'BZ'},
    {'name': 'Benin', 'code': 'BJ'},
    {'name': 'Bermuda', 'code': 'BM'},
    {'name': 'Bhutan', 'code': 'BT'},
    {'name': 'Bolivia', 'code': 'BO'},
    {'name': 'Bosnia and Herzegovina', 'code': 'BA'},
    {'name': 'Botswana', 'code': 'BW'},
    {'name': 'Bouvet Island', 'code': 'BV'},
    {'name': 'Brazil', 'code': 'BR'},
    {'name': 'British Indian Ocean Territory', 'code': 'IO'},
    {'name': 'Brunei Darussalam', 'code': 'BN'},
    {'name': 'Bulgaria', 'code': 'BG'},
    {'name': 'Burkina Faso', 'code': 'BF'},
    {'name': 'Burundi', 'code': 'BI'},
    {'name': 'Cambodia', 'code': 'KH'},
    {'name': 'Cameroon', 'code': 'CM'},
    {'name': 'Canada', 'code': 'CA'},
    {'name': 'Cape Verde', 'code': 'CV'},
    {'name': 'Cayman Islands', 'code': 'KY'},
    {'name': 'Central African Republic', 'code': 'CF'},
    {'name': 'Chad', 'code': 'TD'},
    {'name': 'Chile', 'code': 'CL'},
    {'name': 'China', 'code': 'CN'},
    {'name': 'Christmas Island', 'code': 'CX'},
    {'name': 'Cocos (Keeling) Islands', 'code': 'CC'},
    {'name': 'Colombia', 'code': 'CO'},
    {'name': 'Comoros', 'code': 'KM'},
    {'name': 'Congo', 'code': 'CG'},
    {'name': 'Congo, The Democratic Republic of the', 'code': 'CD'},
    {'name': 'Cook Islands', 'code': 'CK'},
    {'name': 'Costa Rica', 'code': 'CR'},
    {'name': 'Cote D\'Ivoire', 'code': 'CI'},
    {'name': 'Croatia', 'code': 'HR'},
    {'name': 'Cuba', 'code': 'CU'},
    {'name': 'Cyprus', 'code': 'CY'},
    {'name': 'Czech Republic', 'code': 'CZ'},
    {'name': 'Denmark', 'code': 'DK'},
    {'name': 'Djibouti', 'code': 'DJ'},
    {'name': 'Dominica', 'code': 'DM'},
    {'name': 'Dominican Republic', 'code': 'DO'},
    {'name': 'Ecuador', 'code': 'EC'},
    {'name': 'Egypt', 'code': 'EG'},
    {'name': 'El Salvador', 'code': 'SV'},
    {'name': 'Equatorial Guinea', 'code': 'GQ'},
    {'name': 'Eritrea', 'code': 'ER'},
    {'name': 'Estonia', 'code': 'EE'},
    {'name': 'Ethiopia', 'code': 'ET'},
    {'name': 'Falkland Islands (Malvinas)', 'code': 'FK'},
    {'name': 'Faroe Islands', 'code': 'FO'},
    {'name': 'Fiji', 'code': 'FJ'},
    {'name': 'Finland', 'code': 'FI'},
    {'name': 'France', 'code': 'FR'},
    {'name': 'French Guiana', 'code': 'GF'},
    {'name': 'French Polynesia', 'code': 'PF'},
    {'name': 'French Southern Territories', 'code': 'TF'},
    {'name': 'Gabon', 'code': 'GA'},
    {'name': 'Gambia', 'code': 'GM'},
    {'name': 'Georgia', 'code': 'GE'},
    {'name': 'Germany', 'code': 'DE'},
    {'name': 'Ghana', 'code': 'GH'},
    {'name': 'Gibraltar', 'code': 'GI'},
    {'name': 'Greece', 'code': 'GR'},
    {'name': 'Greenland', 'code': 'GL'},
    {'name': 'Grenada', 'code': 'GD'},
    {'name': 'Guadeloupe', 'code': 'GP'},
    {'name': 'Guam', 'code': 'GU'},
    {'name': 'Guatemala', 'code': 'GT'},
    {'name': 'Guernsey', 'code': 'GG'},
    {'name': 'Guinea', 'code': 'GN'},
    {'name': 'Guinea-Bissau', 'code': 'GW'},
    {'name': 'Guyana', 'code': 'GY'},
    {'name': 'Haiti', 'code': 'HT'},
    {'name': 'Heard Island and Mcdonald Islands', 'code': 'HM'},
    {'name': 'Holy See (Vatican City State)', 'code': 'VA'},
    {'name': 'Honduras', 'code': 'HN'},
    {'name': 'Hong Kong', 'code': 'HK'},
    {'name': 'Hungary', 'code': 'HU'},
    {'name': 'Iceland', 'code': 'IS'},
    {'name': 'India', 'code': 'IN'},
    {'name': 'Indonesia', 'code': 'ID'},
    {'name': 'Iran, Islamic Republic Of', 'code': 'IR'},
    {'name': 'Iraq', 'code': 'IQ'},
    {'name': 'Ireland', 'code': 'IE'},
    {'name': 'Isle of Man', 'code': 'IM'},
    {'name': 'Israel', 'code': 'IL'},
    {'name': 'Italy', 'code': 'IT'},
    {'name': 'Jamaica', 'code': 'JM'},
    {'name': 'Japan', 'code': 'JP'},
    {'name': 'Jersey', 'code': 'JE'},
    {'name': 'Jordan', 'code': 'JO'},
    {'name': 'Kazakhstan', 'code': 'KZ'},
    {'name': 'Kenya', 'code': 'KE'},
    {'name': 'Kiribati', 'code': 'KI'},
    {'name': 'Korea, Democratic People\'S Republic of', 'code': 'KP'},
    {'name': 'Korea, Republic of', 'code': 'KR'},
    {'name': 'Kuwait', 'code': 'KW'},
    {'name': 'Kyrgyzstan', 'code': 'KG'},
    {'name': 'Lao People\'S Democratic Republic', 'code': 'LA'},
    {'name': 'Latvia', 'code': 'LV'},
    {'name': 'Lebanon', 'code': 'LB'},
    {'name': 'Lesotho', 'code': 'LS'},
    {'name': 'Liberia', 'code': 'LR'},
    {'name': 'Libyan Arab Jamahiriya', 'code': 'LY'},
    {'name': 'Liechtenstein', 'code': 'LI'},
    {'name': 'Lithuania', 'code': 'LT'},
    {'name': 'Luxembourg', 'code': 'LU'},
    {'name': 'Macao', 'code': 'MO'},
    {'name': 'Macedonia, The Former Yugoslav Republic of', 'code': 'MK'},
    {'name': 'Madagascar', 'code': 'MG'},
    {'name': 'Malawi', 'code': 'MW'},
    {'name': 'Malaysia', 'code': 'MY'},
    {'name': 'Maldives', 'code': 'MV'},
    {'name': 'Mali', 'code': 'ML'},
    {'name': 'Malta', 'code': 'MT'},
    {'name': 'Marshall Islands', 'code': 'MH'},
    {'name': 'Martinique', 'code': 'MQ'},
    {'name': 'Mauritania', 'code': 'MR'},
    {'name': 'Mauritius', 'code': 'MU'},
    {'name': 'Mayotte', 'code': 'YT'},
    {'name': 'Mexico', 'code': 'MX'},
    {'name': 'Micronesia, Federated States of', 'code': 'FM'},
    {'name': 'Moldova, Republic of', 'code': 'MD'},
    {'name': 'Monaco', 'code': 'MC'},
    {'name': 'Mongolia', 'code': 'MN'},
    {'name': 'Montserrat', 'code': 'MS'},
    {'name': 'Morocco', 'code': 'MA'},
    {'name': 'Mozambique', 'code': 'MZ'},
    {'name': 'Myanmar', 'code': 'MM'},
    {'name': 'Namibia', 'code': 'NA'},
    {'name': 'Nauru', 'code': 'NR'},
    {'name': 'Nepal', 'code': 'NP'},
    {'name': 'Netherlands', 'code': 'NL'},
    {'name': 'Netherlands Antilles', 'code': 'AN'},
    {'name': 'New Caledonia', 'code': 'NC'},
    {'name': 'New Zealand', 'code': 'NZ'},
    {'name': 'Nicaragua', 'code': 'NI'},
    {'name': 'Niger', 'code': 'NE'},
    {'name': 'Nigeria', 'code': 'NG'},
    {'name': 'Niue', 'code': 'NU'},
    {'name': 'Norfolk Island', 'code': 'NF'},
    {'name': 'Northern Mariana Islands', 'code': 'MP'},
    {'name': 'Norway', 'code': 'NO'},
    {'name': 'Oman', 'code': 'OM'},
    {'name': 'Pakistan', 'code': 'PK'},
    {'name': 'Palau', 'code': 'PW'},
    {'name': 'Palestinian Territory, Occupied', 'code': 'PS'},
    {'name': 'Panama', 'code': 'PA'},
    {'name': 'Papua New Guinea', 'code': 'PG'},
    {'name': 'Paraguay', 'code': 'PY'},
    {'name': 'Peru', 'code': 'PE'},
    {'name': 'Philippines', 'code': 'PH'},
    {'name': 'Pitcairn', 'code': 'PN'},
    {'name': 'Poland', 'code': 'PL'},
    {'name': 'Portugal', 'code': 'PT'},
    {'name': 'Puerto Rico', 'code': 'PR'},
    {'name': 'Qatar', 'code': 'QA'},
    {'name': 'Reunion', 'code': 'RE'},
    {'name': 'Romania', 'code': 'RO'},
    {'name': 'Russian Federation', 'code': 'RU'},
    {'name': 'RWANDA', 'code': 'RW'},
    {'name': 'Saint Helena', 'code': 'SH'},
    {'name': 'Saint Kitts and Nevis', 'code': 'KN'},
    {'name': 'Saint Lucia', 'code': 'LC'},
    {'name': 'Saint Pierre and Miquelon', 'code': 'PM'},
    {'name': 'Saint Vincent and the Grenadines', 'code': 'VC'},
    {'name': 'Samoa', 'code': 'WS'},
    {'name': 'San Marino', 'code': 'SM'},
    {'name': 'Sao Tome and Principe', 'code': 'ST'},
    {'name': 'Saudi Arabia', 'code': 'SA'},
    {'name': 'Senegal', 'code': 'SN'},
    {'name': 'Serbia and Montenegro', 'code': 'CS'},
    {'name': 'Seychelles', 'code': 'SC'},
    {'name': 'Sierra Leone', 'code': 'SL'},
    {'name': 'Singapore', 'code': 'SG'},
    {'name': 'Slovakia', 'code': 'SK'},
    {'name': 'Slovenia', 'code': 'SI'},
    {'name': 'Solomon Islands', 'code': 'SB'},
    {'name': 'Somalia', 'code': 'SO'},
    {'name': 'South Africa', 'code': 'ZA'},
    {'name': 'South Georgia and the South Sandwich Islands', 'code': 'GS'},
    {'name': 'Spain', 'code': 'ES'},
    {'name': 'Sri Lanka', 'code': 'LK'},
    {'name': 'Sudan', 'code': 'SD'},
    {'name': 'Suriname', 'code': 'SR'},
    {'name': 'Svalbard and Jan Mayen', 'code': 'SJ'},
    {'name': 'Swaziland', 'code': 'SZ'},
    {'name': 'Sweden', 'code': 'SE'},
    {'name': 'Switzerland', 'code': 'CH'},
    {'name': 'Syrian Arab Republic', 'code': 'SY'},
    {'name': 'Taiwan, Province of China', 'code': 'TW'},
    {'name': 'Tajikistan', 'code': 'TJ'},
    {'name': 'Tanzania, United Republic of', 'code': 'TZ'},
    {'name': 'Thailand', 'code': 'TH'},
    {'name': 'Timor-Leste', 'code': 'TL'},
    {'name': 'Togo', 'code': 'TG'},
    {'name': 'Tokelau', 'code': 'TK'},
    {'name': 'Tonga', 'code': 'TO'},
    {'name': 'Trinidad and Tobago', 'code': 'TT'},
    {'name': 'Tunisia', 'code': 'TN'},
    {'name': 'Turkey', 'code': 'TR'},
    {'name': 'Turkmenistan', 'code': 'TM'},
    {'name': 'Turks and Caicos Islands', 'code': 'TC'},
    {'name': 'Tuvalu', 'code': 'TV'},
    {'name': 'Uganda', 'code': 'UG'},
    {'name': 'Ukraine', 'code': 'UA'},
    {'name': 'United Arab Emirates', 'code': 'AE'},
    {'name': 'United Kingdom', 'code': 'GB'},
    {'name': 'United States', 'code': 'US'},
    {'name': 'United States Minor Outlying Islands', 'code': 'UM'},
    {'name': 'Uruguay', 'code': 'UY'},
    {'name': 'Uzbekistan', 'code': 'UZ'},
    {'name': 'Vanuatu', 'code': 'VU'},
    {'name': 'Venezuela', 'code': 'VE'},
    {'name': 'Viet Nam', 'code': 'VN'},
    {'name': 'Virgin Islands, British', 'code': 'VG'},
    {'name': 'Virgin Islands, U.S.', 'code': 'VI'},
    {'name': 'Wallis and Futuna', 'code': 'WF'},
    {'name': 'Western Sahara', 'code': 'EH'},
    {'name': 'Yemen', 'code': 'YE'},
    {'name': 'Zambia', 'code': 'ZM'},
    {'name': 'Zimbabwe', 'code': 'ZW'}
  ];
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}