/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import '../../e2_leonel/hist03_catalogo_general/producto.dart';
import 'servicio_registro_producto_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioRegistroProducto {
  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  Future<Producto> crear(Producto producto);
}

/// Traduce entre el modelo Producto y el formato esperado por la API.
class RepositorioRegistroProductoImpl implements RepositorioRegistroProducto {
  const RepositorioRegistroProductoImpl(this._api);

  final ApiRegistroProducto _api;

  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  @override
  Future<Producto> crear(Producto producto) async {
    final respuesta = await _api.crear(producto.aJsonApi());
    final combinado = <String, dynamic>{
      ...producto.aJsonApi(),
      ...respuesta,
      'id': (respuesta['id'] as num?)?.toInt() ?? producto.id,
    };
    return Producto.desdeJson(combinado);
  }
}
