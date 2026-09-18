import 'package:flutter/material.dart';

import 'controlador_inicio_sesion.dart';
import 'formulario_inicio_sesion.dart';
import 'sesion_usuario.dart';

/// Pantalla de acceso independiente de las rutas globales de la aplicacion.
class PantallaInicioSesion extends StatelessWidget {
  const PantallaInicioSesion({
    super.key,
    required this.controlador,
    this.alAutenticar,
  });

  final ControladorInicioSesion controlador;
  final ValueChanged<SesionUsuario>? alAutenticar;

  /// Responsabilidad única: Interfaz: Construye la interfaz correspondiente a la responsabilidad de este widget.
  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    // Impide volver con el boton Atrás a una vista protegida despues del logout.
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: colores.primaryContainer,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              size: 38,
                              color: colores.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'ALFA BUENA',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Inicio de sesion y asignacion de perfil',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 30),
                        FormularioInicioSesion(
                          controlador: controlador,
                          alAutenticar: alAutenticar,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
