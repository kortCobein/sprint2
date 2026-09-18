/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'package:flutter/foundation.dart';
import 'producto.dart';
import 'repositorio_catalogo.dart';

/// Estado lógico de US03: carga, datos, error y reintento.
class ControladorCatalogo extends ChangeNotifier {
  ControladorCatalogo(this._repositorio);
  final RepositorioCatalogo _repositorio;

  List<Producto> _productos = const [];
  bool _cargando = false;
  String? _error;

  /// Responsabilidad única: Expone la colección de productos disponible en el estado actual.
  List<Producto> get productos => _productos;
  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;
  bool get vacio => !_cargando && _error == null && _productos.isEmpty;

  /// Responsabilidad única: Carga los datos requeridos por esta historia y notifica el nuevo estado.
  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await _repositorio.obtenerProductos();
    } catch (_) {
      _productos = const [];
      _error = 'No fue posible cargar los productos. Revisa tu conexión.';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Responsabilidad única: Limpia el estado o almacenamiento responsabilidad de este componente.
  void limpiar() {
    _productos = const [];
    _error = null;
    _cargando = false;
    notifyListeners();
  }
}
