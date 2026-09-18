import 'dart:async';

enum RolAplicacion { administrador, auditor, cliente }

extension PermisosRolAplicacion on RolAplicacion {
  bool get puedeGestionarProductos => this == RolAplicacion.administrador;
  bool get puedeUsarCarrito => this == RolAplicacion.cliente;
  bool get puedeAuditar =>
      this == RolAplicacion.administrador || this == RolAplicacion.auditor;
}

final class SesionAplicacion {
  const SesionAplicacion({
    required this.id,
    required this.usuario,
    required this.correo,
    required this.nombreVisible,
    required this.rol,
  });

  final int id;
  final String usuario;
  final String correo;
  final String nombreVisible;
  final RolAplicacion rol;
}

abstract interface class AutenticacionAplicacion {
  Future<SesionAplicacion> iniciarSesion({
    required String usuario,
    required String contrasena,
  });

  Future<SesionAplicacion?> restaurarSesion();
}

abstract interface class CierreSesionAplicacion {
  Future<void> cerrarSesion();
}

/// Registro compartido para estados en memoria que deben limpiarse al salir.
///
/// US09 puede registrar el carrito y US02 ejecuta todos los limpiadores sin
/// depender directamente de la implementación del carrito.
final class RegistroLimpiezaSesion {
  final List<FutureOr<void> Function()> _limpiadores =
      <FutureOr<void> Function()>[];

  void agregar(FutureOr<void> Function() limpiador) {
    _limpiadores.add(limpiador);
  }

  Future<void> limpiarTodo() async {
    for (final limpiador in _limpiadores) {
      await limpiador();
    }
  }
}
