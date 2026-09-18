import 'package:flutter/material.dart';

import '../colores_ut.dart';
import '../dimensiones_ut.dart';

/// Contenido visual para confirmaciones o avisos.
///
/// La navegación y la decisión final pertenecen al consumidor mediante
/// [alCancelar] y [alConfirmar].
class DialogoUT extends StatelessWidget {
  const DialogoUT({
    super.key,
    required this.titulo,
    required this.mensaje,
    required this.etiquetaConfirmar,
    this.etiquetaCancelar = 'Cancelar',
    this.alCancelar,
    this.alConfirmar,
    this.peligroso = false,
    this.icono,
  });

  final String titulo;
  final String mensaje;
  final String etiquetaConfirmar;
  final String etiquetaCancelar;
  final VoidCallback? alCancelar;
  final VoidCallback? alConfirmar;
  final bool peligroso;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final color = peligroso ? ColoresUT.error : Theme.of(context).colorScheme.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionesUT.radioGrande),
      ),
      icon: icono == null ? null : Icon(icono, color: color),
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: alCancelar,
          child: Text(etiquetaCancelar),
        ),
        FilledButton(
          onPressed: alConfirmar,
          style: peligroso
              ? FilledButton.styleFrom(
                  backgroundColor: ColoresUT.error,
                  foregroundColor: Colors.white,
                )
              : null,
          child: Text(etiquetaConfirmar),
        ),
      ],
    );
  }
}
