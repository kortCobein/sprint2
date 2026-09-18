/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'package:flutter/material.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import 'controlador_carritos_auditoria.dart';

class PantallaCarritosAuditoria extends StatelessWidget {
  const PantallaCarritosAuditoria({
    super.key,
    required this.controlador,
    required this.rol,
  });

  final ControladorCarritosAuditoria controlador;
  final RolUsuario rol;

  /// Responsabilidad única: Interfaz: Construye la interfaz correspondiente a la responsabilidad de este widget.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controlador,
      builder: (context, _) {
        if (!rol.puedeAuditar) {
          return const Center(child: Text('Acceso restringido.'));
        }
        if (controlador.cargando) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controlador.error != null) {
          return Center(child: Text(controlador.error!));
        }

        return ListView.builder(
          itemCount: controlador.carritos.length,
          itemBuilder: (_, indice) {
            final carrito = controlador.carritos[indice];
            final fecha = carrito.fecha
                    ?.toLocal()
                    .toString()
                    .split(' ')
                    .first ??
                'Sin fecha';

            return ExpansionTile(
              title: Text('Carrito #${carrito.id}'),
              subtitle: Text('Usuario ${carrito.idUsuario} · $fecha'),
              children: carrito.productos.map((articulo) {
                return ListTile(
                  title: Text(
                    articulo.tituloProducto ??
                        'Producto #${articulo.idProducto}',
                  ),
                  trailing: Text('x${articulo.cantidad}'),
                );
              }).toList(growable: false),
            );
          },
        );
      },
    );
  }
}
