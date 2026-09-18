import '../../features/e2_leonel/hist03_catalogo_general/controlador_catalogo.dart';
import '../../features/e2_leonel/hist03_catalogo_general/repositorio_catalogo.dart';
import '../../features/e2_leonel/hist03_catalogo_general/servicio_catalogo_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../datos/almacen_respaldo.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs03();

final class _ModuloUs03 implements ModuloHistoria {
  @override
  String get id => 'us03';

  @override
  List<String> get dependencias => const <String>[];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorCatalogo(
      RepositorioCatalogoImpl(ServicioCatalogoHttp()),
    );

    contenedor.registrar<CatalogoAplicacion>(
      _CatalogoAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CatalogoAplicacion implements CatalogoAplicacion {
  const _CatalogoAplicacion(this._controlador, this._respaldo);

  final ControladorCatalogo _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<List<ProductoAplicacion>> listar() async {
    try {
      await _controlador.cargar().timeout(const Duration(seconds: 12));
    } catch (_) {
      return _respaldo.listarProductos();
    }

    if (_controlador.error == null && _controlador.productos.isNotEmpty) {
      final productos = _controlador.productos
          .map(productoAplicacionDesdeFeature)
          .toList(growable: false);
      _respaldo.reemplazarProductos(productos);
      return productos;
    }

    return _respaldo.listarProductos();
  }
}
