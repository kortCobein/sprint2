import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// Scaffold visual común para las pantallas del Sprint.
///
/// No registra rutas ni importa features. La integración inyecta app bar,
/// contenido, navegación y acciones.
class ShellUT extends StatelessWidget {
  const ShellUT({
    super.key,
    required this.child,
    this.appBar,
    this.navegacionInferior,
    this.floatingActionButton,
    this.paddingInferiorParaNavbar = true,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? navegacionInferior;
  final Widget? floatingActionButton;
  final bool paddingInferiorParaNavbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: navegacionInferior != null,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: navegacionInferior,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: navegacionInferior != null && paddingInferiorParaNavbar
              ? DimensionesUT.alturaNavbar
              : 0,
        ),
        child: child,
      ),
    );
  }
}
