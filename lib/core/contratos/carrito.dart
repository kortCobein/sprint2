import 'productos.dart';
import 'sesion.dart';

final class LineaCarritoAplicacion {
  const LineaCarritoAplicacion({
    required this.producto,
    required this.cantidad,
  });

  final ProductoAplicacion producto;
  final int cantidad;

  double get subtotal => producto.precio * cantidad;
}

final class CarritoAplicacion {
  const CarritoAplicacion({
    required this.usuario,
    required this.lineas,
    this.idRemoto,
  });

  final int usuario;
  final int? idRemoto;
  final List<LineaCarritoAplicacion> lineas;

  double get total =>
      lineas.fold<double>(0, (suma, linea) => suma + linea.subtotal);
}

abstract interface class AgregarCarritoAplicacion {
  CarritoAplicacion get estado;

  Future<CarritoAplicacion> agregar({
    required RolAplicacion rol,
    required int usuario,
    required ProductoAplicacion producto,
    int cantidad = 1,
  });
}

abstract interface class GestionCarritoAplicacion {
  CarritoAplicacion get estado;

  Future<CarritoAplicacion> cambiarCantidad({
    required RolAplicacion rol,
    required int usuario,
    required int productoId,
    required int cantidad,
  });

  Future<CarritoAplicacion> quitar({
    required RolAplicacion rol,
    required int usuario,
    required int productoId,
  });
}
