/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import 'package:flutter/foundation.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../../e2_leonel/hist03_catalogo_general/producto.dart';
import '../hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import '../hist09_agregar_carrito/estado_carrito/linea_carrito.dart';
import 'repositorio_agregar_carrito.dart';

/// US09 evita duplicados: si el producto ya existe, suma cantidades.
class ControladorAgregarCarrito extends ChangeNotifier {
  ControladorAgregarCarrito(this._repositorio, this._estado);

  final RepositorioAgregarCarrito _repositorio;
  final EstadoCarrito _estado;
  bool _cargando = false;
  String? _error;

  /// Responsabilidad única: Expone si el módulo está ejecutando una operación asíncrona.
  bool get cargando => _cargando;
  /// Responsabilidad única: Expone el mensaje de error actual sin permitir modificarlo directamente.
  String? get error => _error;

  /// Responsabilidad única: Agrega el elemento solicitado respetando permisos y reglas de negocio.
  Future<bool> agregar({
    required RolUsuario rol,
    required int usuario,
    required Producto producto,
    required int cantidad,
  }) async {
    if (!rol.puedeUsarCarrito) {
      _error = 'El carrito está disponible únicamente para Clientes.';
      notifyListeners();
      return false;
    }
    if (cantidad <= 0) return false;

    final siguientes = [..._estado.lineas];
    final indice = siguientes.indexWhere(
      (linea) => linea.producto.id == producto.id,
    );

    if (indice >= 0) {
      siguientes[indice] = siguientes[indice].copiarCon(
        cantidad: siguientes[indice].cantidad + cantidad,
      );
    } else {
      siguientes.add(LineaCarrito(producto: producto, cantidad: cantidad));
    }

    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      final id = await _repositorio.crear(usuario, siguientes);
      _estado.establecer(
        usuario: usuario,
        lineas: siguientes,
        idRemoto: id,
      );
      return true;
    } catch (_) {
      _error = 'No fue posible agregar el producto al carrito.';
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
