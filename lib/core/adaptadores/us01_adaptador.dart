import '../../features/e1_sebastian/hist01_login_perfiles/login/almacen_sesion_segura.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/controlador_inicio_sesion.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/repositorio_autenticacion.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/servicio_autenticacion_http.dart';
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
    final repositorio = RepositorioAutenticacionImpl(
      ServicioAutenticacionHttp(),
      AlmacenSesionSegura(),
    );

    final controlador = ControladorInicioSesion(repositorio);
    contenedor.registrar<AutenticacionAplicacion>(
      _AutenticacionAplicacion(controlador),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _AutenticacionAplicacion implements AutenticacionAplicacion {
  const _AutenticacionAplicacion(this._controlador);

  final ControladorInicioSesion _controlador;

  @override
  Future<SesionAplicacion> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    final correcta = await _controlador.iniciarSesion(
      usuario: usuario,
      contrasena: contrasena,
    );

    final sesion = _controlador.sesion;
    if (!correcta || sesion == null) {
      throw StateError(
        _controlador.mensajeError ?? 'No fue posible iniciar sesion.',
      );
    }

    return sesionAplicacionDesdeFeature(sesion);
  }

  @override
  Future<SesionAplicacion?> restaurarSesion() async {
    await _controlador.restaurarSesion();
    final sesion = _controlador.sesion;
    return sesion == null ? null : sesionAplicacionDesdeFeature(sesion);
  }
}
