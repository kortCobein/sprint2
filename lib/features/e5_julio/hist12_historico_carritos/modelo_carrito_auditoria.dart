/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

class ArticuloCarritoAuditoria {
  const ArticuloCarritoAuditoria({
    required this.idProducto,
    required this.cantidad,
    this.tituloProducto,
  });

  final int idProducto;
  final int cantidad;
  final String? tituloProducto;

  /// Responsabilidad única: Construye el modelo a partir de los datos JSON recibidos.
  factory ArticuloCarritoAuditoria.desdeJson(Map<String, dynamic> json) {
    return ArticuloCarritoAuditoria(
      idProducto: (json['productId'] as num?)?.toInt() ?? 0,
      cantidad: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  /// Responsabilidad única: Crea una copia del elemento incorporando el título resuelto.
  ArticuloCarritoAuditoria conTitulo(String? titulo) {
    return ArticuloCarritoAuditoria(
      idProducto: idProducto,
      cantidad: cantidad,
      tituloProducto: titulo ?? tituloProducto,
    );
  }
}

class CarritoAuditoria {
  const CarritoAuditoria({
    required this.id,
    required this.idUsuario,
    required this.fecha,
    required this.productos,
  });

  final int id;
  final int idUsuario;
  final DateTime? fecha;
  final List<ArticuloCarritoAuditoria> productos;

  /// Responsabilidad única: Construye el modelo a partir de los datos JSON recibidos.
  factory CarritoAuditoria.desdeJson(Map<String, dynamic> json) {
    final productosJson = json['products'];
    return CarritoAuditoria(
      id: (json['id'] as num?)?.toInt() ?? 0,
      idUsuario: (json['userId'] as num?)?.toInt() ?? 0,
      fecha: DateTime.tryParse(json['date']?.toString() ?? ''),
      productos: productosJson is List<dynamic>
          ? productosJson
              .whereType<Map<String, dynamic>>()
              .map(ArticuloCarritoAuditoria.desdeJson)
              .toList(growable: false)
          : const [],
    );
  }

  /// Responsabilidad única: Crea una copia del carrito con la colección indicada.
  CarritoAuditoria conProductos(List<ArticuloCarritoAuditoria> nuevos) {
    return CarritoAuditoria(
      id: id,
      idUsuario: idUsuario,
      fecha: fecha,
      productos: nuevos,
    );
  }
}
