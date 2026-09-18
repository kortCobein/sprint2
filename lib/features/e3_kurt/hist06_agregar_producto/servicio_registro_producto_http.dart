/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_config.dart';

/// Contrato HTTP exclusivo del POST /products de US06.
/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiRegistroProducto {
  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  Future<Map<String, dynamic>> crear(Map<String, dynamic> datos);
}

class ServicioRegistroProductoHttp implements ApiRegistroProducto {
  ServicioRegistroProductoHttp({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  @override
  Future<Map<String, dynamic>> crear(Map<String, dynamic> datos) async {
    final respuesta = await _cliente.post(
      /// Responsabilidad única: Construye la URI final a partir de la URL base y la ruta recibida.
      ApiConfig.uri('/products'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw Exception('Error HTTP ${respuesta.statusCode}');
    }

    final json = jsonDecode(respuesta.body);
    if (json is! Map<String, dynamic>) {
      throw Exception('Respuesta de creación inválida');
    }
    return json;
  }
}
