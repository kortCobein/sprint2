import '../../features/e4_ariel/hist09_agregar_carrito/controlador_agregar_carrito.dart';
import '../../features/e4_ariel/hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import '../../features/e4_ariel/hist09_agregar_carrito/repositorio_agregar_carrito.dart';
import '../../features/e4_ariel/hist09_agregar_carrito/servicio_agregar_carrito_http.dart';
import '../contratos/carrito.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs09();

final class _ModuloUs09 implements ModuloHistoria {
  @override
  String get id => 'us09';

  @override
  List<String> get dependencias => const <String>['us01', 'us03'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final estado = EstadoCarrito();
    final controlador = ControladorAgregarCarrito(
      RepositorioAgregarCarritoImpl(ServicioAgregarCarritoHttp()),
      estado,
    );

    contenedor
      ..registrar<EstadoCarrito>(estado)
      ..registrar<AgregarCarritoAplicacion>(
        _AgregarCarritoAplicacion(controlador, estado),
      );

    contenedor.obtener<RegistroLimpiezaSesion>().agregar(() async {
      estado.reiniciar();
    });
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _AgregarCarritoAplicacion implements AgregarCarritoAplicacion {
  const _AgregarCarritoAplicacion(this._controlador, this._estado);

  final ControladorAgregarCarrito _controlador;
  final EstadoCarrito _estado;

  @override
  CarritoAplicacion get estado => carritoAplicacionDesdeFeature(_estado);

  @override
  Future<CarritoAplicacion> agregar({
    required RolAplicacion rol,
    required int usuario,
    required ProductoAplicacion producto,
    int cantidad = 1,
  }) async {
    final agregado = await _controlador.agregar(
      rol: rolFeatureDesdeAplicacion(rol),
      usuario: usuario,
      producto: productoFeatureDesdeAplicacion(producto),
      cantidad: cantidad,
    );

    if (!agregado) {
      throw StateError(
        _controlador.error ?? 'No fue posible agregar el producto al carrito.',
      );
    }

    return carritoAplicacionDesdeFeature(_estado);
  }
}
