import '../../features/e1_sebastian/hist01_login_perfiles/asignacion_perfiles/asignador_perfiles.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/almacen_sesion_segura.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/excepciones_autenticacion.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/repositorio_autenticacion.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/servicio_autenticacion_http.dart';
import '../autenticacion/autenticacion_local_ut.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs01();

final class _ModuloUs01 implements ModuloHistoria {
  @override
  String get id => 'us01';

  @override
  List<String> get dependencias => const <String>[];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final almacen = AlmacenSesionSegura();
    final local = AutenticacionLocalUT(almacen: almacen);
    final remoto = RepositorioAutenticacionImpl(
      ServicioAutenticacionHttp(),
      almacen,
      asignadorPerfiles: const AsignadorPerfilesPorId(),
    );

    contenedor.registrar<AutenticacionAplicacion>(
      _AutenticacionHibrida(
        local: local,
        remoto: remoto,
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _AutenticacionHibrida implements AutenticacionAplicacion {
  _AutenticacionHibrida({
    required this._local,
    required this._remoto,
  });

  final AutenticacionLocalUT _local;
  final RepositorioAutenticacion _remoto;

  @override
  Future<SesionAplicacion> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    final usuarioNormalizado = usuario.trim().toLowerCase();

    // 1. Acceso rápido para cuentas locales conocidas
    if (AutenticacionLocalUT.cuentas.containsKey(usuarioNormalizado)) {
      final cuenta = AutenticacionLocalUT.cuentas[usuarioNormalizado]!;
      if (contrasena.trim() == cuenta.contrasena) {
        return _local.iniciarSesion(
          usuario: usuario,
          contrasena: contrasena,
        );
      }
    }

    // 2. Intento con la API remota (Fake Store API)
    try {
      final sesion = await _remoto.iniciarSesion(
        usuario: usuario.trim(),
        contrasena: contrasena,
      );
      return sesionAplicacionDesdeFeature(sesion);
    } on ExcepcionCredencialesInvalidas {
      throw StateError('Usuario o contraseña inválidos.');
    } on ExcepcionRed catch (error) {
      throw StateError(error.mensaje);
    } on ExcepcionAutenticacion catch (error) {
      throw StateError(error.mensaje);
    } catch (_) {
      if (AutenticacionLocalUT.cuentas.containsKey(usuarioNormalizado)) {
        throw StateError('Usuario o contraseña inválidos.');
      }
      throw StateError(
        'No fue posible autenticar con el servidor. Revisa tu conexión o credenciales.',
      );
    }
  }

  @override
  Future<SesionAplicacion?> restaurarSesion() => _local.restaurarSesion();
}
