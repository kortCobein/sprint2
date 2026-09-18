/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import '../../e2_leonel/hist03_catalogo_general/producto.dart';

/// Valida localmente antes de gastar una petición HTTP.
class ValidadorProducto {
  const ValidadorProducto();

  /// Responsabilidad única: Validación: Comprueba las reglas locales antes de permitir la operación.
  String? validar(Producto producto) {
    if (producto.titulo.trim().isEmpty) {
      return 'El título es obligatorio.';
    }
    if (producto.precio <= 0) {
      return 'El precio debe ser mayor a cero.';
    }
    if (producto.descripcion.trim().isEmpty) {
      return 'La descripción es obligatoria.';
    }
    if (producto.categoria.trim().isEmpty) {
      return 'La categoría es obligatoria.';
    }

    final uri = Uri.tryParse(producto.imagen.trim());
    final esquemaValido = uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
    if (!esquemaValido) {
      return 'La URL de imagen no es válida.';
    }
    return null;
  }
}
