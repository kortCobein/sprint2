/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'package:flutter/foundation.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import 'modelo_carrito_auditoria.dart';
import 'repositorio_carritos_auditoria.dart';

class ControladorCarritosAuditoria extends ChangeNotifier {
  ControladorCarritosAuditoria(this._repositorio);

  final RepositorioCarritosAuditoria _repositorio;
  List<CarritoAuditoria> _carritos = const [];
  bool _cargando = false;
  String? _error;

  List<CarritoAuditoria> get carritos => _carritos;
  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Carga los datos requeridos por esta historia y notifica el nuevo estado.
  Future<void> cargar(RolUsuario rol) async {
    if (!rol.puedeAuditar) {
      _carritos = const [];
      _error = 'Acceso restringido.';
      notifyListeners();
      return;
    }

    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _carritos = await _repositorio.obtener();
    } catch (_) {
      _error = 'No fue posible cargar el histórico de carritos.';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
