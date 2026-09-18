import '../../features/e3_kurt/hist06_agregar_producto/controlador_agregar_producto.dart';
import '../../features/e3_kurt/hist06_agregar_producto/repositorio_registro_producto.dart';
import '../../features/e3_kurt/hist06_agregar_producto/servicio_registro_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs06();

final class _ModuloUs06 implements ModuloHistoria {
  @override
  String get id => 'us06';

  @override
  List<String> get dependencias => const <String>['us01', 'us03'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorAgregarProducto(
      RepositorioRegistroProductoImpl(ServicioRegistroProductoHttp()),
    );

    contenedor.registrar<CrearProductoAplicacion>(
      _CrearProductoAplicacion(controlador),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CrearProductoAplicacion implements CrearProductoAplicacion {
  const _CrearProductoAplicacion(this._controlador);

  final ControladorAgregarProducto _controlador;

  @override
  Future<ProductoAplicacion> crear({
    required RolAplicacion rol,
    required ProductoAplicacion producto,
  }) async {
    final creado = await _controlador.agregar(
      rolFeatureDesdeAplicacion(rol),
      productoFeatureDesdeAplicacion(producto),
    );

    if (creado == null) {
      throw StateError(
        _controlador.error ?? 'No fue posible crear el producto.',
      );
    }

    return productoAplicacionDesdeFeature(creado);
  }
}
