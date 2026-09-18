import '../../features/e2_leonel/hist05_detalle_producto/controlador_detalle_producto.dart';
import '../../features/e2_leonel/hist05_detalle_producto/repositorio_detalle_producto.dart';
import '../../features/e2_leonel/hist05_detalle_producto/servicio_detalle_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
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
      _DetalleProductoAplicacion(controlador),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _DetalleProductoAplicacion implements DetalleProductoAplicacion {
  const _DetalleProductoAplicacion(this._controlador);

  final ControladorDetalleProducto _controlador;

  @override
  Future<ProductoAplicacion> obtener(int id) async {
    await _controlador.cargar(id);

    final producto = _controlador.producto;
    if (producto == null) {
      throw StateError(
        _controlador.error ?? 'Producto no disponible.',
      );
    }

    return productoAplicacionDesdeFeature(producto);
  }
}
