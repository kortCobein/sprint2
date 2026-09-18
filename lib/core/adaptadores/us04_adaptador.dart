import '../../features/e2_leonel/hist04_filtrar_categoria/controlador_filtro_categorias.dart';
import '../../features/e2_leonel/hist04_filtrar_categoria/repositorio_categorias.dart';
import '../../features/e2_leonel/hist04_filtrar_categoria/servicio_categorias_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs04();

final class _ModuloUs04 implements ModuloHistoria {
  @override
  String get id => 'us04';

  @override
  List<String> get dependencias => const <String>['us03'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final controlador = ControladorFiltroCategorias(
      RepositorioCategoriasImpl(ServicioCategoriasHttp()),
    );

    contenedor.registrar<CategoriasAplicacion>(
      _CategoriasAplicacion(
        controlador,
        contenedor.obtener<CatalogoAplicacion>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CategoriasAplicacion implements CategoriasAplicacion {
  const _CategoriasAplicacion(this._controlador, this._catalogo);

  final ControladorFiltroCategorias _controlador;
  final CatalogoAplicacion _catalogo;

  @override
  Future<List<String>> listarCategorias() async {
    await _controlador.cargarCategorias();
    return List<String>.unmodifiable(_controlador.categorias);
  }

  @override
  Future<List<ProductoAplicacion>> listarPorCategoria(String categoria) async {
    if (categoria.trim().isEmpty ||
        categoria == ControladorFiltroCategorias.todos) {
      return _catalogo.listar();
    }

    await _controlador.seleccionar(categoria);

    if (_controlador.error != null) {
      throw StateError(_controlador.error!);
    }

    return _controlador.productos
        .map(productoAplicacionDesdeFeature)
        .toList(growable: false);
  }
}
