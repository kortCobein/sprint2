import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Limita el ancho y adapta el padding de cualquier pantalla UT.
class ContenedorResponsiveUT extends StatelessWidget {
  const ContenedorResponsiveUT({
    super.key,
    required this.child,
    this.anchoMaximo = DimensionesUT.anchoContenido,
    this.alineacion = Alignment.topCenter,
  });

  final Widget child;
  final double anchoMaximo;
  final AlignmentGeometry alineacion;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        final padding = DimensionesUT.paginaResponsive(restricciones.maxWidth);

        return Align(
          alignment: alineacion,
          child: SingleChildScrollView(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: anchoMaximo),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
