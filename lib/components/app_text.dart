import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget gameText(
    {required BuildContext context, required String text, double? textSize}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: _getStyle(size: textSize),
  );
}

Widget appText(
    {required String text,
    Color? color,
    double? size,
    TextAlign textAlign = TextAlign.center,
    TextStyle? customStyle}) {
  return Text(
    text,
    textAlign: textAlign,
    style: customStyle ?? _getStyle(color: color, size: size),
  );
}

TextStyle _getStyle({double? size, Color? color = Colors.black}) => TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: size,
    color: color,
    fontFamily: GoogleFonts.russoOne().fontFamily);
