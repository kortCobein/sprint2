/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'package:flutter/foundation.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import 'modelo_usuario.dart';
import 'repositorio_usuarios.dart';

class ControladorUsuarios extends ChangeNotifier {
  ControladorUsuarios(this._repositorio);

  final RepositorioUsuarios _repositorio;
  List<UsuarioTienda> _usuarios = const [];
  bool _cargando = false;
  String? _error;

  List<UsuarioTienda> get usuarios => _usuarios;
  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Carga los datos requeridos por esta historia y notifica el nuevo estado.
  Future<void> cargar(RolUsuario rol) async {
    if (!rol.puedeAuditar) {
      _usuarios = const [];
      _error = 'Acceso restringido.';
      notifyListeners();
      return;
    }

    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _usuarios = await _repositorio.obtenerUsuarios();
    } catch (_) {
      _error = 'No fue posible cargar los usuarios.';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
