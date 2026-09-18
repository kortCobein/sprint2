
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'sesion_usuario.dart';

/// Contrato de persistencia. Permite sustituir almacenamiento real por un fake.
abstract interface class AlmacenSesion {
  /// Responsabilidad única: Guarda los datos recibidos en el almacenamiento correspondiente.
  Future<void> guardar(SesionUsuario sesion);
  /// Responsabilidad única: Recupera los datos almacenados sin modificar su contenido.
  Future<SesionUsuario?> leer();
  /// Responsabilidad única: Limpia el estado o almacenamiento responsabilidad de este componente.
  Future<void> limpiar();
}

/// Persistencia de la sesion usando almacenamiento cifrado del dispositivo.
class AlmacenSesionSegura implements AlmacenSesion {
  AlmacenSesionSegura({FlutterSecureStorage? almacenamiento})
      : _almacenamiento = almacenamiento ?? const FlutterSecureStorage();

  /// Esta clave tambien es eliminada por la US02.
  static const String claveSesion = 'auth.session';

  final FlutterSecureStorage _almacenamiento;

  /// Responsabilidad única: Guarda los datos recibidos en el almacenamiento correspondiente.
  @override
  Future<void> guardar(SesionUsuario sesion) {
    return _almacenamiento.write(
      key: claveSesion,
      value: jsonEncode(sesion.aJson()),
    );
  }

  /// Responsabilidad única: Recupera los datos almacenados sin modificar su contenido.
  @override
  Future<SesionUsuario?> leer() async {
    final valor = await _almacenamiento.read(key: claveSesion);
    if (valor == null || valor.isEmpty) return null;

    try {
      final decodificado = jsonDecode(valor);
      if (decodificado is! Map<String, dynamic>) {
        throw const FormatException('Formato de sesion invalido.');
      }
      return SesionUsuario.desdeJson(decodificado);
    } on FormatException {
      // Si la sesion guardada esta corrupta, se elimina para no restaurarla.
      await limpiar();
      return null;
    }
  }

  /// Responsabilidad única: Limpia el estado o almacenamiento responsabilidad de este componente.
  @override
  Future<void> limpiar() => _almacenamiento.delete(key: claveSesion);
}
