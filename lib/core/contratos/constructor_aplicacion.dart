import 'package:flutter/widgets.dart';

import '../integracion/contenedor_dependencias.dart';

/// Contrato de frontera entre core y la capa visual.
///
/// La implementación concreta vive en lib/theme/ y decide navegación,
/// pantallas y apariencia usando únicamente contratos registrados en core.
abstract interface class ConstructorAplicacion {
  Widget construir({
    required Set<String> historiasActivas,
    required ContenedorDependencias contenedor,
  });
}
