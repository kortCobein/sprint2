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
    if (!rol.puedeUsarCarrito) {
      throw StateError('El carrito está disponible únicamente para clientes.');
    }

    var correcto = false;
    try {
      correcto = await _controlador
          .cambiarCantidad(
            rol: rolFeatureDesdeAplicacion(rol),
            usuario: usuario,
            productoId: productoId,
            cantidad: cantidad,
          )
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      correcto = false;
    }

    if (!correcto) {
      final lineas = [..._estado.lineas];
      final indice = lineas.indexWhere(
        (linea) => linea.producto.id == productoId,
      );
      if (indice < 0) {
        throw StateError('El producto no está en el carrito.');
      }

      if (cantidad <= 0) {
        lineas.removeAt(indice);
      } else {
        lineas[indice] = lineas[indice].copiarCon(cantidad: cantidad);
      }

      if (lineas.isEmpty) {
        _estado.reiniciar();
      } else {
        _estado.establecer(
          usuario: usuario,
          lineas: lineas,
          idRemoto: _estado.idRemoto ?? 9000 + usuario,
        );
      }
    }

    return carritoAplicacionDesdeFeature(_estado);
  }

  @override
  Future<CarritoAplicacion> quitar({
    required RolAplicacion rol,
    required int usuario,
    required int productoId,
  }) async {
    if (!rol.puedeUsarCarrito) {
      throw StateError('El carrito está disponible únicamente para clientes.');
    }

    var correcto = false;
    try {
      correcto = await _controlador
          .quitar(
            rol: rolFeatureDesdeAplicacion(rol),
            usuario: usuario,
            productoId: productoId,
          )
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      correcto = false;
    }

    if (!correcto) {
      final lineas = _estado.lineas
          .where((linea) => linea.producto.id != productoId)
          .toList(growable: false);

      if (lineas.isEmpty) {
        _estado.reiniciar();
      } else {
        _estado.establecer(
          usuario: usuario,
          lineas: lineas,
          idRemoto: _estado.idRemoto ?? 9000 + usuario,
        );
      }
    }

    return carritoAplicacionDesdeFeature(_estado);
  }
}
