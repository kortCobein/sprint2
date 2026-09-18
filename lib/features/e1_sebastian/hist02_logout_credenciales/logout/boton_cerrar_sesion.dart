
import 'package:flutter/material.dart';

import 'controlador_cierre_sesion.dart';

/// Boton que ejecuta logout y destruye todo el historial de navegacion.
class BotonCerrarSesion extends StatelessWidget {
  const BotonCerrarSesion({
    super.key,
    required this.controlador,
    required this.construirLogin,
  });

  final ControladorCierreSesion controlador;

  /// US02 no importa US01: la app principal inyecta la pantalla de Login.
  final WidgetBuilder construirLogin;

  /// Responsabilidad única: Interfaz: Construye la interfaz correspondiente a la responsabilidad de este widget.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controlador,
      builder: (context, _) {
        return FilledButton.tonalIcon(
          onPressed: controlador.cerrando
              ? null
              : () => _cerrarSesionYSalir(context),
          icon: controlador.cerrando
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout),
          label: Text(
            controlador.cerrando ? 'Cerrando sesion...' : 'Cerrar sesion',
          ),
        );
      },
    );
  }

  /// Responsabilidad única: Coordina el cierre de sesión y la limpieza de datos sensibles.
  Future<void> _cerrarSesionYSalir(BuildContext context) async {
    final correcto = await controlador.cerrarSesion();
    if (!context.mounted) return;

    if (!correcto) {
      final mensaje = controlador.mensajeError ?? 'No se pudo cerrar la sesion.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
      return;
    }

    // pushAndRemoveUntil elimina Catalogo, Perfil y cualquier otra vista privada.
    await Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(builder: construirLogin),
      (Route<dynamic> ruta) => false,
    );
  }
}
