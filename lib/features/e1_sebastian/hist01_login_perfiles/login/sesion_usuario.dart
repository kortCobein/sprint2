
import '../asignacion_perfiles/rol_usuario.dart';

/// Representa exclusivamente los datos necesarios para una sesion autenticada.
class SesionUsuario {
  const SesionUsuario({
    required this.id,
    required this.usuario,
    required this.correo,
    required this.nombre,
    required this.apellido,
    required this.rol,
    required this.token,
  });

  final int id;
  final String usuario;
  final String correo;
  final String nombre;
  final String apellido;
  final RolUsuario rol;
  final String token;

  /// Nombre visible para la interfaz; usa el usuario si la API no entrega nombre.
  String get nombreVisible {
    final nombreCompleto = '$nombre $apellido'.trim();
    return nombreCompleto.isEmpty ? usuario : nombreCompleto;
  }

  /// Serializa la sesion antes de enviarla al almacenamiento seguro.
  Map<String, dynamic> aJson() => <String, dynamic>{
        'id': id,
        'usuario': usuario,
        'correo': correo,
        'nombre': nombre,
        'apellido': apellido,
        'rol': rol.name,
        'token': token,
      };

  /// Reconstruye una sesion validando los campos indispensables.
  factory SesionUsuario.desdeJson(Map<String, dynamic> json) {
    final id = (json['id'] as num?)?.toInt();
    final token = json['token']?.toString();

    if (id == null || token == null || token.isEmpty) {
      throw const FormatException('La sesion almacenada es invalida.');
    }

    return SesionUsuario(
      id: id,
      usuario: json['usuario']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      rol: RolUsuario.values.firstWhere(
        (rol) => rol.name == (json['rol']?.toString() ?? ''),
        orElse: () => RolUsuario.cliente,
      ),
      token: token,
    );
  }
}
