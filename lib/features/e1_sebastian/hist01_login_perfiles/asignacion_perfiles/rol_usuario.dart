enum RolUsuario { administrador, auditor, cliente }

extension PermisosRolUsuario on RolUsuario {
  /// Expone `etiqueta` como estado de solo lectura para sus consumidores.
  String get etiqueta => switch (this) {
        RolUsuario.administrador => 'Administrador',
        RolUsuario.auditor => 'Auditor',
        RolUsuario.cliente => 'Cliente',
      };

  /// Expone `puedeGestionarProductos` como estado de solo lectura para sus consumidores.
  bool get puedeGestionarProductos => this == RolUsuario.administrador;

  /// Expone `puedeUsarCarrito` como estado de solo lectura para sus consumidores.
  bool get puedeUsarCarrito => this == RolUsuario.cliente;

  /// Expone `puedeAuditar` como estado de solo lectura para sus consumidores.
  bool get puedeAuditar =>
      this == RolUsuario.administrador || this == RolUsuario.auditor;
}
