/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import '../hist09_agregar_carrito/estado_carrito/linea_carrito.dart';
import 'servicio_gestion_carrito_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioGestionCarrito {
  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  Future<void> actualizar(
    int id,
    int usuario,
    List<LineaCarrito> lineas,
  );
  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  Future<void> eliminar(int id);
}

class RepositorioGestionCarritoImpl implements RepositorioGestionCarrito {
  const RepositorioGestionCarritoImpl(this._api);

  final ApiGestionCarrito _api;

  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  @override
  Future<void> actualizar(
    int id,
    int usuario,
    List<LineaCarrito> lineas,
  ) {
    return _api.actualizar(id, {
      'userId': usuario,
      'date': DateTime.now().toIso8601String(),
      'products': lineas.map((linea) => linea.aJsonApi()).toList(),
    });
  }

  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  @override
  Future<void> eliminar(int id) => _api.eliminar(id);
}
