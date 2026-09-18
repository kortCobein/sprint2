import '../../features/e2_leonel/hist04_filtrar_categoria/controlador_filtro_categorias.dart';
import '../../features/e2_leonel/hist04_filtrar_categoria/repositorio_categorias.dart';
import '../../features/e2_leonel/hist04_filtrar_categoria/servicio_categorias_http.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../datos/almacen_respaldo.dart';
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
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _CategoriasAplicacion implements CategoriasAplicacion {
  const _CategoriasAplicacion(
    this._controlador,
    this._catalogo,
    this._respaldo,
  );

  final ControladorFiltroCategorias _controlador;
  final CatalogoAplicacion _catalogo;
  final AlmacenRespaldo _respaldo;

  @override
  Future<List<String>> listarCategorias() async {
    try {
      await _controlador.cargarCategorias().timeout(const Duration(seconds: 12));
    } catch (_) {
      return <String>['Todos', ..._respaldo.listarCategorias()];
    }

    if (_controlador.error == null && _controlador.categorias.isNotEmpty) {
      return List<String>.unmodifiable(_controlador.categorias);
    }

    return <String>['Todos', ..._respaldo.listarCategorias()];
  }

  @override
  Future<List<ProductoAplicacion>> listarPorCategoria(String categoria) async {
    if (categoria.trim().isEmpty ||
        categoria == ControladorFiltroCategorias.todos) {
      return _catalogo.listar();
    }

    try {
      await _controlador.seleccionar(categoria).timeout(const Duration(seconds: 12));
    } catch (_) {
      return _respaldo.listarPorCategoria(categoria);
    }

    if (_controlador.error == null && _controlador.productos.isNotEmpty) {
      return _controlador.productos
          .map(productoAplicacionDesdeFeature)
          .toList(growable: false);
    }

    return _respaldo.listarPorCategoria(categoria);
  }
}
