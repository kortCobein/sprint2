/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import '../hist09_agregar_carrito/estado_carrito/linea_carrito.dart';
import 'servicio_agregar_carrito_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioAgregarCarrito {
  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  Future<int> crear(int usuario, List<LineaCarrito> lineas);
}

class RepositorioAgregarCarritoImpl implements RepositorioAgregarCarrito {
  const RepositorioAgregarCarritoImpl(this._api);

  final ApiAgregarCarrito _api;

  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  @override
  Future<int> crear(int usuario, List<LineaCarrito> lineas) async {
    final respuesta = await _api.crear({
      'userId': usuario,
      'date': DateTime.now().toIso8601String(),
      'products': lineas.map((linea) => linea.aJsonApi()).toList(),
    });

    return (respuesta['id'] as num?)?.toInt() ??
        DateTime.now().millisecondsSinceEpoch;
  }
}
