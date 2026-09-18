
import 'package:flutter/foundation.dart';

import 'excepcion_cierre_sesion.dart';
import 'repositorio_cierre_sesion.dart';

/// Estado de presentacion de la US02.
class ControladorCierreSesion extends ChangeNotifier {
  ControladorCierreSesion(this._repositorio);

  final RepositorioCierreSesion _repositorio;

  bool _cerrando = false;
  String? _mensajeError;

  bool get cerrando => _cerrando;
  String? get mensajeError => _mensajeError;

  /// Devuelve true unicamente si la limpieza sensible termino correctamente.
  Future<bool> cerrarSesion() async {
    if (_cerrando) return false;
    _cambiarEstado(true);
    _mensajeError = null;

    try {
      await _repositorio.cerrarSesion();
      return true;
    } on ExcepcionCierreSesion catch (error) {
      _mensajeError = error.mensaje;
    } catch (_) {
      _mensajeError = 'Ocurrio un error inesperado al cerrar la sesion.';
    } finally {
      _cambiarEstado(false);
    }
    return false;
  }

  /// Responsabilidad única: Ejecuta la operación interna `_cambiarEstado` usada únicamente por este componente.
  void _cambiarEstado(bool valor) {
    _cerrando = valor;
    notifyListeners();
  }
}
