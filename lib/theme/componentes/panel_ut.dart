import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Superficie base para formularios, resúmenes, listas y detalles.
class PanelUT extends StatelessWidget {
  const PanelUT({
    super.key,
    required this.child,
    this.titulo,
    this.subtitulo,
    this.acciones = const [],
    this.padding,
    this.margen,
    this.fondo,
  });

  final Widget child;
  final String? titulo;
  final String? subtitulo;
  final List<Widget> acciones;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margen;
  final Color? fondo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final tieneEncabezado = titulo != null || subtitulo != null || acciones.isNotEmpty;

    return Container(
      margin: margen,
      padding: padding ?? DimensionesUT.panel,
      decoration: BoxDecoration(
        color: fondo ?? tema.colorScheme.surface,
        borderRadius: BorderRadius.circular(DimensionesUT.radioGrande),
        border: Border.all(
          color: tema.colorScheme.outline.withValues(alpha: .72),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tieneEncabezado) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (titulo != null)
                        Text(titulo!, style: tema.textTheme.titleLarge),
                      if (subtitulo != null) ...[
                        const SizedBox(height: DimensionesUT.espacio4),
                        Text(
                          subtitulo!,
                          style: tema.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (acciones.isNotEmpty) ...[
                  const SizedBox(width: DimensionesUT.espacio12),
                  Wrap(
                    spacing: DimensionesUT.espacio8,
                    runSpacing: DimensionesUT.espacio8,
                    children: acciones,
                  ),
                ],
              ],
            ),
            const SizedBox(height: DimensionesUT.espacio20),
          ],
          child,
        ],
      ),
    );
  }
}
