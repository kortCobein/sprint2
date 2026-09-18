
import '../limpieza_credenciales/almacen_credenciales_seguras.dart';
import '../limpieza_credenciales/limpiador_estado_memoria.dart';
import 'excepcion_cierre_sesion.dart';

/// Contrato consumido por el controlador de cierre de sesión.
/// Inversión de dependencias: El controlador depende de este contrato, no de una implementación concreta.
/// Segregación de interfaces: El contrato expone únicamente operaciones necesarias para esta historia.
abstract interface class RepositorioCierreSesion {
  /// Responsabilidad única: Coordina el cierre de sesión y la limpieza de datos sensibles.
  Future<void> cerrarSesion();
}

/// Coordina el logout con la limpieza de credenciales y estados sensibles.
///
/// La carpeta logout/ inicia el proceso; la limpieza concreta vive en
/// limpieza_credenciales/ para mantener separadas ambas responsabilidades.
class RepositorioCierreSesionImpl implements RepositorioCierreSesion {
  const RepositorioCierreSesionImpl({
    required AlmacenCredenciales almacenCredenciales,
    List<LimpiadorEstadoMemoria> limpiadores = const <LimpiadorEstadoMemoria>[],
  })  : _almacenCredenciales = almacenCredenciales,
        _limpiadores = limpiadores;

  final AlmacenCredenciales _almacenCredenciales;
  final List<LimpiadorEstadoMemoria> _limpiadores;

  /// Responsabilidad única: Coordina el cierre de sesión y la limpieza de datos sensibles.
  @override
  Future<void> cerrarSesion() async {
    try {
      // Primero se borran los datos persistentes de autenticación.
      await _almacenCredenciales.limpiarCredenciales();

      // Después se reinician estados en memoria, por ejemplo el carrito.
      for (final limpiador in _limpiadores) {
        await limpiador.limpiar();
      }
    } catch (_) {
      throw const ExcepcionCierreSesion(
        'No fue posible limpiar por completo los datos de la sesion.',
      );
    }
  }
}
