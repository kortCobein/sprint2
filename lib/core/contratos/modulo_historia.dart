import 'package:flutter/widgets.dart';

/// Punto de integración estable entre una historia y el núcleo de la app.
///
/// Las historias existentes no necesitan modificarse para implementar este
/// contrato directamente. Un adaptador dentro de core puede envolverlas.
abstract interface class ModuloHistoria {
  /// Identificador estable: us01, us02, ..., us12.
  String get id;

  /// Historias que deben estar activas antes que este módulo.
  List<String> get dependencias;

  /// Rutas que aporta el módulo a la aplicación.
  Iterable<RutaHistoria> get rutas;

  /// Inicialización opcional de controladores, repositorios o estado.
  Future<void> inicializar();
}

/// Ruta expuesta por una historia sin obligar a main.dart a conocer su widget.
final class RutaHistoria {
  const RutaHistoria({
    required this.nombre,
    required this.construir,
    this.requiereSesion = false,
  });

  final String nombre;
  final WidgetBuilder construir;
  final bool requiereSesion;
}
