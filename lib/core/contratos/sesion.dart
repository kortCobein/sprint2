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
