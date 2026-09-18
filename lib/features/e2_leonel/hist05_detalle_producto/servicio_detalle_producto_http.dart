/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api_config.dart';

/// Responsabilidad única: Obtiene el recurso solicitado por su identificador o criterio.
/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiDetalleProducto { Future<Map<String, dynamic>> obtener(int id); }

class ServicioDetalleProductoHttp implements ApiDetalleProducto {
  ServicioDetalleProductoHttp({http.Client? cliente}) : _cliente = cliente ?? http.Client();
  final http.Client _cliente;
  /// Responsabilidad única: Consulta la información correspondiente a `obtener` manteniendo esta operación dentro de su responsabilidad.
  @override Future<Map<String, dynamic>> obtener(int id) async {
    final respuesta = await _cliente.get(ApiConfig.uri('/products/$id')).timeout(const Duration(seconds: 12));
    if (respuesta.statusCode != 200 || respuesta.body.isEmpty) throw Exception('Producto no disponible');
    final datos = jsonDecode(respuesta.body);
    if (datos is! Map<String, dynamic>) throw Exception('Producto no disponible');
    return datos;
  }
}
