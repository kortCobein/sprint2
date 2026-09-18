import 'package:flutter/material.dart';

/// Paleta visual institucional de la Universidad Tecnológica de San Juan del Río.
///
/// Esta clase no contiene reglas de negocio. Centraliza colores reutilizables
/// para que todos los módulos presenten la misma identidad visual.
abstract final class ColoresUT {
  static const Color verde = Color(0xFF009D81);
  static const Color azul = Color(0xFF00245A);

  static const Color verdeOscuro = Color(0xFF006B59);
  static const Color verdeClaro = Color(0xFFD8F3EC);
  static const Color verdeMuyClaro = Color(0xFFF0FAF7);

  static const Color azulOscuro = Color(0xFF001735);
  static const Color azulMedio = Color(0xFF174B82);
  static const Color azulClaro = Color(0xFFDCE7F4);
  static const Color azulMuyClaro = Color(0xFFF2F6FB);

  static const Color fondoClaro = Color(0xFFF6F9F8);
  static const Color superficieClara = Color(0xFFFFFFFF);
  static const Color superficieSecundariaClara = Color(0xFFEEF4F2);

  static const Color fondoOscuro = Color(0xFF0B1214);
  static const Color superficieOscura = Color(0xFF121C1F);
  static const Color superficieSecundariaOscura = Color(0xFF19262A);

  static const Color textoPrincipal = Color(0xFF14201F);
  static const Color textoSecundario = Color(0xFF536462);
  static const Color textoSobreOscuro = Color(0xFFF4F8F7);
  static const Color textoSecundarioOscuro = Color(0xFFB8C8C5);

  static const Color bordeClaro = Color(0xFFD8E3E0);
  static const Color bordeOscuro = Color(0xFF2A3B3F);

  static const Color error = Color(0xFFB3261E);
  static const Color errorClaro = Color(0xFFFFDAD6);
  static const Color advertencia = Color(0xFF9A6700);
  static const Color exito = Color(0xFF18794E);
  static const Color informacion = Color(0xFF245EA8);

  static const Color rolAdministrador = azul;
  static const Color rolCliente = verde;
  static const Color rolAuditor = Color(0xFF6D4C8D);
}
