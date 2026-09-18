import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../api_config.dart';
import 'excepciones_autenticacion.dart';

/// Contrato de la fuente remota usada por el repositorio.
/// Segregación de interfaces: Contrato pequeño para aislar el consumo HTTP de la lógica de negocio.
/// Inversión de dependencias: Permite reemplazar la fuente remota en pruebas o futuras integraciones.
abstract interface class ApiAutenticacion {
  /// Responsabilidad única: API: Ejecuta el inicio de sesión con las credenciales proporcionadas.
  Future<String> iniciarSesion({
    required String usuario,
    required String contrasena,
  });

  /// Responsabilidad única: API: Consulta la información del usuario necesaria para completar la sesión.
  Future<Map<String, dynamic>> buscarUsuario(String usuario);
}

/// Permite inyectar otra construcción de URI en pruebas sin duplicar ApiConfig.
typedef ConstructorUriApi = Uri Function(String ruta);

/// Verifica conectividad antes de enviar credenciales a la API.
abstract interface class VerificadorConexion {
  /// Responsabilidad única: Verifica conectividad antes de iniciar una petición remota.
  Future<bool> hayConexion(Uri destino);
}

/// Implementación móvil basada en resolución DNS del host del backend.
class VerificadorConexionDns implements VerificadorConexion {
  const VerificadorConexionDns();

  /// Responsabilidad única: Verifica conectividad antes de iniciar una petición remota.
  @override
  Future<bool> hayConexion(Uri destino) async {
    try {
      final direcciones = await InternetAddress.lookup(destino.host)
          .timeout(const Duration(seconds: 4));
      return direcciones.isNotEmpty;
    } catch (_) {
      // En dispositivos móviles con DNS privado o IPv6, lookup puede fallar
      // pero la petición HTTP real sí funciona. Permitimos que continúe.
      return true;
    }
  }
}

/// Implementación HTTP de la responsabilidad de inicio de sesión.
class ServicioAutenticacionHttp implements ApiAutenticacion {
  ServicioAutenticacionHttp({
    http.Client? cliente,
    VerificadorConexion? verificadorConexion,
    ConstructorUriApi? construirUri,
    Duration? tiempoEspera,
  })  : _cliente = cliente ?? http.Client(),
        _verificadorConexion =
            verificadorConexion ?? const VerificadorConexionDns(),
        _construirUri = construirUri ?? ApiConfig.uri,
        _tiempoEspera = tiempoEspera ?? const Duration(seconds: 12);

  final http.Client _cliente;
  final VerificadorConexion _verificadorConexion;
  final ConstructorUriApi _construirUri;
  final Duration _tiempoEspera;

  /// Responsabilidad única: API: Ejecuta el inicio de sesión con las credenciales proporcionadas.
  @override
  Future<String> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    final endpoint = _construirUri('/auth/login');
    await _asegurarConexion(endpoint);

    try {
      final respuesta = await _cliente
          .post(
            endpoint,
            headers: const <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'username': usuario,
              'password': contrasena,
            }),
          )
          .timeout(_tiempoEspera);

      if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
        final datos = jsonDecode(respuesta.body);
        if (datos is! Map<String, dynamic>) {
          throw const ExcepcionAutenticacion(
            'La API devolvio una respuesta invalida.',
          );
        }

        final token = datos['token']?.toString();
        if (token == null || token.isEmpty) {
          throw const ExcepcionAutenticacion(
            'La API no devolvio un token de acceso.',
          );
        }
        return token;
      }

      if (<int>{400, 401, 403}.contains(respuesta.statusCode)) {
        throw const ExcepcionCredencialesInvalidas();
      }

      throw ExcepcionAutenticacion(
        'Error de autenticacion (${respuesta.statusCode}).',
      );
    } on ExcepcionCredencialesInvalidas {
      rethrow;
    } on ExcepcionAutenticacion {
      rethrow;
    } on TimeoutException {
      throw const ExcepcionRed('La solicitud tardo demasiado en responder.');
    } on SocketException {
      throw const ExcepcionRed('No hay conexion a internet.');
    } on http.ClientException {
      throw const ExcepcionRed('No fue posible conectar con el servidor.');
    } on FormatException {
      throw const ExcepcionAutenticacion(
        'La API devolvio datos con formato invalido.',
      );
    }
  }

  /// Responsabilidad única: API: Consulta la información del usuario necesaria para completar la sesión.
  @override
  Future<Map<String, dynamic>> buscarUsuario(String usuario) async {
    final endpoint = _construirUri('/users');
    await _asegurarConexion(endpoint);

    try {
      final respuesta = await _cliente.get(endpoint).timeout(_tiempoEspera);
      if (respuesta.statusCode != 200) {
        throw ExcepcionAutenticacion(
          'No se pudo descargar el usuario (${respuesta.statusCode}).',
        );
      }

      final datos = jsonDecode(respuesta.body);
      if (datos is! List<dynamic>) {
        throw const ExcepcionAutenticacion(
          'La API devolvio una lista de usuarios invalida.',
        );
      }

      for (final elemento in datos) {
        if (elemento is Map<String, dynamic> &&
            elemento['username']?.toString().toLowerCase() ==
                usuario.toLowerCase()) {
          return elemento;
        }
      }

      throw const ExcepcionAutenticacion(
        'El login fue correcto, pero no se encontro el usuario.',
      );
    } on ExcepcionAutenticacion {
      rethrow;
    } on TimeoutException {
      throw const ExcepcionRed('La solicitud tardo demasiado en responder.');
    } on SocketException {
      throw const ExcepcionRed('No hay conexion a internet.');
    } on http.ClientException {
      throw const ExcepcionRed('No fue posible conectar con el servidor.');
    } on FormatException {
      throw const ExcepcionAutenticacion(
        'La API devolvio datos con formato invalido.',
      );
    }
  }

  /// Responsabilidad única: Ejecuta la operación interna `_asegurarConexion` usada únicamente por este componente.
  Future<void> _asegurarConexion(Uri destino) async {
    final disponible = await _verificadorConexion.hayConexion(destino);
    if (!disponible) {
      throw const ExcepcionRed('No hay conexion a internet.');
    }
  }

  /// Libera el cliente HTTP cuando el módulo deje de utilizarse.
  void cerrar() => _cliente.close();
}
