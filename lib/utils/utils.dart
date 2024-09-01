import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static String messageParrainage = "Voici%20mon%20code%20de%20parrainage%20ChapChap%20%3A%20%24%7Buser%21.codeParrainage%7D%0AUtilise%20le%20pour%20t%E2%80%99inscrire%20sur%20transfert%20ChapChap%20et%20b%C3%A9n%C3%A9ficie%20de%2010%24%20gratuit%0A%0AT%C3%A9l%C3%A9charge%20l%27application%20ChapChap%20et%20suivant%20ce%20lien%0Ahttps%3A%2F%2Fwww.chapchap.ca";

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(context: context, flushbar: Flushbar(
      message: message,
      forwardAnimationCurve: Curves.decelerate,
      icon: const Icon(Icons.error, size: 25, color: Colors.white,),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context));
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
}