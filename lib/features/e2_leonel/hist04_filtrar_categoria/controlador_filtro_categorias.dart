/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'package:flutter/foundation.dart';
import '../hist03_catalogo_general/producto.dart';
import 'repositorio_categorias.dart';

class ControladorFiltroCategorias extends ChangeNotifier {
  ControladorFiltroCategorias(this._repositorio);
  static const todos = 'Todos';
  final RepositorioCategorias _repositorio;

  List<String> _categorias = const [todos];
  List<Producto> _productos = const [];
  String _seleccionada = todos;
  bool _cargando = false;
  String? _error;

  /// Responsabilidad única: Expone las categorías disponibles para la interfaz.
  List<String> get categorias => _categorias;
  /// Responsabilidad única: Expone la colección de productos disponible en el estado actual.
  List<Producto> get productos => _productos;
  /// Responsabilidad única: Expone la categoría seleccionada actualmente.
  String get categoriaSeleccionada => _seleccionada;
  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Carga las categorías disponibles y actualiza el estado de la historia.
  Future<void> cargarCategorias() async {
    try { _categorias = [todos, ...await _repositorio.obtenerCategorias()]; }
    catch (_) { _categorias = const [todos]; }
    notifyListeners();
  }

  /// Responsabilidad única: Selecciona una categoría y actualiza el conjunto de productos visible.
  Future<void> seleccionar(String categoria) async {
    _seleccionada = categoria;
    _error = null;
    if (categoria == todos) {
      _productos = const [];
      notifyListeners();
      return;
    }
    _cargando = true;
    _productos = const []; // Evita mostrar datos de la categoría anterior.
    notifyListeners();
    try { _productos = await _repositorio.filtrar(categoria); }
    catch (_) { _error = 'No fue posible aplicar el filtro.'; }
    finally { _cargando = false; notifyListeners(); }
  }
}
