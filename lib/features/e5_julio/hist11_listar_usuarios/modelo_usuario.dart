/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

/// Modelo anidado requerido por la respuesta de /users.
class DireccionUsuario {
  const DireccionUsuario({
    required this.ciudad,
    required this.calle,
    required this.numero,
    required this.cp,
    required this.latitud,
    required this.longitud,
  });

  final String ciudad;
  final String calle;
  final int? numero;
  final String cp;
  final String latitud;
  final String longitud;

  /// Responsabilidad única: Construye el modelo a partir de los datos JSON recibidos.
  factory DireccionUsuario.desdeJson(Map<String, dynamic>? json) {
    final ubicacion = json?['geolocation'];
    final geo = ubicacion is Map<String, dynamic> ? ubicacion : null;
    return DireccionUsuario(
      ciudad: json?['city']?.toString() ?? '',
      calle: json?['street']?.toString() ?? '',
      numero: (json?['number'] as num?)?.toInt(),
      cp: json?['zipcode']?.toString() ?? '',
      latitud: geo?['lat']?.toString() ?? '',
      longitud: geo?['long']?.toString() ?? '',
    );
  }
}

class UsuarioTienda {
  const UsuarioTienda({
    required this.id,
    required this.usuario,
    required this.correo,
    required this.telefono,
    required this.nombre,
    required this.apellido,
    required this.direccion,
  });

  final int id;
  final String usuario;
  final String correo;
  final String telefono;
  final String nombre;
  final String apellido;
  final DireccionUsuario direccion;

  String get nombreCompleto => '$nombre $apellido'.trim();

  /// Responsabilidad única: Construye el modelo a partir de los datos JSON recibidos.
  factory UsuarioTienda.desdeJson(Map<String, dynamic> json) {
    final nombreJson = json['name'];
    final nombreMapa = nombreJson is Map<String, dynamic> ? nombreJson : null;
    final direccionJson = json['address'];

    return UsuarioTienda(
      id: (json['id'] as num?)?.toInt() ?? 0,
      usuario: json['username']?.toString() ?? '',
      correo: json['email']?.toString() ?? '',
      telefono: json['phone']?.toString() ?? '',
      nombre: nombreMapa?['firstname']?.toString() ?? '',
      apellido: nombreMapa?['lastname']?.toString() ?? '',
      direccion: DireccionUsuario.desdeJson(
        direccionJson is Map<String, dynamic> ? direccionJson : null,
      ),
    );
  }
}
