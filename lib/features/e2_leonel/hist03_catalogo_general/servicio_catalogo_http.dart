/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiCatalogo {
  /// Responsabilidad única: API: Obtiene el catálogo general desde la fuente configurada.
  Future<List<dynamic>> obtenerProductos();
}

/// Únicamente conoce HTTP y el endpoint GET /products.
class ServicioCatalogoHttp implements ApiCatalogo {
  ServicioCatalogoHttp({http.Client? cliente}) : _cliente = cliente ?? http.Client();
  final http.Client _cliente;
  static const _espera = Duration(seconds: 12);

  /// Responsabilidad única: API: Obtiene el catálogo general desde la fuente configurada.
  @override
  Future<List<dynamic>> obtenerProductos() async {
    try {
      final respuesta = await _cliente.get(ApiConfig.uri('/products')).timeout(_espera);
      if (respuesta.statusCode != 200) {
        throw ExcepcionCatalogo('Error HTTP ${respuesta.statusCode}');
      }
      final datos = jsonDecode(respuesta.body);
      if (datos is! List<dynamic>) throw const ExcepcionCatalogo('Respuesta inválida');
      return datos;
    } on TimeoutException {
      throw const ExcepcionCatalogo('La solicitud agotó el tiempo de espera');
    } on http.ClientException {
      throw const ExcepcionCatalogo('No se pudo conectar con el servidor');
    } on FormatException {
      throw const ExcepcionCatalogo('La API devolvió datos inválidos');
    }
  }
}

class ExcepcionCatalogo implements Exception {
  const ExcepcionCatalogo(this.mensaje);
  final String mensaje;
  /// Responsabilidad única: Devuelve una representación textual del error para que otras capas puedan mostrarlo o registrarlo.
  @override String toString() => mensaje;
}
