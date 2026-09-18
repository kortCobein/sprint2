/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import 'package:flutter/foundation.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import '../hist09_agregar_carrito/estado_carrito/linea_carrito.dart';
import 'repositorio_gestion_carrito.dart';

class ControladorGestionCarrito extends ChangeNotifier {
  ControladorGestionCarrito(this._repositorio, this.estado);

  final RepositorioGestionCarrito _repositorio;
  final EstadoCarrito estado;
  bool _sincronizando = false;
  String? _error;

  bool get sincronizando => _sincronizando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  Future<bool> cambiarCantidad({
    required RolUsuario rol,
    required int usuario,
    required int productoId,
    required int cantidad,
  }) async {
    if (!rol.puedeUsarCarrito) return false;
    if (cantidad <= 0) {
      return quitar(
        rol: rol,
        usuario: usuario,
        productoId: productoId,
      );
    }

    final lineas = [...estado.lineas];
    final indice = lineas.indexWhere(
      (linea) => linea.producto.id == productoId,
    );
    if (indice < 0) return false;

    lineas[indice] = lineas[indice].copiarCon(cantidad: cantidad);
    return _guardar(usuario, lineas);
  }

  /// Responsabilidad única: Quita la información correspondiente a `quitar` manteniendo esta operación dentro de su responsabilidad.
  Future<bool> quitar({
    required RolUsuario rol,
    required int usuario,
    required int productoId,
  }) async {
    if (!rol.puedeUsarCarrito) return false;

    final lineas = estado.lineas
        .where((linea) => linea.producto.id != productoId)
        .toList(growable: false);

    // Si se elimina el último artículo, también se simula DELETE /carts/{id}.
    if (lineas.isEmpty) {
      final id = estado.idRemoto;
      if (id == null) {
        estado.reiniciar();
        return true;
      }

      _sincronizando = true;
      notifyListeners();
      try {
        await _repositorio.eliminar(id);
        estado.reiniciar();
        return true;
      } catch (_) {
        _error = 'No fue posible eliminar el carrito.';
        return false;
      } finally {
        _sincronizando = false;
        notifyListeners();
      }
    }

    return _guardar(usuario, lineas);
  }

  /// Responsabilidad única: Guarda los datos recibidos en el almacenamiento correspondiente.
  Future<bool> _guardar(int usuario, List<LineaCarrito> lineas) async {
    final id = estado.idRemoto;
    if (id == null) return false;

    _sincronizando = true;
    _error = null;
    notifyListeners();
    try {
      await _repositorio.actualizar(id, usuario, lineas);
      estado.establecer(usuario: usuario, lineas: lineas);
      return true;
    } catch (_) {
      _error = 'No fue posible sincronizar el carrito.';
      return false;
    } finally {
      _sincronizando = false;
      notifyListeners();
    }
  }
}
