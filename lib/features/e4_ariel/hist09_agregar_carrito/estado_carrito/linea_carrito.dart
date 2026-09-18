/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import '../../../e2_leonel/hist03_catalogo_general/producto.dart';

/// Une un producto con la cantidad seleccionada por el cliente.
class LineaCarrito {
  const LineaCarrito({
    required this.producto,
    required this.cantidad,
  });

  final Producto producto;
  final int cantidad;

  /// Responsabilidad única: Calcula y expone el subtotal de esta línea de carrito.
  double get subtotal => producto.precio * cantidad;

  /// Responsabilidad única: Crea una copia cambiando únicamente los campos especificados.
  LineaCarrito copiarCon({int? cantidad}) {
    return LineaCarrito(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  /// Responsabilidad única: Convierte el modelo al formato esperado por la API.
  Map<String, dynamic> aJsonApi() => {
        'productId': producto.id,
        'quantity': cantidad,
      };
}
