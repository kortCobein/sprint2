/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api_config.dart';

/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiCategorias {
  /// Responsabilidad única: API: Obtiene las categorías disponibles desde la fuente configurada.
  Future<List<dynamic>> obtenerCategorias();
  /// Responsabilidad única: API: Obtiene el catálogo general desde la fuente configurada.
  Future<List<dynamic>> obtenerProductosPorCategoria(String categoria);
}

class ServicioCategoriasHttp implements ApiCategorias {
  ServicioCategoriasHttp({http.Client? cliente}) : _cliente = cliente ?? http.Client();
  final http.Client _cliente;
  static const _espera = Duration(seconds: 12);

  /// Responsabilidad única: Ejecuta la operación interna `_lista` usada únicamente por este componente.
  Future<List<dynamic>> _lista(Uri uri) async {
    try {
      final respuesta = await _cliente.get(uri).timeout(_espera);
      if (respuesta.statusCode != 200) throw Exception('HTTP ${respuesta.statusCode}');
      final datos = jsonDecode(respuesta.body);
      if (datos is! List<dynamic>) throw const FormatException();
      return datos;
    } on TimeoutException { throw Exception('Tiempo de espera agotado'); }
  }

  /// Responsabilidad única: Consulta la información correspondiente a `obtenerCategorias` manteniendo esta operación dentro de su responsabilidad.
  @override Future<List<dynamic>> obtenerCategorias() => _lista(ApiConfig.uri('/products/categories'));
  @override Future<List<dynamic>> obtenerProductosPorCategoria(String categoria) =>
      _lista(ApiConfig.uri('/products/category/${Uri.encodeComponent(categoria)}'));
}
