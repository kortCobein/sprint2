/// Puerto requerido por HIST12 para resolver títulos de producto.
///
/// Segregación de interfaces: La historia depende de una interfaz mínima y no del catálogo concreto.
abstract interface class ProveedorTitulosProducto {
  /// Responsabilidad única: Devuelve la relación de identificadores y títulos requerida por auditoría.
  Future<Map<int, String>> obtenerTitulos();
}
