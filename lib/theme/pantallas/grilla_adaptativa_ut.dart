import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Grilla responsive para catálogo, usuarios o paneles de auditoría.
///
/// El consumidor entrega widgets terminados; esta clase no conoce modelos.
class GrillaAdaptativaUT extends StatelessWidget {
  const GrillaAdaptativaUT({
    super.key,
    required this.items,
    this.anchoMinimoItem = 240,
    this.espaciado = DimensionesUT.espacio16,
    this.proporcion = .78,
  });

  final List<Widget> items;
  final double anchoMinimoItem;
  final double espaciado;
  final double proporcion;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        final anchoDisponible = restricciones.maxWidth;
        final columnas =
            (anchoDisponible / anchoMinimoItem).floor().clamp(1, 4).toInt();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnas,
            crossAxisSpacing: espaciado,
            mainAxisSpacing: espaciado,
            childAspectRatio: proporcion,
          ),
          itemBuilder: (context, indice) => items[indice],
        );
      },
    );
  }
}
