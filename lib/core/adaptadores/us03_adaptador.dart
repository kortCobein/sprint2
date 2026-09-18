import '../../features/e2_leonel/hist03_catalogo_general/controlador_catalogo.dart';
import '../../features/e2_leonel/hist03_catalogo_general/repositorio_catalogo.dart';
import '../../features/e2_leonel/hist03_catalogo_general/servicio_catalogo_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
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
      _CatalogoAplicacion(controlador),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CatalogoAplicacion implements CatalogoAplicacion {
  const _CatalogoAplicacion(this._controlador);

  final ControladorCatalogo _controlador;

  @override
  Future<List<ProductoAplicacion>> listar() async {
    await _controlador.cargar();

    if (_controlador.error != null) {
      throw StateError(_controlador.error!);
    }

    return _controlador.productos
        .map(productoAplicacionDesdeFeature)
        .toList(growable: false);
  }
}
