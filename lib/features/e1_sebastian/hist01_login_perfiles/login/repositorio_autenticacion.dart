import '../asignacion_perfiles/asignador_perfiles.dart';
import 'almacen_sesion_segura.dart';
import 'excepciones_autenticacion.dart';
import 'servicio_autenticacion_http.dart';
import 'sesion_usuario.dart';

/// Contrato que consume el controlador de login.
///
/// Oculta los detalles de HTTP, persistencia y asignación de perfiles.
/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioAutenticacion {
  /// Responsabilidad única: API: Ejecuta el inicio de sesión con las credenciales proporcionadas.
  Future<SesionUsuario> iniciarSesion({
    required String usuario,
    required String contrasena,
  });

  /// Responsabilidad única: Estado: Recupera la sesión persistida y actualiza el estado del controlador.
  Future<SesionUsuario?> restaurarSesion();
}

/// Coordina el flujo de la HIST01 sin implementar directamente sus detalles.
///
/// La autenticación se delega a [ApiAutenticacion], el guardado a
/// y la asignación del perfil a [AsignadorPerfiles].
class RepositorioAutenticacionImpl implements RepositorioAutenticacion {
  RepositorioAutenticacionImpl(
    this._api,
    this._almacen, {
    AsignadorPerfiles? asignadorPerfiles,
  }) : _asignadorPerfiles =
            asignadorPerfiles ?? const AsignadorPerfilesPorId();

  final ApiAutenticacion _api;
  final AlmacenSesion _almacen;
  final AsignadorPerfiles _asignadorPerfiles;

  /// Responsabilidad única: API: Ejecuta el inicio de sesión con las credenciales proporcionadas.
  @override
  Future<SesionUsuario> iniciarSesion({
    required String usuario,
    required String contrasena,
  }) async {
    final usuarioNormalizado = usuario.trim();

    // 1. La carpeta login se encarga de autenticar las credenciales.
    final token = await _api.iniciarSesion(
      usuario: usuarioNormalizado,
      contrasena: contrasena,
    );

    // 2. Se recuperan los datos del usuario autenticado.
    final datosUsuario = await _api.buscarUsuario(usuarioNormalizado);
    final id = (datosUsuario['id'] as num?)?.toInt();
    if (id == null) {
      throw const ExcepcionAutenticacion(
        'La informacion del usuario no contiene un ID valido.',
      );
    }

    final nombreCrudo = datosUsuario['name'];
    final nombre = nombreCrudo is Map<String, dynamic>
        ? nombreCrudo
        : const <String, dynamic>{};

    // 3. La regla de perfiles vive exclusivamente en asignacion_perfiles/.
    final rol = _asignadorPerfiles.asignar(id);

    final sesion = SesionUsuario(
      id: id,
      usuario: datosUsuario['username']?.toString() ?? usuarioNormalizado,
      correo: datosUsuario['email']?.toString() ?? '',
      nombre: nombre['firstname']?.toString() ?? '',
      apellido: nombre['lastname']?.toString() ?? '',
      rol: rol,
      token: token,
    );

    // La sesión se persiste solo después de construirla correctamente.
    await _almacen.guardar(sesion);
    return sesion;
  }

  /// Responsabilidad única: Estado: Recupera la sesión persistida y actualiza el estado del controlador.
  @override
  Future<SesionUsuario?> restaurarSesion() => _almacen.leer();
}
