/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiAgregarCarrito {
  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  Future<Map<String, dynamic>> crear(Map<String, dynamic> datos);
}

class ServicioAgregarCarritoHttp implements ApiAgregarCarrito {
  ServicioAgregarCarritoHttp({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Responsabilidad única: Crea el recurso después de recibir datos previamente validados.
  @override
  Future<Map<String, dynamic>> crear(Map<String, dynamic> datos) async {
    final respuesta = await _cliente.post(
      /// Responsabilidad única: Construye la URI final a partir de la URL base y la ruta recibida.
      ApiConfig.uri('/carts'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw Exception('HTTP ${respuesta.statusCode}');
    }

    final json = jsonDecode(respuesta.body);
    if (json is! Map<String, dynamic>) {
      throw Exception('Carrito inválido');
    }
    return json;
  }
}
