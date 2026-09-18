import '../integracion/contenedor_dependencias.dart';

/// Contrato mínimo que representa una User Story dentro del núcleo.
///
/// El código congelado de features no necesita implementar este contrato.
/// Cada historia se conecta mediante un adaptador ubicado en core.
abstract interface class ModuloHistoria {
  /// Identificador estable: us01, us02, ..., us12.
  String get id;

  /// Historias que deben estar activas antes que este módulo.
  List<String> get dependencias;

  /// Registra los contratos que esta historia expone a otras capas.
  void registrarDependencias(ContenedorDependencias contenedor);

  /// Inicializa la historia usando únicamente contratos ya disponibles.
  Future<void> inicializar(ContenedorDependencias contenedor);
}
