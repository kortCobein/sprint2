import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Estado visual de carga reutilizable.
class EstadoCargaUT extends StatelessWidget {
  const EstadoCargaUT({
    super.key,
    this.mensaje = 'Cargando…',
    this.compacto = false,
  });

  final String mensaje;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final contenido = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox.square(
          dimension: 30,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        const SizedBox(height: DimensionesUT.espacio12),
        Text(
          mensaje,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );

    if (compacto) return contenido;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DimensionesUT.espacio32),
        child: contenido,
      ),
    );
  }
}
