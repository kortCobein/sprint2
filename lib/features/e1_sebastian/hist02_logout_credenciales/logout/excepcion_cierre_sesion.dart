
/// Error funcional al limpiar credenciales o estados sensibles.
class ExcepcionCierreSesion implements Exception {
  const ExcepcionCierreSesion(this.mensaje);

  final String mensaje;

  /// Responsabilidad única: Devuelve una representación textual del error para que otras capas puedan mostrarlo o registrarlo.
  @override
  String toString() => mensaje;
}
