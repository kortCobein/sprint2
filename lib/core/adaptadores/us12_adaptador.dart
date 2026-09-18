import '../../features/e5_julio/hist12_historico_carritos/controlador_carritos_auditoria.dart';
import '../../features/e5_julio/hist12_historico_carritos/enriquecedor_carritos.dart';
import '../../features/e5_julio/hist12_historico_carritos/proveedor_titulos_producto.dart';
import '../../features/e5_julio/hist12_historico_carritos/repositorio_carritos_auditoria.dart';
import '../../features/e5_julio/hist12_historico_carritos/servicio_carritos_auditoria_http.dart';
import '../contratos/auditoria.dart';
import '../contratos/modulo_historia.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';
import '../datos/almacen_respaldo.dart';
import '../integracion/contenedor_dependencias.dart';
import 'mapeos.dart';

ModuloHistoria crearModulo() => _ModuloUs12();

final class _ModuloUs12 implements ModuloHistoria {
  @override
  String get id => 'us12';

  @override
  List<String> get dependencias => const <String>['us01'];

  @override
  void registrarDependencias(ContenedorDependencias contenedor) {
    final proveedor = _ProveedorTitulosDesdeCore(
      contenedor.intentarObtener<CatalogoAplicacion>(),
    );

    final controlador = ControladorCarritosAuditoria(
      RepositorioCarritosAuditoriaImpl(
        ServicioCarritosAuditoriaHttp(),
        EnriquecedorCarritos(proveedor),
      ),
    );

    contenedor.registrar<AuditoriaCarritosAplicacion>(
      _AuditoriaCarritosAplicacion(
        controlador,
        contenedor.obtener<AlmacenRespaldo>(),
      ),
    );
  }

  @override
  Future<void> inicializar(ContenedorDependencias contenedor) async {}
}

final class _ProveedorTitulosDesdeCore implements ProveedorTitulosProducto {
  const _ProveedorTitulosDesdeCore(this._catalogo);

  final CatalogoAplicacion? _catalogo;

  @override
  Future<Map<int, String>> obtenerTitulos() async {
    final catalogo = _catalogo;
    if (catalogo == null) {
      return const <int, String>{};
    }

    final productos = await catalogo.listar();
    return <int, String>{
      for (final producto in productos) producto.id: producto.titulo,
    };
  }
}

final class _AuditoriaCarritosAplicacion
    implements AuditoriaCarritosAplicacion {
  const _AuditoriaCarritosAplicacion(this._controlador, this._respaldo);

  final ControladorCarritosAuditoria _controlador;
  final AlmacenRespaldo _respaldo;

  @override
  Future<List<CarritoAuditoriaAplicacion>> listar(RolAplicacion rol) async {
    if (!rol.puedeAuditar) {
      throw StateError('No tienes permiso para consultar carritos.');
    }

    try {
      await _controlador
          .cargar(rolFeatureDesdeAplicacion(rol))
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      return _respaldo.listarCarritosAuditoria();
    }

    if (_controlador.error == null && _controlador.carritos.isNotEmpty) {
      return _controlador.carritos
          .map(carritoAuditoriaDesdeFeature)
          .toList(growable: false);
    }

    return _respaldo.listarCarritosAuditoria();
  }
}
