import 'package:flutter/material.dart';

import '../colores_ut.dart';
import '../dimensiones_ut.dart';

enum VarianteBotonUT { primario, secundario, peligro, texto }

/// Botón reutilizable sin reglas de permisos.
///
/// [habilitado], [cargando] y [alPresionar] deben ser calculados por la capa
/// que integra la historia de usuario.
class BotonUT extends StatelessWidget {
  const BotonUT({
    super.key,
    required this.etiqueta,
    required this.alPresionar,
    this.icono,
    this.variante = VarianteBotonUT.primario,
    this.habilitado = true,
    this.cargando = false,
    this.expandido = false,
  });

  final String etiqueta;
  final VoidCallback? alPresionar;
  final IconData? icono;
  final VarianteBotonUT variante;
  final bool habilitado;
  final bool cargando;
  final bool expandido;

  @override
  Widget build(BuildContext context) {
    final accion = habilitado && !cargando ? alPresionar : null;
    final contenido = _contenido();

    final Widget boton = switch (variante) {
      VarianteBotonUT.primario => FilledButton(
          onPressed: accion,
          child: contenido,
        ),
      VarianteBotonUT.secundario => OutlinedButton(
          onPressed: accion,
          style: OutlinedButton.styleFrom(
            foregroundColor: ColoresUT.azul,
          ),
          child: contenido,
        ),
      VarianteBotonUT.peligro => FilledButton(
          onPressed: accion,
          style: FilledButton.styleFrom(
            backgroundColor: ColoresUT.error,
            foregroundColor: Colors.white,
          ),
          child: contenido,
        ),
      VarianteBotonUT.texto => TextButton(
          onPressed: accion,
          child: contenido,
        ),
    };

    if (!expandido) return boton;
    return SizedBox(width: double.infinity, child: boton);
  }

  Widget _contenido() {
    if (cargando) {
      final color = variante == VarianteBotonUT.primario ||
              variante == VarianteBotonUT.peligro
          ? Colors.white
          : ColoresUT.verde;

      return SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          color: color,
        ),
      );
    }

    if (icono == null) return Text(etiqueta);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 19),
        const SizedBox(width: DimensionesUT.espacio8),
        Text(etiqueta),
      ],
    );
  }
}
