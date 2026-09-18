/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'package:flutter/foundation.dart';
import '../hist03_catalogo_general/producto.dart';
import 'repositorio_detalle_producto.dart';

class ControladorDetalleProducto extends ChangeNotifier {
  ControladorDetalleProducto(this._repositorio);
  final RepositorioDetalleProducto _repositorio;
  Producto? _producto;
  bool _cargando = false;
  String? _error;
  /// Responsabilidad única: Expone el producto cargado actualmente por el controlador.
  Producto? get producto => _producto;

  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;

  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Carga los datos requeridos por esta historia y notifica el nuevo estado.
  Future<void> cargar(int id) async {
    _cargando=true; _producto=null; _error=null; notifyListeners();
    try { _producto=await _repositorio.obtener(id); }
    catch (_) { _error='Producto no disponible'; }
    finally { _cargando=false; notifyListeners(); }
  }
}
