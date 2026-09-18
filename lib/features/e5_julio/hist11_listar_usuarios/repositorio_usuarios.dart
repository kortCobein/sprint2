/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'modelo_usuario.dart';
import 'servicio_usuarios_http.dart';

/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioUsuarios {
  /// Responsabilidad única: Obtiene el recurso solicitado usando el identificador o criterio recibido.
  Future<List<UsuarioTienda>> obtenerUsuarios();
}

class RepositorioUsuariosImpl implements RepositorioUsuarios {
  const RepositorioUsuariosImpl(this._api);

  final ApiUsuarios _api;

  /// Responsabilidad única: Obtiene el recurso solicitado usando el identificador o criterio recibido.
  @override
  Future<List<UsuarioTienda>> obtenerUsuarios() async {
    final datos = await _api.obtenerUsuarios();
    return datos
        .whereType<Map<String, dynamic>>()
        .map(UsuarioTienda.desdeJson)
        .toList(growable: false);
  }
}
