import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Tarjeta visual de catálogo desacoplada del modelo de producto.
///
/// La integración entrega textos, imagen y callback; este widget no importa
/// clases de features.
class TarjetaProductoUT extends StatelessWidget {
  const TarjetaProductoUT({
    super.key,
    required this.titulo,
    required this.precio,
    required this.imagen,
    this.categoria,
    this.descripcion,
    this.alPresionar,
    this.accion,
  });

  final String titulo;
  final String precio;
  final Widget imagen;
  final String? categoria;
  final String? descripcion;
  final VoidCallback? alPresionar;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Material(
      color: tema.colorScheme.surface,
      borderRadius: BorderRadius.circular(DimensionesUT.radioGrande),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alPresionar,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: tema.colorScheme.outline.withValues(alpha: .72),
            ),
            borderRadius: BorderRadius.circular(DimensionesUT.radioGrande),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.35,
                child: ColoredBox(
                  color: tema.colorScheme.surfaceContainerHighest
                      .withValues(alpha: .45),
                  child: Padding(
                    padding: const EdgeInsets.all(DimensionesUT.espacio16),
                    child: Center(child: imagen),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(DimensionesUT.espacio12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (categoria != null) ...[
                            Text(
                              categoria!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tema.textTheme.labelSmall?.copyWith(
                                color: tema.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: DimensionesUT.espacio4),
                          ],
                          Text(
                            titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tema.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (descripcion != null) ...[
                            const SizedBox(height: DimensionesUT.espacio4),
                            Text(
                              descripcion!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: tema.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              precio,
                              style: tema.textTheme.titleMedium?.copyWith(
                                color: tema.colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          ?accion,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
