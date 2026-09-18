/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'producto.dart';
import 'servicio_catalogo_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioCatalogo {
  /// Responsabilidad única: API: Obtiene el catálogo general desde la fuente configurada.
  Future<List<Producto>> obtenerProductos();
}

class RepositorioCatalogoImpl implements RepositorioCatalogo {
  const RepositorioCatalogoImpl(this._api);
  final ApiCatalogo _api;

  /// Responsabilidad única: API: Obtiene el catálogo general desde la fuente configurada.
  @override
  Future<List<Producto>> obtenerProductos() async {
    final datos = await _api.obtenerProductos();
    return datos
        .whereType<Map<String, dynamic>>()
        .map(Producto.desdeJson)
        .toList(growable: false);
  }
}
