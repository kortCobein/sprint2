import '../../features/e5_julio/hist11_listar_usuarios/controlador_usuarios.dart';
import '../../features/e5_julio/hist11_listar_usuarios/repositorio_usuarios.dart';
import '../../features/e5_julio/hist11_listar_usuarios/servicio_usuarios_http.dart';
import '../contratos/auditoria.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs11();

final class _ModuloUs11 implements ModuloHistoria {
  @override
  String get id => 'us11';

  @override
  List<String> get dependencias => const <String>['us01'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorUsuarios(
      RepositorioUsuariosImpl(ServicioUsuariosHttp()),
    );

    contenedor.registrar<UsuariosAplicacion>(
      _UsuariosAplicacion(controlador),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _UsuariosAplicacion implements UsuariosAplicacion {
  const _UsuariosAplicacion(this._controlador);

  final ControladorUsuarios _controlador;

  @override
  Future<List<UsuarioAplicacion>> listar(RolAplicacion rol) async {
    await _controlador.cargar(rolFeatureDesdeAplicacion(rol));

    if (_controlador.error != null) {
      throw StateError(_controlador.error!);
    }

    return _controlador.usuarios
        .map(usuarioAplicacionDesdeFeature)
        .toList(growable: false);
  }
}
