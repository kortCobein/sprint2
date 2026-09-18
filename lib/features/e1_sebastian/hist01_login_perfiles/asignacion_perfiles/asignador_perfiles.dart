/// HIST01 - Asignación local de perfiles.
///
/// Este archivo conserva la regla de negocio que convierte el ID obtenido
/// durante el login en un rol de la aplicación.

import 'rol_usuario.dart';

/// Segregación de interfaces: Contrato mínimo para asignar un perfil sin acoplar el login a una
/// implementación concreta.
abstract interface class AsignadorPerfiles {
  /// Responsabilidad única: Aplica la regla de negocio que determina el perfil del usuario.
  RolUsuario asignar(int idUsuario);
}

/// Implementación de la regla local solicitada por US01.
/// Sustitución de Liskov: Puede sustituir al contrato [AsignadorPerfiles] sin cambiar al consumidor.
class AsignadorPerfilesPorId implements AsignadorPerfiles {
  const AsignadorPerfilesPorId();

  /// Responsabilidad única: Aplica la regla de negocio que determina el perfil del usuario.
  @override
  RolUsuario asignar(int idUsuario) {
    if (idUsuario == 1 || idUsuario == 2) return RolUsuario.administrador;
    if (idUsuario == 3) return RolUsuario.auditor;
    return RolUsuario.cliente;
  }
}
