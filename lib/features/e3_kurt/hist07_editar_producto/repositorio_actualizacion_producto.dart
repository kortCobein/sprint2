/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import '../../e2_leonel/hist03_catalogo_general/producto.dart';
import 'servicio_actualizacion_producto_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioActualizacionProducto {
  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  Future<Producto> actualizar(Producto producto);
}

class RepositorioActualizacionProductoImpl
    implements RepositorioActualizacionProducto {
  const RepositorioActualizacionProductoImpl(this._api);

  final ApiActualizacionProducto _api;

  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  @override
  Future<Producto> actualizar(Producto producto) async {
    final respuesta = await _api.actualizar(
      producto.id,
      producto.aJsonApi(),
    );

    final combinado = <String, dynamic>{
      ...producto.aJsonApi(),
      ...respuesta,
      'id': producto.id,
    };
    return Producto.desdeJson(combinado);
  }
}
