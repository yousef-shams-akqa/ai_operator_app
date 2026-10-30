import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const String family = 'Roboto';

  static const double sizeXs = 11;
  static const double sizeSm = 13;
  static const double sizeMd = 15;
  static const double sizeLg = 17;
  static const double sizeXl = 20;
  static const double sizeXxl = 24;
  static const double sizeDisplay = 32;

  static const TextStyle displayLarge = TextStyle(
    fontFamily: family,
    fontSize: sizeDisplay,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: family,
    fontSize: sizeXxl,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: family,
    fontSize: sizeXl,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: family,
    fontSize: sizeLg,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: family,
    fontSize: sizeMd,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: family,
    fontSize: sizeLg,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: family,
    fontSize: sizeMd,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: family,
    fontSize: sizeSm,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: family,
    fontSize: sizeMd,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: family,
    fontSize: sizeSm,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.15,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: family,
    fontSize: sizeXs,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );
}
