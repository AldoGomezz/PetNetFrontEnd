import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getHeaderStyle(BuildContext context) => GoogleFonts.quicksand(
      fontSize: 27,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textColor,
    );

TextStyle getTitleBoldStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textColor,
    );

TextStyle getTitleStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textColor,
    );

TextStyle getTitleStyle700(BuildContext context) => GoogleFonts.roboto(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).textColor,
    );

TextStyle getSubtitleStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textColor,
    );

TextStyle getSubtitleBoldStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textColor,
    );

TextStyle getSubtitleStyle600(BuildContext context) => GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textColor,
    );

TextStyle getSmallSubtitleBoldStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textColor,
    );

TextStyle getSmallSubtitleStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textColor,
    );

TextStyle getSubSmallSubtitleStyle(BuildContext context) => GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textColor,
    );
