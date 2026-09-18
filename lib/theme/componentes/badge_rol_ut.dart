import 'package:flutter/material.dart';

import '../colores_ut.dart';
import '../dimensiones_ut.dart';

enum EstiloRolUT { administrador, cliente, auditor, neutro }

/// Indicador visual de rol.
///
/// La feature decide qué rol tiene el usuario y qué [estilo] corresponde.
/// Este componente no calcula permisos.
class BadgeRolUT extends StatelessWidget {
  const BadgeRolUT({
    super.key,
    required this.etiqueta,
    required this.estilo,
    this.icono,
  });

  final String etiqueta;
  final EstiloRolUT estilo;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final color = switch (estilo) {
      EstiloRolUT.administrador => ColoresUT.rolAdministrador,
      EstiloRolUT.cliente => ColoresUT.rolCliente,
      EstiloRolUT.auditor => ColoresUT.rolAuditor,
      EstiloRolUT.neutro => Theme.of(context).colorScheme.outline,
    };

    return Semantics(
      label: 'Rol: $etiqueta',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionesUT.espacio12,
          vertical: DimensionesUT.espacio8,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(DimensionesUT.radioCapsula),
          border: Border.all(color: color.withValues(alpha: .32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icono != null) ...[
              Icon(icono, size: 16, color: color),
              const SizedBox(width: DimensionesUT.espacio4),
            ],
            Text(
              etiqueta,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
