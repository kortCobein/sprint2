import '../../features/e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/almacen_sesion_segura.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/sesion_usuario.dart';
import '../adaptadores/mapeos.dart';
import '../contratos/sesion.dart';

final class CuentaLocalUT {
  const CuentaLocalUT({
    required this.id,
    required this.usuario,
    required this.nombre,
    required this.rol,
    required this.contrasena,
  });

  final int id;
  final String usuario;
  final String nombre;
  final RolUsuario rol;
  final String contrasena;
}

/// Autenticación local del sprint.
///
/// No depende de Fake Store API. La persistencia es secundaria: un fallo del
/// almacenamiento seguro nunca impide entrar con credenciales válidas.
final class AutenticacionLocalUT implements AutenticacionAplicacion {
  AutenticacionLocalUT({AlmacenSesion? almacen}) : _almacen = almacen;

  static const Map<String, CuentaLocalUT> cuentas = <String, CuentaLocalUT>{
    'admin1': CuentaLocalUT(
      id: 1,
      usuario: 'admin1',
      nombre: 'Administrador 1',
      rol: RolUsuario.administrador,
      contrasena: '1',
    ),
    'admin2': CuentaLocalUT(
      id: 2,
      usuario: 'admin2',
      nombre: 'Administrador 2',
      rol: RolUsuario.administrador,
      contrasena: '2',
    ),
    'auditor1': CuentaLocalUT(
      id: 3,
      usuario: 'auditor1',
      nombre: 'Auditor 1',
      rol: RolUsuario.auditor,
      contrasena: '3',
    ),
    'cliente1': CuentaLocalUT(
      id: 4,
      usuario: 'cliente1',
      nombre: 'Cliente 1',
      rol: RolUsuario.cliente,
      contrasena: '4',
    ),
    'cliente2': CuentaLocalUT(
      id: 5,
      usuario: 'cliente2',
      nombre: 'Cliente 2',
      rol: RolUsuario.cliente,
      contrasena: '5',
    ),
    'cliente3': CuentaLocalUT(
      id: 6,
      usuario: 'cliente3',
      nombre: 'Cliente 3',
      rol: RolUsuario.cliente,
      contrasena: '6',
    ),
  };

  final AlmacenSesion? _almacen;

  @override
  Future<SesionAplicacion> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    final usuarioNormalizado = usuario.trim().toLowerCase();
    final cuenta = cuentas[usuarioNormalizado];

    if (cuenta == null || contrasena.trim() != cuenta.contrasena) {
      throw StateError('Usuario o contraseña inválidos.');
    }

    final sesion = SesionUsuario(
      id: cuenta.id,
      usuario: cuenta.usuario,
      correo: '${cuenta.usuario}@utsjr.local',
      nombre: cuenta.nombre,
      apellido: '',
      rol: cuenta.rol,
      token: 'sesion-local-${cuenta.id}',
    );

    final almacen = _almacen;
    if (almacen != null) {
      try {
        await almacen.guardar(sesion).timeout(const Duration(seconds: 1));
      } catch (_) {
        // El acceso local debe funcionar aunque falle la persistencia.
      }
    }

    return sesionAplicacionDesdeFeature(sesion);
  }

  @override
  Future<SesionAplicacion?> restaurarSesion() async {
    final almacen = _almacen;
    if (almacen == null) return null;

    try {
      final sesion = await almacen.leer().timeout(const Duration(seconds: 1));
      return sesion == null ? null : sesionAplicacionDesdeFeature(sesion);
    } catch (_) {
      return null;
    }
  }
}
