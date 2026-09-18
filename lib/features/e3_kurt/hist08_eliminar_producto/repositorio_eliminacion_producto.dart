/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'servicio_eliminacion_producto_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioEliminacionProducto {
  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  Future<void> eliminar(int id);
}

class RepositorioEliminacionProductoImpl
    implements RepositorioEliminacionProducto {
  const RepositorioEliminacionProductoImpl(this._api);

  final ApiEliminacionProducto _api;

  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  @override
  Future<void> eliminar(int id) => _api.eliminar(id);
}
