import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppTexts {
  static Text titleText (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color
    ));
  }

  static Text bodyText (String value, {Color color = Colors.black, bool bold = false}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
        color: color
    ));
  }
  
  static Text descriptionText (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color.withOpacity(.8)
    ));
  }

  static Text smallText (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color
    ));
  }

  static Text menuText (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: color
    ));
  }

  static Text buttonText (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color
    ));
  }

  static Text smallButtonText (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color
    ));
  }

  static Text cardTitle (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color
    ));
  }

  static Text cardDescription (String value, {Color color = Colors.black}) {
    return Text(value, style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color
    ));
  }
}