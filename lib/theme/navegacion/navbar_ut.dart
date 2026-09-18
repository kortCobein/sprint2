import 'package:flutter/material.dart';

import '../colores_ut.dart';
import '../dimensiones_ut.dart';

class ItemNavbarUT {
  const ItemNavbarUT({
    required this.etiqueta,
    required this.icono,
    this.iconoSeleccionado,
    this.badge,
  });

  final String etiqueta;
  final IconData icono;
  final IconData? iconoSeleccionado;
  final String? badge;
}

/// Navegación inferior visual tipo cápsula.
///
/// No conoce rutas. El consumidor proporciona [items], [indiceActual] y
/// [alSeleccionar].
class NavbarUT extends StatelessWidget {
  const NavbarUT({
    super.key,
    required this.items,
    required this.indiceActual,
    required this.alSeleccionar,
  });

  final List<ItemNavbarUT> items;
  final int indiceActual;
  final ValueChanged<int> alSeleccionar;

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty);
    assert(indiceActual >= 0 && indiceActual < items.length);

    final tema = Theme.of(context);
    final esOscuro = tema.brightness == Brightness.dark;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        DimensionesUT.espacio16,
        0,
        DimensionesUT.espacio16,
        DimensionesUT.espacio12,
      ),
      child: Center(
        heightFactor: 1,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          padding: const EdgeInsets.all(DimensionesUT.espacio8),
          decoration: BoxDecoration(
            color: esOscuro
                ? ColoresUT.superficieSecundariaOscura
                : ColoresUT.superficieClara,
            borderRadius: BorderRadius.circular(DimensionesUT.radioCapsula),
            border: Border.all(
              color: tema.colorScheme.outline.withValues(alpha: .72),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: esOscuro ? .22 : .08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (indice) {
              final item = items[indice];
              final seleccionado = indice == indiceActual;
              return Expanded(
                child: _ItemNavbarUT(
                  item: item,
                  seleccionado: seleccionado,
                  alPresionar: () => alSeleccionar(indice),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ItemNavbarUT extends StatelessWidget {
  const _ItemNavbarUT({
    required this.item,
    required this.seleccionado,
    required this.alPresionar,
  });

  final ItemNavbarUT item;
  final bool seleccionado;
  final VoidCallback alPresionar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final color = seleccionado
        ? tema.colorScheme.primary
        : tema.colorScheme.onSurface.withValues(alpha: .62);

    return Semantics(
      selected: seleccionado,
      button: true,
      label: item.etiqueta,
      child: InkWell(
        onTap: alPresionar,
        borderRadius: BorderRadius.circular(DimensionesUT.radioCapsula),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionesUT.espacio8,
            vertical: DimensionesUT.espacio10,
          ),
          decoration: BoxDecoration(
            color: seleccionado
                ? tema.colorScheme.primary.withValues(alpha: .11)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(DimensionesUT.radioCapsula),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                isLabelVisible: item.badge != null,
                label: item.badge == null ? null : Text(item.badge!),
                child: Icon(
                  seleccionado
                      ? (item.iconoSeleccionado ?? item.icono)
                      : item.icono,
                  color: color,
                  size: 22,
                ),
              ),
              if (seleccionado) ...[
                const SizedBox(width: DimensionesUT.espacio8),
                Flexible(
                  child: Text(
                    item.etiqueta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
