import 'package:flutter/widgets.dart';

import '../integracion/contenedor_dependencias.dart';

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

  /// Registra en el contenedor los contratos que este módulo expone.
  void registrarDependencias(ContenedorDependencias contenedor);

  /// Inicializa controladores, repositorios o estado usando contratos ya
  /// registrados por sus dependencias.
  Future<void> inicializar(ContenedorDependencias contenedor);
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
