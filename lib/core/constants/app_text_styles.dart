import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // Barlow Condensed — headings, labels, números grandes, uppercase
  static TextStyle headline1 = GoogleFonts.barlowCondensed(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    letterSpacing: -0.5,
  );
  static TextStyle headline2 = GoogleFonts.barlowCondensed(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    letterSpacing: -0.3,
  );
  static TextStyle headline3 = GoogleFonts.barlowCondensed(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static TextStyle label = GoogleFonts.barlowCondensed(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.slate,
    letterSpacing: 0.1,
  );
  static TextStyle labelUppercase = GoogleFonts.barlowCondensed(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.slate,
    letterSpacing: 0.12,
  );
  static TextStyle sportTag = GoogleFonts.barlowCondensed(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: 0.05,
  );
  static TextStyle bigNumber = GoogleFonts.barlowCondensed(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    height: 1.0,
  );
  static TextStyle time = GoogleFonts.barlowCondensed(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    height: 1.0,
  );

  // Barlow — texto corrido, body, subtítulos
  static TextStyle body = GoogleFonts.barlow(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.slate,
    height: 1.6,
  );
  static TextStyle bodyMedium = GoogleFonts.barlow(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );
  static TextStyle bodySmall = GoogleFonts.barlow(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.slate,
    height: 1.5,
  );
  static TextStyle button = GoogleFonts.barlowCondensed(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.08,
  );
}
