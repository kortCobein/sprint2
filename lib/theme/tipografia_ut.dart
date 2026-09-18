import 'package:flutter/material.dart';

/// Tipografía institucional basada en fuentes del sistema.
///
/// Evita dependencias externas y mantiene jerarquías uniformes en Android,
/// web y escritorio.
abstract final class TipografiaUT {
  static const String? familia = null;

  static TextTheme construir({
    required Color principal,
    required Color secundario,
  }) {
    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: familia,
        fontSize: 34,
        height: 1.12,
        fontWeight: FontWeight.w700,
        color: principal,
        letterSpacing: -0.7,
      ),
      headlineLarge: TextStyle(
        fontFamily: familia,
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: principal,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: familia,
        fontSize: 26,
        height: 1.18,
        fontWeight: FontWeight.w700,
        color: principal,
        letterSpacing: -0.35,
      ),
      headlineSmall: TextStyle(
        fontFamily: familia,
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: principal,
      ),
      titleLarge: TextStyle(
        fontFamily: familia,
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: principal,
      ),
      titleMedium: TextStyle(
        fontFamily: familia,
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: principal,
      ),
      titleSmall: TextStyle(
        fontFamily: familia,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: principal,
      ),
      bodyLarge: TextStyle(
        fontFamily: familia,
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: principal,
      ),
      bodyMedium: TextStyle(
        fontFamily: familia,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: principal,
      ),
      bodySmall: TextStyle(
        fontFamily: familia,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: secundario,
      ),
      labelLarge: TextStyle(
        fontFamily: familia,
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: principal,
      ),
      labelMedium: TextStyle(
        fontFamily: familia,
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: principal,
      ),
      labelSmall: TextStyle(
        fontFamily: familia,
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: secundario,
      ),
    );
  }
}
