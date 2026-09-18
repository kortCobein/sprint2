import 'package:flutter/material.dart';

/// Chip de selección para categorías u otros filtros visuales.
class ChipFiltroUT extends StatelessWidget {
  const ChipFiltroUT({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.alSeleccionar,
    this.cantidad,
  });

  final String etiqueta;
  final bool seleccionado;
  final ValueChanged<bool>? alSeleccionar;
  final int? cantidad;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: seleccionado,
      onSelected: alSeleccionar,
      showCheckmark: false,
      label: Text(
        cantidad == null ? etiqueta : '$etiqueta · $cantidad',
      ),
    );
  }
}
