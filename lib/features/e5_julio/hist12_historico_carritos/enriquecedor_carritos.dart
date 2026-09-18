/// HIST12 - Cruce de datos del histórico de carritos.

import 'modelo_carrito_auditoria.dart';
import 'proveedor_titulos_producto.dart';

/// Inversión de dependencias: Depende del contrato [ProveedorTitulosProducto], no de la Épica 2.
class EnriquecedorCarritos {
  const EnriquecedorCarritos(this._proveedor);

  final ProveedorTitulosProducto _proveedor;

  /// Responsabilidad única: Agrega el elemento solicitado respetando permisos y reglas de negocio.
  Future<List<CarritoAuditoria>> agregarTitulos(
    List<CarritoAuditoria> carritos,
  ) async {
    try {
      final titulos = await _proveedor.obtenerTitulos();
      return carritos.map((carrito) {
        final productos = carrito.productos
            .map((item) => item.conTitulo(titulos[item.idProducto]))
            .toList(growable: false);
        return carrito.conProductos(productos);
      }).toList(growable: false);
    } catch (_) {
      return carritos;
    }
  }
}
