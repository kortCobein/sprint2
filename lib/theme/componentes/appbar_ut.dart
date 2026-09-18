import 'package:flutter/material.dart';

import '../dimensiones_ut.dart';

/// AppBar institucional preparada para título, contexto y acciones.
class AppBarUT extends StatelessWidget implements PreferredSizeWidget {
  const AppBarUT({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.leading,
    this.acciones = const [],
  });

  final String titulo;
  final String? subtitulo;
  final Widget? leading;
  final List<Widget> acciones;

  @override
  Size get preferredSize => Size.fromHeight(subtitulo == null ? 64 : 76);

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return AppBar(
      leading: leading,
      actions: acciones,
      toolbarHeight: preferredSize.height,
      titleSpacing: leading == null ? DimensionesUT.espacio20 : 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (subtitulo != null) ...[
            const SizedBox(height: DimensionesUT.espacio2),
            Text(
              subtitulo!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tema.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
