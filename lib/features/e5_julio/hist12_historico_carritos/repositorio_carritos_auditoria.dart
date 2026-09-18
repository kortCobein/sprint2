/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'enriquecedor_carritos.dart';
import 'modelo_carrito_auditoria.dart';
import 'servicio_carritos_auditoria_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioCarritosAuditoria {
  /// Responsabilidad única: Obtiene el recurso solicitado usando el identificador o criterio recibido.
  Future<List<CarritoAuditoria>> obtener();
}

class RepositorioCarritosAuditoriaImpl
    implements RepositorioCarritosAuditoria {
  const RepositorioCarritosAuditoriaImpl(this._api, this._enriquecedor);

  final ApiCarritosAuditoria _api;
  final EnriquecedorCarritos _enriquecedor;

  /// Responsabilidad única: Obtiene el recurso solicitado usando el identificador o criterio recibido.
  @override
  Future<List<CarritoAuditoria>> obtener() async {
    final datos = await _api.obtenerCarritos();
    final base = datos
        .whereType<Map<String, dynamic>>()
        .map(CarritoAuditoria.desdeJson)
        .toList(growable: false);
    return _enriquecedor.agregarTitulos(base);
  }
}
