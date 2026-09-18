/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'package:flutter/foundation.dart';
import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../../e2_leonel/hist03_catalogo_general/producto.dart';
import '../hist06_agregar_producto/validador_producto.dart';
import 'repositorio_registro_producto.dart';

class ControladorAgregarProducto extends ChangeNotifier {
  ControladorAgregarProducto(
    this._repositorio, {
    ValidadorProducto? validador,
  }) : _validador = validador ?? const ValidadorProducto();
  final RepositorioRegistroProducto _repositorio;
  final ValidadorProducto _validador;
  bool _cargando = false;
  String? _error;
  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;

  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Agrega el elemento solicitado respetando permisos y reglas de negocio.
  Future<Producto?> agregar(RolUsuario rol, Producto p) async {
    if (!rol.puedeGestionarProductos) {
      _error = 'No tienes permiso para agregar productos.';
      notifyListeners();
      return null;
    }

    _error = _validador.validar(p);
    if (_error != null) {
      notifyListeners();
      return null;
    }

    _cargando = true;
    notifyListeners();
    try {
      return await _repositorio.crear(p);
    } catch (_) {
      _error = 'No fue posible crear el producto.';
      return null;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
