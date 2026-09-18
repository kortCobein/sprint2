import 'sesion.dart';

final class ProductoAplicacion {
  const ProductoAplicacion({
    required this.id,
    required this.titulo,
    required this.precio,
    required this.imagen,
    required this.categoria,
    required this.descripcion,
  });

  final int id;
  final String titulo;
  final double precio;
  final String imagen;
  final String categoria;
  final String descripcion;

  ProductoAplicacion copiarCon({
    int? id,
    String? titulo,
    double? precio,
    String? imagen,
    String? categoria,
    String? descripcion,
  }) {
    return ProductoAplicacion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      precio: precio ?? this.precio,
      imagen: imagen ?? this.imagen,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
    );
  }
}

abstract interface class CatalogoAplicacion {
  Future<List<ProductoAplicacion>> listar();
}

abstract interface class CategoriasAplicacion {
  Future<List<String>> listarCategorias();
  Future<List<ProductoAplicacion>> listarPorCategoria(String categoria);
}

abstract interface class DetalleProductoAplicacion {
  Future<ProductoAplicacion> obtener(int id);
}

abstract interface class CrearProductoAplicacion {
  Future<ProductoAplicacion> crear({
    required RolAplicacion rol,
    required ProductoAplicacion producto,
  });
}

abstract interface class EditarProductoAplicacion {
  Future<ProductoAplicacion> editar({
    required RolAplicacion rol,
    required ProductoAplicacion producto,
  });
}

abstract interface class EliminarProductoAplicacion {
  Future<void> eliminar({
    required RolAplicacion rol,
    required int id,
  });
}
