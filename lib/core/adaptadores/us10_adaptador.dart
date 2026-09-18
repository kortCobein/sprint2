import '../../features/e4_ariel/hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import '../../features/e4_ariel/hist10_gestionar_carrito/controlador_gestion_carrito.dart';
import '../../features/e4_ariel/hist10_gestionar_carrito/repositorio_gestion_carrito.dart';
import '../../features/e4_ariel/hist10_gestionar_carrito/servicio_gestion_carrito_http.dart';
import '../contratos/carrito.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/sesion.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs10();

final class _ModuloUs10 implements ModuloHistoria {
  @override
  String get id => 'us10';

  @override
  List<String> get dependencias => const <String>['us01', 'us09'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final estado = contenedor.obtener<EstadoCarrito>();
    final controlador = ControladorGestionCarrito(
      RepositorioGestionCarritoImpl(ServicioGestionCarritoHttp()),
      estado,
    );

    contenedor.registrar<GestionCarritoAplicacion>(
      _GestionCarritoAplicacion(controlador, estado),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _GestionCarritoAplicacion implements GestionCarritoAplicacion {
  const _GestionCarritoAplicacion(this._controlador, this._estado);

  final ControladorGestionCarrito _controlador;
  final EstadoCarrito _estado;

  @override
  CarritoAplicacion get estado => carritoAplicacionDesdeFeature(_estado);

  @override
  Future<CarritoAplicacion> cambiarCantidad({
    required RolAplicacion rol,
    required int usuario,
    required int productoId,
    required int cantidad,
  }) async {
    final correcto = await _controlador.cambiarCantidad(
      rol: rolFeatureDesdeAplicacion(rol),
      usuario: usuario,
      productoId: productoId,
      cantidad: cantidad,
    );

    if (!correcto) {
      throw StateError(
        _controlador.error ?? 'No fue posible actualizar el carrito.',
      );
    }

    return carritoAplicacionDesdeFeature(_estado);
  }

  @override
  Future<CarritoAplicacion> quitar({
    required RolAplicacion rol,
    required int usuario,
    required int productoId,
  }) async {
    final correcto = await _controlador.quitar(
      rol: rolFeatureDesdeAplicacion(rol),
      usuario: usuario,
      productoId: productoId,
    );

    if (!correcto) {
      throw StateError(
        _controlador.error ?? 'No fue posible quitar el producto.',
      );
    }

    return carritoAplicacionDesdeFeature(_estado);
  }
}
