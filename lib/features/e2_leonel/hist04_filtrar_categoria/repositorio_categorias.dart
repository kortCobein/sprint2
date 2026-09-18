/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import '../hist03_catalogo_general/producto.dart';
import 'servicio_categorias_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioCategorias {
  /// Responsabilidad única: API: Obtiene las categorías disponibles desde la fuente configurada.
  Future<List<String>> obtenerCategorias();
  /// Segregación de interfaces: Define una operación mínima del contrato que la implementación debe cumplir.
  Future<List<Producto>> filtrar(String categoria);
}

class RepositorioCategoriasImpl implements RepositorioCategorias {
  const RepositorioCategoriasImpl(this._api);
  final ApiCategorias _api;

  /// Responsabilidad única: Consulta la información correspondiente a `obtenerCategorias` manteniendo esta operación dentro de su responsabilidad.
  @override Future<List<String>> obtenerCategorias() async =>
      (await _api.obtenerCategorias()).map((e) => e.toString()).toSet().toList()..sort();

  @override Future<List<Producto>> filtrar(String categoria) async =>
      (await _api.obtenerProductosPorCategoria(categoria))
          .whereType<Map<String, dynamic>>().map(Producto.desdeJson).toList(growable: false);
}
