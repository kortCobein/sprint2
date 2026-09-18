/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiActualizacionProducto {
  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  Future<Map<String, dynamic>> actualizar(
    int id,
    Map<String, dynamic> datos,
  );
}

class ServicioActualizacionProductoHttp implements ApiActualizacionProducto {
  ServicioActualizacionProductoHttp({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  @override
  Future<Map<String, dynamic>> actualizar(
    int id,
    Map<String, dynamic> datos,
  ) async {
    final respuesta = await _cliente.put(
      /// Responsabilidad única: Construye la URI final a partir de la URL base y la ruta recibida.
      ApiConfig.uri('/products/$id'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw Exception('Error HTTP ${respuesta.statusCode}');
    }

    final json = jsonDecode(respuesta.body);
    if (json is! Map<String, dynamic>) {
      throw Exception('Respuesta de actualización inválida');
    }
    return json;
  }
}
