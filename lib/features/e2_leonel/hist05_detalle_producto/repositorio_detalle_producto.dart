/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import '../hist03_catalogo_general/producto.dart';
import 'servicio_detalle_producto_http.dart';

/// Responsabilidad única: Obtiene el recurso solicitado por su identificador o criterio.
/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioDetalleProducto { Future<Producto> obtener(int id); }
class RepositorioDetalleProductoImpl implements RepositorioDetalleProducto {
  const RepositorioDetalleProductoImpl(this._api);
  final ApiDetalleProducto _api;
  /// Responsabilidad única: Consulta la información correspondiente a `obtener` manteniendo esta operación dentro de su responsabilidad.
  @override Future<Producto> obtener(int id) async => Producto.desdeJson(await _api.obtener(id));
}
