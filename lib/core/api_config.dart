/// Configuración central de comunicación remota.
///
/// Para este Sprint se usa Fake Store API como origen temporal. Cuando el
/// backend intermediario del equipo esté disponible, sólo debe cambiarse
/// [baseUrl].
abstract final class ApiConfig {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Uri uri(String path) {
    final ruta = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$ruta');
  }
}
