/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'package:flutter/foundation.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import 'repositorio_eliminacion_producto.dart';

class ControladorEliminarProducto extends ChangeNotifier {
  ControladorEliminarProducto(this._repositorio);

  final RepositorioEliminacionProducto _repositorio;
  bool _cargando = false;
  String? _error;

  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  Future<bool> eliminar(RolUsuario rol, int id) async {
    if (!rol.puedeGestionarProductos) {
      _error = 'No tienes permiso para eliminar productos.';
      notifyListeners();
      return false;
    }

    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      await _repositorio.eliminar(id);
      return true;
    } catch (_) {
      _error = 'No fue posible eliminar el producto.';
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
