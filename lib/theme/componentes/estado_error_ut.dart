import 'package:flutter/material.dart';

import '../colores_ut.dart';
import '../dimensiones_ut.dart';
import 'boton_ut.dart';

/// Estado visual de error. El reintento se inyecta desde la feature.
class EstadoErrorUT extends StatelessWidget {
  const EstadoErrorUT({
    super.key,
    required this.mensaje,
    this.titulo = 'No pudimos completar la acción',
    this.alReintentar,
    this.etiquetaReintentar = 'Reintentar',
  });

  final String titulo;
  final String mensaje;
  final VoidCallback? alReintentar;
  final String etiquetaReintentar;

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
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: ColoresUT.errorClaro,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: ColoresUT.error,
                  size: 28,
                ),
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
              if (alReintentar != null) ...[
                const SizedBox(height: DimensionesUT.espacio20),
                BotonUT(
                  etiqueta: etiquetaReintentar,
                  icono: Icons.refresh_rounded,
                  variante: VarianteBotonUT.secundario,
                  alPresionar: alReintentar,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
