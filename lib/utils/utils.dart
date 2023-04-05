import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:standard_dialogs/standard_dialogs.dart';
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

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(context: context, flushbar: Flushbar(
      message: message,
      forwardAnimationCurve: Curves.decelerate,
      icon: const Icon(Icons.error, size: 25, color: Colors.white,),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
    )..show(context));
  }

  static Future<void> launchUrl(String _url) async {
    if (await canLaunchUrl(Uri.parse(_url))) {
      await launchUrl(_url);
    } else {
      throw "Could not launch $_url";
    }
  }

  static void showDialog (BuildContext context, title, {bool isSuccess = true, description}) {
    if (isSuccess) {
      showSuccessDialog(context,
          title: Text(title),
          content: Text(description.toString()),
          action: DialogAction(
            title: const Text('OK'),
          )
      );
    } else {
      showErrorDialog(context,
          title: Text(title));

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