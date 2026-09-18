import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';
import 'boton_ut.dart';

/// Estado vacío para catálogo, carrito, usuarios o auditoría.
class EstadoVacioUT extends StatelessWidget {
  const EstadoVacioUT({
    super.key,
    required this.titulo,
    required this.mensaje,
    this.icono = Icons.inbox_outlined,
    this.etiquetaAccion,
    this.alAccionar,
  });

  final String titulo;
  final String mensaje;
  final IconData icono;
  final String? etiquetaAccion;
  final VoidCallback? alAccionar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(DimensionesUT.espacio24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                size: 52,
                color: tema.colorScheme.primary.withValues(alpha: .82),
              ),
              const SizedBox(height: DimensionesUT.espacio16),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: tema.textTheme.titleLarge,
              ),
              const SizedBox(height: DimensionesUT.espacio8),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyMedium,
              ),
              if (etiquetaAccion != null && alAccionar != null) ...[
                const SizedBox(height: DimensionesUT.espacio20),
                BotonUT(
                  etiqueta: etiquetaAccion!,
                  alPresionar: alAccionar,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
