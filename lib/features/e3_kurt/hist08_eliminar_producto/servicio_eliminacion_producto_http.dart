/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'package:http/http.dart' as http;
import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiEliminacionProducto {
  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  Future<void> eliminar(int id);
}

class ServicioEliminacionProductoHttp implements ApiEliminacionProducto {
  ServicioEliminacionProductoHttp({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  @override
  Future<void> eliminar(int id) async {
    final respuesta = await _cliente.delete(ApiConfig.uri('/products/$id'));
    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw Exception('Error HTTP ${respuesta.statusCode}');
    }
  }
}
