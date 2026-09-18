
import 'package:flutter/foundation.dart';

import 'excepciones_autenticacion.dart';
import 'repositorio_autenticacion.dart';
import 'sesion_usuario.dart';

/// Estado de presentacion de US01.
///
/// Depende del contrato [RepositorioAutenticacion] y no de HTTP directamente.
class ControladorInicioSesion extends ChangeNotifier {
  ControladorInicioSesion(this._repositorio);

  final RepositorioAutenticacion _repositorio;

  SesionUsuario? _sesion;
  bool _cargando = false;
  String? _mensajeError;

  /// Responsabilidad única: Expone la sesión activa conocida por el controlador.
  SesionUsuario? get sesion => _sesion;
  bool get autenticado => _sesion != null;
  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  String? get mensajeError => _mensajeError;

  /// Restaura una sesion valida si existe en almacenamiento seguro.
  Future<void> restaurarSesion() async {
    try {
      _sesion = await _repositorio.restaurarSesion();
      _mensajeError = null;
    } catch (_) {
      _sesion = null;
      _mensajeError = 'No se pudo recuperar la sesion guardada.';
    }
    notifyListeners();
  }

  /// Ejecuta el login y traduce excepciones tecnicas a mensajes de interfaz.
  Future<bool> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    if (_cargando) return false;
    _cambiarCarga(true);
    _mensajeError = null;

    try {
      _sesion = await _repositorio.iniciarSesion(
        usuario: usuario,
        contrasena: contrasena,
      );
      return true;
    } on ExcepcionCredencialesInvalidas {
      _mensajeError = 'Usuario o contrasena invalidos';
    } on ExcepcionRed catch (error) {
      _mensajeError = error.mensaje;
    } on ExcepcionAutenticacion catch (error) {
      _mensajeError = error.mensaje;
    } catch (_) {
      _mensajeError = 'Ocurrio un error inesperado al iniciar sesion.';
    } finally {
      _cambiarCarga(false);
    }
    return false;
  }

  /// Limpia un mensaje previo al editar nuevamente el formulario.
  void limpiarError() {
    if (_mensajeError == null) return;
    _mensajeError = null;
    notifyListeners();
  }

  /// Responsabilidad única: Ejecuta la operación interna `_cambiarCarga` usada únicamente por este componente.
  void _cambiarCarga(bool valor) {
    _cargando = valor;
    notifyListeners();
  }
}
