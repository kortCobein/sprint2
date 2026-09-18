import 'package:flutter/material.dart';

import 'colores_ut.dart';
import 'dimensiones_ut.dart';
import 'tipografia_ut.dart';

/// Punto de entrada del sistema visual UT.
///
/// El agente de integración puede aplicar [AppThemeUT.claro] o
/// [AppThemeUT.oscuro] directamente en MaterialApp sin modificar features.
abstract final class AppThemeUT {
  static ThemeData get claro => _construir(Brightness.light);
  static ThemeData get oscuro => _construir(Brightness.dark);

  static ThemeData _construir(Brightness brillo) {
    final esOscuro = brillo == Brightness.dark;
    final esquema = ColorScheme(
      brightness: brillo,
      primary: ColoresUT.verde,
      onPrimary: Colors.white,
      primaryContainer:
          esOscuro ? ColoresUT.verdeOscuro : ColoresUT.verdeClaro,
      onPrimaryContainer:
          esOscuro ? ColoresUT.textoSobreOscuro : ColoresUT.verdeOscuro,
      secondary: esOscuro ? ColoresUT.azulMedio : ColoresUT.azul,
      onSecondary: Colors.white,
      secondaryContainer:
          esOscuro ? ColoresUT.azulOscuro : ColoresUT.azulClaro,
      onSecondaryContainer:
          esOscuro ? ColoresUT.textoSobreOscuro : ColoresUT.azulOscuro,
      tertiary: ColoresUT.informacion,
      onTertiary: Colors.white,
      error: ColoresUT.error,
      onError: Colors.white,
      surface:
          esOscuro ? ColoresUT.superficieOscura : ColoresUT.superficieClara,
      onSurface:
          esOscuro ? ColoresUT.textoSobreOscuro : ColoresUT.textoPrincipal,
      outline: esOscuro ? ColoresUT.bordeOscuro : ColoresUT.bordeClaro,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface:
          esOscuro ? ColoresUT.superficieClara : ColoresUT.superficieOscura,
      onInverseSurface:
          esOscuro ? ColoresUT.textoPrincipal : ColoresUT.textoSobreOscuro,
      inversePrimary: ColoresUT.verde,
    );

    final texto = TipografiaUT.construir(
      principal:
          esOscuro ? ColoresUT.textoSobreOscuro : ColoresUT.textoPrincipal,
      secundario: esOscuro
          ? ColoresUT.textoSecundarioOscuro
          : ColoresUT.textoSecundario,
    );

    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(DimensionesUT.radioMedio),
      borderSide: BorderSide(color: esquema.outline),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brillo,
      colorScheme: esquema,
      scaffoldBackgroundColor:
          esOscuro ? ColoresUT.fondoOscuro : ColoresUT.fondoClaro,
      textTheme: texto,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: esquema.onSurface,
        titleTextStyle: texto.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: esOscuro
            ? ColoresUT.superficieSecundariaOscura
            : ColoresUT.superficieClara,
        contentPadding: DimensionesUT.control,
        border: borde,
        enabledBorder: borde,
        focusedBorder: borde.copyWith(
          borderSide: const BorderSide(
            color: ColoresUT.verde,
            width: 1.8,
          ),
        ),
        errorBorder: borde.copyWith(
          borderSide: const BorderSide(color: ColoresUT.error),
        ),
        focusedErrorBorder: borde.copyWith(
          borderSide: const BorderSide(
            color: ColoresUT.error,
            width: 1.8,
          ),
        ),
        labelStyle: texto.bodyMedium,
        hintStyle: texto.bodyMedium?.copyWith(
          color: esOscuro
              ? ColoresUT.textoSecundarioOscuro
              : ColoresUT.textoSecundario,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: esquema.outline.withValues(alpha: .7),
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, DimensionesUT.alturaBoton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionesUT.radioMedio),
          ),
          textStyle: texto.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionesUT.espacio20,
            vertical: DimensionesUT.espacio12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, DimensionesUT.alturaBoton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionesUT.radioMedio),
          ),
          side: BorderSide(color: esquema.outline),
          textStyle: texto.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionesUT.espacio20,
            vertical: DimensionesUT.espacio12,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: texto.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionesUT.radioPequeno),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionesUT.radioMedio),
        ),
        backgroundColor:
            esOscuro ? ColoresUT.superficieClara : ColoresUT.superficieOscura,
        contentTextStyle: texto.bodyMedium?.copyWith(
          color:
              esOscuro ? ColoresUT.textoPrincipal : ColoresUT.textoSobreOscuro,
        ),
      ),
    );
  }
}
