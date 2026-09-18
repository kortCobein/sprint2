/// Épica 5 - Auditorías.
/// Código reorganizado desde US11-US12 del repositorio del equipo.

import 'package:flutter/material.dart';

import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import 'controlador_usuarios.dart';

class PantallaUsuarios extends StatelessWidget {
  const PantallaUsuarios({
    super.key,
    required this.controlador,
    required this.rol,
  });

  final ControladorUsuarios controlador;
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
          itemCount: controlador.usuarios.length,
          itemBuilder: (_, indice) {
            final usuario = controlador.usuarios[indice];
            return ListTile(
              leading: CircleAvatar(child: Text('${usuario.id}')),
              title: Text(
                usuario.nombreCompleto.isEmpty
                    ? usuario.usuario
                    : usuario.nombreCompleto,
              ),
              subtitle: Text(
                '${usuario.usuario}\n${usuario.correo}\n${usuario.telefono}',
              ),
            );
          },
        );
      },
    );
  }
}
