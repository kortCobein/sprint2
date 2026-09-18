
/// Error especifico cuando la API rechaza usuario o contrasena.
class ExcepcionCredencialesInvalidas implements Exception {
  const ExcepcionCredencialesInvalidas();
}

/// Error asociado con conectividad, DNS, timeout o transporte HTTP.
class ExcepcionRed implements Exception {
  const ExcepcionRed(this.mensaje);

  final String mensaje;

  /// Responsabilidad única: Devuelve una representación textual del error para que otras capas puedan mostrarlo o registrarlo.
  @override
  String toString() => mensaje;
}

/// Error funcional de autenticacion o de formato de datos.
class ExcepcionAutenticacion implements Exception {
  const ExcepcionAutenticacion(this.mensaje);

  final String mensaje;

  /// Responsabilidad única: Devuelve una representación textual del error para que otras capas puedan mostrarlo o registrarlo.
  @override
  String toString() => mensaje;
}
