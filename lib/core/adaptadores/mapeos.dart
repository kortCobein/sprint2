import '../../features/e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../../features/e1_sebastian/hist01_login_perfiles/login/sesion_usuario.dart';
import '../../features/e2_leonel/hist03_catalogo_general/producto.dart';
import '../../features/e4_ariel/hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import '../../features/e5_julio/hist11_listar_usuarios/modelo_usuario.dart';
import '../../features/e5_julio/hist12_historico_carritos/modelo_carrito_auditoria.dart';
import '../contratos/auditoria.dart';
import '../contratos/carrito.dart';
import '../contratos/productos.dart';
import '../contratos/sesion.dart';

RolAplicacion rolAplicacionDesdeFeature(RolUsuario rol) => switch (rol) {
      RolUsuario.administrador => RolAplicacion.administrador,
      RolUsuario.auditor => RolAplicacion.auditor,
      RolUsuario.cliente => RolAplicacion.cliente,
    };

RolUsuario rolFeatureDesdeAplicacion(RolAplicacion rol) => switch (rol) {
      RolAplicacion.administrador => RolUsuario.administrador,
      RolAplicacion.auditor => RolUsuario.auditor,
      RolAplicacion.cliente => RolUsuario.cliente,
    };

SesionAplicacion sesionAplicacionDesdeFeature(SesionUsuario sesion) {
  return SesionAplicacion(
    id: sesion.id,
    usuario: sesion.usuario,
    correo: sesion.correo,
    nombreVisible: sesion.nombreVisible,
    rol: rolAplicacionDesdeFeature(sesion.rol),
  );
}

ProductoAplicacion productoAplicacionDesdeFeature(Producto producto) {
  return ProductoAplicacion(
    id: producto.id,
    titulo: producto.titulo,
    precio: producto.precio,
    imagen: producto.imagen,
    categoria: producto.categoria,
    descripcion: producto.descripcion,
  );
}

Producto productoFeatureDesdeAplicacion(ProductoAplicacion producto) {
  return Producto(
    id: producto.id,
    titulo: producto.titulo,
    precio: producto.precio,
    imagen: producto.imagen,
    categoria: producto.categoria,
    descripcion: producto.descripcion,
  );
}

CarritoAplicacion carritoAplicacionDesdeFeature(EstadoCarrito estado) {
  return CarritoAplicacion(
    usuario: estado.idUsuario ?? 0,
    idRemoto: estado.idRemoto,
    lineas: estado.lineas
        .map(
          (linea) => LineaCarritoAplicacion(
            producto: productoAplicacionDesdeFeature(linea.producto),
            cantidad: linea.cantidad,
          ),
        )
        .toList(growable: false),
  );
}

UsuarioAplicacion usuarioAplicacionDesdeFeature(UsuarioTienda usuario) {
  return UsuarioAplicacion(
    id: usuario.id,
    usuario: usuario.usuario,
    correo: usuario.correo,
    telefono: usuario.telefono,
    nombreCompleto: usuario.nombreCompleto,
    direccion: DireccionAplicacion(
      ciudad: usuario.direccion.ciudad,
      calle: usuario.direccion.calle,
      numero: usuario.direccion.numero,
      cp: usuario.direccion.cp,
      latitud: usuario.direccion.latitud,
      longitud: usuario.direccion.longitud,
    ),
  );
}

CarritoAuditoriaAplicacion carritoAuditoriaDesdeFeature(
  CarritoAuditoria carrito,
) {
  return CarritoAuditoriaAplicacion(
    id: carrito.id,
    usuarioId: carrito.idUsuario,
    fecha: carrito.fecha,
    productos: carrito.productos
        .map(
          (item) => ArticuloAuditoriaAplicacion(
            productoId: item.idProducto,
            cantidad: item.cantidad,
            titulo: item.tituloProducto,
          ),
        )
        .toList(growable: false),
  );
}
