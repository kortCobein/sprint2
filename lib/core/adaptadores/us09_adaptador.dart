import '../../features/e4_ariel/hist09_agregar_carrito/controlador_agregar_carrito.dart';
import '../../features/e4_ariel/hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import '../../features/e4_ariel/hist09_agregar_carrito/estado_carrito/linea_carrito.dart';
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
    if (!rol.puedeUsarCarrito) {
      throw StateError('El carrito está disponible únicamente para clientes.');
    }
    if (cantidad <= 0) {
      throw StateError('La cantidad debe ser mayor a cero.');
    }

    var agregado = false;
    try {
      agregado = await _controlador
          .agregar(
            rol: rolFeatureDesdeAplicacion(rol),
            usuario: usuario,
            producto: productoFeatureDesdeAplicacion(producto),
            cantidad: cantidad,
          )
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      agregado = false;
    }

    if (!agregado) {
      final lineas = <LineaCarrito>[..._estado.lineas];
      final indice = lineas.indexWhere(
        (linea) => linea.producto.id == producto.id,
      );

      if (indice >= 0) {
        lineas[indice] = lineas[indice].copiarCon(
          cantidad: lineas[indice].cantidad + cantidad,
        );
      } else {
        lineas.add(
          LineaCarrito(
            producto: productoFeatureDesdeAplicacion(producto),
            cantidad: cantidad,
          ),
        );
      }

      _estado.establecer(
        usuario: usuario,
        lineas: lineas,
        idRemoto: _estado.idRemoto ?? 9000 + usuario,
      );
    }

    return carritoAplicacionDesdeFeature(_estado);
  }
}
