/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiGestionCarrito {
  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  Future<void> actualizar(int id, Map<String, dynamic> datos);
  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  Future<void> eliminar(int id);
}

class ServicioGestionCarritoHttp implements ApiGestionCarrito {
  ServicioGestionCarritoHttp({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Responsabilidad única: Actualiza el recurso indicado en la fuente correspondiente.
  @override
  Future<void> actualizar(int id, Map<String, dynamic> datos) async {
    final respuesta = await _cliente.put(
      /// Responsabilidad única: Construye la URI final a partir de la URL base y la ruta recibida.
      ApiConfig.uri('/carts/$id'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );
    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw Exception('HTTP ${respuesta.statusCode}');
    }
  }

  /// Responsabilidad única: Elimina el recurso indicado mediante la operación correspondiente.
  @override
  Future<void> eliminar(int id) async {
    final respuesta = await _cliente.delete(ApiConfig.uri('/carts/$id'));
    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw Exception('HTTP ${respuesta.statusCode}');
    }
  }
}
