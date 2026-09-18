/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import 'package:flutter/foundation.dart';
import 'linea_carrito.dart';

/// Memoria local del carrito durante la sesión.
/// US02 puede llamar [reiniciar] al cerrar sesión.
class EstadoCarrito extends ChangeNotifier {
  List<LineaCarrito> _lineas = const [];
  int? _idRemoto;
  int? _idUsuario;

  List<LineaCarrito> get lineas => List.unmodifiable(_lineas);
  int? get idRemoto => _idRemoto;
  int? get idUsuario => _idUsuario;
  bool get vacio => _lineas.isEmpty;
  /// Responsabilidad única: Calcula y expone el total actual del carrito.
  double get total => _lineas.fold(0, (suma, linea) => suma + linea.subtotal);

  /// Responsabilidad única: Actualiza la información correspondiente a `establecer` manteniendo esta operación dentro de su responsabilidad.
  void establecer({
    required int usuario,
    required List<LineaCarrito> lineas,
    int? idRemoto,
  }) {
    _idUsuario = usuario;
    _lineas = List.unmodifiable(lineas);
    if (idRemoto != null) _idRemoto = idRemoto;
    notifyListeners();
  }

  /// Responsabilidad única: Aplica la regla de negocio que determina el perfil del usuario.
  void asignarIdRemoto(int id) {
    _idRemoto = id;
    notifyListeners();
  }

  /// Responsabilidad única: Restablece el estado local del módulo sin afectar responsabilidades externas.
  void reiniciar() {
    _lineas = const [];
    _idRemoto = null;
    _idUsuario = null;
    notifyListeners();
  }
}
