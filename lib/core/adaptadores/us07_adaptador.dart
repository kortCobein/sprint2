import '../../features/e3_kurt/hist07_editar_producto/controlador_editar_producto.dart';
import '../../features/e3_kurt/hist07_editar_producto/repositorio_actualizacion_producto.dart';
import '../../features/e3_kurt/hist07_editar_producto/servicio_actualizacion_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../datos/almacen_respaldo.dart';
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
      _EditarProductoAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _EditarProductoAplicacion implements EditarProductoAplicacion {
  const _EditarProductoAplicacion(this._controlador, this._respaldo);

  final ControladorEditarProducto _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<ProductoAplicacion> editar({
    required RolAplicacion rol,
    required ProductoAplicacion producto,
  }) async {
    if (!rol.puedeGestionarProductos) {
      throw StateError('No tienes permiso para editar productos.');
    }

    if (producto.id <= 0 ||
        producto.titulo.trim().isEmpty ||
        producto.descripcion.trim().isEmpty ||
        producto.categoria.trim().isEmpty ||
        producto.precio <= 0) {
      throw StateError('Los datos del producto no son válidos.');
    }

    dynamic editado;
    try {
      editado = await _controlador
          .editar(
            rolFeatureDesdeAplicacion(rol),
            productoFeatureDesdeAplicacion(producto),
          )
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      editado = null;
    }

    if (editado != null) {
      return _respaldo.guardarProducto(
        productoAplicacionDesdeFeature(editado),
      );
    }

    return _respaldo.guardarProducto(producto);
  }
}
