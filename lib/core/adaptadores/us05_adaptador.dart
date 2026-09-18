import '../../features/e2_leonel/hist05_detalle_producto/controlador_detalle_producto.dart';
import '../../features/e2_leonel/hist05_detalle_producto/repositorio_detalle_producto.dart';
import '../../features/e2_leonel/hist05_detalle_producto/servicio_detalle_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../datos/almacen_respaldo.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs05();

final class _ModuloUs05 implements ModuloHistoria {
  @override
  String get id => 'us05';

  @override
  List<String> get dependencias => const <String>['us01', 'us03'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorDetalleProducto(
      RepositorioDetalleProductoImpl(ServicioDetalleProductoHttp()),
    );

    contenedor.registrar<DetalleProductoAplicacion>(
      _DetalleProductoAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _DetalleProductoAplicacion implements DetalleProductoAplicacion {
  const _DetalleProductoAplicacion(this._controlador, this._respaldo);

  final ControladorDetalleProducto _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<ProductoAplicacion> obtener(int id) async {
    try {
      await _controlador.cargar(id).timeout(const Duration(seconds: 12));
    } catch (_) {
      final local = _respaldo.obtenerProducto(id);
      if (local != null) return local;
      throw StateError('Producto no disponible.');
    }

    final producto = _controlador.producto;
    if (producto != null) {
      final convertido = productoAplicacionDesdeFeature(producto);
      _respaldo.guardarProducto(convertido);
      return convertido;
    }

    final local = _respaldo.obtenerProducto(id);
    if (local != null) return local;

    throw StateError(
      _controlador.error ?? 'Producto no disponible.',
    );
  }
}
