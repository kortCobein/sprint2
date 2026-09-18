import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Fila uniforme para detalles, usuarios, auditoría y resúmenes de carrito.
class FilaDatoUT extends StatelessWidget {
  const FilaDatoUT({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.icono,
    this.trailing,
  });

  final String etiqueta;
  final String valor;
  final IconData? icono;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DimensionesUT.espacio8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 20, color: tema.colorScheme.primary),
            const SizedBox(width: DimensionesUT.espacio12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: tema.textTheme.labelMedium),
                const SizedBox(height: DimensionesUT.espacio2),
                Text(valor, style: tema.textTheme.bodyMedium),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: DimensionesUT.espacio12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
