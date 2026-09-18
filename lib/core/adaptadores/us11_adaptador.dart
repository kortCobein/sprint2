import '../../features/e5_julio/hist11_listar_usuarios/controlador_usuarios.dart';
import '../../features/e5_julio/hist11_listar_usuarios/repositorio_usuarios.dart';
import '../../features/e5_julio/hist11_listar_usuarios/servicio_usuarios_http.dart';
import '../contratos/auditoria.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/sesion.dart';
import '../datos/almacen_respaldo.dart';
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
      _UsuariosAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _UsuariosAplicacion implements UsuariosAplicacion {
  const _UsuariosAplicacion(this._controlador, this._respaldo);

  final ControladorUsuarios _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<List<UsuarioAplicacion>> listar(RolAplicacion rol) async {
    if (!rol.puedeAuditar) {
      throw StateError('No tienes permiso para consultar usuarios.');
    }

    try {
      await _controlador
          .cargar(rolFeatureDesdeAplicacion(rol))
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      return _respaldo.listarUsuarios();
    }

    if (_controlador.error == null && _controlador.usuarios.isNotEmpty) {
      return _controlador.usuarios
          .map(usuarioAplicacionDesdeFeature)
          .toList(growable: false);
    }

    return _respaldo.listarUsuarios();
  }
}
