/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiCarritosAuditoria {
  /// Responsabilidad única: Obtiene el recurso solicitado usando el identificador o criterio recibido.
  Future<List<dynamic>> obtenerCarritos();
}

class ServicioCarritosAuditoriaHttp implements ApiCarritosAuditoria {
  ServicioCarritosAuditoriaHttp({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Responsabilidad única: Obtiene el recurso solicitado usando el identificador o criterio recibido.
  @override
  Future<List<dynamic>> obtenerCarritos() async {
    final respuesta = await _cliente.get(ApiConfig.uri('/carts'));
    if (respuesta.statusCode != 200) {
      throw Exception('HTTP ${respuesta.statusCode}');
    }

    final json = jsonDecode(respuesta.body);
    if (json is! List<dynamic>) {
      throw Exception('Lista de carritos inválida');
    }
    return json;
  }
}
