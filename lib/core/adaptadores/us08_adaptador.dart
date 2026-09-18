import '../../features/e3_kurt/hist08_eliminar_producto/controlador_eliminar_producto.dart';
import '../../features/e3_kurt/hist08_eliminar_producto/repositorio_eliminacion_producto.dart';
import '../../features/e3_kurt/hist08_eliminar_producto/servicio_eliminacion_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../datos/almacen_respaldo.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs08();

final class _ModuloUs08 implements ModuloHistoria {
  @override
  String get id => 'us08';

  @override
  List<String> get dependencias => const <String>['us01'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorEliminarProducto(
      RepositorioEliminacionProductoImpl(
        ServicioEliminacionProductoHttp(),
      ),
    );

    contenedor.registrar<EliminarProductoAplicacion>(
      _EliminarProductoAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _EliminarProductoAplicacion implements EliminarProductoAplicacion {
  const _EliminarProductoAplicacion(this._controlador, this._respaldo);

  final ControladorEliminarProducto _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<void> eliminar({
    required RolAplicacion rol,
    required int id,
  }) async {
    if (!rol.puedeGestionarProductos) {
      throw StateError('No tienes permiso para eliminar productos.');
    }

    try {
      await _controlador
          .eliminar(
            rolFeatureDesdeAplicacion(rol),
            id,
          )
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      // La eliminación se mantiene en el respaldo local para la demostración.
    }

    _respaldo.eliminarProducto(id);
  }
}
