import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var appTheme = ThemeData(
    fontFamily: GoogleFonts.nunito().fontFamily,
    brightness: Brightness.light,
    textTheme: const TextTheme(
        bodyText1: TextStyle(fontSize: 15, color: Colors.black),
        bodyText2: TextStyle(fontSize: 15, color: Colors.black),
        headline1: TextStyle(
            fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold)));
