import '../../features/e3_kurt/hist06_agregar_producto/controlador_agregar_producto.dart';
import '../../features/e3_kurt/hist06_agregar_producto/repositorio_registro_producto.dart';
import '../../features/e3_kurt/hist06_agregar_producto/servicio_registro_producto_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../datos/almacen_respaldo.dart';
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
      _CrearProductoAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CrearProductoAplicacion implements CrearProductoAplicacion {
  const _CrearProductoAplicacion(this._controlador, this._respaldo);

  final ControladorAgregarProducto _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<ProductoAplicacion> crear({
    required RolAplicacion rol,
    required ProductoAplicacion producto,
  }) async {
    if (!rol.puedeGestionarProductos) {
      throw StateError('No tienes permiso para agregar productos.');
    }

    _validarProducto(producto);

    dynamic creado;
    try {
      creado = await _controlador
          .agregar(
            rolFeatureDesdeAplicacion(rol),
            productoFeatureDesdeAplicacion(producto),
          )
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      creado = null;
    }

    if (creado != null) {
      final convertido = productoAplicacionDesdeFeature(creado);
      return _respaldo.guardarProducto(convertido);
    }

    return _respaldo.crearProducto(producto);
  }
}

void _validarProducto(ProductoAplicacion producto) {
  if (producto.titulo.trim().isEmpty ||
      producto.descripcion.trim().isEmpty ||
      producto.categoria.trim().isEmpty ||
      producto.precio <= 0) {
    throw StateError('Completa título, descripción, categoría y precio válido.');
  }
}
