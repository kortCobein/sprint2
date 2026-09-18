import '../../features/e1_sebastian/hist02_logout_credenciales/limpieza_credenciales/almacen_credenciales_seguras.dart';
import '../../features/e1_sebastian/hist02_logout_credenciales/limpieza_credenciales/limpiador_estado_memoria.dart';
import '../../features/e1_sebastian/hist02_logout_credenciales/logout/controlador_cierre_sesion.dart';
import '../../features/e1_sebastian/hist02_logout_credenciales/logout/repositorio_cierre_sesion.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';

ModuloHistoria crearModulo() => _ModuloUs02();

final class _ModuloUs02 implements ModuloHistoria {
  @override
  String get id => 'us02';

  @override
  List<String> get dependencias => const <String>['us01'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final limpieza = contenedor.obtener<RegistroLimpiezaSesion>();
    final repositorio = RepositorioCierreSesionImpl(
      almacenCredenciales: AlmacenCredencialesSeguras(),
      limpiadores: <LimpiadorEstadoMemoria>[
        LimpiadorEstadoPorFuncion(limpieza.limpiarTodo),
      ],
    );

    contenedor.registrar<CierreSesionAplicacion>(
      _CierreSesionAplicacion(ControladorCierreSesion(repositorio)),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CierreSesionAplicacion implements CierreSesionAplicacion {
  const _CierreSesionAplicacion(this._controlador);

  final ControladorCierreSesion _controlador;

  @override
  Future<void> cerrarSesion() async {
    final correcta = await _controlador.cerrarSesion();
    if (!correcta) {
      throw StateError(
        _controlador.mensajeError ?? 'No fue posible cerrar la sesion.',
      );
    }
  }
}
