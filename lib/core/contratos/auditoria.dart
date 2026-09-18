import 'sesion.dart';

final class DireccionAplicacion {
  const DireccionAplicacion({
    required this.ciudad,
    required this.calle,
    required this.numero,
    required this.cp,
    required this.latitud,
    required this.longitud,
  });

  final String ciudad;
  final String calle;
  final int? numero;
  final String cp;
  final String latitud;
  final String longitud;
}

final class UsuarioAplicacion {
  const UsuarioAplicacion({
    required this.id,
    required this.usuario,
    required this.correo,
    required this.telefono,
    required this.nombreCompleto,
    required this.direccion,
  });

  final int id;
  final String usuario;
  final String correo;
  final String telefono;
  final String nombreCompleto;
  final DireccionAplicacion direccion;
}

final class ArticuloAuditoriaAplicacion {
  const ArticuloAuditoriaAplicacion({
    required this.productoId,
    required this.cantidad,
    this.titulo,
  });

  final int productoId;
  final int cantidad;
  final String? titulo;
}

final class CarritoAuditoriaAplicacion {
  const CarritoAuditoriaAplicacion({
    required this.id,
    required this.usuarioId,
    required this.fecha,
    required this.productos,
  });

  final int id;
  final int usuarioId;
  final DateTime? fecha;
  final List<ArticuloAuditoriaAplicacion> productos;
}

abstract interface class UsuariosAplicacion {
  Future<List<UsuarioAplicacion>> listar(RolAplicacion rol);
}

abstract interface class AuditoriaCarritosAplicacion {
  Future<List<CarritoAuditoriaAplicacion>> listar(RolAplicacion rol);
}
