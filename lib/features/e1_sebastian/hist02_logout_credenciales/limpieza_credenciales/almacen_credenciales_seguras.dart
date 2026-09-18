
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Contrato minimo que US02 necesita para borrar credenciales persistentes.
abstract interface class AlmacenCredenciales {
  /// Responsabilidad única: Elimina las credenciales persistidas del usuario.
  Future<void> limpiarCredenciales();
}

/// Elimina la sesion actual y claves heredadas de versiones anteriores.
class AlmacenCredencialesSeguras implements AlmacenCredenciales {
  AlmacenCredencialesSeguras({FlutterSecureStorage? almacenamiento})
      : _almacenamiento = almacenamiento ?? const FlutterSecureStorage();

  static const String claveSesion = 'auth.session';
  static const String claveTokenAntigua = 'auth.token';
  static const String claveRolAntigua = 'auth.role';
  static const String claveIdAntigua = 'auth.user_id';

  final FlutterSecureStorage _almacenamiento;

  /// Responsabilidad única: Elimina las credenciales persistidas del usuario.
  @override
  Future<void> limpiarCredenciales() async {
    // Se eliminan tanto la clave vigente como las antiguas para evitar residuos.
    await _almacenamiento.delete(key: claveSesion);
    await _almacenamiento.delete(key: claveTokenAntigua);
    await _almacenamiento.delete(key: claveRolAntigua);
    await _almacenamiento.delete(key: claveIdAntigua);
  }
}
