import 'package:flutter/widgets.dart';

import 'modulo_historia.dart';

/// Separa la composición funcional del aspecto visual.
///
/// La implementación concreta puede vivir en lib/theme/ y recibir los módulos
/// activos ya validados por core.
abstract interface class ConstructorAplicacion {
  Widget construir({
    required List<ModuloHistoria> modulos,
  });
}
