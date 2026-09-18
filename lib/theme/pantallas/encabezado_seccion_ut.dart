import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Encabezado reutilizable para catálogo, carrito, usuarios y auditoría.
class EncabezadoSeccionUT extends StatelessWidget {
  const EncabezadoSeccionUT({
    super.key,
    required this.titulo,
    this.descripcion,
    this.accion,
  });

  final String titulo;
  final String? descripcion;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: tema.textTheme.headlineSmall),
              if (descripcion != null) ...[
                const SizedBox(height: DimensionesUT.espacio4),
                Text(descripcion!, style: tema.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (accion != null) ...[
          const SizedBox(width: DimensionesUT.espacio16),
          accion!,
        ],
      ],
    );
  }
}
