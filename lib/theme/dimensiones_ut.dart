import 'package:flutter/widgets.dart';

/// Escala de espaciado, radios y tamaños de la interfaz UT.
abstract final class DimensionesUT {
  static const double espacio2 = 2;
  static const double espacio4 = 4;
  static const double espacio8 = 8;
  static const double espacio10 = 10;
  static const double espacio12 = 12;
  static const double espacio14 = 14;
  static const double espacio16 = 16;
  static const double espacio20 = 20;
  static const double espacio24 = 24;
  static const double espacio32 = 32;
  static const double espacio40 = 40;
  static const double espacio48 = 48;

  static const double radioPequeno = 10;
  static const double radioMedio = 16;
  static const double radioGrande = 22;
  static const double radioCapsula = 999;

  static const double alturaControl = 52;
  static const double alturaBoton = 50;
  static const double alturaNavbar = 70;
  static const double anchoContenido = 1180;
  static const double anchoFormulario = 620;
  static const double anchoDetalle = 900;

  static const EdgeInsets pagina = EdgeInsets.symmetric(
    horizontal: espacio20,
    vertical: espacio20,
  );

  static const EdgeInsets panel = EdgeInsets.all(espacio20);
  static const EdgeInsets control = EdgeInsets.symmetric(
    horizontal: espacio16,
    vertical: espacio14,
  );

  static EdgeInsets paginaResponsive(double ancho) {
    if (ancho >= 1100) {
      return const EdgeInsets.symmetric(
        horizontal: espacio32,
        vertical: espacio24,
      );
    }
    if (ancho >= 700) {
      return const EdgeInsets.symmetric(
        horizontal: espacio24,
        vertical: espacio20,
      );
    }
    return pagina;
  }
}
