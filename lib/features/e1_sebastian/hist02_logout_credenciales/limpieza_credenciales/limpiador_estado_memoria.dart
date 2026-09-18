
/// Contrato para cualquier estado sensible que deba reiniciarse al cerrar sesion.
///
/// Ejemplos: carrito local, usuario activo, filtros privados o caches de perfil.
abstract interface class LimpiadorEstadoMemoria {
  /// Responsabilidad única: Limpia el estado o almacenamiento responsabilidad de este componente.
  Future<void> limpiar();
}

/// Adaptador sencillo para registrar una funcion como limpiador.
class LimpiadorEstadoPorFuncion implements LimpiadorEstadoMemoria {
  const LimpiadorEstadoPorFuncion(this._accion);

  final Future<void> Function() _accion;

  /// Responsabilidad única: Limpia el estado o almacenamiento responsabilidad de este componente.
  @override
  Future<void> limpiar() => _accion();
}
