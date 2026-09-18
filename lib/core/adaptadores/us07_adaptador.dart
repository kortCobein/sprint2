import '../../features/e3_kurt/hist07_editar_producto/controlador_editar_producto.dart';
import '../../features/e3_kurt/hist07_editar_producto/repositorio_actualizacion_producto.dart';
import '../../features/e3_kurt/hist07_editar_producto/servicio_actualizacion_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs07();

final class _ModuloUs07 implements ModuloHistoria {
  @override
  String get id => 'us07';

  @override
  List<String> get dependencias =>
      const <String>['us01', 'us03', 'us06'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorEditarProducto(
      RepositorioActualizacionProductoImpl(
        ServicioActualizacionProductoHttp(),
      ),
    );

    contenedor.registrar<EditarProductoAplicacion>(
      _EditarProductoAplicacion(controlador),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _EditarProductoAplicacion implements EditarProductoAplicacion {
  const _EditarProductoAplicacion(this._controlador);

  final ControladorEditarProducto _controlador;

  @override
  Future<ProductoAplicacion> editar({
    required RolAplicacion rol,
    required ProductoAplicacion producto,
  }) async {
    final editado = await _controlador.editar(
      rolFeatureDesdeAplicacion(rol),
      productoFeatureDesdeAplicacion(producto),
    );

    if (editado == null) {
      throw StateError(
        _controlador.error ?? 'No fue posible editar el producto.',
      );
    }

    return productoAplicacionDesdeFeature(editado);
  }
}
